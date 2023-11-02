import 'package:eksternal_app/component/graph_view/graph_view.dart';
import 'package:eksternal_app/engine/get_x_creator.dart';
import 'package:eksternal_app/engine/model/device_model.dart';
import 'package:eksternal_app/engine/model/error/error.dart';
import 'package:eksternal_app/engine/model/graph_line.dart';
import 'package:eksternal_app/engine/model/response/historical_data_response.dart';
import 'package:eksternal_app/engine/request/service.dart';
import 'package:eksternal_app/engine/request/transport/interface/response_listener.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:eksternal_app/engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 25/07/23
 */

class ExpandableDeviceController extends GetxController {
    BuildContext context;
    String tag;
    ExpandableDeviceController({required this.tag, required this.context});

    var expanded = false.obs;
    var isLoading = false.obs;
    var indexTab = 0.obs;
    Rx<List<GraphLine>> historicalList = Rx<List<GraphLine>>([]);
    Rx<List<GraphView>> graphViews = Rx<List<GraphView>>([]);


    void expand() {
        expanded.value = true;
    }
    void collapse() => expanded.value = false;


    GraphView gvSmartMonitoring = GraphView(
        controller: GetXCreator.putGraphViewController(
            "gvSmartMonitoring"),
    );

    /// The function `getHistoricalData` retrieves historical data for a specific
    /// sensor type and device, and updates the `historicalList` with the retrieved
    /// data.
    ///
    /// Args:
    ///   sensorType (String): The sensorType parameter is a String that represents
    /// the type of sensor for which historical data is being retrieved. It could be
    /// something like "temperature", "humidity", "pressure", etc.
    ///   device (Device): The "device" parameter is an object of type "Device"
    /// which represents a specific device. It likely contains information such as
    /// the device ID, name, and other relevant details.
    ///   day (int): The "day" parameter is an integer that represents the number of
    /// days for which historical data needs to be fetched. If the value of "day" is
    /// 0, it means that historical data for all available days should be fetched.
    /// Otherwise, it represents the number of days in the past for which
    void getHistoricalData(String sensorType, Device device, int day){
        isLoading.value = true;
        Service.push(
            service: ListApi.getHistoricalData,
            context: context,
            body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId!,
                sensorType,
                day,
                ListApi.pathHistoricalData(device.deviceId!)],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet){
                    if( (body as HistoricalDataResponse).data!.isNotEmpty){
                        historicalList.value.clear();
                        if((body as HistoricalDataResponse).data!.length == 1){
                            body.data!.add(body.data![0]);
                        }
                        for (int i = 0 ; i< (body as HistoricalDataResponse).data!.length ; i++){
                            historicalList.value.add(GraphLine(order: i, benchmarkMax: body.data![i]!.benchmarkMax, benchmarkMin: body.data![i]!.benchmarkMin, label: body.data![i]!.label, current: body.data![i]!.current));
                        }
                    }
                    loadData(historicalList, sensorType);
                    isLoading.value = false;
                },
                onResponseFail: (code, message, body, id, packet){
                    isLoading.value = false;
                    Get.snackbar(
                        "Pesan", "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        duration: Duration(seconds: 5),
                        backgroundColor: Colors.red,
                    );
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    isLoading.value = false;

                }, onTokenInvalid: GlobalVar.invalidResponse())
        );
    }

    void loadData(Rx<List<GraphLine>> historicalList, String sensorType) {
        if(sensorType == "temperature" || sensorType == "relativeHumidity" || sensorType == "heatStressIndex"){
            gvSmartMonitoring.controller
                .setUom('\u00B0C')
                .setLineCurrentColor(GlobalVar.primaryOrange)
                .setLineMinColor(GlobalVar.green)
                .setLineMaxColor(GlobalVar.green)
                .setBackgroundMax(Color.fromARGB(150, 206, 252, 216))
                .setBackgroundCurrentTooltip(GlobalVar.iconHomeBg)
                .setBackgroundMaxTooltip(GlobalVar.green)
                .setBackgroundMinTooltip(GlobalVar.green)
                .setTextColorCurrentTooltip(GlobalVar.primaryOrange)
                .setTextColorMinTooltip(GlobalVar.green)
                .setTextColorMaxTooltip(GlobalVar.green);
        } else if(sensorType == "wind" || sensorType == "lights"){
            gvSmartMonitoring.controller.setLineCurrentColor(GlobalVar.primaryOrange).
            setTextColorCurrentTooltip(GlobalVar.primaryOrange);
        }else if(sensorType == "ammonia"){
            gvSmartMonitoring.controller.setLineCurrentColor(GlobalVar.primaryOrange).
            setTextColorCurrentTooltip(GlobalVar.primaryOrange);
        }
        gvSmartMonitoring.controller.clearData();
        gvSmartMonitoring.controller.setupData(historicalList.value);
        historicalList.value.clear();
        historicalList.refresh();
    }

}

class ExpandableDeviceBinding extends Bindings {
    BuildContext context;
    ExpandableDeviceBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<ExpandableDeviceController>(() => ExpandableDeviceController(tag: "", context:context ));
    }
}