import 'dart:async';
import 'package:eksternal_app/component/device_status.dart';
import 'package:eksternal_app/component/progress_loading/progress_loading.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:eksternal_app/engine/util/route.dart';
import 'package:eksternal_app/ui/dashboard_lamp/dashboard_lamp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 16/08/23
 */


class DashboardLamp extends StatelessWidget {
    DashboardLamp({super.key});

    Widget build(BuildContext context) {
        final DashboardLampController controller =
        Get.put(DashboardLampController(context: context));

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
                    "Lampu",
                    style: GlobalVar.whiteTextStyle
                        .copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
                ),
            );
        }


        Widget listLamp() {
            return Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.lamps.value.length,
                    itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                                Get.toNamed(RoutePage.lampSetupPage, arguments: [controller.lamps.value[index], controller.device, controller.controllerData])!.then((value) {
                                    controller.isLoading.value = true;
                                    controller.lamps.value.clear();
                                    Timer(Duration(milliseconds: 500), () {
                                        controller.getDataLamps();
                                    });
                                });
                            },
                            child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12),
                                margin: EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                    color: controller.lamps.value[index].error == false ?  Colors.white : Color(0xFFFDDFD1),
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
                                                color: controller.lamps.value[index].error == false ?  GlobalVar.iconHomeBg : Color(0xFFFBB8A4),
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(4),
                                                    topRight: Radius.circular(4),
                                                    bottomRight: Radius.circular(4),
                                                    bottomLeft: Radius.circular(4))),
                                            child: Center(
                                                child: controller.lamps.value[index].error == false ? SvgPicture.asset("images/lamp_icon.svg") : SvgPicture.asset("images/lamp_icon_error.svg"),
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
                                                                    controller.lamps.value[index].name!,
                                                                    style: GlobalVar.blackTextStyle
                                                                        .copyWith(fontWeight: GlobalVar.medium, fontSize: 17, overflow: TextOverflow.ellipsis),
                                                                ),
                                                                SizedBox(width: 32,),
                                                                DeviceStatus(status: controller.lamps.value[index].status!, errorStatus: controller.lamps.value[index].error!),
                                                            ],
                                                        ),
                                                        SizedBox(height: 4,),
                                                        Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                                RichText(
                                                                    text: TextSpan(style: TextStyle(color: Colors.blue), //apply style to all
                                                                        children: [
                                                                            TextSpan(text: 'Nyala ', style: GlobalVar.greyTextStyle
                                                                                .copyWith(fontWeight: GlobalVar.medium, fontSize: 12),),
                                                                            TextSpan(text: '${controller.lamps.value[index].onlineTime}', style: GlobalVar.blackTextStyle
                                                                                .copyWith(fontWeight: GlobalVar.medium, fontSize: 12),),
                                                                        ]
                                                                    ),),
                                                                RichText(
                                                                    text: TextSpan(style: TextStyle(color: Colors.blue), //apply style to all
                                                                        children: [
                                                                            TextSpan(text: ' - Mati ', style: GlobalVar.greyTextStyle
                                                                                .copyWith(fontWeight: GlobalVar.medium, fontSize: 12),),
                                                                            TextSpan(text: '${controller.lamps.value[index].offlineTime}', style: GlobalVar.blackTextStyle
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
                            listLamp(),
                        ]
                    )
                    ),
                ],
            )
        );
    }
}
