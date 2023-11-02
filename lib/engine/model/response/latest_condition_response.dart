import 'package:eksternal_app/engine/model/device_summary_model.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

import '../base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 11/08/23
 */

@SetupModel
class LatestConditionResponse {

    int code;
    DeviceSummary? data;

    LatestConditionResponse({required this.code, required this.data});

    static LatestConditionResponse toResponseModel(Map<String, dynamic> map) {
        return LatestConditionResponse(
            code: map['code'],
            data: Mapper.child<DeviceSummary>(map['data'])
        );
    }
}