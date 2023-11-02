import 'dart:async';
import 'dart:io';

import 'package:carrier_info/carrier_info.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:eksternal_app/component/button_fill/button_fill.dart';
import 'package:eksternal_app/component/button_outline/button_outline.dart';
import 'package:eksternal_app/engine/get_x_creator.dart';
import 'package:eksternal_app/engine/model/coop_model.dart';
import 'package:eksternal_app/engine/model/error/error.dart';
import 'package:eksternal_app/engine/model/response/home_response.dart';
import 'package:eksternal_app/engine/request/service.dart';
import 'package:eksternal_app/engine/request/transport/interface/response_listener.dart';
import 'package:eksternal_app/engine/util/access_phone_permission.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:eksternal_app/engine/util/list_api.dart';
import 'package:eksternal_app/engine/util/location_permission.dart';
import 'package:eksternal_app/engine/util/route.dart';
import 'package:eksternal_app/ui/register_coop/register_coop_controller.dart';
import 'package:fl_location/fl_location.dart';
// import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:eksternal_app/flavors.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 06/07/23
 */

class BerandaController extends GetxController {
    BuildContext context;
    BerandaController({required this.context});
    var isLoading = false.obs;
    var isEmptyCoop = true.obs;
    Rx<List<String?>> listRole = Rx<List<String?>>([]);
    Rx<List<Map>> module = Rx<List<Map>>([]);
    Rx<List<Coop>> coops = Rx<List<Coop>>([]);
    String mixpanelValue = "";

    //Tracking Variable
    double? latitude = 0;
    double? longitude = 0;
    String? deviceTracking = "";
    String? phoneCarrier = "No Simcard";
    String? osVersion = "";
    DateTime timeStart = DateTime.now();
    DateTime timeEnd = DateTime.now();

    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    late Future<bool> isAscendingPref;
    Rx<bool> isAscending = true.obs;

    IosCarrierData? _iosInfo;
    AndroidCarrierData? _androidInfo;

    set iosInfo(IosCarrierData? iosInfo) {
        _iosInfo = iosInfo;
    }

    set androidInfo(AndroidCarrierData? carrierInfo) {
         _androidInfo = carrierInfo;
    }

    IosCarrierData? get iosInfo => _iosInfo;
    AndroidCarrierData? get androidInfo => _androidInfo;

    late ButtonOutline boAddDevice = ButtonOutline(
        controller: GetXCreator.putButtonOutlineController("boAddDevice"),
        label: "Tambah Alat", onClick: () {
        Get.toNamed(RoutePage.registerDevicePage);
    },
    );

    late ButtonOutline boOrderDevice = ButtonOutline(
        controller: GetXCreator.putButtonOutlineController("boPesanAlat"),
        label: "Pesan Alat", onClick: () {

    },
    );

    late ButtonFill bfAddCoop = ButtonFill(
        controller: GetXCreator.putButtonFillController("bfAddCoop"),
        label: "Buat Kandang", onClick: () {
        Get.toNamed(RoutePage.createCoopPage, arguments: RegisterCoopController.CREATE_COOP);
    },
    );

    List<SimCard> _simCard = <SimCard>[];

    // Platform messages are asynchronous, so we initialize in an async method.
    Future<void> initMobileNumberState() async {
        // Platform messages may fail, so we use a try/catch PlatformException.
        try {
            _simCard = (await MobileNumber.getSimCards)!;
            phoneCarrier = _simCard[0].carrierName;
        } on PlatformException catch (e) {
        }

    }


    @override
    void onInit() async {
        super.onInit();
        timeStart = DateTime.now();
        isLoading.value = true;
        await initValueMixpanel();
        getDataCoops();
    }

    @override
    void onReady() {
        super.onReady();
    }
    @override
    void onClose() {
        super.onClose();
    }


    /// The function `initValueMixpanel()` initializes the value for Mixpanel by
    /// checking phone access permission and retrieving carrier information for iOS
    /// devices.
    Future<void> initValueMixpanel() async {
        // Platform messages may fail, so we use a try/catch PlatformException.
        if (Platform.isAndroid) {
            final hasPermission = await handlePermissionPhoneAccess();
            if (hasPermission) {
                try {
                    initMobileNumberState();
            } catch (e) {

                }
            }
        } else if (Platform.isIOS) {
            iosInfo = await CarrierInfo.getIosInfo();
            if (iosInfo != null && iosInfo!.carrierData.length > 0) {
                phoneCarrier =
                iosInfo!.carrierData[0].carrierName == null
                    ? ""
                    : iosInfo!.carrierData[0].carrierName;
            }
        }
        initMixpanel();
    }

