import 'package:dartz/dartz.dart';

import '../../../../core_new/api/tautulli_api/api_response_data.dart';
import '../../../../core_new/database/data/models/new_custom_header_model.dart';
import '../../../../core_new/database/data/models/new_server_model.dart';
import '../../../../core_new/error/new_failure.dart';
import '../repositories/new_settings_repository.dart';

class NewSettings {
  final NewSettingsRepository repository;

  NewSettings(this.repository);

  /// Inserts the provided `NewServerModel` into the database.
  Future<int> addServer(NewServerModel server) {
    return repository.addServer(server);
  }

  /// Deletes the server with the provided `id` from the database.
  Future<void> deleteServer(int id) async {
    await repository.deleteServer(id);
  }

  /// Returns a list of `NewServerModel` with all servers in the database.
  Future<List<NewServerModel>> getAllServers() async {
    return await repository.getAllServers();
  }

  /// Returns a list of `NewServerModel` with all servers in the database that
  /// have OneSignalRegistered set to false.
  Future<List<NewServerModel>> getAllServersWithoutOnesignalRegistered() async {
    return await repository.getAllServersWithoutOnesignalRegistered();
  }

  /// Returns a list of user approved certificate hashes.
  ///
  /// Used for communicating with servers that could not be authenticated by
  /// any of the built in trusted root certificates.
  ///
  /// If no value is store returns an empty list.
  Future<List<int>> getCustomCertHashList() async {
    return await repository.getCustomCertHashList();
  }

  /// Returns a list of `CustomHeaderModel` for the server with the provided
  /// Tautulli ID.
  ///
  /// If no value is store returns an empty list.
  Future<List<NewCustomHeaderModel>> getCustomHeadersByTautulliId(
    String tautulliId,
  ) async {
    return await repository.getCustomHeadersByTautulliId(tautulliId);
  }

  /// Returns if exiting the app should require two sequential back actions.
  ///
  /// If no value is stored returns `false`.
  Future<bool> getDoubleTapToExit() async {
    return await repository.getDoubleTapToExit();
  }

  /// Returns if the graph tips should be shown when opening the graphs page.
  ///
  /// If no value is stored returns `false`.
  Future<bool> getGraphTipsShown() async {
    return await repository.getGraphTipsShown();
  }

  /// Returns the last version of the app to determine if the changelog should
  /// be displayed.
  ///
  /// If no value is stored returns `null`.
  Future<String?> getLastAppVersion() async {
    return await repository.getLastAppVersion();
  }

  /// Returns the last read announcement ID to determine which announcements
  /// need the unread indicator.
  ///
  /// If no value is stored returns `-1`.
  Future<int> getLastReadAnnouncementId() async {
    return await repository.getLastReadAnnouncementId();
  }

  /// Used to determine which server was last selected when using multiserver.
  ///
  /// If no value is stored returns `null`.
  Future<String?> getLastSelectedServer() async {
    return await repository.getLastSelectedServer();
  }

  /// Returns if the app should mask sensitive info.
  ///
  /// If no value is stored returns `false`.
  Future<bool> getMaskSensitiveInfo() async {
    return await repository.getMaskSensitiveInfo();
  }

  /// Returns if the OneSignal Banner has been dismissed when determining if
  /// it should be displayed.
  ///
  /// If no value is stored returns `false`.
  Future<bool> getOneSignalBannerDismissed() async {
    return await repository.getOneSignalBannerDismissed();
  }

  /// Returns if the user has consented to OneSignal.
  ///
  /// Used to account for issues where updating OneSignal clears out the
  /// consent status.
  ///
  /// If no value is stored returns `false`.
  Future<bool> getOneSignalConsented() async {
    return await repository.getOneSignalConsented();
  }

  /// Returns Plex server information like name, plexpass status, etc.
  Future<Either<NewFailure, ApiResponseData>> getPlexServerInfo(
    String tautulliId,
  ) async {
    return await repository.getPlexServerInfo(tautulliId);
  }

  /// Returns the refresh rate used for auto refreshing activity.
  ///
  /// If no value is stored returns `0`.
  Future<int> getRefreshRate() async {
    return await repository.getRefreshRate();
  }

  /// Returns a `ServerModel` for the server with the provided ID.
  Future<NewServerModel> getServer(int id) async {
    return await repository.getServer(id);
  }

  /// Returns a `ServerModel` for the corresponding Tautulli ID.
  Future<NewServerModel> getServerByTautulliId(String tautulliId) async {
    return await repository.getServerByTautulliId(tautulliId);
  }

  /// How long to wait in seconds before timing out the server connection.
  ///
  /// If no value is stored returns `15`.
  Future<int> getServerTimeout() async {
    return await repository.getServerTimeout();
  }

  /// Returns the value used for sorting the statistics.
  ///
  /// If no value is stored returns `'plays'`.
  Future<String> getStatsType() async {
    return await repository.getStatsType();
  }

