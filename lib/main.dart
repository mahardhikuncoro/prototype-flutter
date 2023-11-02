

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */



import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:eksternal_app/engine/dao/db_lite.dart';
import 'package:eksternal_app/engine/util/firebase_config.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:eksternal_app/main.reflectable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  ChuckerFlutter.showOnRelease = true;

  initializeReflectable();
  initPlatformState();
  runApp(const PitikApplication());
}

class PitikApplication extends StatelessWidget {
  const PitikApplication({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    GlobalVar.setContext(context);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Montserrat_Medium'),
      //   navigatorObservers: [ChuckerFlutter.navigatorObserver],
      // initialRoute: AppRoutes.initial,
      // getPages: AppRoutes.page,
    );
  }


}

Future<void> initPlatformState() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBLite().database;
  await Firebase.initializeApp();

  FirebaseConfig.setupCrashlytics();
  FirebaseConfig.setupRemoteConfig();

  // String? token = await FirebaseConfig.setupCloudMessaging();
  // print('token firebase -> $token');
}