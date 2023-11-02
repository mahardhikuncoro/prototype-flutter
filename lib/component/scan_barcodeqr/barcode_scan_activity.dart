import 'package:eksternal_app/component/scan_barcodeqr/barcode_scan_controller.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 17/07/23
 */

class ScanBarcodeActivity extends GetView<ScanBarcodeController> {

    @override
    Widget build(BuildContext context) {
        ScanBarcodeController controller = Get.put(ScanBarcodeController(context: context));
        Widget buildQrView(BuildContext context) {
            // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
            var scanArea = (MediaQuery.of(context).size.width < 200 ||
                MediaQuery.of(context).size.height < 200)
                ? 150.0
                : 300.0;
            // To ensure the Scanner view is properly sizes after rotation
            // we need to listen for Flutter SizeChanged notification and update controller
            return QRView(
                key: controller.qrKey,
                onQRViewCreated: controller.onQRViewCreated,
                overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: scanArea),
                onPermissionSet: (ctrl, p) => controller.onPermissionSet(context, ctrl, p),
            );
        }


        return Scaffold(
            body: Column(
                children: <Widget>[
                    // appBar(),
                    Expanded(flex: 4, child: buildQrView(context)),
                    Expanded(
                        flex: 1,
                        child: FittedBox(
                            fit: BoxFit.fill,
                            child:
                                Obx(() =>
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                            if (controller.result.value.code != "")
                                                Text(
                                                    ' ${describeEnum(controller.result.value.format)}   Data: ${controller.result.value.code}')
                                            else
                                                const Text(''),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                    Container(
                                                        margin: const EdgeInsets.all(8),
                                                        child: ElevatedButton(
                                                            onPressed: () async {
                                                                await controller.qrviewController?.toggleFlash();
                                                                // setState(() {}
                                                                // );
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                                padding: EdgeInsets.all(0),
                                                                elevation: 0,
                                                                backgroundColor: Colors.transparent,
                                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                minimumSize: Size(0, 0)
                                                            ),
                                                            child: Container(
                                                                width: 36,
                                                                height: 36,
                                                                padding: EdgeInsets.all(10),
                                                                decoration: BoxDecoration(
                                                                    color: GlobalVar.iconHomeBg,
                                                                    borderRadius: BorderRadius.circular(10)
                                                                ),
                                                              child: FutureBuilder(
                                                                  future: controller.qrviewController?.getFlashStatus(),
                                                                  builder: (context, snapshot) {
                                                                      print("FLASH STATUS ${controller.qrviewController?.getFlashStatus()}");
                                                                      if (snapshot.data != null) {
                                                                          return SvgPicture
                                                                              .asset(
                                                                              "images/flash_light_icon.svg");
                                                                      }else{
                                                                          return SvgPicture
                                                                              .asset(
                                                                              "images/flash_light_icon.svg");
                                                                      }

                                                                  },
                                                              ),
                                                            )),
                                                    ),
                                                    SizedBox(width: 18,),
                                                    Container(
                                                        margin: const EdgeInsets.all(8),
                                                        child: ElevatedButton(
                                                            onPressed: () async {
                                                                await controller.qrviewController?.flipCamera();
                                                                // setState(() {});
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                            padding: EdgeInsets.all(0),
                                                            elevation: 0,
                                                            backgroundColor: Colors.transparent,
                                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                            minimumSize: Size(0, 0)
                                                            ),
                                                            child: GestureDetector(
                                                                onTap:(){
                                                                    Navigator.pop(context);
                                                                },
                                                              child: Container(
                                                                  width: 36,
                                                                  height: 36,
                                                                  padding: EdgeInsets.all(10),
                                                                  decoration: BoxDecoration(
                                                                      color: GlobalVar.iconHomeBg,
                                                                      borderRadius: BorderRadius.circular(10)
                                                                  ),
                                                                  child: SvgPicture.asset("images/close_icon.svg")
                                                              ),
                                                            ),

                                                        ),
                                                    )
                                                ],
                                            ),
                                            SizedBox(height: 20,),
                                        ],
                                    ),)
                        ),
                    )
                ],
            ),
        );
    }

}
