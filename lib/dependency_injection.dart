import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core_new/api/tautulli_api/new_tautulli_api.dart' as tautulli_api;
import 'core_new/local_storage/local_storage.dart';
import 'core_new/network_info/new_network_info.dart';
import 'features_new/new_activity/data/datasources/new_activity_data_source.dart';
import 'features_new/new_activity/data/repositories/new_activity_repository_impl.dart';
import 'features_new/new_activity/domain/repositories/new_activity_repository.dart';
import 'features_new/new_activity/domain/usecases/new_get_activity.dart';
import 'features_new/new_settings/data/datasources/new_settings_data_source.dart';
import 'features_new/new_settings/data/repositories/new_settings_repository_impl.dart';
import 'features_new/new_settings/domain/repositories/new_settings_repository.dart';
import 'features_new/new_settings/domain/usecases/new_settings.dart';

// Service locator alias
final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Activity
  // Use case
  sl.registerLazySingleton(
    () => NewGetActivity(sl()),
  );

  // Repository
  sl.registerLazySingleton<NewActivityRepository>(
    () => NewActivityRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NewActivityDataSource>(
    () => NewActivityDataSourceImpl(sl()),
  );

  //! Features - Settings
  // Use case
  sl.registerLazySingleton(
    () => NewSettings(sl()),
  );

  // Repository
  sl.registerLazySingleton<NewSettingsRepository>(
    () => NewSettingsRepositoryImpl(
      dataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NewSettingsDataSource>(
    () => NewSettingsDataSourceImpl(
      localStorage: sl(),
    ),
  );

  //! Core - API
  sl.registerLazySingleton<tautulli_api.NewCallTautulli>(
    () => tautulli_api.NewCallTautulliImpl(),
  );
  sl.registerLazySingleton<tautulli_api.NewConnectionHandler>(
    () => tautulli_api.NewConnectionHandlerImpl(
      sl(),
    ),
  );

  sl.registerLazySingleton<tautulli_api.NewGetActivity>(
    () => tautulli_api.NewGetActivityImpl(
      sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.NewGetGeoipLookup>(
    () => tautulli_api.NewGetGeoipLookupImpl(
      sl(),
    ),
  );

  //! Core - Local Storage
  sl.registerLazySingleton<LocalStorage>(
    () => LocalStorageImpl(sl()),
  );

  //! Core - Network Info
  sl.registerLazySingleton<NewNetworkInfo>(
    () => NewNetworkInfoImpl(sl()),
  );

  //! External - Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
