import 'package:eksternal_app/engine/model/detail_camera_model.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

import '../base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 21/08/23
 */

@SetupModel
class CameraDetailResponse {

    int code;
    int count;
    DetailCamera? data;

    CameraDetailResponse({required this.code,required this.count, required this.data});

    static CameraDetailResponse toResponseModel(Map<String, dynamic> map) {
        return CameraDetailResponse(
            count: map['count'],
            code: map['code'],
            data: Mapper.child<DetailCamera>(map['data'])
        );
    }
}