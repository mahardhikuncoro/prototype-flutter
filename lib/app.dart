import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:eksternal_app/engine/util/internet_connection.dart';
import 'package:eksternal_app/engine/util/route.dart';
import 'package:eksternal_app/ui/beranda/beranda_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 04/07/23
 */

class App extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        StreamInternetConnection.init();
        GlobalVar.setContext(context);
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Montserrat_Medium'),
            navigatorObservers: [ChuckerFlutter.navigatorObserver],
            initialRoute: AppRoutes.initial,
            initialBinding: BerandaBindings(context: context),
            getPages: AppRoutes.page,
        );
    }
}