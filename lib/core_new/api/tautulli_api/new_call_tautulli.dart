import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../../../dependency_injection.dart' as di;
import '../../../features_new/new_settings/domain/usecases/new_settings.dart';
import '../../error/new_exception.dart';

abstract class NewCallTautulli {
  Future call({
    required String connectionProtocol,
    required String connectionDomain,
    required String? connectionPath,
    required String deviceToken,
    required String cmd,
    required Map<String, String> params,
    required bool trustCert,
    int? timeoutOverride,
  });
}

class NewCallTautulliImpl implements NewCallTautulli {
  @override
  Future call({
    required String connectionProtocol,
    required String connectionDomain,
    required String? connectionPath,
    required String deviceToken,
    required String cmd,
    required Map<String, String> params,
    required bool trustCert,
    int? timeoutOverride,
  }) async {
    // Add required parameter values into params
    params['cmd'] = cmd;
    params['apikey'] = deviceToken;
    params['app'] = 'true';

    // Construct URI using connection information and params
    Uri uri;
    switch (connectionProtocol.toLowerCase()) {
      case ('http'):
        uri = Uri.http('$connectionDomain', '$connectionPath/api/v2', params);
        break;
      case ('https'):
        uri = Uri.https('$connectionDomain', '$connectionPath/api/v2', params);
        break;
      default:
        throw IncorrectConnectionProtocolException();
    }

    //* Return URI for pmsImageProxy
    if (cmd == 'pms_image_proxy') {
      return uri;
    }

    //* Handle custom certificates
    // Get list of custom cert hashes
    List<int> customCertHashList =
        await di.sl<NewSettings>().getCustomCertHashList();

    // Create an HttpClient that catches badCertificateCallback.
    //
    // If the certificate is valid check if it has been previously approved
    // by the user. If so, return true.
    //
    // If it has not been approved and trustCert is true the add hash to list.
    // Otherwise return false.
    //
    // Return CertificationExpiredException if the certificate is not valid.

    HttpClient client = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) {
        int certHashCode = cert.pem.hashCode;

        if (cert.endValidity.isAfter(DateTime.now())) {
          if (customCertHashList.contains(certHashCode)) {
            return true;
          } else {
            if (trustCert) {
              //TODO: Log custom cert addition
              customCertHashList.add(certHashCode);
              return true;
            }
          }
        } else if (cert.endValidity.isBefore(DateTime.now())) {
          throw CertificateExpiredException;
        }

        return false;
      });

    // Set cert list if new certs were added
    if (trustCert) {
      await di.sl<NewSettings>().setCustomCertHashList(customCertHashList);
    }

    // Create IOClient using above HTTPClient
    var ioClient = IOClient(client);

    // Get timeout value from settings
    final timeout = await di.sl<NewSettings>().getServerTimeout();

    // Call API using contructed URI and IOClient
    http.Response response;
    try {
      response = await ioClient.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: timeoutOverride ?? timeout));
    } catch (e) {
      if (e.runtimeType == HandshakeException &&
          e.toString().contains('CERTIFICATE_VERIFY_FAILED')) {
        throw CertificateVerificationException;
      }

      rethrow;
    }

    // Attempt to parse reponse into JSON.
    //
    // Throws JsonDecodeException on error.
    Map<String, dynamic> responseJson;
    try {
      responseJson = json.decode(response.body);
    } catch (_) {
      throw JsonDecodeException();
    }

    // If status code is not 200 either:
    // Throw ServerVersionException if the message indicates a version issue
    // Throw a ServerException for all other cases
    if (response.statusCode != 200) {
      RegExp badServerVersion = RegExp(
          r'^Device registration failed: Tautulli version v\d.\d.\d does not meet the minimum requirement of v\d.\d.\d.');

      if (responseJson['response']['message'] != null &&
          badServerVersion.hasMatch(responseJson['response']['message'])) {
        throw ServerVersionException();
      }

      throw ServerException();
    }

    // Return parsed JSON
    return responseJson;
  }
}
