import 'package:eksternal_app/engine/model/device_model.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

import '../base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 10/08/23
 */

@SetupModel
class DeviceDetailResponse {

    int code;
    Device? data;

    DeviceDetailResponse({required this.code, required this.data});

    static DeviceDetailResponse toResponseModel(Map<String, dynamic> map) {
        return DeviceDetailResponse(
            code: map['code'],
            data: Mapper.child<Device>(map['data'])
        );
    }
}