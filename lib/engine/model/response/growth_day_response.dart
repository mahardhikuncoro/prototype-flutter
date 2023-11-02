import 'package:eksternal_app/engine/model/base_model.dart';
import 'package:eksternal_app/engine/model/growth_day_model.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';


/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 30/08/23
 */

@SetupModel
class GrowthDayResponse {

    int code;
    GrowthDay? data;

    GrowthDayResponse({required this.code, required this.data});

    static GrowthDayResponse toResponseModel(Map<String, dynamic> map) {
        return GrowthDayResponse(
            code: map['code'],
            data: Mapper.child<GrowthDay>(map['data'])
        );
    }
}