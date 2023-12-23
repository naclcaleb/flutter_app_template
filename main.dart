import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'app.dart';
import 'service_locator.dart';
import 'model/services/preferences_service.dart';
import 'root_app_config.dart';
import 'package:flutter/material.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var firebaseApp = await Firebase.initializeApp(
    /* Firebase data here */
  );

  //Dev mode; use Firebase emulators
  if (RootAppConfig.environment == ProjectEnvironment.dev) {
    await FirebaseAuth.instance.useAuthEmulator(RootAppConfig.devHost, 9099);
    await FirebaseStorage.instance.useStorageEmulator(RootAppConfig.devHost, 9199);
  }

  //Set up dependencies
  initLocator();
  final preferencesService = GetIt.instance.get<PreferencesService>();
  await preferencesService.init();

  //Run the app
  runApp(App());
}

