import 'package:quiver/strings.dart';

import '../../../../dependency_injection.dart' as di;
import '../../../features_new/new_settings/domain/usecases/new_settings.dart';
import '../../database/data/models/new_server_model.dart';
import '../../error/new_exception.dart';
import 'new_call_tautulli.dart';

abstract class NewConnectionHandler {
  /// Requires either the Tautulli ID or the connection protocol,
  /// domain, path, and device token.
  ///
  /// Returns a map containing the `dynamic` Tautulli server `responseData` and the
  /// current `bool` state of `primaryActive`.
  Future<Map<String, dynamic>> call({
    String? tautulliId,
    String? connectionProtocol,
    String? connectionDomain,
    String? connectionPath,
    String? deviceToken,
    required String cmd,
    required Map<String, String> params,
    bool trustCert,
    int? timeoutOverride,
  });
}

class NewConnectionHandlerImpl implements NewConnectionHandler {
  final NewCallTautulli callTautulli;

  NewConnectionHandlerImpl(this.callTautulli);

  @override
  Future<Map<String, dynamic>> call({
    String? tautulliId,
    String? connectionProtocol,
    String? connectionDomain,
    String? connectionPath,
    String? deviceToken,
    required String cmd,
    required Map<String, String> params,
    bool trustCert = false,
    int? timeoutOverride,
  }) async {
    String? secondaryConnectionAddress;
    String? secondaryConnectionProtocol;
    String? secondaryConnectionDomain;
    String? secondaryConnectionPath;
    bool? primaryActive;

    // If Tautulli ID is blank and connection information is blank
    // throw ConnectionDetailsException.
    if (isBlank(tautulliId) &&
        (isBlank(connectionProtocol) ||
            isBlank(connectionDomain) ||
            isBlank(deviceToken))) {
      throw ConnectionDetailsException();
    }

    // If a Tautulli ID is provided get the existing server details.
    if (isNotBlank(tautulliId)) {
      final NewServerModel server =
          await di.sl<NewSettings>().getServerByTautulliId(tautulliId!);

      connectionProtocol = server.primaryConnectionProtocol;
      connectionDomain = server.primaryConnectionDomain;
      connectionPath = server.primaryConnectionPath;
      secondaryConnectionAddress = server.secondaryConnectionAddress;
      secondaryConnectionProtocol = server.secondaryConnectionProtocol;
      secondaryConnectionDomain = server.secondaryConnectionDomain;
      secondaryConnectionPath = server.secondaryConnectionPath;
      deviceToken = server.deviceToken;
      primaryActive = server.primaryActive;

      // If the server's Primary Connection address or device token are blank
      // throw ConnectionDetailsException.
      if (isBlank(server.primaryConnectionAddress) ||
          isBlank(server.deviceToken)) {
        throw ConnectionDetailsException();
      }
    }

    // If primaryActive has not been set default to true
    if (primaryActive == null) {
      primaryActive = true;
    }

    var responseData;
    // Try making the call to Tautulli using the active connection details.
    //
    // If that fails, and there are secondary connection details, swap the
    // active connection and try again.
    //
    // If that again fails throw the error.
    try {
      responseData = await callTautulli(
        connectionProtocol:
            primaryActive ? connectionProtocol! : secondaryConnectionProtocol!,
        connectionDomain:
            primaryActive ? connectionDomain! : secondaryConnectionDomain!,
        connectionPath:
            primaryActive ? connectionPath : secondaryConnectionPath,
        deviceToken: deviceToken!,
        cmd: cmd,
        params: params,
        trustCert: trustCert,
        timeoutOverride: timeoutOverride,
      );
    } catch (e) {
      // If a secondary connection address is configured swap the active
      // connection and try again. Otherwise, throw the error.
      if (isNotBlank(secondaryConnectionAddress)) {
        try {
          if (primaryActive) {
            //TODO: Log connection failure for primary connection and active swap
          } else {
            //TODO: Log connection failure for secondary connection and active swap
          }

          // Swap the active connection
          primaryActive = !primaryActive;

          responseData = await callTautulli(
            connectionProtocol: primaryActive
                ? connectionProtocol!
                : secondaryConnectionProtocol!,
            connectionDomain:
                primaryActive ? connectionDomain! : secondaryConnectionDomain!,
            connectionPath:
                primaryActive ? connectionPath : secondaryConnectionPath,
            deviceToken: deviceToken!,
            cmd: cmd,
            params: params,
            trustCert: trustCert,
            timeoutOverride: timeoutOverride,
          );

          //TODO: The SettingsBloc state needs to know the active server swapped
        } catch (e) {
          // If both connections failed set primary active to true and throw error
          primaryActive = !primaryActive!;
          //TODO: Add logging that both connections failed

          //TODO: The SettingsBloc state needs to know the active server should be the primary

          rethrow;
        }
      } else {
        rethrow;
      }
    }

    return {
      'responseData': responseData,
      'primaryActive': primaryActive,
    };
  }
}
