import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiver/strings.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote/rewrite/core_new/error/new_exception.dart';
import 'package:tautulli_remote/rewrite/core_new/helpers/new_failure_helper.dart';

import '../../../../core_new/database/data/models/new_custom_header_model.dart';
import '../../../../core_new/database/data/models/new_server_model.dart';
import '../../../../core_new/enums/protocol.dart';
import '../../../../core_new/error/new_failure.dart';
import '../../../new_logging/domain/usecases/new_logging.dart';
import '../../../new_onesignal/data/datasources/new_onesignal_data_source.dart';
import '../../data/models/connection_address_model.dart';
import '../../domain/usecases/new_register_device.dart';
import '../../domain/usecases/new_settings.dart';
import 'new_settings_bloc.dart';

part 'new_registration_event.dart';
part 'new_registration_state.dart';

String primaryConnectionAddressCache = '';
String secondaryConnectionAddressCache = '';
String deviceTokenCache = '';
List<NewCustomHeaderModel> customHeadersCache = [];

class NewRegistrationBloc
    extends Bloc<NewRegistrationEvent, NewRegistrationState> {
  final NewRegisterDevice registerDevice;
  final NewLogging logging;
  final NewSettings settings;
  final NewOnesignalDataSource onesignal;

  NewRegistrationBloc({
    required this.registerDevice,
    required this.logging,
    required this.settings,
    required this.onesignal,
  }) : super(NewRegistrationInitial()) {
    on<NewRegistrationStarted>(
      (event, emit) => _onNewRegistrationStarted(event, emit),
    );
    on<NewRegistrationUnverifiedCert>(
      (event, emit) => _onNewRegistrationUnverifiedCert(event, emit),
    );
  }

  void _onNewRegistrationStarted(
    NewRegistrationStarted event,
    Emitter<NewRegistrationState> emit,
  ) async {
    emit(
      NewRegistrationInProgress(),
    );

    // Set cache values
    primaryConnectionAddressCache = event.primaryConnectionAddress.trim();
    secondaryConnectionAddressCache = event.secondaryConnectionAddress.trim();
    deviceTokenCache = event.deviceToken.trim();
    customHeadersCache = event.headers;

    await _callRegisterDevice(
      emit: emit,
      trustCert: false,
      settingsBloc: event.settingsBloc,
    );
  }

  void _onNewRegistrationUnverifiedCert(
    NewRegistrationUnverifiedCert event,
    Emitter<NewRegistrationState> emit,
  ) async {
    emit(
      NewRegistrationInProgress(),
    );

    await _callRegisterDevice(
      emit: emit,
      trustCert: true,
      settingsBloc: event.settingsBloc,
    );
  }

  Future<void> _callRegisterDevice({
    required Emitter<NewRegistrationState> emit,
    required bool trustCert,
    required NewSettingsBloc settingsBloc,
  }) async {
    final primaryConnectionAddress =
        ConnectionAddressModel.fromConnectionAddress(
      primary: true,
      connectionAddress: primaryConnectionAddressCache,
    );

    final failureOrRegistered = await registerDevice(
      connectionProtocol: primaryConnectionAddress.protocol!.toShortString(),
      connectionDomain: primaryConnectionAddress.domain!,
      connectionPath: primaryConnectionAddress.path ?? '',
      deviceToken: deviceTokenCache,
      trustCert: trustCert,
    );

    await failureOrRegistered.fold(
      (failure) {
        logging.error(
          'RegisterDevice :: Failed to register device [$failure]',
        );

        emit(
          NewRegistrationFailure(failure),
        );
      },
      (registeredData) async {
        late bool plexPass;
        switch (registeredData['pms_plexpass']) {
          case (0):
            plexPass = false;
            break;
          case (1):
            plexPass = true;
            break;
        }

        final bool onesignalRegistered = isNotBlank(await onesignal.userId);

        try {
          final NewServerModel existingServer =
              await settings.getServerByTautulliId(
            registeredData['server_id'],
          );

          settingsBloc.add(
            NewSettingsUpdateServer(
              id: existingServer.id!,
              sortIndex: existingServer.sortIndex,
              primaryConnectionAddress: primaryConnectionAddressCache,
              secondaryConnectionAddress: secondaryConnectionAddressCache,
              deviceToken: deviceTokenCache,
              tautulliId: registeredData['server_id'],
              plexName: registeredData['pms_name'],
              plexIdentifier: registeredData['pms_identifier'],
              plexPass: plexPass,
              dateFormat: existingServer.dateFormat,
              timeFormat: existingServer.timeFormat,
              onesignalRegistered: onesignalRegistered,
              customHeaders: customHeadersCache,
            ),
          );

          logging.info(
            'RegisterDevice :: Successfully updated information for ${registeredData['pms_name']}',
          );

          emit(
            NewRegistrationSuccess(),
          );
        } catch (e) {
          if (e == ServerNotFoundException) {
            settingsBloc.add(
              NewSettingsAddServer(
                primaryConnectionAddress: primaryConnectionAddressCache,
                secondaryConnectionAddress: secondaryConnectionAddressCache,
                deviceToken: deviceTokenCache,
                tautulliId: registeredData['server_id'],
                plexName: registeredData['pms_name'],
                plexIdentifier: registeredData['pms_identifier'],
                plexPass: plexPass,
                onesignalRegistered: onesignalRegistered,
                customHeaders: customHeadersCache,
              ),
            );

            logging.info(
              'RegisterDevice :: Successfully registered ${registeredData['pms_name']}',
            );

            emit(
              NewRegistrationSuccess(),
            );
          } else {
            final failure = NewFailureHelper.mapExceptionToFailure(e);

            logging.error(
              'RegisterDevice :: Failed to properly save server [$failure]',
            );

            emit(
              NewRegistrationFailure(failure),
            );
          }
        }
      },
    );
  }
}
