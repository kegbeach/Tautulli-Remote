import 'package:dartz/dartz.dart';

import '../../../../core_new/api/tautulli_api/api_response_data.dart';
import '../../../../core_new/database/data/models/new_custom_header_model.dart';
import '../../../../core_new/database/data/models/new_server_model.dart';
import '../../../../core_new/error/new_failure.dart';

abstract class NewSettingsRepository {
  Future<int> addServer(NewServerModel server);

  Future<void> deleteServer(int id);

  Future<List<NewServerModel>> getAllServers();

  Future<List<NewServerModel>> getAllServersWithoutOnesignalRegistered();

  Future<List<int>> getCustomCertHashList();

  Future<List<NewCustomHeaderModel>> getCustomHeadersByTautulliId(
    String tautulliId,
  );

  Future<bool> getDoubleTapToExit();

  Future<bool> getGraphTipsShown();

  Future<String?> getLastAppVersion();

  Future<int> getLastReadAnnouncementId();

  Future<String?> getLastSelectedServer();

  Future<bool> getMaskSensitiveInfo();

  Future<bool> getOneSignalBannerDismissed();

  Future<bool> getOneSignalConsented();

  Future<Either<NewFailure, ApiResponseData>> getPlexServerInfo(
    String tautulliId,
  );

  Future<int> getRefreshRate();

  Future<NewServerModel> getServer(int id);

  Future<NewServerModel> getServerByTautulliId(String tautulliId);

  Future<int> getServerTimeout();

  Future<String> getStatsType();

  Future<Either<NewFailure, ApiResponseData>> getTautulliSettings(
    String tautulliId,
  );

  Future<String> getUsersSort();

  Future<bool> getWizardComplete();

  Future<String> getYAxis();

  Future<bool> setCustomCertHashList(List<int> certHashList);

  Future<bool> setDoubleTapToExit(bool value);

  Future<bool> setGraphTipsShown(bool value);

  Future<bool> setLastAppVersion(String appVersion);

  Future<bool> setLastReadAnnouncementId(int value);

  Future<bool> setLastSelectedServer(String tautulliId);

  Future<bool> setMaskSensitiveInfo(bool value);

  Future<bool> setOneSignalBannerDismissed(bool value);

  Future<bool> setOneSignalConsented(bool value);

  Future<bool> setRefreshRate(int value);

  Future<bool> setServerTimeout(int value);

  Future<bool> setStatsType(String statsType);

  Future<bool> setUsersSort(String value);

  Future<bool> setWizardComplete(bool value);

  Future<bool> setYAxis(String value);

  Future<int> updateConnectionInfo({
    required int id,
    required Map<String, String> connectionInfo,
  });

  Future<int> updateCustomHeaders({
    required String tautulliId,
    required List<NewCustomHeaderModel> customHeaders,
  });

  Future<int> updatePrimaryActive({
    required String tautulliId,
    required bool primaryActive,
  });

  Future<int> updateServer(NewServerModel server);

  Future<void> updateServerSort({
    required int serverId,
    required int oldIndex,
    required int newIndex,
  });
}
