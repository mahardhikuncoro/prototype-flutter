import 'dart:async';
import 'package:eksternal_app/component/button_fill/button_fill.dart';
import 'package:eksternal_app/component/item_detail_smartcamera/item_detail_smartcamera.dart';
import 'package:eksternal_app/component/progress_loading/progress_loading.dart';
import 'package:eksternal_app/engine/get_x_creator.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:eksternal_app/engine/util/route.dart';
import 'package:eksternal_app/ui/detail_smartcamera/detail_smartcamera_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 25/07/23
 */

class DetailSmartCamera extends GetView<DetailSmartCameraController>{
    const DetailSmartCamera({
        super.key
    });

    @override
    Widget build(BuildContext context) {
        final DetailSmartCameraController controller = Get.put(DetailSmartCameraController(
            context: context,
        ));

        _showButtonDialog(BuildContext context, DetailSmartCameraController controller) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                    return

                        Align(
                        alignment: Alignment(1, -1),
                        child: GestureDetector(
                            onTap: () {
                                // _showBottomDialog(context, controller);
                            },
                            child: Container(
                                margin: EdgeInsets.only(top: 50, right: 30),
                                width: 135,
                                height: 66,
                                child: Stack(children: [
                                    Container(
                                        margin: EdgeInsets.only(top: 8),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(6)),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                GestureDetector(
                                                  child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                          const SizedBox(
                                                              width: 8,
                                                          ),
                                                          DefaultTextStyle(
                                                              style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),
                                                              child: Text("Edit"),
                                                          ),
                                                      ],
                                                  ),
                                                    onTap: (){
                                                        GlobalVar.track("Click_option_menu_edit_camera");
                                                        Get.back();
                                                        Get.toNamed(RoutePage.modifySmartMonitorPage, arguments:[controller.coop, controller.device, "edit"])!.then((value) {
                                                            controller.isLoading.value = true;
                                                            controller.sensorCameras.value.clear();
                                                            Timer(Duration(milliseconds: 500), () {
                                                                controller.getListCamera();
                                                            });
                                                        });
                                                    },
                                                ),
                                                GestureDetector(
                                                  child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                          const SizedBox(
                                                              width: 8,
                                                          ),
                                                          DefaultTextStyle(
                                                              style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),
                                                              child: Text("Ubah Nama"),
                                                          ),
                                                      ],
                                                  ),
                                                    onTap: (){
                                                        GlobalVar.track("Click_option_menu_rename");
                                                        Get.back();
                                                        Get.toNamed(RoutePage.modifySmartMonitorPage, arguments:[controller.coop, controller.device, "rename"])!.then((value) {
                                                            value == null ? controller.deviceUpdatedName.value = "" : controller.deviceUpdatedName.value = value[0]["backValue"];
                                                            controller.isLoading.value =true;
                                                            controller.sensorCameras.value.clear();
                                                            Timer(Duration(milliseconds: 500), () {
                                                                controller.getListCamera();
                                                            });
                                                        });
                                                    },
                                                ),
                                            ],
                                        )


                                    ),
                                    Align(
                                        alignment: Alignment(1, -1),
                                        child: Image.asset(
                                            "images/triangle_icon.png",
                                            height: 17,
                                            width: 17,
                                        ),
                                    )
                                ]),
                            ),
                        ));
                },
            );
        }


        Widget appBar() {
            return AppBar(
                elevation: 0,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back()),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                ),
                backgroundColor: GlobalVar.primaryOrange,
                centerTitle: true,
                title:
                Obx(() => controller.deviceUpdatedName == "" ?
                Text("${controller.device.deviceName}", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
                ) : Text("${controller.deviceUpdatedName}", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
                )
                ),
                actions: [
                    GestureDetector(
                        onTap: () {
                            GlobalVar.track("Click_option_menu");
                            _showButtonDialog(context, controller);
                        },
                        child: Container(
                            color: Colors.transparent,
                            height: 32,
                            width: 32,
                            margin: EdgeInsets.only(right: 20, top: 13, bottom: 13),
                            child: Container(child: SvgPicture.asset("images/dot_icon.svg")),
                        ),
                    ),
                ],
            );
        }

        Widget listSmartCamera(){
            return  Container(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
                child: ListView.builder(
                    controller: controller.scrollCameraController,
                    itemCount: controller.isLoadMore.isTrue
                        ? controller.sensorCameras.value.length + 1
                        : controller.sensorCameras.value.length,
                    itemBuilder: (context, index) {
                        int length = controller.sensorCameras.value.length;
                        if (index >= length) {
                            return Column(
                                children: [
                                    Center(
                                        child: SizedBox(
                                            child: ProgressLoading(
                                            ),
                                            height: 24,
                                            width: 24,
                                        ),
                                    ),
                                    SizedBox(height: 120),
                                ],
                            );
                        }
                        return Column(
                            children: [
                                ItemDetailSmartCamera(
                                    camera: controller.sensorCameras.value[index],
                                    indeksCamera : index,
                                    onTap: () {
                                        GlobalVar.track("Click_card_camera");
                                        Get.toNamed(RoutePage.HistorySmartCameraPage, arguments: [false, controller.sensorCameras.value[index], controller.coop, index])!.then((value) {
                                            controller.isLoading.value = true;
                                            controller.sensorCameras.value.clear();
                                            controller.pageSmartCamera.value = 0;
                                            Timer(Duration(milliseconds: 500), () {
                                                controller.getListCamera();
                                            });
                                        });
                                    },
                                ),
                                index == controller.sensorCameras.value.length - 1 ? SizedBox(height: 120)
                                    : Container(),
                            ],
                        );
                    },
                ),
            );
        }

        Widget bottomNavBar() {
            return Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                    BoxShadow(
                                        color: Color.fromARGB(20, 158, 157, 157),
                                        blurRadius: 5,
                                        offset: Offset(0.75, 0.0))
                                ],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                            ),
                            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Expanded(
                                        child: ButtonFill(
                                            controller: GetXCreator.putButtonFillController("takePicture"),
                                            label: "Ambil Gambar",
                                            onClick: () {
                                                GlobalVar.track("Click_button_ambil_gambar");
                                                controller.takePictureSmartCamera();
                                            },
                                        )),
                                ],
                            ),
                        ),
                    ],
                ));
        }





        return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: appBar(),
            ),
            body: Stack(
                children: [
                    Obx(() => controller.isLoading.isTrue ?
                    Center(
                        child:
                        ProgressLoading(),
                    ) : controller.sensorCameras.value.isEmpty ?
                    Center(
                        child: Container(
                            width: double.infinity,
                            height: MediaQuery. of(context). size. height,
                            margin: EdgeInsets.only(left: 56, right: 56, bottom: 32, top: 186),
                            child: Column(
                                children: [
                                    SvgPicture.asset("images/empty_icon.svg"),
                                    const SizedBox(
                                        height: 17,),
                                    Text("Data Camera Belum Ada",
                                        textAlign: TextAlign.center, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),)
                                ],
                            ),
                        )
                    ) :
                    Column(
                        children: [
                            const SizedBox(
                                height: 16,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: GlobalVar.primaryLight,
                                    borderRadius: BorderRadius.circular(8)),
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                padding: EdgeInsets.all(12),
                                child : Column(
                                    children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Expanded(child: Text("Detail Gambar ", style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium))),
                                             ],
                                        ),
                                        const SizedBox(
                                            height: 12,
                                        ),
                                        Obx(() => controller.isLoading.isTrue ? Container()
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Expanded(child: Text("Total Kamera", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),)),
                                                Text("${controller.totalCamera}", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium), overflow: TextOverflow.clip)
                                            ],
                                        ))
,
                                    ]
                                ),
                            ),
                            Container(
                                margin: EdgeInsets.only(right: 16, left: 16, top: 16),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: GlobalVar.blueLights,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                    children: [
                                        SvgPicture.asset("images/information_blue_icon.svg"),
                                        SizedBox(width: 8,),
                                        Expanded(child: Text("Silahkan ambil gambar terlebih dahulu",  style: GlobalVar.blueTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium))),
                                    ],
                                ),
                            ),
                            Expanded(child: listSmartCamera())
                        ],
                    )
                    ),
                    bottomNavBar()
                ],
            ),
        );


    }

}