    /// The `initMixpanel` function initializes the Mixpanel analytics library,
    /// requests location permission, retrieves the device information, registers
    /// super properties, identifies the user, sets user properties, and tracks
    /// events.
    Future<void> initMixpanel() async {

        final hasPermission = await handleLocationPermission();
        if (await hasPermission){
            final timeLimit = const Duration(seconds: 5);
            await FlLocation.getLocation(timeLimit: timeLimit).then((position) async {
                if(position.isMock) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, Gps Mock Detected",
                        snackPosition: SnackPosition.TOP,
                        duration: Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,);
                } else {
                   latitude = position.latitude;
                   longitude = position.longitude;
                }
            });
        }

        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        if(Platform.isAndroid) {
            AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
            deviceTracking = "${androidInfo.model}";
            osVersion = Platform.operatingSystemVersion;
        }else{
            IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
            deviceTracking = "${iosInfo.model}";
            osVersion = Platform.operatingSystem;
        }

        GlobalVar.mixpanel = await Mixpanel.init(F.tokenMixpanel, trackAutomaticEvents: true);
        GlobalVar.mixpanel!.registerSuperProperties({
            "Phone_Number": GlobalVar.profileUser!.phoneNumber,
            "Username": GlobalVar.profileUser!.phoneNumber,
            "Location": "${latitude},${longitude}",
            "Device": deviceTracking,
            "Phone_Carrier": phoneCarrier,
            "OS": osVersion,

        });
        GlobalVar.mixpanel!.identify(GlobalVar.profileUser!.phoneNumber!);

        GlobalVar.mixpanel!.getPeople().set("\$name", GlobalVar.profileUser!.phoneNumber!);
        GlobalVar.mixpanel!.getPeople().set("\$email", GlobalVar.profileUser!.email!);

        GlobalVar.trackWithMap("Open_Beranda", {'Day_Value': 0});

        timeEnd = DateTime.now();
        Duration totalTime = timeEnd.difference(timeStart);
        GlobalVar.trackWithMap("Render_Time", {'Page' : "Beranda" , 'value': "${totalTime.inHours} hours : ${totalTime.inMinutes} minutes : ${totalTime.inSeconds} seconds : ${totalTime.inMilliseconds} miliseconds"});

    }

    /// The function `getDataCoops` makes an API call to retrieve data for coops and
    /// handles the response accordingly.
    void getDataCoops(){
        Service.push(
            service: ListApi.getHomeData,
            context: context,
            body: [GlobalVar.auth!.token!, GlobalVar.auth!.id, GlobalVar.xAppId!],
            listener: ResponseListener(onResponseDone: (code, message, body, id, packet) async {
                if ((body as HomeRespone).data!.coops!.isNotEmpty){
                    isAscendingPref = prefs.then((SharedPreferences prefs) {
                        return prefs.getBool('isAscending') ?? true;
                    });
                    isAscending.value = await isAscendingPref;
                    coops = isAscending.value ? ascendingListByStatus(body.data!.coops) : descendingListByStatus(body.data!.coops);
                    isEmptyCoop.value = false;
                }
                GlobalVar.isEmptyCoop = isEmptyCoop.value;
                GlobalVar.farm = body.data!.farm;
                isLoading.value = false;
            }, onResponseFail: (code, message, body, id, packet){
                Get.snackbar(
                    "Pesan",
                    "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                    snackPosition: SnackPosition.TOP,
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );
                isLoading.value = false;
            }, onResponseError: (exception, stacktrace, id, packet){

                Get.snackbar(
                    "Pesan",
                    "Terjadi kesalahan internal",
                    snackPosition: SnackPosition.TOP,
                    duration: Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );
                isLoading.value = false;

            },  onTokenInvalid: GlobalVar.invalidResponse()));
    }

    /// The function takes a list of Coop objects, filters them based on their room
    /// status, and returns a reactive stream of Coop objects sorted in ascending
    /// order of their room status.
    ///
    /// Args:
    ///   coops (List<Coop?>): A list of Coop objects, where each Coop object may be
    /// null.
    ///
    /// Returns:
    ///   an Rx object that contains a list of Coop objects.
    Rx<List<Coop>> ascendingListByStatus(List<Coop?>? coops){
        Rx<List<Coop>> coopAscending = Rx<List<Coop>>([]);;
        for (var result in coops!){
            if(result!.room!.status == "active"){
                coopAscending.value.add(result);
            }
        }
        for (var result in coops){
            if(result!.room!.status == "inactive"){
                coopAscending.value.add(result);
            }
        }
        return coopAscending;
    }

    /// The function takes a list of Coop objects, sorts them in descending order
    /// based on their status, and returns the sorted list as a reactive stream.
    ///
    /// Args:
    ///   coops (List<Coop?>): A list of Coop objects, where each Coop object may be
    /// null.
    ///
    /// Returns:
    ///   an Rx object that contains a list of Coop objects.
    Rx<List<Coop>> descendingListByStatus(List<Coop?>? coops){
        Rx<List<Coop>> coopAscending = Rx<List<Coop>>([]);;
        for (var result in coops!){
            if(result!.room!.status == "inactive"){
                coopAscending.value.add(result);
            }
        }
        for (var result in coops){
            if(result!.room!.status == "active"){
                coopAscending.value.add(result);
            }
        }
        return coopAscending;
    }

    /// The function sets the 'isAscending' preference in SharedPreferences,
    /// retrieves the value, updates the 'isAscending' variable, and sorts the
    /// 'coops' list based on the updated value.
    ///
    /// Returns:
    ///   The `setPreferences()` function is returning a `Future<void>`.
    Future<void> setPreferences() async {
        final SharedPreferences pref = await prefs;
        if(isAscending.value) {
            pref.setBool('isAscending',false);
        }else{
            pref.setBool('isAscending',true);
        }

        isAscendingPref = prefs.then((SharedPreferences prefs) {
            return prefs.getBool('isAscending') ?? true;
        });
        isAscending.value = await isAscendingPref;
        coops = isAscending.value ? ascendingListByStatus(coops.value) : descendingListByStatus(coops.value);
    }

}
class BerandaBindings extends Bindings {
    BuildContext context;
    BerandaBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => BerandaController(context: context));
    }
}