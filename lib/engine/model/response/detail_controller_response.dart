import 'package:eksternal_app/engine/model/device_controller_model.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

import '../base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 29/08/23
 */

@SetupModel
class DetailControllerResponse {

    int code;
    DeviceController? data;

    DetailControllerResponse({required this.code, required this.data});

    static DetailControllerResponse toResponseModel(Map<String, dynamic> map) {
        return DetailControllerResponse(
            code: map['code'],
            data: Mapper.child<DeviceController>(map['data'])
        );
    }
}