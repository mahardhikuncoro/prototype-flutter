// ignore_for_file: no_logic_in_create_state;, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eksternal_app/component/spinner_field/spinner_field_controller.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 07/07/23
 */

class SpinnerField extends StatelessWidget {
    SpinnerFieldController controller;
    String label;
    String hint;
    String alertText;
    bool hideLabel = false;
    bool isDetail;
    Map<String, bool> items;
    Function(String) onSpinnerSelected;

    SpinnerField({super.key, required this.controller, required this.label, required this.hint, required this.alertText, this.hideLabel = false, required this.items, required this.onSpinnerSelected, this.isDetail = false,});

    SpinnerFieldController getController() {
        return Get.find(tag: controller.tag);
    }

    bool onInit = true;

    @override
    Widget build(BuildContext context) {
        Future.delayed(Duration.zero, () {
            if (onInit) {
                controller.generateItems(items);
                onInit = false;
            }
        });

        final labelField = SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
                label,
                textAlign: TextAlign.left,
                style: TextStyle(color: GlobalVar.black, fontSize: 14),
            ),
        );

        return Obx(() => controller.showSpinner.isTrue
            ? Padding(
            key: controller.formKey,
            padding: const EdgeInsets.only(top: 16),
            child: Column(
                children: <Widget>[
                    controller.hideLabel.isFalse ? labelField : Container(),
                    const SizedBox(height: 8,),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: controller.activeField.isTrue ? GlobalVar.primaryLight : GlobalVar.gray,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        color: controller.activeField.isTrue && controller.showTooltip.isFalse && controller.isShowList.isTrue
                                            ? GlobalVar.primaryOrange : controller.activeField.isTrue && controller.showTooltip.isTrue
                                            ? GlobalVar.red : Colors.transparent,
                                        width: 2)
                                ),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                        autofocus: true,
                                        menuItemStyleData: MenuItemStyleData(),
                                        dropdownStyleData: DropdownStyleData(
                                            maxHeight: 260,
                                            padding: null,
                                            isOverButton: false,
                                            offset: Offset(0, -5),
                                            scrollbarTheme: ScrollbarThemeData(
                                                trackVisibility: MaterialStateProperty.all(true),
                                                radius: const Radius.circular(40),
                                                thickness: MaterialStateProperty.all(6),
                                                thumbVisibility: MaterialStateProperty.all(true),
                                                interactive: true,
                                            ),

                                        ),
                                        isExpanded : true,
                                        isDense: true,
                                        alignment: Alignment.centerLeft,
                                        focusNode: controller.focusNode,
                                        buttonStyleData: ButtonStyleData(padding: null),
                                        iconStyleData: IconStyleData(
                                            icon: Align(
                                                alignment: Alignment.center,
                                                child : Row(children: [
                                                    controller.isloading.isTrue ? Container(
                                                        margin: EdgeInsets.only(right: 16),
                                                        child: SizedBox(
                                                            width: 24,
                                                            height: 24,
                                                            child: CircularProgressIndicator(color: GlobalVar.primaryOrange,)),
                                                    ) : Container(),
                                                    controller.activeField.isTrue
                                                        ?controller.isShowList.isTrue? SvgPicture.asset("images/arrow_up.svg") : SvgPicture.asset("images/arrow_down.svg")
                                                        : SvgPicture.asset("images/arrow_disable.svg"),
                                                    const SizedBox(width: 16,)
                                                ],)
                                            ),
                                        ),
                                        onMenuStateChange: (isOpen) {
                                            if(isOpen) {
                                                controller.focusNode.focusInDirection(TraversalDirection.down);
                                            }
                                            controller.isShowList.value = isOpen;
                                        },
                                        items: renderItems(),
                                        underline: Container(),
                                        hint: Text(
                                            controller.textSelected.value == "" ? hint : controller.textSelected.value,
                                            style: TextStyle(color: controller.textSelected.value == "" ? Color(0xFF9E9D9D) : GlobalVar.black, fontSize: 14)
                                        ),
                                        onChanged: controller.activeField.isTrue ? (String? newValue) {
                                            controller.items.value.forEach((key, value) {
                                                if (key == newValue) {
                                                    controller.items.value[key] = true;
                                                    controller.textSelected.value = key;

                                                    int index = 0;
                                                    controller.items.value.forEach((label, value) {
                                                        if (key == label) {
                                                            controller.selectedIndex = index;

                                                            // for selected object
                                                            if (controller.listObject.length > 0) {
                                                                controller.selectedObject = controller.listObject[controller.selectedIndex];
                                                            }
                                                        }
                                                        index++;
                                                    });

                                                    onSpinnerSelected(key);
                                                    controller.showTooltip.value = false;
                                                    controller.isShowList.value = false;
                                                } else {
                                                    controller.items.value[key] = false;
                                                }
                                            });
                                        } : null,
                                    ),
                                )
                            ),
                            controller.showTooltip.isTrue
                                ? Container(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                    children: [
                                        Padding(
                                            padding: const EdgeInsets.only(right: 8),
                                            child: SvgPicture.asset("images/error_icon.svg")
                                        ),
                                        Text(
                                            controller.alertText.value.isNotEmpty ? controller.alertText.value : alertText,
                                            style: TextStyle(color: GlobalVar.red, fontSize: 12),
                                        )
                                    ],
                                )
                            ) : Container()
                        ],
                    ),
                ],
            ),
        ) : Container());
    }

    List<DropdownMenuItem<String>> renderItems() {
        List<DropdownMenuItem<String>> result = [];

        controller.items.value.forEach((key, value) {
            result.add(
                DropdownMenuItem(
                    value: key,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            controller.items.value[key] == true ? SvgPicture.asset("images/on_spin.svg") : SvgPicture.asset("images/off_spin.svg"),
                            const SizedBox(width: 8),
                            isDetail ? Center(
                                child: Container(
                                    margin: EdgeInsets.only(left: 4),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            const SizedBox(height: 8),
                                            Text(key, style: TextStyle(color: GlobalVar.black, fontSize: 14)),
                                            Row(
                                                children: [
                                                    Text("Jumlah (Ekor) ", style: GlobalVar.blackTextStyle.copyWith(fontSize: 10),),
                                                    Text("${controller.amountItems[key]} Ekor - ", style: GlobalVar.blackTextStyle.copyWith(fontSize: 10, fontWeight: FontWeight.w500)),
                                                    Text("Total (Kg) ", style: GlobalVar.blackTextStyle.copyWith(fontSize: 10),),
                                                    Text("${controller.weightItems[key]} Kg", style: GlobalVar.blackTextStyle.copyWith(fontSize: 10, fontWeight: FontWeight.w500)),
                                                ]
                                            )
                                        ],
                                    ),
                                ),
                            ) : Expanded(child: Text(key, style: TextStyle(color: GlobalVar.black, fontSize: 14), overflow: TextOverflow.clip,)),
                        ]
                    )
                )
            );
        });

        return result;
    }
}
