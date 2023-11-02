// ignore_for_file: no_logic_in_create_state;, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors

import 'package:eksternal_app/component/button_fill/button_fill_controller.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 04/07/23
 */

class ButtonFill extends StatelessWidget {
    ButtonFillController controller;
    String label;
    double width;
    final Function() onClick;

    ButtonFill({super.key, this.width = double.infinity, required this.controller, required this.label, required this.onClick});

    ButtonFillController getController() {
        return Get.find(tag: controller.tag);
    }

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SizedBox(
                    width: width,
                    height: 50,
                    child: ElevatedButton(
                    
                        onPressed: controller.activeField.isTrue ? onClick : () {},
                        style: ElevatedButton.styleFrom(
                             elevation: 0,
                            backgroundColor: controller.activeField.isTrue ? GlobalVar.primaryOrange : GlobalVar.gray,
                            foregroundColor: controller.activeField.isTrue ? GlobalVar.primaryOrange : GlobalVar.gray,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                        ),
                        child: Center(
                            child: Padding(
                                padding: const EdgeInsets.only(top: 16, bottom: 16),
                                child: Text(
                                    label,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                            )
                        ),
                    ),
                )
            )
        );
    }
}
