import 'dart:async';
import 'package:eksternal_app/component/device_status.dart';
import 'package:eksternal_app/component/progress_loading/progress_loading.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:eksternal_app/engine/util/route.dart';
import 'package:eksternal_app/ui/dashboard_fan/dashboard_fan_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 06/07/23
 */


class DashboardFan extends StatelessWidget {
    DashboardFan({super.key});

    Widget build(BuildContext context) {
        final DashboardFanController controller =
        Get.put(DashboardFanController(context: context));

        Widget appBar() {
            return AppBar(
                elevation: 0,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                ),
                backgroundColor: GlobalVar.primaryOrange,
                centerTitle: true,
                title: Text(
                    "Kipas",
                    style: GlobalVar.whiteTextStyle
                        .copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
                ),
            );
        }


        Widget listFan() {
            return Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.fans.value.length,
                    itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                                Get.toNamed(RoutePage.fanSetupPage, arguments: [controller.fans.value[index], controller.device, controller.controllerData])!.then((value) {
                                    controller.isLoading.value = true;
                                    controller.fans.value.clear();
                                    Timer(Duration(milliseconds: 500), () {
                                        controller.getDataFans();
                                    });
                                });
                            },
                            child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12),
                                margin: EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: GlobalVar.outlineColor),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                        Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color:GlobalVar.iconHomeBg,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(4),
                                                    topRight: Radius.circular(4),
                                                    bottomRight: Radius.circular(4),
                                                    bottomLeft: Radius.circular(4))),
                                            child: Center(
                                                child: SvgPicture.asset("images/fan_icon.svg"),
                                            ),
                                        ),
                                         Expanded(
                                           child: Container(
                                               margin: EdgeInsets.only(left: 8, right: 8),
                                             child: Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                     Row(
                                                         children: [
                                                             Text(
                                                                 controller.fans.value[index].fanName!,
                                                                 style: GlobalVar.blackTextStyle
                                                                     .copyWith(fontWeight: GlobalVar.medium, fontSize: 17, overflow: TextOverflow.ellipsis),
                                                             ),
                                                             SizedBox(width: 24,),
                                                             DeviceStatus(status: controller.fans.value[index].status!),
                                                         ],
                                                     ),
                                                     SizedBox(height: 4,),
                                                     Row(
                                                         crossAxisAlignment: CrossAxisAlignment.start,
                                                         children: [
                                                             RichText(
                                                                 text: TextSpan(style: TextStyle(color: Colors.blue), //apply style to all
                                                                     children: [
                                                                         TextSpan(text: 'Target ', style: GlobalVar.greyTextStyle
                                                                             .copyWith(fontWeight: GlobalVar.medium, fontSize: 12),),
                                                                         TextSpan(text: '${controller.fans.value[index].temperatureTarget} °C', style: GlobalVar.blackTextStyle
                                                                             .copyWith(fontWeight: GlobalVar.medium, fontSize: 12),),
                                                                     ]
                                                                 ),),
                                                             RichText(
                                                                 text: TextSpan(style: TextStyle(color: Colors.blue), //apply style to all
                                                                     children: [
                                                                         TextSpan(text: ' - Intermitten ', style: GlobalVar.greyTextStyle
                                                                             .copyWith(fontWeight: GlobalVar.medium, fontSize: 12),),
                                                                         TextSpan(text: controller.fans.value[index].intermitten == true ? 'Nyala' : 'Mati', style: GlobalVar.blackTextStyle
                                                                             .copyWith(fontWeight: GlobalVar.medium, fontSize: 12),),
                                                                     ]
                                                                 ),),
                                                         ],
                                                     ),
                                                 ],
                                             ),
                                           ),
                                         ),
                                ]
                                )
                            ),
                        );
                    }),
            );
        }

        return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: appBar(),
            ),
            body: Stack(
                children: [
                    Obx(() => controller.isLoading.isTrue ?
                    Container(
                        child: Center(
                            child: ProgressLoading(),
                        ),
                    ) : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children : [
                            const SizedBox(
                                height: 10,
                            ),
                            listFan(),
                        ]
                    )
                    ),
                ],
            )
        );
    }
}
