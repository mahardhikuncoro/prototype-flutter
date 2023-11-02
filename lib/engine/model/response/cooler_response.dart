import 'package:eksternal_app/engine/model/base_model.dart';
import 'package:eksternal_app/engine/model/device_setting_model.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';


/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 30/08/23
 */

@SetupModel
class CoolerResponse {

    int code;
    DeviceSetting? data;

    CoolerResponse({required this.code, required this.data});

    static CoolerResponse toResponseModel(Map<String, dynamic> map) {
        return CoolerResponse(
            code: map['code'],
            data: Mapper.child<DeviceSetting>(map['data'])
        );
    }
}