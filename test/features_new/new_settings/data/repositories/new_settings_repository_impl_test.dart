import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/core_new/api/tautulli_api/api_response_data.dart';
import 'package:tautulli_remote/rewrite/core_new/database/data/models/new_custom_header_model.dart';
import 'package:tautulli_remote/rewrite/core_new/database/data/models/new_server_model.dart';
import 'package:tautulli_remote/rewrite/core_new/error/new_exception.dart';
import 'package:tautulli_remote/rewrite/core_new/error/new_failure.dart';
import 'package:tautulli_remote/rewrite/core_new/network_info/new_network_info.dart';
import 'package:tautulli_remote/rewrite/features_new/new_settings/data/datasources/new_settings_data_source.dart';
import 'package:tautulli_remote/rewrite/features_new/new_settings/data/models/new_plex_server_info_model.dart';
import 'package:tautulli_remote/rewrite/features_new/new_settings/data/models/new_tautulli_settings_general_model.dart';
import 'package:tautulli_remote/rewrite/features_new/new_settings/data/repositories/new_settings_repository_impl.dart';

import '../../../../fixtures_new/new_fixture_reader.dart';

class MockSettingsDataSource extends Mock implements NewSettingsDataSource {}

class MockNetworkInfo extends Mock implements NewNetworkInfoImpl {}

