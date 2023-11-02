import 'package:eksternal_app/component/button_fill/button_fill.dart';
import 'package:eksternal_app/component/button_outline/button_outline.dart';
import 'package:eksternal_app/component/edit_field/edit_field.dart';
import 'package:eksternal_app/engine/get_x_creator.dart';
import 'package:eksternal_app/engine/util/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 25/08/23
 */

class OnBoardingController extends GetxController {
    BuildContext context;
    OnBoardingController({required this.context});

    final Future<SharedPreferences> pref = SharedPreferences.getInstance();
    late Future<bool> isFirstRun;

    ScrollController scrollController = ScrollController();
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

    var boardingIndeks = 0.obs;

    late ButtonFill bfNext = ButtonFill(
        controller: GetXCreator.putButtonFillController("bfNext"),
        label: "Lanjut", onClick: () {
        if(boardingIndeks < 3) {
            boardingIndeks++;
        }

    },
    );
    late ButtonFill bfStart = ButtonFill(
        controller: GetXCreator.putButtonFillController("bfStart"),
        label: "Mulai", onClick: () {
        setPreferences();
        Get.offNamed(RoutePage.loginPage);
    },
    );
    late ButtonOutline boNoRegBuilding;
    late EditField efNoHp = EditField(
        controller: GetXCreator.putEditFieldController(
            "efNoHpForgetPassword"),
        label: "Nomor Handphone",
        hint: "08xxxx",
        alertText: "Nomer Handphone Tidak Boleh Kosong",
        textUnit: "",
        inputType: TextInputType.number,
        maxInput: 20,
        onTyping: (value, control) {
        }
    );

    @override
    void onInit() {
        super.onInit();
    }

    @override
    void onClose() {
        super.onClose();
    }

    @override
    void onReady() {
        super.onReady();
    }

    Future<void> setPreferences() async {
        final SharedPreferences prefs = await pref;
        isFirstRun = prefs.setBool('isFirstRun', false);
    }
}

class OnBoardingBindings extends Bindings {
    BuildContext context;

    OnBoardingBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => OnBoardingController(context: context));
    }
}

