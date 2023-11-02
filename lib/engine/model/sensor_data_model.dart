import 'package:eksternal_app/engine/model/base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 11/08/23
 */

@SetupModel
class SensorData{

    double? value;
    String? uom;
    String? status;

    SensorData({this.value, this.uom, this.status,});

    static SensorData toResponseModel(Map<String, dynamic> map) {
        if(map['value'] is int) {
            map['value'] = map['value'].toDouble();
        }

        return SensorData(
            value: map['value'],
            uom: map['uom'],
            status: map['status'],
        );
    }
}