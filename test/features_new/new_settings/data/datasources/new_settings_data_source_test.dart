import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/core_new/local_storage/local_storage.dart';
import 'package:tautulli_remote/rewrite/features_new/new_settings/data/datasources/new_settings_data_source.dart';
import 'package:tautulli_remote/rewrite/core_new/api/tautulli_api/new_tautulli_api.dart'
    as tautulli_api;
import 'package:tautulli_remote/rewrite/features_new/new_settings/data/models/new_plex_server_info_model.dart';
import 'package:tautulli_remote/rewrite/features_new/new_settings/data/models/new_tautulli_settings_general_model.dart';

import '../../../../fixtures_new/new_fixture_reader.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

class MockGetServerInfo extends Mock
    implements tautulli_api.NewGetServerInfoImpl {}

class MockGetSettings extends Mock implements tautulli_api.NewGetSettingsImpl {}

void main() {
  final mockLocalStorage = MockLocalStorage();
  final mockGetServerInfo = MockGetServerInfo();
  final mockGetSettings = MockGetSettings();
  final dataSource = NewSettingsDataSourceImpl(
    localStorage: mockLocalStorage,
    apiGetServerInfo: mockGetServerInfo,
    apiGetSettings: mockGetSettings,
  );

  const String tTautulliId = 'abc';

  final plexServerInfoJson = json.decode(
    fixture('new_plex_server_info.json'),
  );
  final tautulliSettingsJson = json.decode(
    fixture('new_tautulli_settings.json'),
  );

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
  const int tServerTimeout = 15;
  const String tStatsType = 'plays';
  final NewTautulliSettingsGeneralModel tTautulliSettings =
      NewTautulliSettingsGeneralModel.fromJson(
    tautulliSettingsJson['response']['data']['General'],
  );
  const String tUsersSort = 'friendly_name|asc';
  const bool tWizardComplete = false;
  const String tYAxis = 'plays';

  group('Custom Cert Hash List', () {
    test(
      'should return list of custom cert hashes from settings',
      () async {
        // arrange
        when(() => mockLocalStorage.getStringList('customCertHashList'))
            .thenReturn(['1', '2']);
        // act
        final customCertHashList = await dataSource.getCustomCertHashList();
        // assert
        verify(() => mockLocalStorage.getStringList('customCertHashList'))
            .called(1);
        expect(customCertHashList, equals([1, 2]));
      },
    );

    test(
      'should return an ampty list when there is no stored value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getStringList('customCertHashList'),
        ).thenReturn(null);
        // act
        final customCertHashList = await dataSource.getCustomCertHashList();
        // assert
        expect(customCertHashList, equals([]));
      },
    );

    test(
      'should call LocalStorage to save the custom cert hash list',
      () async {
        // arrange
        when(
          () => mockLocalStorage.setStringList(
            'customCertHashList',
            ['1', '2'],
          ),
        ).thenAnswer((_) async => Future.value(true));
        // act
        await dataSource.setCustomCertHashList([1, 2]);
        // assert
        verify(
          () => mockLocalStorage.setStringList(
            'customCertHashList',
            ['1', '2'],
          ),
        ).called(1);
      },
    );
  });

  group('Double Tap To Exit', () {
    test(
      'should return bool from settings',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getBool('doubleTapToExit'),
        ).thenReturn(tDoubleTapToExit);
        // act
        final doubleTapToExit = await dataSource.getDoubleTapToExit();
        // assert
        verify(() => mockLocalStorage.getBool('doubleTapToExit')).called(1);
        expect(doubleTapToExit, equals(tDoubleTapToExit));
      },
    );

    test(
      'should return fase when there is no stored value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getBool('doubleTapToExit'),
        ).thenReturn(null);
        // act
        final doubleTapToExit = await dataSource.getDoubleTapToExit();
        // assert
        expect(doubleTapToExit, equals(false));
      },
    );

    test(
      'should call LocalStorage to save double tap to exit value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.setBool(
            'doubleTapToExit',
            tDoubleTapToExit,
          ),
        ).thenAnswer((_) async => Future.value(true));
        // act
        await dataSource.setDoubleTapToExit(tDoubleTapToExit);
        // assert
        verify(
          () => mockLocalStorage.setBool('doubleTapToExit', tDoubleTapToExit),
        ).called(1);
      },
    );
  });

  group('Graph Tips Shown', () {
    test(
      'should return bool from settings',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getBool('graphTipsShown'),
        ).thenReturn(tGraphTipsShown);
        // act
        final graphTipsShown = await dataSource.getGraphTipsShown();
        // assert
        verify(() => mockLocalStorage.getBool('graphTipsShown')).called(1);
        expect(graphTipsShown, equals(tGraphTipsShown));
      },
    );

    test(
      'should return false when there is no stored value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getBool('graphTipsShown'),
        ).thenReturn(null);
        // act
        final graphTipsShown = await dataSource.getGraphTipsShown();
        // assert
        expect(graphTipsShown, equals(false));
      },
    );

    test(
      'should call LocalStorage to save graph tips shown value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.setBool(
            'graphTipsShown',
            tGraphTipsShown,
          ),
        ).thenAnswer((_) async => Future.value(true));
        // act
        await dataSource.setGraphTipsShown(tGraphTipsShown);
        // assert
        verify(
          () => mockLocalStorage.setBool('graphTipsShown', tGraphTipsShown),
        ).called(1);
      },
    );
  });

  group('Last App Version', () {
    test(
      'should return string from settings',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getString('lastAppVersion'),
        ).thenReturn(tLastAppVersion);
        // act
        final lastAppVersion = await dataSource.getLastAppVersion();
        // assert
        verify(() => mockLocalStorage.getString('lastAppVersion')).called(1);
        expect(lastAppVersion, equals(tLastAppVersion));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getString('lastAppVersion'),
        ).thenReturn(null);
        // act
        final lastAppVersion = await dataSource.getLastAppVersion();
        // assert
        expect(lastAppVersion, equals(null));
      },
    );

    test(
      'should call LocalStorage to save the last app version',
      () async {
        // arrange
        when(
          () => mockLocalStorage.setString(
            'lastAppVersion',
            tLastAppVersion,
          ),
        ).thenAnswer((_) async => Future.value(true));
        // act
        await dataSource.setLastAppVersion(tLastAppVersion);
        // assert
        verify(
          () => mockLocalStorage.setString('lastAppVersion', tLastAppVersion),
        ).called(1);
      },
    );
  });

  group('Last Read Announcement ID', () {
    test(
      'should return int from settings',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getInt('lastReadAnnouncementId'),
        ).thenReturn(tLastReadAnnouncementId);
        // act
        final lastReadAnnouncementId =
            await dataSource.getLastReadAnnouncementId();
        // assert
        verify(() => mockLocalStorage.getInt('lastReadAnnouncementId'))
            .called(1);
        expect(lastReadAnnouncementId, equals(tLastReadAnnouncementId));
      },
    );

    test(
      'should return -1 when there is no stored value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getInt('lastReadAnnouncementId'),
        ).thenReturn(null);
        // act
        final lastReadAnnouncementId =
            await dataSource.getLastReadAnnouncementId();
        // assert
        expect(lastReadAnnouncementId, equals(-1));
      },
    );

    test(
      'should call LocalStorage to save the last read announcement ID',
      () async {
        // arrange
        when(
          () => mockLocalStorage.setInt(
            'lastReadAnnouncementId',
            tLastReadAnnouncementId,
          ),
        ).thenAnswer((_) async => Future.value(true));
        // act
        await dataSource.setLastReadAnnouncementId(tLastReadAnnouncementId);
        // assert
        verify(
          () => mockLocalStorage.setInt(
            'lastReadAnnouncementId',
            tLastReadAnnouncementId,
          ),
        ).called(1);
      },
    );
  });

  group('Last Selected Server', () {
    test(
      'should return string from settings',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getString('lastSelectedServer'),
        ).thenReturn(tLastSelectedServer);
        // act
        final lastSelectedServer = await dataSource.getLastSelectedServer();
        // assert
        verify(() => mockLocalStorage.getString('lastSelectedServer'))
            .called(1);
        expect(lastSelectedServer, equals(tLastSelectedServer));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getString('lastSelectedServer'),
        ).thenReturn(null);
        // act
        final lastSelectedServer = await dataSource.getLastSelectedServer();
        // assert
        expect(lastSelectedServer, equals(null));
      },
    );

    test(
      'should call LocalStorage to save the last selected server',
      () async {
        // arrange
        when(
          () => mockLocalStorage.setString(
            'lastSelectedServer',
            tLastSelectedServer,
          ),
        ).thenAnswer((_) async => Future.value(true));
        // act
        await dataSource.setLastSelectedServer(tLastSelectedServer);
        // assert
        verify(
          () => mockLocalStorage.setString(
            'lastSelectedServer',
            tLastSelectedServer,
          ),
        ).called(1);
      },
    );
  });

  group('Mask Sensitive Info', () {
    test(
      'should return bool from settings',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getBool('maskSensitiveInfo'),
        ).thenReturn(tMaskSensitiveInfo);
        // act
        final maskSensitiveInfo = await dataSource.getMaskSensitiveInfo();
        // assert
        verify(() => mockLocalStorage.getBool('maskSensitiveInfo')).called(1);
        expect(maskSensitiveInfo, equals(tMaskSensitiveInfo));
      },
    );

    test(
      'should return false when there is no stored value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getBool('maskSensitiveInfo'),
        ).thenReturn(null);
        // act
        final maskSensitiveInfo = await dataSource.getMaskSensitiveInfo();
        // assert
        expect(maskSensitiveInfo, equals(false));
      },
    );

    test(
      'should call LocalStorage to save mask sensitive info value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.setBool(
            'maskSensitiveInfo',
            tMaskSensitiveInfo,
          ),
        ).thenAnswer((_) async => Future.value(true));
        // act
        await dataSource.setMaskSensitiveInfo(tMaskSensitiveInfo);
        // assert
        verify(
          () => mockLocalStorage.setBool(
            'maskSensitiveInfo',
            tMaskSensitiveInfo,
          ),
        ).called(1);
      },
    );
  });

  group('OneSignal Banner Dismissed', () {
    test(
      'should return bool from settings',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getBool('oneSignalBannerDismissed'),
        ).thenReturn(tOneSignalBannerDismissed);
        // act
        final oneSignalBannerDismissed =
            await dataSource.getOneSignalBannerDismissed();
        // assert
        verify(() => mockLocalStorage.getBool('oneSignalBannerDismissed'))
            .called(1);
        expect(oneSignalBannerDismissed, equals(tOneSignalBannerDismissed));
      },
    );

    test(
      'should return false when there is no stored value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getBool('oneSignalBannerDismissed'),
        ).thenReturn(null);
        // act
        final oneSignalBannerDismissed =
            await dataSource.getOneSignalBannerDismissed();
        // assert
        expect(oneSignalBannerDismissed, equals(false));
      },
    );

    test(
      'should call LocalStorage to save OneSignal banner dismissed value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.setBool(
            'oneSignalBannerDismissed',
            tOneSignalBannerDismissed,
          ),
        ).thenAnswer((_) async => Future.value(true));
        // act
        await dataSource.setOneSignalBannerDismissed(tOneSignalBannerDismissed);
        // assert
        verify(
          () => mockLocalStorage.setBool(
            'oneSignalBannerDismissed',
            tOneSignalBannerDismissed,
          ),
        ).called(1);
      },
    );
  });

  group('OneSignal Consented', () {
    test(
      'should return int from settings',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getBool('oneSignalConsented'),
        ).thenReturn(tOneSignalConsented);
        // act
        final oneSignalConsented = await dataSource.getOneSignalConsented();
        // assert
        verify(() => mockLocalStorage.getBool('oneSignalConsented')).called(1);
        expect(oneSignalConsented, equals(tOneSignalConsented));
      },
    );

    test(
      'should return false when there is no stored value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getBool('oneSignalConsented'),
        ).thenReturn(null);
        // act
        final oneSignalConsented = await dataSource.getOneSignalConsented();
        // assert
        expect(oneSignalConsented, equals(false));
      },
    );

    test(
      'should call LocalStorage to save OneSignal consented value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.setBool(
            'oneSignalConsented',
            tOneSignalConsented,
          ),
        ).thenAnswer((_) async => Future.value(true));
        // act
        await dataSource.setOneSignalConsented(tOneSignalConsented);
        // assert
        verify(
          () => mockLocalStorage.setBool(
            'oneSignalConsented',
            tOneSignalConsented,
          ),
        ).called(1);
      },
    );
  });

  group('Plex Server Info', () {
    test(
      'should call getServerInfo from API',
      () async {
        // arrange
        when(
          () => mockGetServerInfo(
            tautulliId: any(named: 'tautulliId'),
          ),
        ).thenAnswer((_) async => {
              'responseData': plexServerInfoJson,
              'primaryActive': true,
            });
        // act
        await dataSource.getPlexServerInfo(tTautulliId);
        // assert
        verify(() => mockGetServerInfo(tautulliId: tTautulliId)).called(1);
        verifyNoMoreInteractions(mockGetServerInfo);
      },
    );

    test(
      'should return a PlexServerInfoModel',
      () async {
        // arrange
        when(
          () => mockGetServerInfo(
            tautulliId: any(named: 'tautulliId'),
          ),
        ).thenAnswer((_) async => {
              'responseData': plexServerInfoJson,
              'primaryActive': true,
            });
        // act
        final response = await dataSource.getPlexServerInfo(tTautulliId);
        // assert
        expect(response, equals(tPlexServerInfo));
      },
    );
  });

  group('Refresh Rate', () {
    test(
      'should return int from settings',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getInt('refreshRate'),
        ).thenReturn(tRefreshRate);
        // act
        final refreshRate = await dataSource.getRefreshRate();
        // assert
        verify(() => mockLocalStorage.getInt('refreshRate')).called(1);
        expect(refreshRate, equals(tRefreshRate));
      },
    );

    test(
      'should return 0 when there is no stored value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getInt('refreshRate'),
        ).thenReturn(null);
        // act
        final refreshRate = await dataSource.getRefreshRate();
        // assert
        expect(refreshRate, equals(0));
      },
    );

    test(
      'should call LocalStorage to save the refresh rate',
      () async {
        // arrange
        when(
          () => mockLocalStorage.setInt(
            'refreshRate',
            tRefreshRate,
          ),
        ).thenAnswer((_) async => Future.value(true));
        // act
        await dataSource.setRefreshRate(tRefreshRate);
        // assert
        verify(
          () => mockLocalStorage.setInt('refreshRate', tRefreshRate),
        ).called(1);
      },
    );
  });

  group('Server Timeout', () {
    test(
      'should return int from settings',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getInt('serverTimeout'),
        ).thenReturn(tServerTimeout);
        // act
        final serverTimeout = await dataSource.getServerTimeout();
        // assert
        verify(() => mockLocalStorage.getInt('serverTimeout')).called(1);
        expect(serverTimeout, equals(tServerTimeout));
      },
    );

    test(
      'should return 15 when there is no stored value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getInt('serverTimeout'),
        ).thenReturn(null);
        // act
        final serverTimeout = await dataSource.getServerTimeout();
        // assert
        expect(serverTimeout, equals(15));
      },
    );

    test(
      'should call LocalStorage to save the server timeout',
      () async {
        // arrange
        when(
          () => mockLocalStorage.setInt(
            'serverTimeout',
            tServerTimeout,
          ),
        ).thenAnswer((_) async => Future.value(true));
        // act
        await dataSource.setServerTimeout(tServerTimeout);
        // assert
        verify(
          () => mockLocalStorage.setInt('serverTimeout', tServerTimeout),
        ).called(1);
      },
    );
  });

  group('Stats Type', () {
    test(
      'should return string from settings',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getString('statsType'),
        ).thenReturn(tStatsType);
        // act
        final statsType = await dataSource.getStatsType();
        // assert
        verify(() => mockLocalStorage.getString('statsType')).called(1);
        expect(statsType, equals(tStatsType));
      },
    );

    test(
      'should return "plays" when there is no stored value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getString('statsType'),
        ).thenReturn(null);
        // act
        final statsType = await dataSource.getStatsType();
        // assert
        expect(statsType, equals('plays'));
      },
    );

    test(
      'should call LocalStorage to save the stats type',
      () async {
        // arrange
        when(
          () => mockLocalStorage.setString(
            'statsType',
            tStatsType,
          ),
        ).thenAnswer((_) async => Future.value(true));
        // act
        await dataSource.setStatsType(tStatsType);
        // assert
        verify(
          () => mockLocalStorage.setString('statsType', tStatsType),
        ).called(1);
      },
    );
  });

  group('Get Tautulli Settings', () {
    test(
      'should call getTautulliSettings from API',
      () async {
        // arrange
        when(
          () => mockGetSettings(
            tautulliId: any(named: 'tautulliId'),
          ),
        ).thenAnswer((_) async => {
              'responseData': tautulliSettingsJson,
              'primaryActive': true,
            });
        // act
        await dataSource.getTautulliSettings(tTautulliId);
        // assert
        verify(() => mockGetSettings(tautulliId: tTautulliId)).called(1);
        verifyNoMoreInteractions(mockGetSettings);
      },
    );

    test(
      'should return a TautulliSettingsGeneralModel',
      () async {
        // arrange
        when(
          () => mockGetSettings(
            tautulliId: any(named: 'tautulliId'),
          ),
        ).thenAnswer((_) async => {
              'responseData': tautulliSettingsJson,
              'primaryActive': true,
            });
        // act
        final response = await dataSource.getTautulliSettings(tTautulliId);
        // assert
        expect(response, equals(tTautulliSettings));
      },
    );
  });

  group('Users Sort', () {
    test(
      'should return string from settings',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getString('usersSort'),
        ).thenReturn(tUsersSort);
        // act
        final usersSort = await dataSource.getUsersSort();
        // assert
        verify(() => mockLocalStorage.getString('usersSort')).called(1);
        expect(usersSort, equals(tUsersSort));
      },
    );

    test(
      'should return "friendly_name|asc" when there is no stored value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getString('usersSort'),
        ).thenReturn(null);
        // act
        final usersSort = await dataSource.getUsersSort();
        // assert
        expect(usersSort, equals('friendly_name|asc'));
      },
    );

    test(
      'should call LocalStorage to save the users sort value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.setString(
            'usersSort',
            tUsersSort,
          ),
        ).thenAnswer((_) async => Future.value(true));
        // act
        await dataSource.setUsersSort(tUsersSort);
        // assert
        verify(
          () => mockLocalStorage.setString('usersSort', tUsersSort),
        ).called(1);
      },
    );
  });

  group('Wizard Complete', () {
    test(
      'should return bool from settings',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getBool('wizardComplete'),
        ).thenReturn(tWizardComplete);
        // act
        final wizardComplete = await dataSource.getWizardComplete();
        // assert
        verify(() => mockLocalStorage.getBool('wizardComplete')).called(1);
        expect(wizardComplete, equals(tWizardComplete));
      },
    );

    test(
      'should return false when there is no stored value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getBool('wizardComplete'),
        ).thenReturn(null);
        // act
        final wizardComplete = await dataSource.getWizardComplete();
        // assert
        expect(wizardComplete, equals(false));
      },
    );

    test(
      'should call LocalStorage to save the wizard complete value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.setBool(
            'wizardComplete',
            tWizardComplete,
          ),
        ).thenAnswer((_) async => Future.value(true));
        // act
        await dataSource.setWizardComplete(tWizardComplete);
        // assert
        verify(
          () => mockLocalStorage.setBool(
            'wizardComplete',
            tWizardComplete,
          ),
        ).called(1);
      },
    );
  });

  group('Y Axis', () {
    test(
      'should return string from settings',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getString('yAxis'),
        ).thenReturn(tYAxis);
        // act
        final yAxis = await dataSource.getYAxis();
        // assert
        verify(() => mockLocalStorage.getString('yAxis')).called(1);
        expect(yAxis, equals(tYAxis));
      },
    );

    test(
      'should return "plays" when there is no stored value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getString('yAxis'),
        ).thenReturn(null);
        // act
        final yAxis = await dataSource.getYAxis();
        // assert
        expect(yAxis, equals('plays'));
      },
    );

    test(
      'should call LocalStorage to save the y axis value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.setString(
            'yAxis',
            tYAxis,
          ),
        ).thenAnswer((_) async => Future.value(true));
        // act
        await dataSource.setYAxis(tYAxis);
        // assert
        verify(
          () => mockLocalStorage.setString('yAxis', tYAxis),
        ).called(1);
      },
    );
  });
}
