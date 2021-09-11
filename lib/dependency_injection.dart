import 'package:get_it/get_it.dart';

import 'core_new/api/tautulli_api/new_tautulli_api.dart' as tautulli_api;
import 'core_new/device_info/device_info.dart';
import 'core_new/local_storage/local_storage.dart';
import 'core_new/network_info/new_network_info.dart';
import 'features_new/new_activity/data/datasources/new_activity_data_source.dart';
import 'features_new/new_activity/data/repositories/new_activity_repository_impl.dart';
import 'features_new/new_activity/domain/repositories/new_activity_repository.dart';
import 'features_new/new_activity/domain/usecases/new_get_activity.dart';
import 'features_new/new_activity/presentation/bloc/new_activity_bloc.dart';
import 'features_new/new_image_url/data/datasources/new_image_url_data_source.dart';
import 'features_new/new_image_url/data/repositories/new_image_url_repository_impl.dart';
import 'features_new/new_image_url/domain/repositories/new_image_url_repository.dart';
import 'features_new/new_image_url/domain/usecases/new_get_image_url.dart';
import 'features_new/new_onesignal/data/datasources/new_onesignal_data_source.dart';
import 'features_new/new_settings/data/datasources/new_register_device_data_source.dart';
import 'features_new/new_settings/data/datasources/new_settings_data_source.dart';
import 'features_new/new_settings/data/repositories/new_register_device_repository_impl.dart';
import 'features_new/new_settings/data/repositories/new_settings_repository_impl.dart';
import 'features_new/new_settings/domain/repositories/new_register_device_repository.dart';
import 'features_new/new_settings/domain/repositories/new_settings_repository.dart';
import 'features_new/new_settings/domain/usecases/new_register_device.dart';
import 'features_new/new_settings/domain/usecases/new_settings.dart';
import 'features_new/new_settings/presentation/bloc/new_settings_bloc.dart';

// Service locator alias
final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Activity
  // Bloc
  sl.registerFactory(
    () => NewActivityBloc(
      getActivity: sl(),
      getImageUrl: sl(),
    ),
  );

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

  //! Feature - Image URL
  // Use case
  sl.registerLazySingleton(
    () => NewGetImageUrl(sl()),
  );

  // Repository
  sl.registerLazySingleton<NewImageUrlRepository>(
    () => NewImageUrlRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NewImageUrlDataSource>(
    () => NewImageUrlDataSourceImpl(sl()),
  );

  //! Features - OneSignal
  // Data sources
  sl.registerLazySingleton<NewOnesignalDataSource>(
    () => NewOnesignalDataSourceImpl(),
  );

  //! Features - Settings
  // Bloc
  sl.registerFactory(
    () => NewSettingsBloc(sl()),
  );

  // Use case
  sl.registerLazySingleton(
    () => NewRegisterDevice(sl()),
  );
  sl.registerLazySingleton(
    () => NewSettings(sl()),
  );

  // Repository
  sl.registerLazySingleton<NewRegisterDeviceRepository>(
    () => NewRegisterDeviceRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<NewSettingsRepository>(
    () => NewSettingsRepositoryImpl(
      dataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NewRegisterDeviceDataSource>(
    () => NewRegisterDeviceDataSourceImpl(
      apiRegisterDevice: sl(),
      deviceInfo: sl(),
      oneSignal: sl(),
    ),
  );
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
  sl.registerLazySingleton<tautulli_api.NewPmsImageProxy>(
    () => tautulli_api.NewPmsImageProxyImpl(
      sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.NewRegisterDevice>(
    () => tautulli_api.NewRegisterDeviceImpl(
      sl(),
    ),
  );

  //! Core - Device Info
  sl.registerLazySingleton<DeviceInfo>(
    () => DeviceInfoImpl(sl()),
  );

  //! Core - Local Storage
  sl.registerLazySingleton<LocalStorage>(
    () => LocalStorageImpl(sl()),
  );

  //! Core - Network Info
  sl.registerLazySingleton<NewNetworkInfo>(
    () => NewNetworkInfoImpl(sl()),
  );

  //! External
  //TODO: Uncomment when swiching over from injection_container.dart
  // final sharedPreferences = await SharedPreferences.getInstance();
  // sl.registerLazySingleton(() => sharedPreferences);
  // sl.registerLazySingleton(() => Connectivity());
  // sl.registerLazySingleton(() => DeviceInfoPlugin());
}
