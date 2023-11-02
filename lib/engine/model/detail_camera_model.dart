import 'package:eksternal_app/engine/model/base_model.dart';
import 'package:eksternal_app/engine/model/record_model.dart';
import 'package:eksternal_app/engine/util/mapper/annotation/is_children.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 21/08/23
 */

@SetupModel
class DetailCamera{

    String? date;
    String? buildingName;
    String? roomTypeName;

    @IsChildren()
    List<RecordCamera?>? records;

    DetailCamera({this.date, this.buildingName, this.roomTypeName, this.records});

    static DetailCamera toResponseModel(Map<String, dynamic> map) {

        return DetailCamera(
            date: map['date'],
            buildingName: map['buildingName'],
            roomTypeName: map['roomTypeName'],
            records: Mapper.children<RecordCamera>(map['records']),
        );
    }
}