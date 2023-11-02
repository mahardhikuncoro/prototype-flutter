import 'package:eksternal_app/engine/model/coop_model.dart';
import 'package:eksternal_app/engine/util/mapper/annotation/is_children.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

import '../base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 01/08/23
 */

@SetupModel
class CoopListResponse {

    int code;

    @IsChildren()
    List<Coop?>? data;

    CoopListResponse({required this.code, required this.data});

    static CoopListResponse toResponseModel(Map<String, dynamic> map) {
        return CoopListResponse(
            code: map['code'],
            data: Mapper.children<Coop>(map['data']),
        );
    }
}