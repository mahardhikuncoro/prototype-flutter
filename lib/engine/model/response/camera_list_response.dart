import 'package:eksternal_app/engine/model/record_model.dart';
import 'package:eksternal_app/engine/util/mapper/annotation/is_children.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

import '../base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 21/08/23
 */

@SetupModel
class CameraListResponse {

    int code;
    int count;

    @IsChildren()
    List<RecordCamera?>? data;

    CameraListResponse({required this.code, required this.data, required this.count});

    static CameraListResponse toResponseModel(Map<String, dynamic> map) {
        return CameraListResponse(
            code: map['code'],
            count: map['count'],
            data: Mapper.children<RecordCamera>(map['data']),
        );
    }
}