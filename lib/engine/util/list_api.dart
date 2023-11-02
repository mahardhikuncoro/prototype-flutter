/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

class ListApi {
    static const String auth = "auth";
    static const String profile = "profile";
    static const String changePassword = "changePassword";
    static const String getHomeData = "getHomeData";
    static const String createCoopInfrastructure = "createCoopInfrastructure";
    static const String modifyInfrastructure = "modifyInfrastructure";
    static const String getDetailRoom = "getDetailRoom";
    static const String getCoops = "getCoops";
    static const String getDetailCoop = "getDetailCoop";
    static const String registerDevice = "registerDevice";
    static const String getDetailSmartMonitoring = "getDetailSmartMonitoring";
    static const String modifyDevice = "modifyDevice";
    static const String getLatestCondition = "getLatestCondition";
    static const String getHistoricalData = "getHistoricalData";
    static const String getRecordImages = "getRecordImages";
    static const String getListDataCamera = "getListDataCamera";
    static const String takePictureSmartCamera = "takePictureSmartCamera";
    static const String getDetailSmartController = "getDetailSmartController";
    static const String getDataGrowthDay = "getDataGrowthDay";
    static const String setController = "setController";
    static const String getFanData = "getFanData";
    static const String getCoolerData = "getCoolerData";

    static String pathChangePassword(){
        return "v2/auth/reset-password";
    }

    static String pathDetailRoom(String coopId, String roomId){
        return "v2/b2b/farm-infrastructure/coops/${coopId}/rooms/${roomId}";
    }

    static String pathListCoops(){
        return "v2/b2b/farm-infrastructure/coops";
    }

    static String pathDetailCoop(String coopId){
        return "v2/b2b/farm-infrastructure/coops/${coopId}";
    }

    static String pathModifyInfrastructure(String coopId){
        return "v2/b2b/farm-infrastructure/coops/${coopId}";
    }

    static String pathDetailSmartMonitoring(String deviceId){
        return "v2/b2b/iot-devices/smart-monitoring/${deviceId}";
    }

    static String pathLatestCondition(String deviceId){
        return "v2/b2b/iot-devices/smart-monitoring/${deviceId}/latest-conditions";
    }

    static String pathModifyDevice(String deviceType, String deviceId, String action){
        return "v2/b2b/iot-devices/${deviceType}/${deviceId}/${action}";
    }

    static String pathHistoricalData(String deviceId){
        return "v2/b2b/iot-devices/smart-monitoring/${deviceId}/historical";
    }

    static String pathRegisterDevice(String deviceType){
        return "v2/b2b/iot-devices/${deviceType}/register";
    }

    static String pathCameraImages(String coopId, String cameraId){
        return "v2/b2b/iot-devices/smart-camera/${coopId}/records/${cameraId}";
    }

    static String pathListCamera(String coopId){
        return "v2/b2b/iot-devices/smart-camera/${coopId}/records";
    }

    static String pathTakeImage(String coopId){
        return "v2/b2b/iot-devices/smart-camera/jobs/${coopId}";
    }

    static String pathdetailSmartController(String coopCodeId, String deviceId){
        return "v2/b2b/iot-devices/smart-controller/coop/summary?coopId=${coopCodeId}&deviceId=${deviceId}";
    }

    static String pathdetailGrowthDay(String coopCodeId, String deviceId){
        return "v2/b2b/iot-devices/smart-controller/coop/growth-day?coopId=${coopCodeId}&deviceId=${deviceId}";
    }

    static String pathDeviceData(String device, String coopCodeId, String deviceId){
        return "v2/b2b/iot-devices/smart-controller/coop/${device}?coopId=${coopCodeId}&deviceId=${deviceId}";
    }

    static String pathSetController(String device, String coopCodeId){
        return "v2/b2b/iot-devices/smart-controller/coop/${device}/${coopCodeId}";
    }

}
