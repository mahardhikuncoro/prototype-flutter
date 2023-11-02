// ignore_for_file: no_logic_in_create_state;, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors

import 'package:eksternal_app/component/button_outline/button_outline_controller.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 04/07/23
 */


class ButtonOutline extends StatelessWidget {
    ButtonOutlineController controller;
    final String label;
    final double width;
    final bool isHaveIcon;
    final String imageAsset;
    final Function() onClick;

    ButtonOutline({super.key, this.width = double.infinity, required this.controller, required this.label, this.isHaveIcon = false, this.imageAsset = "images/checkin_icon.svg", required this.onClick});

    ButtonOutlineController getController() {
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
                            backgroundColor: controller.activeField.isTrue ? Colors.white : GlobalVar.gray,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                width: 2,
                                color: controller.activeField.isTrue ? GlobalVar.primaryOrange : GlobalVar.gray),
                            ),
                        ),
                        child: isHaveIcon
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Text(
                                        label,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: controller.activeField.isTrue ? GlobalVar.primaryOrange : Colors.white, fontSize: 14),
                                    ),
                                    const SizedBox(width: 11),
                                    Icon(Icons.add, size: 24, color: GlobalVar.primaryOrange,)
                                ],
                            )
                            : Center(
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                                    child: Text(
                                        label,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: controller.activeField.isTrue ? GlobalVar.primaryOrange : Colors.white, fontSize: 14),
                                    ),
                                )
                            ),
                     ),
                )
            )
        );
  }
}
