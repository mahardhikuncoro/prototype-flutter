import 'package:eksternal_app/engine/model/base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 04/08/23
 */

@SetupModel
class TemperatureReduction{

    String? group;
    int? day;
    double? reduction;

    TemperatureReduction({this.group, this.day, this.reduction});

    static TemperatureReduction toResponseModel(Map<String, dynamic> map) {

        if(map['reduction'] is int) {
            map['reduction'] = map['reduction'].toDouble();
        }
        return TemperatureReduction(
            group: map['group'],
            day: map['day'],
            reduction: map['reduction']
        );
    }
}