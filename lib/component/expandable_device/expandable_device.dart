// ignore_for_file: no_logic_in_create_state;, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors

import 'package:eksternal_app/component/expandable_device/expandable_device_controller.dart';
import 'package:eksternal_app/component/progress_loading/progress_loading.dart';
import 'package:eksternal_app/engine/model/device_model.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 25/07/23
 */

class ExpandableDevice extends StatelessWidget {
    ExpandableDeviceController controller;
    String headerText;
    bool expanded;
    String value;
    String unitValue;
    String icon;
    int valueTextColor;
    Device device;
    String sensorType;
    String targetLabel;
    String averageLabel;
    Function(bool) onExpand;


    ExpandableDevice({super.key, required this.controller, required this.headerText, this.expanded = false
        , required this.value, required this.unitValue, this.icon = "images/temperature_icon.svg", this.valueTextColor = 0xFF2C2B2B
        , required this.onExpand, required this.device, required this.sensorType, this.averageLabel = "", this.targetLabel = ""});

    ExpandableDeviceController getController() {
        return Get.find(tag: controller.tag);
    }

    @override
    Widget build(BuildContext context) {
        controller.expanded.value = expanded;

        return Obx(() =>
            GFAccordion(
                margin: EdgeInsets.only(top: 10),
                // title: headerText,
                titleChild: Row(
                    children: [
                        Row(
                            children: [
                                Container(
                                    width: 64,
                                    height: 64,
                                    // padding: EdgeInsets.all(36),
                                    margin: EdgeInsets.only(left: 6, right: 6),
                                    decoration: BoxDecoration(
                                        color:GlobalVar.iconHomeBg,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(6),
                                            topRight: Radius.circular(6),
                                            bottomRight: Radius.circular(6),
                                            bottomLeft: Radius.circular(6))),
                                    child: Center(
                                        child: SvgPicture.asset(icon, width: 32, height: 32,),
                                    ),
                                )
                            ],
                        ),
                        // Icon(Icons.widgets),
                        SizedBox(width: 8,),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text("${headerText}",
                                    style: GlobalVar.greyTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium)
                                ),
                                SizedBox(height: 8,),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        Text("${value} ${unitValue}",
                                            style: TextStyle(color: Color(valueTextColor), fontSize: 24, fontWeight: GlobalVar.medium)
                                        )
                            ],)
                        ],)
                    ],
                ),
                textStyle: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium),
                onToggleCollapsed: (isExpand) {
                    onExpand(isExpand);
                    if (isExpand) {
                        controller.expand();
                        controller.getHistoricalData(sensorType, device, 1);
                        controller.indexTab.value = 0 ;
                    } else {
                        controller.collapse();
                    }
                },
                collapsedTitleBackgroundColor: Colors.white,
                expandedTitleBackgroundColor: Colors.white,
                showAccordion: controller.expanded.value,
                collapsedIcon: Container(
                    margin: EdgeInsets.only(right: 16),
                    child: SvgPicture.asset("images/arrow_down.svg")),
                expandedIcon: SvgPicture.asset("images/arrow_up.svg"),
                titleBorder: Border.all(color: GlobalVar.outlineColor,),
                titleBorderRadius: controller.expanded.isTrue ? BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)) : BorderRadius.all(Radius.circular(10)),
                contentBorder: Border(
                    bottom: BorderSide(color:GlobalVar.outlineColor, width: 1),
                    left: BorderSide(color: GlobalVar.outlineColor, width: 1),
                    right: BorderSide(color: GlobalVar.outlineColor, width: 1),
                    top: BorderSide(color: GlobalVar.outlineColor, width: 0),
                ),
                contentBorderRadius: controller.expanded.isTrue ? BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)) : BorderRadius.all(Radius.circular(10)),
                contentChild:
                Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            SizedBox(height: 8,),
                            Text("Riwayat ${headerText} Kandang",
                                style: GlobalVar.primaryTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium)
                            ),
                            SizedBox(height: 16,),
                            Row(
                              children: [
                                  targetLabel == "" ? Container() :
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                          SizedBox(width: 16,),
                                          SvgPicture.asset("images/circle_green.svg"),
                                          SizedBox(width: 12,),
                                          Text(targetLabel, style: GlobalVar.blackTextStyle),

                                      ],
                                  ),
                                  averageLabel == "" ? Container() :
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                          SizedBox(width: 24,),
                                          SvgPicture.asset("images/circle_primary_orange.svg"),
                                          SizedBox(width: 12,),
                                          Text(averageLabel, style: GlobalVar.blackTextStyle),
                                      ],
                                  )
                              ]
                            ),
                            controller.isLoading.isTrue ?
                            Center(
                                child:
                                SizedBox(
                                    child: ProgressLoading(), height: 124, width: 124,
                                ),
                            ) : controller.gvSmartMonitoring,
                            Container(
                                margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        GestureDetector(
                                            onTap: (){
                                                controller.indexTab.value = 0;
                                                controller.getHistoricalData(sensorType, device, 1);
                                            }  ,
                                              child: Column(
                                                  children: [
                                                      Text("1 Hari", style: controller.indexTab == 0 ? GlobalVar.primaryTextStyle : GlobalVar.blackTextStyle),
                                                      SizedBox(height: 8,),
                                                      Container(
                                                          height: 2,
                                                          width: 48,
                                                          color: controller.indexTab == 0 ? GlobalVar.primaryOrange : Colors.white,
                                                      )
                                                  ],
                                              ),
                                        ),
                                        GestureDetector(
                                            onTap: (){
                                                controller.indexTab.value = 1;
                                                controller.getHistoricalData(sensorType, device, 3);
                                            },
                                            child: Column(
                                                children: [
                                                    Text("3 Hari", style: controller.indexTab == 1 ? GlobalVar.primaryTextStyle : GlobalVar.blackTextStyle),
                                                    SizedBox(height: 8,),
                                                    Container(
                                                        height: 2,
                                                        width: 48,
                                                        color: controller.indexTab == 1 ? GlobalVar.primaryOrange : Colors.white,
                                                      )
                                                  ],
                                              ),
                                        ),
                                        GestureDetector(
                                            onTap: (){
                                                controller.indexTab.value = 2;
                                                controller.getHistoricalData(sensorType, device, 7);
                                            },
                                            child: Column(
                                              children: [
                                                  Text("7 Hari", style: controller.indexTab == 2 ? GlobalVar.primaryTextStyle : GlobalVar.blackTextStyle),
                                                  SizedBox(height: 8,),
                                                  Container(
                                                      height: 2,
                                                      width: 48,
                                                      color: controller.indexTab == 2 ? GlobalVar.primaryOrange : Colors.white,
                                                  )
                                              ],
                                          ),
                                        ),
                                        GestureDetector(
                                            onTap: (){
                                                controller.indexTab.value = 3;
                                                controller.getHistoricalData(sensorType, device, -1);
                                            },
                                            child: Column(
                                              children: [
                                                  Text("1 Siklus", style: controller.indexTab == 3 ? GlobalVar.primaryTextStyle : GlobalVar.blackTextStyle),
                                                  SizedBox(height: 8,),
                                                  Container(
                                                      height: 2,
                                                      width: 48,
                                                      color: controller.indexTab == 3 ? GlobalVar.primaryOrange : Colors.white,
                                                  )
                                              ],
                                          ),
                                        )
                                    ],
                                ),
                            )
                        ],
                    ),
                )
            )
        );
    }
}
