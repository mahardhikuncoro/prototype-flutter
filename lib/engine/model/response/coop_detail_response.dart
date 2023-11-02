import 'package:eksternal_app/engine/model/coop_model.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

import '../base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 02/08/23
 */

@SetupModel
class CoopDetailResponse {

    int code;
    Coop? data;

    CoopDetailResponse({required this.code, required this.data});

    static CoopDetailResponse toResponseModel(Map<String, dynamic> map) {
        return CoopDetailResponse(
            code: map['code'],
            data: Mapper.child<Coop>(map['data'])
        );
    }
}