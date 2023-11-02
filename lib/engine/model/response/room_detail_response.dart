import 'package:eksternal_app/engine/model/coop_model.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

import '../base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 01/08/23
 */

@SetupModel
class RoomDetailResponse {

    int code;
    Coop? data;

    RoomDetailResponse({required this.code, required this.data});

    static RoomDetailResponse toResponseModel(Map<String, dynamic> map) {
        return RoomDetailResponse(
            code: map['code'],
            data: Mapper.child<Coop>(map['data'])
        );
    }
}