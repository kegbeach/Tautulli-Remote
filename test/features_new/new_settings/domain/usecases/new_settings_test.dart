import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/core_new/api/tautulli_api/api_response_data.dart';
import 'package:tautulli_remote/rewrite/core_new/database/data/models/new_custom_header_model.dart';
import 'package:tautulli_remote/rewrite/core_new/database/data/models/new_server_model.dart';
import 'package:tautulli_remote/rewrite/features_new/new_settings/data/models/new_plex_server_info_model.dart';
import 'package:tautulli_remote/rewrite/features_new/new_settings/data/models/new_tautulli_settings_general_model.dart';
import 'package:tautulli_remote/rewrite/features_new/new_settings/domain/repositories/new_settings_repository.dart';
import 'package:tautulli_remote/rewrite/features_new/new_settings/domain/usecases/new_settings.dart';

import '../../../../fixtures_new/new_fixture_reader.dart';

class MockSettingsRepository extends Mock implements NewSettingsRepository {}

void main() {
  final mockSettingsRepository = MockSettingsRepository();
  final usecase = NewSettings(mockSettingsRepository);

  const String tTautulliId = 'abc';

  final plexServerInfoJson = json.decode(
    fixture('new_plex_server_info.json'),
  );
  final tautulliSettingsJson = json.decode(
    fixture('new_tautulli_settings.json'),
  );

  const List<int> tCustomCertHashList = [1, 2];
  final List<NewCustomHeaderModel> tCustomHeaderList = [
    const NewCustomHeaderModel(key: 'test', value: 'test'),
  ];
  const bool tDoubleTapToExit = false;
  const bool tGraphTipsShown = false;
  const String tLastAppVersion = '3.0.0';
  const int tLastReadAnnouncementId = 1;
  const String tLastSelectedServer = 'abc';
  const bool tMaskSensitiveInfo = false;
  const bool tOneSignalBannerDismissed = false;
  const bool tOneSignalConsented = false;
  final NewPlexServerInfoModel tPlexServerInfo =
      NewPlexServerInfoModel.fromJson(
    plexServerInfoJson['response']['data'],
  );
  const int tRefreshRate = 10;
  NewServerModel tServerModel = NewServerModel(
    id: 0,
    sortIndex: 1,
    plexName: 'Plex',
    plexIdentifier: '123abc',
    tautulliId: tTautulliId,
    primaryConnectionAddress: 'http://192.168.0.10:8181',
    primaryConnectionProtocol: 'http',
    primaryConnectionDomain: '192.168.0.10:8181',
    deviceToken: 'xyz',
    primaryActive: true,
    onesignalRegistered: true,
    plexPass: true,
  );
  const int tServerTimeout = 15;
  const String tStatsType = 'plays';
  final NewTautulliSettingsGeneralModel tTautulliSettings =
      NewTautulliSettingsGeneralModel.fromJson(
    tautulliSettingsJson['response']['data']['General'],
  );
  const String tUsersSort = 'friendly_name|asc';
  const bool tWizardComplete = false;
  const String tYAxis = 'plays';

  test(
    'addServer should forward the call to the repository to add the server',
    () async {
      // arrange
      when(() => mockSettingsRepository.addServer(tServerModel)).thenAnswer(
        (_) async => Future.value(1),
      );
      // act
      await usecase.addServer(tServerModel);
      // assert
      verify(() => mockSettingsRepository.addServer(tServerModel)).called(1);
    },
  );

  test(
    'deleteServer should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.deleteServer(1)).thenAnswer(
        (_) async => Future.value(1),
      );
      // act
      await usecase.deleteServer(1);
      // assert
      verify(() => mockSettingsRepository.deleteServer(1)).called(1);
    },
  );

  test(
    'getAllServers should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.getAllServers()).thenAnswer(
        (_) async => Future.value([tServerModel]),
      );
      // act
      await usecase.getAllServers();
      // assert
      verify(() => mockSettingsRepository.getAllServers()).called(1);
    },
  );

  test(
    'getAllServersWithoutOnesignalRegistered should forward the call to the repository',
    () async {
      // arrange
      when(
        () => mockSettingsRepository.getAllServersWithoutOnesignalRegistered(),
      ).thenAnswer(
        (_) async => Future.value([]),
      );
      // act
      await usecase.getAllServersWithoutOnesignalRegistered();
      // assert
      verify(
        () => mockSettingsRepository.getAllServersWithoutOnesignalRegistered(),
      ).called(1);
    },
  );

  test(
    'getCustomCertHashList should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.getCustomCertHashList()).thenAnswer(
        (_) async => Future.value(tCustomCertHashList),
      );
      // act
      await usecase.getCustomCertHashList();
      // assert
      verify(() => mockSettingsRepository.getCustomCertHashList()).called(1);
    },
  );

  test(
    'getCustomHeadersByTautulliId should forward the call to the repository',
    () async {
      // arrange
      when(
        () => mockSettingsRepository.getCustomHeadersByTautulliId(tTautulliId),
      ).thenAnswer(
        (_) async => Future.value(tCustomHeaderList),
      );
      // act
      await usecase.getCustomHeadersByTautulliId(tTautulliId);
      // assert
      verify(
        () => mockSettingsRepository.getCustomHeadersByTautulliId(tTautulliId),
      ).called(1);
    },
  );

  test(
    'getDoubleTapToExit should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.getDoubleTapToExit()).thenAnswer(
        (_) async => Future.value(tDoubleTapToExit),
      );
      // act
      await usecase.getDoubleTapToExit();
      // assert
      verify(() => mockSettingsRepository.getDoubleTapToExit()).called(1);
    },
  );

  test(
    'getGraphTipsShown should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.getGraphTipsShown()).thenAnswer(
        (_) async => Future.value(tGraphTipsShown),
      );
      // act
      await usecase.getGraphTipsShown();
      // assert
      verify(() => mockSettingsRepository.getGraphTipsShown()).called(1);
    },
  );

  test(
    'getLastAppVersion should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.getLastAppVersion()).thenAnswer(
        (_) async => Future.value(tLastAppVersion),
      );
      // act
      await usecase.getLastAppVersion();
      // assert
      verify(() => mockSettingsRepository.getLastAppVersion()).called(1);
    },
  );

  test(
    'getLastReadAnnouncementId should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.getLastReadAnnouncementId()).thenAnswer(
        (_) async => Future.value(tLastReadAnnouncementId),
      );
      // act
      await usecase.getLastReadAnnouncementId();
      // assert
      verify(
        () => mockSettingsRepository.getLastReadAnnouncementId(),
      ).called(1);
    },
  );

  test(
    'getLastSelectedServer should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.getLastSelectedServer()).thenAnswer(
        (_) async => Future.value(tLastSelectedServer),
      );
      // act
      await usecase.getLastSelectedServer();
      // assert
      verify(() => mockSettingsRepository.getLastSelectedServer()).called(1);
    },
  );

  test(
    'getMaskSensitiveInfo should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.getMaskSensitiveInfo()).thenAnswer(
        (_) async => Future.value(tMaskSensitiveInfo),
      );
      // act
      await usecase.getMaskSensitiveInfo();
      // assert
      verify(() => mockSettingsRepository.getMaskSensitiveInfo()).called(1);
    },
  );

  test(
    'getOneSignalBannerDismissed should forward the call to the repository',
    () async {
      // arrange
      when(
        () => mockSettingsRepository.getOneSignalBannerDismissed(),
      ).thenAnswer(
        (_) async => Future.value(tOneSignalBannerDismissed),
      );
      // act
      await usecase.getOneSignalBannerDismissed();
      // assert
      verify(
        () => mockSettingsRepository.getOneSignalBannerDismissed(),
      ).called(1);
    },
  );

  test(
    'getOneSignalConsented should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.getOneSignalConsented()).thenAnswer(
        (_) async => Future.value(tOneSignalConsented),
      );
      // act
      await usecase.getOneSignalConsented();
      // assert
      verify(() => mockSettingsRepository.getOneSignalConsented()).called(1);
    },
  );

  test(
    'getPlexServerInfo should forward the call to the repository',
    () async {
      // arrange
      when(
        () => mockSettingsRepository.getPlexServerInfo(any()),
      ).thenAnswer(
        (_) async => Future.value(
          Right(
            ApiResponseData(data: tPlexServerInfo, primaryActive: true),
          ),
        ),
      );
      // act
      await usecase.getPlexServerInfo(tTautulliId);
      // assert
      verify(
        () => mockSettingsRepository.getPlexServerInfo(tTautulliId),
      ).called(1);
    },
  );

  test(
    'getRefreshRate should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.getRefreshRate()).thenAnswer(
        (_) async => Future.value(tRefreshRate),
      );
      // act
      await usecase.getRefreshRate();
      // assert
      verify(() => mockSettingsRepository.getRefreshRate()).called(1);
    },
  );

  test(
    'getServer should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.getServer(any())).thenAnswer(
        (_) async => Future.value(tServerModel),
      );
      // act
      await usecase.getServer(0);
      // assert
      verify(() => mockSettingsRepository.getServer(0)).called(1);
    },
  );

  test(
    'getServerByTautulliId should forward the call to the repository',
    () async {
      // arrange
      when(
        () => mockSettingsRepository.getServerByTautulliId(any()),
      ).thenAnswer(
        (_) async => Future.value(tServerModel),
      );
      // act
      await usecase.getServerByTautulliId(tTautulliId);
      // assert
      verify(() => mockSettingsRepository.getServerByTautulliId(tTautulliId))
          .called(1);
    },
  );

  test(
    'getServerTimeout should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.getServerTimeout()).thenAnswer(
        (_) async => Future.value(tServerTimeout),
      );
      // act
      await usecase.getServerTimeout();
      // assert
      verify(() => mockSettingsRepository.getServerTimeout()).called(1);
    },
  );

  test(
    'getStatsType should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.getStatsType()).thenAnswer(
        (_) async => Future.value(tStatsType),
      );
      // act
      await usecase.getStatsType();
      // assert
      verify(() => mockSettingsRepository.getStatsType()).called(1);
    },
  );

  test(
    'getTautulliSettings should forward the call to the repository',
    () async {
      // arrange
      when(
        () => mockSettingsRepository.getTautulliSettings(any()),
      ).thenAnswer(
        (_) async => Future.value(
          Right(
            ApiResponseData(data: tTautulliSettings, primaryActive: true),
          ),
        ),
      );
      // act
      await usecase.getTautulliSettings(tTautulliId);
      // assert
      verify(() => mockSettingsRepository.getTautulliSettings(tTautulliId))
          .called(1);
    },
  );

  test(
    'getUsersSort should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.getUsersSort()).thenAnswer(
        (_) async => Future.value(tUsersSort),
      );
      // act
      await usecase.getUsersSort();
      // assert
      verify(() => mockSettingsRepository.getUsersSort()).called(1);
    },
  );

  test(
    'getWizardComplete should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.getWizardComplete()).thenAnswer(
        (_) async => Future.value(tWizardComplete),
      );
      // act
      await usecase.getWizardComplete();
      // assert
      verify(() => mockSettingsRepository.getWizardComplete()).called(1);
    },
  );

  test(
    'getYAxis should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.getYAxis()).thenAnswer(
        (_) async => Future.value(tYAxis),
      );
      // act
      await usecase.getYAxis();
      // assert
      verify(() => mockSettingsRepository.getYAxis()).called(1);
    },
  );

  test(
    'setCustomCertHashList should forward the call to the repository',
    () async {
      // arrange
      when(
        () => mockSettingsRepository.setCustomCertHashList(any()),
      ).thenAnswer(
        (_) async => Future.value(true),
      );
      // act
      await usecase.setCustomCertHashList(tCustomCertHashList);
      // assert
      verify(
        () => mockSettingsRepository.setCustomCertHashList(tCustomCertHashList),
      ).called(1);
    },
  );

  test(
    'setDoubleTapToExit should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.setDoubleTapToExit(any())).thenAnswer(
        (_) async => Future.value(true),
      );
      // act
      await usecase.setDoubleTapToExit(tDoubleTapToExit);
      // assert
      verify(
        () => mockSettingsRepository.setDoubleTapToExit(tDoubleTapToExit),
      ).called(1);
    },
  );

  test(
    'setGraphTipsShown should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.setGraphTipsShown(any())).thenAnswer(
        (_) async => Future.value(true),
      );
      // act
      await usecase.setGraphTipsShown(tGraphTipsShown);
      // assert
      verify(
        () => mockSettingsRepository.setGraphTipsShown(tGraphTipsShown),
      ).called(1);
    },
  );

  test(
    'setLastAppVersion should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.setLastAppVersion(any())).thenAnswer(
        (_) async => Future.value(true),
      );
      // act
      await usecase.setLastAppVersion(tLastAppVersion);
      // assert
      verify(
        () => mockSettingsRepository.setLastAppVersion(tLastAppVersion),
      ).called(1);
    },
  );

  test(
    'setLastReadAnnouncementId should forward the call to the repository',
    () async {
      // arrange
      when(
        () => mockSettingsRepository.setLastReadAnnouncementId(any()),
      ).thenAnswer(
        (_) async => Future.value(true),
      );
      // act
      await usecase.setLastReadAnnouncementId(tLastReadAnnouncementId);
      // assert
      verify(
        () => mockSettingsRepository
            .setLastReadAnnouncementId(tLastReadAnnouncementId),
      ).called(1);
    },
  );

  test(
    'setLastSelectedServer should forward the call to the repository',
    () async {
      // arrange
      when(
        () => mockSettingsRepository.setLastSelectedServer(any()),
      ).thenAnswer(
        (_) async => Future.value(true),
      );
      // act
      await usecase.setLastSelectedServer(tLastSelectedServer);
      // assert
      verify(
        () => mockSettingsRepository.setLastSelectedServer(tLastSelectedServer),
      ).called(1);
    },
  );

  test(
    'setMaskSensitiveInfo should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.setMaskSensitiveInfo(any())).thenAnswer(
        (_) async => Future.value(true),
      );
      // act
      await usecase.setMaskSensitiveInfo(tMaskSensitiveInfo);
      // assert
      verify(
        () => mockSettingsRepository.setMaskSensitiveInfo(tMaskSensitiveInfo),
      ).called(1);
    },
  );

  test(
    'setOneSignalBannerDismissed should forward the call to the repository',
    () async {
      // arrange
      when(
        () => mockSettingsRepository.setOneSignalBannerDismissed(any()),
      ).thenAnswer(
        (_) async => Future.value(true),
      );
      // act
      await usecase.setOneSignalBannerDismissed(tOneSignalBannerDismissed);
      // assert
      verify(
        () => mockSettingsRepository
            .setOneSignalBannerDismissed(tOneSignalBannerDismissed),
      ).called(1);
    },
  );

  test(
    'setOneSignalConsented should forward the call to the repository',
    () async {
      // arrange
      when(
        () => mockSettingsRepository.setOneSignalConsented(any()),
      ).thenAnswer(
        (_) async => Future.value(true),
      );
      // act
      await usecase.setOneSignalConsented(tOneSignalConsented);
      // assert
      verify(
        () => mockSettingsRepository.setOneSignalConsented(tOneSignalConsented),
      ).called(1);
    },
  );

  test(
    'setRefreshRate should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.setRefreshRate(any())).thenAnswer(
        (_) async => Future.value(true),
      );
      // act
      await usecase.setRefreshRate(tRefreshRate);
      // assert
      verify(
        () => mockSettingsRepository.setRefreshRate(tRefreshRate),
      ).called(1);
    },
  );

  test(
    'setServerTimeout should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.setServerTimeout(any())).thenAnswer(
        (_) async => Future.value(true),
      );
      // act
      await usecase.setServerTimeout(tServerTimeout);
      // assert
      verify(
        () => mockSettingsRepository.setServerTimeout(tServerTimeout),
      ).called(1);
    },
  );

  test(
    'setStatsType should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.setStatsType(any())).thenAnswer(
        (_) async => Future.value(true),
      );
      // act
      await usecase.setStatsType(tStatsType);
      // assert
      verify(
        () => mockSettingsRepository.setStatsType(tStatsType),
      ).called(1);
    },
  );

  test(
    'setUsersSort should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.setUsersSort(any())).thenAnswer(
        (_) async => Future.value(true),
      );
      // act
      await usecase.setUsersSort(tUsersSort);
      // assert
      verify(
        () => mockSettingsRepository.setUsersSort(tUsersSort),
      ).called(1);
    },
  );

  test(
    'setWizardComplete should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.setWizardComplete(any())).thenAnswer(
        (_) async => Future.value(true),
      );
      // act
      await usecase.setWizardComplete(tWizardComplete);
      // assert
      verify(
        () => mockSettingsRepository.setWizardComplete(tWizardComplete),
      ).called(1);
    },
  );

  test(
    'setYAxis should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.setYAxis(any())).thenAnswer(
        (_) async => Future.value(true),
      );
      // act
      await usecase.setYAxis(tYAxis);
      // assert
      verify(
        () => mockSettingsRepository.setYAxis(tYAxis),
      ).called(1);
    },
  );

  test(
    'updateConnectionInfo should forward the call to the repository',
    () async {
      // arrange
      when(
        () => mockSettingsRepository.updateConnectionInfo(
          id: any(named: 'id'),
          connectionInfo: any(named: 'connectionInfo'),
        ),
      ).thenAnswer(
        (_) async => Future.value(1),
      );
      // act
      await usecase.updateConnectionInfo(id: 0, connectionInfo: {
        'primary_connection_address': tServerModel.primaryConnectionAddress,
        'primary_connection_protocol': tServerModel.primaryConnectionProtocol,
        'primary_connection_domain': tServerModel.primaryConnectionDomain,
      });
      // assert
      verify(
        () => mockSettingsRepository.updateConnectionInfo(
          id: 0,
          connectionInfo: {
            'primary_connection_address': tServerModel.primaryConnectionAddress,
            'primary_connection_protocol':
                tServerModel.primaryConnectionProtocol,
            'primary_connection_domain': tServerModel.primaryConnectionDomain,
          },
        ),
      ).called(1);
    },
  );

  test(
    'updateCustomHeaders should forward the call to the repository',
    () async {
      // arrange
      when(
        () => mockSettingsRepository.updateCustomHeaders(
          tautulliId: any(named: 'tautulliId'),
          customHeaders: any(named: 'customHeaders'),
        ),
      ).thenAnswer(
        (_) async => Future.value(1),
      );
      // act
      await usecase.updateCustomHeaders(
        tautulliId: tTautulliId,
        customHeaders: tCustomHeaderList,
      );
      // assert
      verify(
        () => mockSettingsRepository.updateCustomHeaders(
          tautulliId: tTautulliId,
          customHeaders: tCustomHeaderList,
        ),
      ).called(1);
    },
  );

  test(
    'updatePrimaryActive should forward the call to the repository',
    () async {
      // arrange
      when(
        () => mockSettingsRepository.updatePrimaryActive(
          tautulliId: any(named: 'tautulliId'),
          primaryActive: any(named: 'primaryActive'),
        ),
      ).thenAnswer(
        (_) async => Future.value(1),
      );
      // act
      await usecase.updatePrimaryActive(
        tautulliId: tTautulliId,
        primaryActive: true,
      );
      // assert
      verify(
        () => mockSettingsRepository.updatePrimaryActive(
          tautulliId: tTautulliId,
          primaryActive: true,
        ),
      ).called(1);
    },
  );

  test(
    'updateServer should forward the call to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.updateServer(tServerModel)).thenAnswer(
        (_) async => Future.value(1),
      );
      // act
      await usecase.updateServer(tServerModel);
      // assert
      verify(
        () => mockSettingsRepository.updateServer(tServerModel),
      ).called(1);
    },
  );

  test(
    'updateServerSort should forward the call to the repository',
    () async {
      // arrange
      when(
        () => mockSettingsRepository.updateServerSort(
          serverId: any(named: 'serverId'),
          newIndex: any(named: 'newIndex'),
          oldIndex: any(named: 'oldIndex'),
        ),
      ).thenAnswer(
        (_) async => Future.value(),
      );
      // act
      await usecase.updateServerSort(
        serverId: 0,
        newIndex: 1,
        oldIndex: 0,
      );
      // assert
      verify(
        () => mockSettingsRepository.updateServerSort(
          serverId: 0,
          newIndex: 1,
          oldIndex: 0,
        ),
      ).called(1);
    },
  );
}
