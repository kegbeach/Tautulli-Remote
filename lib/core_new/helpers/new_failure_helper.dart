import 'dart:async';
import 'dart:io';

import 'package:tautulli_remote/core_new/new_requirements/versions.dart';

import '../error/new_exception.dart';
import '../error/new_failure.dart';

//* Error Messages
const String CERTIFICATE_EXPIRED_MESSAGE = 'TLS/SSL Certificate is Expired.';
const String CERTIFICATE_VERIFICATION_MESSAGE =
    'Certificate verification failed.';
const String CONNECTION_MESSAGE = 'No network connectivity.';
const String DATA_BASE_INIT_MESSAGE = 'Failed to initalize database.';
const String GENERIC_MESSAGE = 'Unknown error.';
const String JSON_MESSAGE = 'Failed to parse response.';
const String MISSING_SERVER_MESSAGE = 'No servers are configured.';
const String SERVER_MESSAGE = 'Failed to connect to server.';
const String SERVER_VERSION_MESSAGE =
    'Server version does not meet requirements.';
const String SETTINGS_MESSAGE = 'Required settings are missing.';
const String SOCKET_MESSAGE = 'Failed to connect to Connection Address.';
const String TIMEOUT_MESSAGE = 'Connection to server timed out.';
const String TLS_MESSAGE = 'Failed to establish TLS/SSL connection.';

//* Error Suggestions
const String CERTIFICATE_EXPIRED_SUGGESTION =
    'Please check your certificate and re-register with your Tautulli server.';
const String CERTIFICATE_VERIFICATION_SUGGESTION =
    'Please re-register with your Tautulli server.';
const String CHECK_CONNECTION_ADDRESS_SUGGESTION =
    'Check your Connection Address for errors.';
const String CHECK_SERVER_SETTINGS_SUGGESTION =
    'Please verify your connection settings.';
const String GENERIC_SUGGESTION = 'Please contact Support.';
const String MISSING_SERVER_SUGGESTION =
    'Please register with a Tautulli server.';
const String PLEX_CONNECTION_SUGGESTION =
    'Check your Connection Address for errors and make sure Tautulli can communicate with Plex.';
final String SERVER_VERSION_SUGGESTION =
    'Please update the Tautulli server to v${MinimumVersion.tautulliServer} or greater';

class NewFailureHelper {
  /// Map [Exception] to corresponding [Failure].
  static NewFailure mapExceptionToFailure(dynamic exception) {
    if ([
      TimeoutException,
      SettingsException,
      JsonDecodeException,
      HandshakeException,
      SocketException,
      ServerException,
      ServerVersionException,
    ].contains(exception.runtimeType)) {
      exception = exception.runtimeType;
    }

    switch (exception) {
      case (CertificateExpiredException):
        return CertificateExpiredFailure();
      case (CertificateVerificationException):
        return CertificateVerificationFailure();
      case (ConnectionDetailsException):
        return ConnectionDetailsFailure();
      case (DatabaseInitException):
        return DatabaseInitFailure();
      case (HandshakeException):
        return TlsFailure();
      case (JsonDecodeException):
        return JsonDecodeFailure();
      case (ServerException):
        return ServerFailure();
      case (ServerVersionException):
        return ServerVersionFailure();
      case (SettingsException):
        return SettingsFailure();
      case (SocketException):
        return SocketFailure();
      case (TimeoutException):
        return TimeoutFailure();
      case (TlsException):
        return TlsFailure();
      default:
        //TODO: Log non specific failure map
        print('Unable to map $exception to a specific failure');
        return GenericFailure();
    }
  }

  static String mapFailureToMessage(NewFailure failure) {
    switch (failure.runtimeType) {
      case (CertificateExpiredFailure):
        return CERTIFICATE_EXPIRED_MESSAGE;
      case (CertificateVerificationFailure):
        return CERTIFICATE_VERIFICATION_MESSAGE;
      case (ConnectionDetailsFailure):
        return SETTINGS_MESSAGE;
      case (ConnectionFailure):
        return CONNECTION_MESSAGE;
      case (DatabaseInitFailure):
        return DATA_BASE_INIT_MESSAGE;
      case (JsonDecodeFailure):
        return JSON_MESSAGE;
      case (MissingServerFailure):
        return MISSING_SERVER_MESSAGE;
      case (ServerFailure):
        return SERVER_MESSAGE;
      case (ServerVersionFailure):
        return SERVER_VERSION_MESSAGE;
      case (SettingsFailure):
        return SETTINGS_MESSAGE;
      case (SocketFailure):
        return SOCKET_MESSAGE;
      case (TimeoutFailure):
        return TIMEOUT_MESSAGE;
      case (TlsFailure):
        return TLS_MESSAGE;
      case (GenericFailure):
      default:
        return GENERIC_MESSAGE;
    }
  }

  static String mapFailureToSuggestion(NewFailure failure) {
    switch (failure.runtimeType) {
      case (CertificateExpiredFailure):
        return CERTIFICATE_EXPIRED_SUGGESTION;
      case (CertificateVerificationFailure):
        return CERTIFICATE_VERIFICATION_SUGGESTION;
      case (ConnectionDetailsFailure):
        return CHECK_SERVER_SETTINGS_SUGGESTION;
      case (ConnectionFailure):
        return '';
      case (DatabaseInitFailure):
        return GENERIC_SUGGESTION;
      case (JsonDecodeFailure):
        return CHECK_CONNECTION_ADDRESS_SUGGESTION;
      case (MissingServerFailure):
        return MISSING_SERVER_SUGGESTION;
      case (ServerFailure):
        return CHECK_SERVER_SETTINGS_SUGGESTION;
      case (ServerVersionFailure):
        return SERVER_VERSION_SUGGESTION;
      case (SettingsFailure):
        return CHECK_SERVER_SETTINGS_SUGGESTION;
      case (SocketFailure):
        return CHECK_CONNECTION_ADDRESS_SUGGESTION;
      case (TimeoutFailure):
        return PLEX_CONNECTION_SUGGESTION;
      case (TlsFailure):
        return CHECK_CONNECTION_ADDRESS_SUGGESTION;
      case (GenericFailure):
      default:
        return GENERIC_SUGGESTION;
    }
  }
}