  /// Returns `TautulliSettingsGeneralModel` with Tautulli General settings.
  Future<Either<NewFailure, ApiResponseData>> getTautulliSettings(
    String tautulliId,
  ) async {
    return await repository.getTautulliSettings(tautulliId);
  }

  /// Returns the value used for sorting users.
  ///
  /// If no value is store returns `'friendly_name|asc'`.
  Future<String> getUsersSort() async {
    return await repository.getUsersSort();
  }

  /// Returns if the setup wizard has been completed/edited.
  ///
  /// Used to determine if the setup wizard needs to be displayed.
  Future<bool> getWizardComplete() async {
    return await repository.getWizardComplete();
  }

  /// Returns the value used for the y axis on graphs.
  ///
  /// If no value is stored returns `'plays'`.
  Future<String> getYAxis() async {
    return await repository.getYAxis();
  }

  /// Sets the list of approved custom cert hashes.
  Future<bool> setCustomCertHashList(List<int> certHashList) async {
    return await repository.setCustomCertHashList(certHashList);
  }

  /// Sets if exiting the app should require two sequential back actions.
  Future<bool> setDoubleTapToExit(bool value) async {
    return await repository.setDoubleTapToExit(value);
  }

  /// Sets if the graph tips have been shown.
  Future<bool> setGraphTipsShown(bool value) async {
    return await repository.setGraphTipsShown(value);
  }

  /// Sets the current app version to be compared against in a future update.
  Future<bool> setLastAppVersion(String appVersion) async {
    return await repository.setLastAppVersion(appVersion);
  }

  /// Sets the last read announcement ID for indicating new announcements.
  Future<bool> setLastReadAnnouncementId(int value) async {
    return await repository.setLastReadAnnouncementId(value);
  }

  /// Set the last selected server when using multiserver.
  Future<bool> setLastSelectedServer(String tautulliId) async {
    return await repository.setLastSelectedServer(tautulliId);
  }

  /// Sets if the app should mask sensitive info.
  Future<bool> setMaskSensitiveInfo(bool value) async {
    return await repository.setMaskSensitiveInfo(value);
  }

  /// Sets if the OneSignal banner has been manually dismissed.
  Future<bool> setOneSignalBannerDismissed(bool value) async {
    return await repository.setOneSignalBannerDismissed(value);
  }

  /// Sets if OneSignal data privacy has been consented to.
  Future<bool> setOneSignalConsented(bool value) async {
    return await repository.setOneSignalConsented(value);
  }

  /// Set the refresh rate used when automatically updating the activity.
  Future<bool> setRefreshRate(int value) async {
    return await repository.setRefreshRate(value);
  }

  /// Sets the time to wait in seconds before timing out the server connection.
  Future<bool> setServerTimeout(int value) async {
    return await repository.setServerTimeout(value);
  }

  /// Set the value used for sorting the statistics.
  Future<bool> setStatsType(String statsType) async {
    return await repository.setStatsType(statsType);
  }

  /// Set the value used for sorting the users.
  Future<bool> setUsersSort(String value) async {
    return await repository.setUsersSort(value);
  }

  /// Set if the setup wizard has been completed/exited.
  Future<bool> setWizardComplete(bool value) async {
    return await repository.setWizardComplete(value);
  }

  /// Set the value used for the graph y axis.
  Future<bool> setYAxis(String value) async {
    return await repository.setYAxis(value);
  }

  /// Updates the server with provided ID using the information provided in
  /// `connectionInfo`.
  ///
  /// Map should contain keys of `*_connection_address`,
  /// `*_connection_protocol`, `*_connection_domain`, and `*_connection_path`.
  ///
  /// Where `*` can be `primary` or `secondary`.
  Future<int> updateConnectionInfo({
    required int id,
    required Map<String, String> connectionInfo,
  }) async {
    return await repository.updateConnectionInfo(
      id: id,
      connectionInfo: connectionInfo,
    );
  }

  /// Updates the server with the provided Tautulli ID with the list of
  /// `CustomHeaderModel`.
  ///
  /// This list should contain all headers for the server.
  Future<int> updateCustomHeaders({
    required String tautulliId,
    required List<NewCustomHeaderModel> customHeaders,
  }) async {
    return await repository.updateCustomHeaders(
      tautulliId: tautulliId,
      customHeaders: customHeaders,
    );
  }

  /// Updates the server with the current active connection address.
  Future<int> updatePrimaryActive({
    required String tautulliId,
    required bool primaryActive,
  }) async {
    return await repository.updatePrimaryActive(
      tautulliId: tautulliId,
      primaryActive: primaryActive,
    );
  }

  /// Updates the server with the provided `ServerModel`.
  Future<int> updateServer(NewServerModel server) async {
    return await repository.updateServer(server);
  }

  /// Updates the server sort by taking the server with provided `serverId` and
  ///moving it from `oldIndex` to `newIndex`.
  Future<void> updateServerSort({
    required int serverId,
    required int oldIndex,
    required int newIndex,
  }) async {
    await repository.updateServerSort(
      serverId: serverId,
      oldIndex: oldIndex,
      newIndex: newIndex,
    );
  }
}
