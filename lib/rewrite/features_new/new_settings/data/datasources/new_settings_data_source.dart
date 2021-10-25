import 'dart:convert';

import '../../../../core_new/api/tautulli_api/api_response_data.dart';
import '../../../../core_new/api/tautulli_api/new_tautulli_api.dart'
    as tautulli_api;
import '../../../../core_new/database/data/datasources/new_database.dart';
import '../../../../core_new/database/data/models/new_custom_header_model.dart';
import '../../../../core_new/database/data/models/new_server_model.dart';
import '../../../../core_new/enums/protocol.dart';
import '../../../../core_new/local_storage/local_storage.dart';
import '../models/connection_address_model.dart';
import '../models/new_plex_server_info_model.dart';
import '../models/new_tautulli_settings_general_model.dart';

abstract class NewSettingsDataSource {
  Future<int> addServer(NewServerModel server);

  Future<void> deleteServer(int id);

  Future<List<NewServerModel>> getAllServers();

  Future<List<NewServerModel>> getAllServersWithoutOnesignalRegistered();

  Future<List<int>> getCustomCertHashList();

  Future<List<NewCustomHeaderModel>> getCustomHeadersByTautulliId(
      String tautulliId);

  Future<bool> getDoubleTapToExit();

  Future<bool> getGraphTipsShown();

  Future<String?> getLastAppVersion();

  Future<int> getLastReadAnnouncementId();

  Future<String?> getLastSelectedServer();

  Future<bool> getMaskSensitiveInfo();

  Future<bool> getOneSignalBannerDismissed();

  Future<bool> getOneSignalConsented();

  Future<ApiResponseData> getPlexServerInfo(String tautulliId);

  Future<int> getRefreshRate();

  Future<NewServerModel> getServer(int id);

  Future<NewServerModel> getServerByTautulliId(String tautulliId);

  Future<int> getServerTimeout();

  Future<String> getStatsType();

