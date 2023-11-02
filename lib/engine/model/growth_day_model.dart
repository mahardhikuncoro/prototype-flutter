import 'package:eksternal_app/engine/model/base_model.dart';
import 'package:eksternal_app/engine/model/temperature_reduction_model.dart';
import 'package:eksternal_app/engine/util/mapper/annotation/is_children.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 30/08/23
 */

@SetupModel
class GrowthDay{

    double? temperature;
    double? requestTemperature;
    int? growthDay;
    String? deviceId;

    @IsChildren()
    List<TemperatureReduction?>? temperatureReduction;

    GrowthDay({this.temperature, this.requestTemperature, this.growthDay,
    this.temperatureReduction, this.deviceId});

    static GrowthDay toResponseModel(Map<String, dynamic> map) {
        if(map['temperature'] is int) {
            map['temperature'] = map['temperature'].toDouble();
        }
        if(map['requestTemperature'] is int) {
            map['requestTemperature'] = map['requestTemperature'].toDouble();
        }
        return GrowthDay(
            temperature: map['temperature'],
            requestTemperature: map['requestTemperature'],
            growthDay: map['growthDay'],
            temperatureReduction: Mapper.children<TemperatureReduction>(map['temperatureReduction']),
            deviceId: map['deviceId'],
        );
    }
}