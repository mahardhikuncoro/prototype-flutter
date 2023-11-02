import 'package:eksternal_app/engine/model/device_setting_model.dart';
import 'package:eksternal_app/engine/util/mapper/annotation/is_children.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

import '../base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 01/09/23
 */

@SetupModel
class FanListResponse {

    int code;

    @IsChildren()
    List<DeviceSetting?>? data;

    FanListResponse({required this.code, required this.data});

    static FanListResponse toResponseModel(Map<String, dynamic> map) {
        return FanListResponse(
            code: map['code'],
            data: Mapper.children<DeviceSetting>(map['data']),
        );
    }
}