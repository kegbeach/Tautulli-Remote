import 'package:dartz/dartz.dart';

import '../../../../core_new/api/tautulli_api/api_response_data.dart';
import '../../../../core_new/database/data/models/new_custom_header_model.dart';
import '../../../../core_new/database/data/models/new_server_model.dart';
import '../../../../core_new/error/new_failure.dart';
import '../../../../core_new/helpers/new_failure_helper.dart';
import '../../../../core_new/network_info/new_network_info.dart';
import '../../domain/repositories/new_settings_repository.dart';
import '../datasources/new_settings_data_source.dart';

class NewSettingsRepositoryImpl implements NewSettingsRepository {
  final NewSettingsDataSource dataSource;
  final NewNetworkInfo networkInfo;

  NewSettingsRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<int> addServer(NewServerModel server) async {
    return await dataSource.addServer(server);
  }

  @override
  Future<void> deleteServer(int id) async {
    return await dataSource.deleteServer(id);
  }

  @override
  Future<List<NewServerModel>> getAllServers() async {
    return await dataSource.getAllServers();
  }

  @override
  Future<List<NewServerModel>> getAllServersWithoutOnesignalRegistered() async {
    return await dataSource.getAllServersWithoutOnesignalRegistered();
  }

  @override
  Future<List<int>> getCustomCertHashList() async {
    return await dataSource.getCustomCertHashList();
  }

  @override
  Future<List<NewCustomHeaderModel>> getCustomHeadersByTautulliId(
    String tautulliId,
  ) async {
    return await dataSource.getCustomHeadersByTautulliId(tautulliId);
  }

  @override
  Future<bool> getDoubleTapToExit() async {
    return await dataSource.getDoubleTapToExit();
  }

  @override
  Future<bool> getGraphTipsShown() async {
    return await dataSource.getGraphTipsShown();
  }

  @override
  Future<String?> getLastAppVersion() async {
    return await dataSource.getLastAppVersion();
  }

  @override
  Future<int> getLastReadAnnouncementId() async {
    return await dataSource.getLastReadAnnouncementId();
  }

  @override
  Future<String?> getLastSelectedServer() async {
    return await dataSource.getLastSelectedServer();
  }

  @override
  Future<bool> getMaskSensitiveInfo() async {
    return await dataSource.getMaskSensitiveInfo();
  }

  @override
  Future<bool> getOneSignalBannerDismissed() async {
    return await dataSource.getOneSignalBannerDismissed();
  }

  @override
  Future<bool> getOneSignalConsented() async {
    return await dataSource.getOneSignalConsented();
  }

  @override
  Future<Either<NewFailure, ApiResponseData>> getPlexServerInfo(
    String tautulliId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final plexServerInfo = await dataSource.getPlexServerInfo(tautulliId);
        return Right(plexServerInfo);
      } catch (exception) {
        final NewFailure failure =
            NewFailureHelper.mapExceptionToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<int> getRefreshRate() async {
    return await dataSource.getRefreshRate();
  }

  @override
  Future<NewServerModel> getServer(int id) async {
    return await dataSource.getServer(id);
  }

  @override
  Future<NewServerModel> getServerByTautulliId(String tautulliId) async {
    return await dataSource.getServerByTautulliId(tautulliId);
  }

  @override
  Future<int> getServerTimeout() async {
    return await dataSource.getServerTimeout();
  }

  @override
  Future<String> getStatsType() async {
    return await dataSource.getStatsType();
  }

  @override
  Future<Either<NewFailure, ApiResponseData>> getTautulliSettings(
    String tautulliId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final tautulliSettings =
            await dataSource.getTautulliSettings(tautulliId);
        return Right(tautulliSettings);
      } catch (exception) {
        final NewFailure failure =
            NewFailureHelper.mapExceptionToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<String> getUsersSort() async {
    return await dataSource.getUsersSort();
  }

  @override
  Future<bool> getWizardComplete() async {
    return await dataSource.getWizardComplete();
  }

  @override
  Future<String> getYAxis() async {
    return await dataSource.getYAxis();
  }

  @override
  Future<bool> setCustomCertHashList(List<int> certHashList) async {
    return await dataSource.setCustomCertHashList(certHashList);
  }

  @override
  Future<bool> setDoubleTapToExit(bool value) async {
    return await dataSource.setDoubleTapToExit(value);
  }

  @override
  Future<bool> setGraphTipsShown(bool value) async {
    return await dataSource.setGraphTipsShown(value);
  }

  @override
  Future<bool> setLastAppVersion(String appVersion) async {
    return await dataSource.setLastAppVersion(appVersion);
  }

  @override
  Future<bool> setLastReadAnnouncementId(int value) async {
    return await dataSource.setLastReadAnnouncementId(value);
  }

  @override
  Future<bool> setLastSelectedServer(String tautulliId) async {
    return await dataSource.setLastSelectedServer(tautulliId);
  }

  @override
  Future<bool> setMaskSensitiveInfo(bool value) async {
    return await dataSource.setMaskSensitiveInfo(value);
  }

  @override
  Future<bool> setOneSignalBannerDismissed(bool value) async {
    return await dataSource.setOneSignalBannerDismissed(value);
  }

  @override
  Future<bool> setOneSignalConsented(bool value) async {
    return await dataSource.setOneSignalConsented(value);
  }

  @override
  Future<bool> setRefreshRate(int value) async {
    return await dataSource.setRefreshRate(value);
  }

  @override
  Future<bool> setServerTimeout(int value) async {
    return await dataSource.setServerTimeout(value);
  }

  @override
  Future<bool> setStatsType(String statsType) async {
    return await dataSource.setStatsType(statsType);
  }

  @override
  Future<bool> setUsersSort(String value) async {
    return await dataSource.setUsersSort(value);
  }

  @override
  Future<bool> setWizardComplete(bool value) async {
    return await dataSource.setWizardComplete(value);
  }

  @override
  Future<bool> setYAxis(String value) async {
    return await dataSource.setYAxis(value);
  }

  @override
  Future<int> updateConnectionInfo({
    required int id,
    required Map<String, String> connectionInfo,
  }) async {
    return await dataSource.updateConnectionInfo(
      id: id,
      connectionInfo: connectionInfo,
    );
  }

  @override
  Future<int> updateCustomHeaders({
    required String tautulliId,
    required List<NewCustomHeaderModel> customHeaders,
  }) async {
    return await dataSource.updateCustomHeaders(
      tautulliId: tautulliId,
      customHeaders: customHeaders,
    );
  }

  @override
  Future<int> updatePrimaryActive({
    required String tautulliId,
    required bool primaryActive,
  }) async {
    return await dataSource.updatePrimaryActive(
      tautulliId: tautulliId,
      primaryActive: primaryActive,
    );
  }

  @override
  Future<int> updateServer(NewServerModel server) async {
    return await dataSource.updateServer(server);
  }

  @override
  Future<void> updateServerSort({
    required int serverId,
    required int oldIndex,
    required int newIndex,
  }) async {
    await dataSource.updateServerSort(
      serverId: serverId,
      oldIndex: oldIndex,
      newIndex: newIndex,
    );
  }
}