void main() {
  final mockDataSource = MockSettingsDataSource();
  final mockNetworkInfo = MockNetworkInfo();
  final repository = NewSettingsRepositoryImpl(
    dataSource: mockDataSource,
    networkInfo: mockNetworkInfo,
  );

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

  group('Add Server', () {
    test(
      'should forward the call to the data source to add the server',
      () async {
        // arrange
        when(() => mockDataSource.addServer(tServerModel)).thenAnswer(
          (_) async => Future.value(1),
        );
        // act
        await repository.addServer(tServerModel);
        // assert
        verify(() => mockDataSource.addServer(tServerModel)).called(1);
      },
    );
  });

  group('Delete Server', () {
    test(
      'should forward the call to the data source to delete the server',
      () async {
        // arrange
        when(() => mockDataSource.deleteServer(0)).thenAnswer(
          (_) async => Future.value(),
        );
        // act
        await repository.deleteServer(0);
        // assert
        verify(() => mockDataSource.deleteServer(0)).called(1);
      },
    );
  });

  group('All Servers', () {
    test(
      'should forward the call to the data source to retreive all servers',
      () async {
        // arrange
        when(() => mockDataSource.getAllServers()).thenAnswer(
          (_) async => Future.value([tServerModel]),
        );
        // act
        await repository.getAllServers();
        // assert
        verify(() => mockDataSource.getAllServers()).called(1);
      },
    );
  });

  group('All Servers Without OneSignal Registered', () {
    test(
      'should forward the call to the data source to retreive all servers with OneSignal Registered as false',
      () async {
        // arrange
        when(
          () => mockDataSource.getAllServersWithoutOnesignalRegistered(),
        ).thenAnswer(
          (_) async => Future.value([]),
        );
        // act
        await repository.getAllServersWithoutOnesignalRegistered();
        // assert
        verify(
          () => mockDataSource.getAllServersWithoutOnesignalRegistered(),
        ).called(1);
      },
    );
  });

  group('Custom Cert Hash List', () {
    test(
      'should return the custom cert hash list from settings',
      () async {
        // arrange
        when(() => mockDataSource.getCustomCertHashList()).thenAnswer(
          (_) async => tCustomCertHashList,
        );
        // act
        final result = await repository.getCustomCertHashList();
        // assert
        expect(result, equals(tCustomCertHashList));
      },
    );

    test(
      'should forward the call to the data source to set custom cert hash list',
      () async {
        // arrange
        when(
          () => mockDataSource.setCustomCertHashList(tCustomCertHashList),
        ).thenAnswer(
          (_) async => Future.value(true),
        );
        // act
        await repository.setCustomCertHashList(tCustomCertHashList);
        // assert
        verify(
          () => mockDataSource.setCustomCertHashList(tCustomCertHashList),
        ).called(1);
      },
    );
  });

  group('Custom Headers By Tautulli ID', () {
    test(
      'should forward the call to the data source to retreive custom headers for the specific server',
      () async {
        // arrange
        when(
          () => mockDataSource.getCustomHeadersByTautulliId(tTautulliId),
        ).thenAnswer(
          (_) async => Future.value([]),
        );
        // act
        await repository.getCustomHeadersByTautulliId(tTautulliId);
        // assert
        verify(
          () => mockDataSource.getCustomHeadersByTautulliId(tTautulliId),
        ).called(1);
      },
    );
  });

  group('Double Tap To Exit', () {
    test(
      'should return the double tap to exit from settings',
      () async {
        // arrange
        when(() => mockDataSource.getDoubleTapToExit()).thenAnswer(
          (_) async => tDoubleTapToExit,
        );
        // act
        final result = await repository.getDoubleTapToExit();
        // assert
        expect(result, equals(tDoubleTapToExit));
      },
    );

    test(
      'should forward the call to the data source to set double tap to exit',
      () async {
        // arrange
        when(() => mockDataSource.setDoubleTapToExit(any())).thenAnswer(
          (_) async => Future.value(true),
        );
        // act
        await repository.setDoubleTapToExit(tDoubleTapToExit);
        // assert
        verify(() => mockDataSource.setDoubleTapToExit(tDoubleTapToExit))
            .called(1);
      },
    );
  });

  group('Graph Tips Shown', () {
    test(
      'should return the graph tips shown value from settings',
      () async {
        // arrange
        when(() => mockDataSource.getGraphTipsShown()).thenAnswer(
          (_) async => tGraphTipsShown,
        );
        // act
        final result = await repository.getGraphTipsShown();
        // assert
        expect(result, equals(tGraphTipsShown));
      },
    );

    test(
      'should forward the call to the data source to set graph tips shown value',
      () async {
        // arrange
        when(() => mockDataSource.setGraphTipsShown(any())).thenAnswer(
          (_) async => Future.value(true),
        );
        // act
        await repository.setGraphTipsShown(tGraphTipsShown);
        // assert
        verify(() => mockDataSource.setGraphTipsShown(tGraphTipsShown))
            .called(1);
      },
    );
  });

  group('Last App Version', () {
    test(
      'should return the last app version from settings',
      () async {
        // arrange
        when(() => mockDataSource.getLastAppVersion()).thenAnswer(
          (_) async => tLastAppVersion,
        );
        // act
        final result = await repository.getLastAppVersion();
        // assert
        expect(result, equals(tLastAppVersion));
      },
    );

    test(
      'should forward the call to the data source to set last app version',
      () async {
        // arrange
        when(() => mockDataSource.setLastAppVersion(any())).thenAnswer(
          (_) async => Future.value(true),
        );
        // act
        await repository.setLastAppVersion(tLastAppVersion);
        // assert
        verify(() => mockDataSource.setLastAppVersion(tLastAppVersion))
            .called(1);
      },
    );
  });

  group('Last Read Announcement ID', () {
    test(
      'should return the last read announcement ID from settings',
      () async {
        // arrange
        when(() => mockDataSource.getLastReadAnnouncementId()).thenAnswer(
          (_) async => tLastReadAnnouncementId,
        );
        // act
        final result = await repository.getLastReadAnnouncementId();
        // assert
        expect(result, equals(tLastReadAnnouncementId));
      },
    );

    test(
      'should forward the call to the data source to set last read announcement ID',
      () async {
        // arrange
        when(() => mockDataSource.setLastReadAnnouncementId(any())).thenAnswer(
          (_) async => Future.value(true),
        );
        // act
        await repository.setLastReadAnnouncementId(tLastReadAnnouncementId);
        // assert
        verify(
          () =>
              mockDataSource.setLastReadAnnouncementId(tLastReadAnnouncementId),
        ).called(1);
      },
    );
  });

  group('Last Selected Server', () {
    test(
      'should return the last selected server from settings',
      () async {
        // arrange
        when(() => mockDataSource.getLastSelectedServer()).thenAnswer(
          (_) async => tLastSelectedServer,
        );
        // act
        final result = await repository.getLastSelectedServer();
        // assert
        expect(result, equals(tLastSelectedServer));
      },
    );

    test(
      'should forward the call to the data source to set last selected server',
      () async {
        // arrange
        when(() => mockDataSource.setLastSelectedServer(any())).thenAnswer(
          (_) async => Future.value(true),
        );
        // act
        await repository.setLastSelectedServer(tLastSelectedServer);
        // assert
        verify(
          () => mockDataSource.setLastSelectedServer(tLastSelectedServer),
        ).called(1);
      },
    );
  });

  group('Mask Sensitive Info', () {
    test(
      'should return the mask sensitive info value from settings',
      () async {
        // arrange
        when(() => mockDataSource.getMaskSensitiveInfo()).thenAnswer(
          (_) async => tMaskSensitiveInfo,
        );
        // act
        final result = await repository.getMaskSensitiveInfo();
        // assert
        expect(result, equals(tMaskSensitiveInfo));
      },
    );

    test(
      'should forward the call to the data source to set mask sensitive info value',
      () async {
        // arrange
        when(() => mockDataSource.setMaskSensitiveInfo(any())).thenAnswer(
          (_) async => Future.value(true),
        );
        // act
        await repository.setMaskSensitiveInfo(tMaskSensitiveInfo);
        // assert
        verify(
          () => mockDataSource.setMaskSensitiveInfo(tMaskSensitiveInfo),
        ).called(1);
      },
    );
  });

  group('OneSignal Banner Dismissed', () {
    test(
      'should return the OneSignal banner dismissed value from settings',
      () async {
        // arrange
        when(() => mockDataSource.getOneSignalBannerDismissed()).thenAnswer(
          (_) async => tOneSignalBannerDismissed,
        );
        // act
        final result = await repository.getOneSignalBannerDismissed();
        // assert
        expect(result, equals(tOneSignalBannerDismissed));
      },
    );

    test(
      'should forward the call to the data source to set OneSignal banner dismissed value',
      () async {
        // arrange
        when(
          () => mockDataSource.setOneSignalBannerDismissed(any()),
        ).thenAnswer(
          (_) async => Future.value(true),
        );
        // act
        await repository.setOneSignalBannerDismissed(tOneSignalBannerDismissed);
        // assert
        verify(
          () => mockDataSource
              .setOneSignalBannerDismissed(tOneSignalBannerDismissed),
        ).called(1);
      },
    );
  });

  group('OneSignal Consented', () {
    test(
      'should return the OneSignal consented value from settings',
      () async {
        // arrange
        when(() => mockDataSource.getOneSignalConsented()).thenAnswer(
          (_) async => tOneSignalConsented,
        );
        // act
        final result = await repository.getOneSignalConsented();
        // assert
        expect(result, equals(tOneSignalConsented));
      },
    );

    test(
      'should forward the call to the data source to set OneSignal consented value',
      () async {
        // arrange
        when(() => mockDataSource.setOneSignalConsented(any())).thenAnswer(
          (_) async => Future.value(true),
        );
        // act
        await repository.setOneSignalConsented(tOneSignalConsented);
        // assert
        verify(() => mockDataSource.setOneSignalConsented(tOneSignalConsented))
            .called(1);
      },
    );
  });

  group('Plex Server Info', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getPlexServerInfo(tTautulliId);
        // assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call data source getPlexServerInfo',
        () async {
          // act
          await repository.getPlexServerInfo(tTautulliId);
          // assert
          verify(() => mockDataSource.getPlexServerInfo(tTautulliId));
        },
      );

      test(
        'response should contain ApiResponseData with PlexServerInfoModel',
        () async {
          // arrange
          when(() => mockDataSource.getPlexServerInfo(any())).thenAnswer(
            (_) async => ApiResponseData(
              data: tPlexServerInfo,
              primaryActive: true,
            ),
          );
          // act
          final response = await repository.getPlexServerInfo(tTautulliId);
          // assert
          expect(
            response,
            equals(
              Right(
                ApiResponseData(
                  data: tPlexServerInfo,
                  primaryActive: true,
                ),
              ),
            ),
          );
        },
      );

      test(
        'should return proper Failure using FailureMapperHelper if a known exception is thrown',
        () async {
          // arrange
          when(() => mockDataSource.getPlexServerInfo(any()))
              .thenThrow(ServerException);
          // act
          final response = await repository.getPlexServerInfo(tTautulliId);
          // assert
          expect(response, equals(Left(ServerFailure())));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return a ConnectionFailure when there is no internet',
        () async {
          //act
          final response = await repository.getPlexServerInfo(tTautulliId);
          //assert
          expect(response, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('Refresh Rate', () {
    test(
      'should return the refresh rate from settings',
      () async {
        // arrange
        when(() => mockDataSource.getRefreshRate()).thenAnswer(
          (_) async => tRefreshRate,
        );
        // act
        final result = await repository.getRefreshRate();
        // assert
        expect(result, equals(tRefreshRate));
      },
    );

    test(
      'should forward the call to the data source to set refresh rate',
      () async {
        // arrange
        when(() => mockDataSource.setRefreshRate(any())).thenAnswer(
          (_) async => Future.value(true),
        );
        // act
        await repository.setRefreshRate(tRefreshRate);
        // assert
        verify(() => mockDataSource.setRefreshRate(tRefreshRate)).called(1);
      },
    );
  });

  group('Get Server', () {
    test(
      'should forward the call to the data source to retreive the server with the ID',
      () async {
        // arrange
        when(() => mockDataSource.getServer(0)).thenAnswer(
          (_) async => Future.value(tServerModel),
        );
        // act
        await repository.getServer(0);
        // assert
        verify(() => mockDataSource.getServer(0)).called(1);
      },
    );
  });

  group('Get Server By Tautulli ID', () {
    test(
      'should forward the call to the data source to retreive the server with the Tautulli ID',
      () async {
        // arrange
        when(
          () => mockDataSource.getServerByTautulliId(tTautulliId),
        ).thenAnswer(
          (_) async => Future.value(tServerModel),
        );
        // act
        await repository.getServerByTautulliId(tTautulliId);
        // assert
        verify(
          () => mockDataSource.getServerByTautulliId(tTautulliId),
        ).called(1);
      },
    );
  });

  group('Server Timeout', () {
    test(
      'should return the server timeout from settings',
      () async {
        // arrange
        when(() => mockDataSource.getServerTimeout())
            .thenAnswer((_) async => tServerTimeout);
        // act
        final result = await repository.getServerTimeout();
        // assert
        expect(result, equals(tServerTimeout));
      },
    );

    test(
      'should forward the call to the data source to set server timeout',
      () async {
        // arrange
        when(() => mockDataSource.setServerTimeout(tServerTimeout)).thenAnswer(
          (_) async => Future.value(true),
        );
        // act
        await repository.setServerTimeout(tServerTimeout);
        // assert
        verify(() => mockDataSource.setServerTimeout(tServerTimeout)).called(1);
      },
    );
  });

  group('Stats Type', () {
    test(
      'should return the stats type from settings',
      () async {
        // arrange
        when(() => mockDataSource.getStatsType()).thenAnswer(
          (_) async => tStatsType,
        );
        // act
        final result = await repository.getStatsType();
        // assert
        expect(result, equals(tStatsType));
      },
    );

    test(
      'should forward the call to the data source to set stats type',
      () async {
        // arrange
        when(() => mockDataSource.setStatsType(any())).thenAnswer(
          (_) async => Future.value(true),
        );
        // act
        await repository.setStatsType(tStatsType);
        // assert
        verify(() => mockDataSource.setStatsType(tStatsType)).called(1);
      },
    );
  });

  group('Tautulli Settings', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getPlexServerInfo(tTautulliId);
        // assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call data source getTautulliSettings',
        () async {
          // act
          await repository.getTautulliSettings(tTautulliId);
          // assert
          verify(() => mockDataSource.getTautulliSettings(tTautulliId));
        },
      );

      test(
        'response should contain ApiResponseData with TautulliSettingsGeneralModel',
        () async {
          // arrange
          when(() => mockDataSource.getTautulliSettings(any())).thenAnswer(
            (_) async => ApiResponseData(
              data: tTautulliSettings,
              primaryActive: true,
            ),
          );
          // act
          final response = await repository.getTautulliSettings(tTautulliId);
          // assert
          expect(
            response,
            equals(
              Right(
                ApiResponseData(
                  data: tTautulliSettings,
                  primaryActive: true,
                ),
              ),
            ),
          );
        },
      );

      test(
        'should return proper Failure using FailureMapperHelper if a known exception is thrown',
        () async {
          // arrange
          when(() => mockDataSource.getTautulliSettings(any()))
              .thenThrow(ServerException);
          // act
          final response = await repository.getTautulliSettings(tTautulliId);
          // assert
          expect(response, equals(Left(ServerFailure())));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return a ConnectionFailure when there is no internet',
        () async {
          //act
          final response = await repository.getTautulliSettings(tTautulliId);
          //assert
          expect(response, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('Users Sort', () {
    test(
      'should return the users sort value from settings',
      () async {
        // arrange
        when(() => mockDataSource.getUsersSort()).thenAnswer(
          (_) async => tUsersSort,
        );
        // act
        final result = await repository.getUsersSort();
        // assert
        expect(result, equals(tUsersSort));
      },
    );

    test(
      'should forward the call to the data source to set users sort value',
      () async {
        // arrange
        when(() => mockDataSource.setUsersSort(any())).thenAnswer(
          (_) async => Future.value(true),
        );
        // act
        await repository.setUsersSort(tUsersSort);
        // assert
        verify(() => mockDataSource.setUsersSort(tUsersSort)).called(1);
      },
    );
  });

  group('Wizard Complete', () {
    test(
      'should return the wizard complete value from settings',
      () async {
        // arrange
        when(() => mockDataSource.getWizardComplete()).thenAnswer(
          (_) async => tWizardComplete,
        );
        // act
        final result = await repository.getWizardComplete();
        // assert
        expect(result, equals(tWizardComplete));
      },
    );

    test(
      'should forward the call to the data source to set wizard complete value',
      () async {
        // arrange
        when(() => mockDataSource.setWizardComplete(any())).thenAnswer(
          (_) async => Future.value(true),
        );
        // act
        await repository.setWizardComplete(tWizardComplete);
        // assert
        verify(() => mockDataSource.setWizardComplete(tWizardComplete))
            .called(1);
      },
    );
  });

  group('Y Axis', () {
    test(
      'should return the y axis value from settings',
      () async {
        // arrange
        when(() => mockDataSource.getYAxis()).thenAnswer(
          (_) async => tYAxis,
        );
        // act
        final result = await repository.getYAxis();
        // assert
        expect(result, equals(tYAxis));
      },
    );

    test(
      'should forward the call to the data source to set y axis value',
      () async {
        // arrange
        when(() => mockDataSource.setYAxis(any())).thenAnswer(
          (_) async => Future.value(true),
        );
        // act
        await repository.setYAxis(tYAxis);
        // assert
        verify(() => mockDataSource.setYAxis(tYAxis)).called(1);
      },
    );
  });

  group('Update Connection Info', () {
    test(
      'should forward the call to the data source to update the connection info',
      () async {
        // arrange
        when(() => mockDataSource.updateConnectionInfo(
              id: any(named: 'id'),
              connectionInfo: any(named: 'connectionInfo'),
            )).thenAnswer(
          (_) async => Future.value(1),
        );
        // act
        await repository.updateConnectionInfo(
          id: 0,
          connectionInfo: {
            'primary_connection_address': tServerModel.primaryConnectionAddress,
            'primary_connection_protocol':
                tServerModel.primaryConnectionProtocol,
            'primary_connection_domain': tServerModel.primaryConnectionDomain,
          },
        );
        // assert
        verify(() => mockDataSource.updateConnectionInfo(
              id: 0,
              connectionInfo: {
                'primary_connection_address':
                    tServerModel.primaryConnectionAddress,
                'primary_connection_protocol':
                    tServerModel.primaryConnectionProtocol,
                'primary_connection_domain':
                    tServerModel.primaryConnectionDomain,
              },
            )).called(1);
      },
    );
  });

  group('Update Custom Headers', () {
    test(
      'should forward the call to the data source to update the list of custom headers',
      () async {
        // arrange
        when(
          () => mockDataSource.updateCustomHeaders(
            tautulliId: any(named: 'tautulliId'),
            customHeaders: any(named: 'customHeaders'),
          ),
        ).thenAnswer(
          (_) async => Future.value(1),
        );
        // act
        await repository.updateCustomHeaders(
          tautulliId: tTautulliId,
          customHeaders: tCustomHeaderList,
        );
        // assert
        verify(
          () => mockDataSource.updateCustomHeaders(
            tautulliId: tTautulliId,
            customHeaders: tCustomHeaderList,
          ),
        ).called(1);
      },
    );
  });

  group('Update Primary Active', () {
    test(
      'should forward the call to the data source to update primary active',
      () async {
        // arrange
        when(
          () => mockDataSource.updatePrimaryActive(
            tautulliId: any(named: 'tautulliId'),
            primaryActive: any(named: 'primaryActive'),
          ),
        ).thenAnswer(
          (_) async => Future.value(1),
        );
        // act
        await repository.updatePrimaryActive(
          tautulliId: tTautulliId,
          primaryActive: true,
        );
        // assert
        verify(
          () => mockDataSource.updatePrimaryActive(
            tautulliId: tTautulliId,
            primaryActive: true,
          ),
        ).called(1);
      },
    );
  });

  group('Update Server', () {
    test(
      'should forward the call to the data source to the provided server',
      () async {
        // arrange
        when(
          () => mockDataSource.updateServer(tServerModel),
        ).thenAnswer(
          (_) async => Future.value(1),
        );
        // act
        await repository.updateServer(tServerModel);
        // assert
        verify(
          () => mockDataSource.updateServer(tServerModel),
        ).called(1);
      },
    );
  });

  group('Update Server Sort', () {
    test(
      'should forward the call to the data source to update the server sort',
      () async {
        // arrange
        when(
          () => mockDataSource.updateServerSort(
            serverId: any(named: 'serverId'),
            newIndex: any(named: 'newIndex'),
            oldIndex: any(named: 'oldIndex'),
          ),
        ).thenAnswer(
          (_) async => Future.value(),
        );
        // act
        await repository.updateServerSort(
          serverId: 0,
          newIndex: 1,
          oldIndex: 0,
        );
        // assert
        verify(
          () => mockDataSource.updateServerSort(
            serverId: 0,
            newIndex: 1,
            oldIndex: 0,
          ),
        ).called(1);
      },
    );
  });
}
