import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'app_theme.dart';
import 'model/api/server.dart';
import 'model/auth/auth_controller.dart';
import 'model/error_handlers/error_service_plugins/api_error_plugin.dart';
import 'model/managers/cached_loadable_manager.dart';
import 'model/managers/cached_paginated_loadable_manager.dart';
import 'model/managers/category_manager.dart';
import 'model/managers/post_manager.dart';
import 'model/managers/user_manager.dart';
import 'model/services/auth_service.dart';
import 'model/managers/group_manager.dart';
import 'model/services/camera_service.dart';
import 'model/services/error_service.dart';
import 'model/services/media_service.dart';
import 'model/services/navigation_chain_service.dart';
import 'model/services/notification_service.dart';
import 'model/services/search_service.dart';

import 'model/error_handlers/error_service_plugins/firebase_auth_error_plugin.dart';
import 'model/error_handlers/error_service_plugins/info_exception_plugin.dart';
import 'model/services/preferences_service.dart';

final sl = GetIt.instance;

void initLocator() {

  //Error service
  final ErrorService errorService = ErrorService();
  errorService.registerPlugins([
    apiErrorPlugin,
    infoExceptionPlugin,
    firebaseAuthErrorPlugin
  ]);
  sl.registerSingleton(errorService);

  sl.registerLazySingleton(() => AuthController( FirebaseAuth.instance ));
  sl.registerLazySingleton(() => FirebaseStorage.instance);

  sl.registerLazySingleton(() => Server( sl() ));

  sl.registerLazySingleton(() => AuthService(FirebaseAuth.instance, sl<Server>()));
  sl.registerLazySingleton(() => SearchService());

  sl.registerLazySingleton(() => NotificationService());
  sl.registerLazySingleton(() => MediaService());
  sl.registerLazySingleton(() => CameraService());
  sl.registerLazySingleton(() => PreferencesService());
  sl.registerLazySingleton(() => NavigationChainService());
  sl.registerLazySingleton(() => GlobalAppThemeConfig());

  //Managers
  sl.registerLazySingleton(() => GroupManager(sl<Server>()));
  sl.registerLazySingleton(() => PostManager(sl<Server>()));
  sl.registerLazySingleton(() => UserManager(sl<Server>()));
  sl.registerLazySingleton(() => CategoryManager());
  sl.registerLazySingleton(() => CachedPaginatedLoadableManager());
  sl.registerLazySingleton(() => CachedLoadableManager());

}