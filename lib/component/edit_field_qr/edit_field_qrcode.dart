// ignore_for_file: no_logic_in_create_state;, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors

import 'package:eksternal_app/component/edit_field_qr/edit_field_qrcode_controller.dart';
import 'package:eksternal_app/engine/util/convert.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:eksternal_app/engine/util/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 17/07/23
 */


class EditFieldQR extends StatelessWidget {
    EditFieldQRController controller;
    String label;
    String hint;
    String alertText;
    String textUnit;
    String? textPrefix;
    int maxInput;
    bool hideLabel;
    double width;
    bool isMacAddres;
    TextInputType inputType;
    TextInputAction action;
    Function(String, EditFieldQR) onTyping;

    EditFieldQR({super.key, required this.controller, required this.label, required this.hint, required this.alertText, required this.textUnit, required this.maxInput, this.inputType = TextInputType.text,
        this.action = TextInputAction.done, this.hideLabel = false, required this.onTyping, this.width = double.infinity, this.textPrefix, this.isMacAddres=false});

    late String data;
    final editFieldController = TextEditingController();

    EditFieldQRController getController() {
        return Get.find(tag: controller.tag);
    }

    void setInput(String text) {
        editFieldController.text = text;
    }

    String getInput() {
        return editFieldController.text;
    }

    double? getInputNumber() {
        return Convert.toDouble(editFieldController.text);
    }

    String getTextPrefix() {
        return textPrefix!;
    }

    @override
    Widget build(BuildContext context) {

        final labelField = SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
                label,
                textAlign: TextAlign.left,
                style: TextStyle(color: GlobalVar.black, fontSize: 14),
            ),
        );

        return Obx(
                () => controller.showField.isTrue
                ? Padding(
                key: controller.formKey,
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                    children: <Widget>[
                        controller.hideLabel.isFalse ? labelField : Container(),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 8, top: 8),
                            child: Column(
                                children: <Widget>[
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                            Flexible(
                                                child: SizedBox(
                                                    width: width,
                                                    height: 50,
                                                    child: TextFormField(
                                                        controller: editFieldController,
                                                        enabled: controller.activeField.isTrue,
                                                        maxLength: maxInput,
                                                        textInputAction: action,
                                                        keyboardType: inputType,
                                                        inputFormatters: isMacAddres ? [
                                                            MaskTextInputFormatter(mask: "##:##:##:##:##:##:##:##",
                                                                filter: {"#": RegExp('[0-9A-Fa-f]')}
                                                            )
                                                        ] :  [
                                                            MaskTextInputFormatter(mask: "######",
                                                                filter: {"#": RegExp('[0-9A-Za-z]')}
                                                            )
                                                        ],
                                                        onChanged: (text) {
                                                            controller.hideAlert();
                                                            onTyping(text, this);

                                                        },
                                                        decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets.only(left: 8),
                                                            counterText: "",
                                                            hintText: hint,
                                                            hintStyle: TextStyle(fontSize: 15, color: Color(0xFF9E9D9D)),
                                                            prefixIcon: textPrefix != null ? Padding(
                                                                padding: const EdgeInsets.only(left: 16.0, top: 15.0, bottom: 15.0, right: 2),
                                                                child: Text("${textPrefix}",
                                                                    style: TextStyle(color: controller.activeField.isTrue ? GlobalVar.primaryOrange : GlobalVar.black, fontSize: 16)),
                                                            ): null,
                                                            suffixIcon: Padding(
                                                                padding: const EdgeInsets.all(16),
                                                                child: Text(textUnit,
                                                                    style: TextStyle(color: controller.activeField.isTrue ? GlobalVar.primaryOrange : GlobalVar.black, fontSize: 14)),
                                                            ),
                                                            fillColor: controller.activeField.isTrue ? GlobalVar.primaryLight : GlobalVar.gray,
                                                            focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                borderSide: BorderSide(
                                                                    color: controller.activeField.isTrue && controller.showTooltip.isFalse ? GlobalVar.primaryOrange : controller.activeField.isTrue && controller.showTooltip.isTrue ? GlobalVar.red : Colors.white,
                                                                    width: 2.0,
                                                                ),
                                                            ),
                                                            disabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                borderSide: BorderSide(color: GlobalVar.gray),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                borderSide: BorderSide(color: GlobalVar.primaryLight)
                                                            ),
                                                            filled: true,
                                                        ),
                                                    ),
                                                ),
                                            ),
                                            SizedBox(width: 8,),
                                            controller.activeField.isTrue ?
                                            ElevatedButton(
                                                      onPressed: (){
                                                          GlobalVar.track("Click_scan_button");
                                                          Get.toNamed(RoutePage.scanBarcode, arguments: [
                                                              {"first": 'First data'},
                                                              {"second": 'Second data'}
                                                          ])!.then((result) {
                                                              String resultString = result[0]["backValue"];
                                                              if(textPrefix != "" && !resultString.contains(textPrefix!)) {
                                                                  controller.showAlert();
                                                              }else{
                                                                  controller.hideAlert();
                                                              }
                                                              editFieldController.text = resultString.replaceAll(textPrefix!, "");

                                                          });
                                                          // openCamera();
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                          padding: EdgeInsets.all(0),
                                                          elevation: 0,
                                                          backgroundColor: Colors.transparent,
                                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                          minimumSize: Size(0, 0)
                                                      ),
                                                      child: Container(
                                                          width: 50,
                                                          height: 50,
                                                          padding: EdgeInsets.all(10),
                                                          decoration: BoxDecoration(
                                                              color: GlobalVar.orangeLight,
                                                              borderRadius: BorderRadius.circular(10)
                                                          ),
                                                          child:SvgPicture.asset("images/qr_code_icon.svg") ,
                                                      ),

                                            ) :Container(
                                                width: 50,
                                                height: 50,
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color:  GlobalVar.gray,
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                                child:SvgPicture.asset("images/qr_code_disable_icon.svg") ,
                                            ),

                                            // Container(
                                            //     width: 40,
                                            //     height: 40,
                                            //     margin: EdgeInsets.all(4),
                                            //     padding: EdgeInsets.all(8),
                                            //     decoration: BoxDecoration(
                                            //         color:Color(0xFFFEEFD2),
                                            //         borderRadius: BorderRadius.only(
                                            //             topLeft: Radius.circular(4),
                                            //             topRight: Radius.circular(4),
                                            //             bottomRight: Radius.circular(4),
                                            //             bottomLeft: Radius.circular(4))),
                                            //     child: Center(
                                            //         child: SvgPicture.asset("images/qr_code_icon.svg"),
                                            //     ),
                                            // )
                                        ],
                                    )
,
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: controller.showTooltip.isTrue
                                            ? Container(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Row(
                                                children: [
                                                    Padding(
                                                        padding: const EdgeInsets.only(right: 8),
                                                        child: SvgPicture.asset("images/error_icon.svg")
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                            controller.alertText.value.isNotEmpty ? controller.alertText.value : alertText,
                                                            style: TextStyle(color: GlobalVar.red, fontSize: 12),
                                                            overflow: TextOverflow.clip,
                                                        ),
                                                    )
                                                ],
                                            )
                                        )
                                            : Container(),
                                    )
                                ],
                            )
                        )
                    ],
                ),
            )
                : Container(),
        );
    }
}
