// ignore_for_file: no_logic_in_create_state;, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors

import 'package:eksternal_app/component/date_time_field/datetime_field_controller.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 09/08/23
 */

class DateTimeField extends StatelessWidget {

    static const int DATE_FLAG = 1;
    static const int TIME_FLAG = 2;
    static const int ALL_FLAG = 3;

    DateTimeFieldController controller;
    String label;
    String hint;
    String alertText;
    bool hideLabel = false;
    int flag;
    Function(DateTime) onDateTimeSelected;

    DateTimeField({super.key, required this.controller, required this.label, required this.hint, required this.alertText, this.flag = ALL_FLAG, required this.onDateTimeSelected});

    DateTimeFieldController getController() {
        return Get.find(tag: controller.tag);
    }

    DateTime _lastDateTime = DateTime.now();

    DateTime getLastTimeSelected() {
        return _lastDateTime;
    }

    String getLastTimeSelectedText() {
        return getController().textSeleted.value;
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

        return Obx(() =>
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                    children: <Widget>[
                        controller.hideLabel.isFalse ? labelField : Container(),
                        Padding(
                            key: controller.formKey,
                            padding: const EdgeInsets.only(bottom: 8, top: 8),
                            child: Column(
                                children: <Widget>[
                                    GestureDetector(
                                        onTap: () => _showPicker(context),
                                        child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: controller.activeField.isTrue ? GlobalVar.primaryLight : GlobalVar.gray,
                                                borderRadius: BorderRadius.circular(10.0),
                                                border: Border.all(color: controller.activeField.isTrue && controller.showTooltip.isFalse ? Colors.white : controller.activeField.isTrue && controller.showTooltip.isTrue ? GlobalVar.red : Colors.white, width: 2)
                                            ),
                                            child: Row(
                                                children: [
                                                    Expanded(
                                                        flex: 8,
                                                        child: Padding(
                                                            padding: const EdgeInsets.only(left: 8),
                                                            child: Text(
                                                                controller.textSeleted.value == "" ? hint : controller.textSeleted.value,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(color: controller.activeField.isTrue || controller.textSeleted.value == "" ? GlobalVar.black : Color(0xFF9E9D9D), fontSize: 14)
                                                            ),
                                                        )
                                                    ),
                                                    Expanded(
                                                        flex: 1,
                                                        child: controller.activeField.isTrue ?  SvgPicture.asset("images/time_on_icon.svg") : SvgPicture.asset("images/time_on_icon_disable.svg")
                                                    ),
                                                ],
                                            ),
                                        ),
                                    ),
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
                                                    Text(
                                                        alertText,
                                                        style: TextStyle(color: GlobalVar.red, fontSize: 12),
                                                    )
                                                ],
                                            )
                                        ) : Container(),
                                    )
                                ],
                            )
                        ),
                    ],
                ),
            )
        );
    }

    Future<void> _showPicker(BuildContext context) async {
        if (flag == DATE_FLAG) {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _lastDateTime,
                firstDate: DateTime(1900),
                lastDate: DateTime(2200)
            );

            if (pickedDate != null ) {
                _lastDateTime = pickedDate;
                onDateTimeSelected(_lastDateTime);
            }
        } else if (flag == TIME_FLAG) {
            TimeOfDay initTime = TimeOfDay.fromDateTime(_lastDateTime);
            TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: initTime.replacing(hour: initTime.hourOfPeriod)
            );

            if (pickedTime != null ) {
                _lastDateTime = DateTime(_lastDateTime.year, _lastDateTime.month, _lastDateTime.day, pickedTime.hour, pickedTime.minute);
                onDateTimeSelected(_lastDateTime);
            }
        } else {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _lastDateTime,
                firstDate: DateTime(1900),
                lastDate: DateTime(2200)
            );

            if (pickedDate != null ) {
                _lastDateTime = pickedDate;
                TimeOfDay initTime = TimeOfDay.fromDateTime(pickedDate);
                TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: initTime.replacing(hour: initTime.hourOfPeriod)
                );

                if (pickedTime != null ) {
                    _lastDateTime = DateTime(_lastDateTime.year, _lastDateTime.month, _lastDateTime.day, pickedTime.hour, pickedTime.minute);
                    onDateTimeSelected(_lastDateTime);
                }
            }
        }
    }
}