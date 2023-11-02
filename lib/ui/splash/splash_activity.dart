import 'dart:async';
import 'dart:io';

import 'package:eksternal_app/engine/dao/impl/auth_impl.dart';
import 'package:eksternal_app/engine/dao/impl/profile_impl.dart';
import 'package:eksternal_app/engine/dao/impl/x_app_id_impl.dart';
import 'package:eksternal_app/engine/model/auth_model.dart';
import 'package:eksternal_app/engine/model/profile.dart';
import 'package:eksternal_app/engine/model/x_app_model.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:eksternal_app/engine/util/route.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../engine/util/access_phone_permission.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 04/07/23
 */


class SplashActivity extends StatefulWidget {
    const SplashActivity({super.key});

    @override
    State<SplashActivity> createState() => _SplashActivityState();

}

class _SplashActivityState extends State<SplashActivity> {

    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    late Future<bool> isFirstRun;

    final Future<SharedPreferences> prefFirstLogin = SharedPreferences.getInstance();
    late Future<bool> isFirstLogin;

    @override
    void initState()  {
        WidgetsBinding.instance.addPostFrameCallback((_)async {

            var permissionGPS = await Permission.location.request();
            var permissionPhoneAccess = await handlePermissionPhoneAccess();
            if(Platform.isIOS){
                // GpsUtil.on();
            }else {
                if(permissionGPS.isDenied) {
                    Get.snackbar("Alert", "This Apps Need Location Permission",
                        duration: Duration(seconds: 5), snackPosition: SnackPosition.BOTTOM, colorText: Colors.white, backgroundColor: GlobalVar.red);
                }
                else if (await Permission.locationWhenInUse.isDenied) {
                    Get.snackbar("Info", "Enable Location, Please!", snackPosition: SnackPosition.BOTTOM,
                        duration: Duration(seconds: 5), colorText: Colors.white, backgroundColor: GlobalVar.red);

                }else if(!permissionPhoneAccess) {
                    Get.snackbar("Alert", "Enable Phone Access, Please!", snackPosition: SnackPosition.BOTTOM,
                        duration: Duration(seconds: 5), colorText: Colors.white, backgroundColor: GlobalVar.red);
                }else {
                    // GpsUtil.mock(true);
                }
            }

            Timer(
                const Duration(seconds: 2),
                    () async {
                    Auth? auth = await AuthImpl().get();
                    Profile? userProfile = await ProfileImpl().get();
                    XAppId? xAppId = await XAppIdImpl().get();
                    if (auth == null ||userProfile == null ) {
                        isFirstRun = prefs.then((SharedPreferences prefs) {
                            return prefs.getBool('isFirstRun') ?? true;
                        });
                        if(await isFirstRun){
                            Get.offNamed(RoutePage.onBoardingPage);
                        }else{
                            Get.offNamed(RoutePage.loginPage);
                        }

                    } else {
                        GlobalVar.auth = auth;
                        GlobalVar.profileUser = userProfile;
                        String appId = await FirebaseRemoteConfig.instance.getString("appId");
                        if(xAppId != null && (appId.isNotEmpty && xAppId.appId != appId) ){
                            xAppId.appId = appId;
                            XAppIdImpl().save(xAppId);
                            GlobalVar.xAppId = xAppId.appId;
                        } else if(xAppId != null){
                            GlobalVar.xAppId = xAppId.appId;
                        } else {
                            xAppId = XAppId();
                            xAppId.appId = appId;
                            XAppIdImpl().save(xAppId);
                            GlobalVar.xAppId = appId;
                        }

                        isFirstLogin = prefFirstLogin.then((SharedPreferences prefs) {
                            return prefs.getBool('isFirstLogin') ?? true;
                        });
                        if(await isFirstLogin){
                            Get.toNamed(RoutePage.privacyPage, arguments: true);
                        }else{
                            Get.offNamed(RoutePage.homePage);
                        }
                    }
                },
            );
        });
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: GlobalVar.primaryOrange,
            body: Center(
                child: Container(
                    height: 192,
                    width: 192,
                    child: SvgPicture.asset("images/white_logo.svg"),
                ),
            ),
        );
    }
}