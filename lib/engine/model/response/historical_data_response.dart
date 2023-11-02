import 'package:eksternal_app/engine/model/graph_line.dart';
import 'package:eksternal_app/engine/util/mapper/annotation/is_children.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

import '../base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 11/08/23
 */

@SetupModel
class HistoricalDataResponse {

    int code;

    @IsChildren()
    List<GraphLine?>? data;

    HistoricalDataResponse({required this.code, required this.data});

    static HistoricalDataResponse toResponseModel(Map<String, dynamic> map) {
        return HistoricalDataResponse(
            code: map['code'],
            data: Mapper.children<GraphLine>(map['data']),
        );
    }
}