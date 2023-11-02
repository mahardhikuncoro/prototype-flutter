import 'package:eksternal_app/engine/model/base_model.dart';
import 'package:eksternal_app/engine/model/sensor_data_model.dart';
import 'package:eksternal_app/engine/util/mapper/annotation/is_child.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 10/08/23
 */

@SetupModel
class DeviceSummary{

    @IsChild()
    SensorData? temperature;

    @IsChild()
    SensorData? relativeHumidity;

    @IsChild()
    SensorData? ammonia;

    @IsChild()
    SensorData? heatStressIndex;

    @IsChild()
    SensorData? wind;

    @IsChild()
    SensorData? lights;

    String? id;
    String? coopCodeId;
    String? deviceId;

    DeviceSummary({this.temperature,
        this.relativeHumidity,
        this.ammonia,
        this.heatStressIndex,
        this.wind,
        this.lights,
        this.id,
        this.coopCodeId,
        this.deviceId,
    });

    static DeviceSummary toResponseModel(Map<String, dynamic> map) {

        return DeviceSummary(
            temperature: Mapper.child<SensorData>(map['temperature']),
            relativeHumidity: Mapper.child<SensorData>(map['relativeHumidity']),
            ammonia: Mapper.child<SensorData>(map['ammonia']),
            heatStressIndex: Mapper.child<SensorData>(map['heatStressIndex']),
            wind: Mapper.child<SensorData>(map['wind']),
            lights: Mapper.child<SensorData>(map['lights']),
            id: map['id'],
            coopCodeId: map['coopCodeId'],
            deviceId: map['deviceId'],
        );
    }

    bool isNullObject(){
        if(temperature == null && relativeHumidity == null && ammonia == null
            && heatStressIndex == null && wind == null && lights == null){
            return true;
        }
        return false;
    }
}