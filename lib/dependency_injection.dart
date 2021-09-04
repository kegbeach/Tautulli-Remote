import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core_new/local_storage/local_storage.dart';
import 'features_new/new_settings/data/datasources/new_settings_data_source.dart';
import 'features_new/new_settings/data/repositories/new_settings_repository_impl.dart';
import 'features_new/new_settings/domain/repositories/new_settings_repository.dart';
import 'features_new/new_settings/domain/usecases/new_settings.dart';

// Service locator alias
final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Settings
  // Use case
  sl.registerLazySingleton(
    () => NewSettings(sl()),
  );

  // Repository
  sl.registerLazySingleton<NewSettingsRespository>(
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

  //! Core - Local Storage
  sl.registerLazySingleton<LocalStorage>(
    () => LocalStorageImpl(sl()),
  );

  //! External - Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