  Future<ApiResponseData> getTautulliSettings(
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
    required ConnectionAddressModel connectionAddress,
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

const customCertHashList = 'customCertHashList';
const doubleTapToExit = 'doubleTapToExit';
const graphTipsShown = 'graphTipsShown';
const lastAppVersion = 'lastAppVersion';
const lastReadAnnouncementId = 'lastReadAnnouncementId';
const lastSelectedServer = 'lastSelectedServer';
const maskSensitiveInfo = 'maskSensitiveInfo';
const oneSignalBannerDismissed = 'oneSignalBannerDismissed';
const oneSignalConsented = 'oneSignalConsented';
const refreshRate = 'refreshRate';
const serverTimeout = 'serverTimeout';
const statsType = 'statsType';
const usersSort = 'usersSort';
const wizardComplete = 'wizardComplete';
const yAxis = 'yAxis';

class NewSettingsDataSourceImpl implements NewSettingsDataSource {
  final LocalStorage localStorage;
  final tautulli_api.NewGetServerInfo apiGetServerInfo;
  final tautulli_api.NewGetSettings apiGetSettings;

  NewSettingsDataSourceImpl({
    required this.localStorage,
    required this.apiGetServerInfo,
    required this.apiGetSettings,
  });

  @override
  Future<int> addServer(NewServerModel server) async {
    return await DBProvider.db.addServer(server);
  }

  @override
  Future<void> deleteServer(int id) async {
    await DBProvider.db.deleteServer(id);
  }

  //* GET

  @override
  Future<List<NewServerModel>> getAllServers() async {
    return await DBProvider.db.getAllServers();
  }

  @override
  Future<List<NewServerModel>> getAllServersWithoutOnesignalRegistered() async {
    return await DBProvider.db.getAllServersWithoutOnesignalRegistered();
  }

  @override
  Future<List<int>> getCustomCertHashList() {
    List<String> stringList;
    List<int> intList = [];

    stringList = localStorage.getStringList(customCertHashList) ?? [];
    intList = stringList.map((i) => int.parse(i)).toList();

    return Future.value(intList);
  }

  @override
  Future<List<NewCustomHeaderModel>> getCustomHeadersByTautulliId(
      String tautulliId) async {
    final String encodedHeaders =
        await DBProvider.db.getCustomHeadersByTautulliId(tautulliId);
    final Map<String, dynamic> decodedHeaders = json.decode(encodedHeaders);

    final List<NewCustomHeaderModel> customHeaderList = [];

    decodedHeaders.forEach((key, value) {
      customHeaderList.add(
        NewCustomHeaderModel(
          key: key,
          value: value,
        ),
      );
    });

    return customHeaderList;
  }

  @override
  Future<bool> getDoubleTapToExit() async {
    return Future.value(localStorage.getBool(doubleTapToExit) ?? false);
  }

  @override
  Future<bool> getGraphTipsShown() async {
    return Future.value(localStorage.getBool(graphTipsShown) ?? false);
  }

  @override
  Future<String?> getLastAppVersion() async {
    return Future.value(localStorage.getString(lastAppVersion));
  }

  @override
  Future<int> getLastReadAnnouncementId() async {
    return Future.value(localStorage.getInt(lastReadAnnouncementId) ?? -1);
  }

  @override
  Future<String?> getLastSelectedServer() async {
    return Future.value(localStorage.getString(lastSelectedServer));
  }

  @override
  Future<bool> getMaskSensitiveInfo() async {
    return Future.value(
      localStorage.getBool(maskSensitiveInfo) ?? false,
    );
  }

  @override
  Future<bool> getOneSignalBannerDismissed() async {
    return Future.value(
      localStorage.getBool(oneSignalBannerDismissed) ?? false,
    );
  }

  @override
  Future<bool> getOneSignalConsented() async {
    return Future.value(
      localStorage.getBool(oneSignalConsented) ?? false,
    );
  }

  @override
  Future<ApiResponseData> getPlexServerInfo(String tautulliId) async {
    final response = await apiGetServerInfo(tautulliId: tautulliId);

    final plexServerInfo = NewPlexServerInfoModel.fromJson(
      response['responseData']['response']['data'],
    );

    return ApiResponseData(
      data: plexServerInfo,
      primaryActive: response['primaryActive'],
    );
  }

  @override
  Future<int> getRefreshRate() async {
    return Future.value(localStorage.getInt(refreshRate) ?? 0);
  }

  @override
  Future<NewServerModel> getServer(int id) async {
    return await DBProvider.db.getServer(id);
  }

  @override
  Future<NewServerModel> getServerByTautulliId(String tautulliId) async {
    return await DBProvider.db.getServerByTautulliId(tautulliId);
  }

  @override
  Future<int> getServerTimeout() {
    return Future.value(localStorage.getInt(serverTimeout) ?? 15);
  }

  @override
  Future<String> getStatsType() {
    return Future.value(localStorage.getString(statsType) ?? 'plays');
  }

  @override
  Future<ApiResponseData> getTautulliSettings(
    String tautulliId,
  ) async {
    final response = await apiGetSettings(tautulliId: tautulliId);

    final tautulliSettingsGeneral = NewTautulliSettingsGeneralModel.fromJson(
      response['responseData']['response']['data']['General'],
    );

    return ApiResponseData(
      data: tautulliSettingsGeneral,
      primaryActive: response['primaryActive'],
    );
  }

  @override
  Future<String> getUsersSort() async {
    return Future.value(
      localStorage.getString(usersSort) ?? 'friendly_name|asc',
    );
  }

  @override
  Future<bool> getWizardComplete() async {
    return Future.value(localStorage.getBool(wizardComplete) ?? false);
  }

  @override
  Future<String> getYAxis() async {
    return Future.value(localStorage.getString(yAxis) ?? 'plays');
  }

  //* SET

  @override
  Future<bool> setCustomCertHashList(List<int> certHashList) {
    final List<String> stringList =
        certHashList.map((i) => i.toString()).toList();

    return localStorage.setStringList(customCertHashList, stringList);
  }

  @override
  Future<bool> setDoubleTapToExit(bool value) {
    return localStorage.setBool(doubleTapToExit, value);
  }

  @override
  Future<bool> setGraphTipsShown(bool value) {
    return localStorage.setBool(graphTipsShown, value);
  }

  @override
  Future<bool> setLastAppVersion(String appVersion) {
    return localStorage.setString(lastAppVersion, appVersion);
  }

  @override
  Future<bool> setLastReadAnnouncementId(int value) {
    return localStorage.setInt(lastReadAnnouncementId, value);
  }

  @override
  Future<bool> setLastSelectedServer(String tautulliId) {
    return localStorage.setString(lastSelectedServer, tautulliId);
  }

  @override
  Future<bool> setMaskSensitiveInfo(bool value) {
    return localStorage.setBool(maskSensitiveInfo, value);
  }

  @override
  Future<bool> setOneSignalBannerDismissed(bool value) {
    return localStorage.setBool(oneSignalBannerDismissed, value);
  }

  @override
  Future<bool> setOneSignalConsented(bool value) {
    return localStorage.setBool(oneSignalConsented, value);
  }

  @override
  Future<bool> setRefreshRate(int value) {
    return localStorage.setInt(refreshRate, value);
  }

  @override
  Future<bool> setServerTimeout(int value) {
    return localStorage.setInt(serverTimeout, value);
  }

  @override
  Future<bool> setStatsType(String value) {
    return localStorage.setString(statsType, value);
  }

  @override
  Future<bool> setUsersSort(String value) {
    return localStorage.setString(usersSort, value);
  }

  @override
  Future<bool> setWizardComplete(bool value) {
    return localStorage.setBool(wizardComplete, value);
  }

  @override
  Future<bool> setYAxis(String value) {
    return localStorage.setString(yAxis, value);
  }

  @override
  Future<int> updateConnectionInfo({
    required int id,
    required ConnectionAddressModel connectionAddress,
  }) async {
    final Map<String, String?> connectionAddressMap = {};

    if (connectionAddress.primary) {
      connectionAddressMap['primary_connection_address'] =
          connectionAddress.address;
      connectionAddressMap['primary_connection_protocol'] =
          connectionAddress.protocol?.toShortString();
      connectionAddressMap['primary_connection_domain'] =
          connectionAddress.domain;
      connectionAddressMap['primary_connection_path'] = connectionAddress.path;
    } else {
      connectionAddressMap['secondary_connection_address'] =
          connectionAddress.address;
      connectionAddressMap['secondary_connection_protocol'] =
          connectionAddress.protocol?.toShortString();
      connectionAddressMap['secondary_connection_domain'] =
          connectionAddress.domain;
      connectionAddressMap['secondary_connection_path'] =
          connectionAddress.path;
    }

    return await DBProvider.db.updateConnection(
      id: id,
      dbConnectionAddressMap: connectionAddressMap,
    );
  }

  @override
  Future<int> updateCustomHeaders({
    required String tautulliId,
    required List<NewCustomHeaderModel> customHeaders,
  }) async {
    Map<String, String> customHeaderMap = {};
    for (NewCustomHeaderModel customHeader in customHeaders) {
      customHeaderMap[customHeader.key] = customHeader.value;
    }

    final String encodedHeaders = json.encode(customHeaderMap);

    return await DBProvider.db.updateCustomHeaders(
      tautulliId: tautulliId,
      encodedCustomHeaders: encodedHeaders,
    );
  }

  @override
  Future<int> updatePrimaryActive({
    required String tautulliId,
    required bool primaryActive,
  }) async {
    late int value;

    switch (primaryActive) {
      case (false):
        value = 0;
        break;
      case (true):
        value = 1;
        break;
    }

    return await DBProvider.db.updatePrimaryActive(
      tautulliId: tautulliId,
      primaryActive: value,
    );
  }

  @override
  Future<int> updateServer(NewServerModel server) async {
    return await DBProvider.db.updateServer(server);
  }

  @override
  Future<void> updateServerSort({
    required int serverId,
    required int oldIndex,
    required int newIndex,
  }) async {
    await DBProvider.db.updateServerSort(serverId, oldIndex, newIndex);
  }
}
