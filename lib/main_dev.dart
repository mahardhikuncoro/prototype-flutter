import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:eksternal_app/app.dart';
import 'package:eksternal_app/engine/dao/db_lite.dart';
import 'package:eksternal_app/engine/util/firebase_config.dart';
import 'package:eksternal_app/flavors.dart';
import 'package:eksternal_app/main.reflectable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
void main() async {
  F.appFlavor = Flavor.DEV;
  ChuckerFlutter.showOnRelease = true;
  initializeReflectable();
  await initPlatformState();
  runApp(App());
}

Future<void> initPlatformState() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBLite().database;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //
  FirebaseConfig.setupCrashlytics();
  FirebaseConfig.setupRemoteConfig();

  // await FirebaseConfig.setupCloudMessaging();
}