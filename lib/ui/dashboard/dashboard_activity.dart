import 'package:eksternal_app/component/menu_bottomsheet.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:eksternal_app/engine/util/route.dart';
import 'package:eksternal_app/ui/beranda/beranda_activity.dart';
import 'package:eksternal_app/ui/dashboard/dashboard_controller.dart';
import 'package:eksternal_app/ui/profile/profile_activity.dart';
import 'package:eksternal_app/ui/register_coop/register_coop_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 06/07/23
 */

class DashboardActivity extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return GetBuilder<DashboardController>(
            builder: (controller) {
                showBottomDialog(BuildContext context, DashboardController controller) {
                    return showModalBottomSheet(
                        isScrollControlled: true,
                        useRootNavigator: true,
                        useSafeArea: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                            return Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                    ),
                                ),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                        Container(
                                            margin: EdgeInsets.only(top: 8),
                                            width: 60,
                                            height: 4,
                                            decoration: BoxDecoration(
                                                color: GlobalVar.outlineColor,
                                                borderRadius: BorderRadius.circular(2),
                                            ),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                                GlobalVar.track("Click_buat_kandang");
                                                Get.back();
                                                Get.toNamed(RoutePage.createCoopPage, arguments: RegisterCoopController.CREATE_COOP);
                                            },
                                            child:
                                            MenuBottomSheet(title: "Buat Kandang", subTitle : "Dapat membuat kandang yang terdiri dari beberapa lantai", imagesPath: "images/building_icon.svg",),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                                if(!GlobalVar.isEmptyCoop){
                                                    GlobalVar.track("Click_buat_lantai");
                                                    Get.back();
                                                    Get.toNamed(RoutePage.createFloorPage);
                                                }
                                            },
                                            child: MenuBottomSheet(title: "Buat Lantai", subTitle : "Dapat membuat lantai pada kandang tertentu", imagesPath: GlobalVar.isEmptyCoop ? "images/floor_disable_icon.svg" : "images/floor_icon.svg" , enable: GlobalVar.isEmptyCoop ? false : true,),
                                        )
                                        ,
                                        const SizedBox(height: GlobalVar.bottomSheetMargin,)
                                    ],
                                ),
                            );
                        });
                }


                return Scaffold(
                    body: SafeArea(
                        child: IndexedStack(
                            index: controller.tabIndex,
                            children: [
                                BerandaActivity(),
                                // PerformaActivity(),
                                // CoopActivity(),
                                ProfileActivity(),
                            ],
                        ),
                    ),
                    floatingActionButton: Container(
                        height: 64,
                        width: 64,
                        child: FloatingActionButton(
                            onPressed: () {
                                GlobalVar.track("Click_navbar_plus");
                                showBottomDialog(context, controller);
                            },
                            backgroundColor: GlobalVar.primaryOrange,
                            child: SvgPicture.asset("images/add_white_icon.svg", fit: BoxFit.cover, width: 32, height: 32)),
                    ),
                    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                    bottomNavigationBar: Container(
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                            boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(158, 157, 157, 0.2),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                )
                            ]
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                                GestureDetector(
                                    onTap: (){
                                        controller.changeTabIndex(0);
                                        GlobalVar.track("Click_navbar_beranda");
                                    },
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            SvgPicture.asset(controller.tabIndex == 0 ? "images/beranda_on_icon.svg" :"images/beranda_off_icon.svg" , height: 24, width: 24, ),
                                            const SizedBox(height: 5,),
                                            Text("Beranda", style: controller.tabIndex == 0 ? GlobalVar.primaryTextStyle.copyWith(fontWeight: GlobalVar.medium): GlobalVar.greyLightTextStyle.copyWith(fontWeight: GlobalVar.medium) ),
                                        ],
                                    ),
                                ),
                                // GestureDetector(
                                //     onTap: (){
                                //         controller.changeTabIndex(1);
                                //     },
                                //     child: Column(
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         children: [
                                //             SvgPicture.asset(controller.tabIndex == 1 ? "images/profile_on_icon.svg" :"images/profile_off_icon.svg" ),
                                //             const SizedBox(height: 5,),
                                //             Text("Kandang", style: controller.tabIndex == 1 ? GlobalVar.primaryTextStyle.copyWith(fontWeight: GlobalVar.medium): GlobalVar.grayTextStyle.copyWith(fontWeight: GlobalVar.medium) ),
                                //         ],
                                //     ),
                                // ),
                                // GestureDetector(
                                //     onTap: (){
                                //         controller.changeTabIndex(2);
                                //     },
                                //     child: Column(
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         children: [
                                //             SvgPicture.asset(controller.tabIndex == 2 ? "images/profile_on_icon.svg" :"images/profile_off_icon.svg" ),
                                //             const SizedBox(height: 5,),
                                //             Text("Performa", style: controller.tabIndex == 2 ? GlobalVar.primaryTextStyle.copyWith(fontWeight: GlobalVar.medium): GlobalVar.grayTextStyle.copyWith(fontWeight: GlobalVar.medium) ),
                                //         ],
                                //     ),
                                // ),
                                GestureDetector(
                                    onTap: (){
                                        controller.changeTabIndex(1);
                                        GlobalVar.track("Click_navbar_profile");
                                    },
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            SvgPicture.asset(controller.tabIndex == 1 ? "images/profile_on_icon.svg" :"images/profile_off_icon.svg"  ,height: 24, width: 24),
                                            const SizedBox(height: 5,),
                                            Text("Profil", style: controller.tabIndex == 1 ? GlobalVar.primaryTextStyle.copyWith(fontWeight: GlobalVar.medium): GlobalVar.greyLightTextStyle.copyWith(fontWeight: GlobalVar.medium) ),
                                        ],
                                    ),
                                ),

                            ],
                        ),
                    )
                );
            },
        );
    }
}