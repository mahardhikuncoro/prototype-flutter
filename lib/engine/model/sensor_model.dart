import 'package:eksternal_app/engine/model/base_model.dart';
import 'package:eksternal_app/engine/model/room_model.dart';
import 'package:eksternal_app/engine/util/mapper/annotation/is_child.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 01/08/23
 */

@SetupModel
class Sensor{

    String? id;
    String? name;
    String? position;
    String? deviceName;
    int? totalDevice;
    String? sensorCode;
    String? sensorMac;
    String? sensorType;
    double? temperature;
    double? humidity;

    @IsChild()
    Room? room;

    Sensor({this.id, this.name, this.position, this.deviceName, this.totalDevice, this.temperature, this.humidity, this.sensorMac, this.sensorType, this.sensorCode, this.room});

    static Sensor toResponseModel(Map<String, dynamic> map) {
        if(map['temperature'] is int) {
            map['temperature'] = map['temperature'].toDouble();
        }
        if(map['humidity'] is int) {
            map['humidity'] = map['humidity'].toDouble();
        }
        return Sensor(
            id: map['id'],
            name: map['name'],
            position: map['position'],
            deviceName: map['deviceName'],
            totalDevice: map['totalDevice'],
            temperature: map['temperature'],
            sensorMac: map['sensorMac'],
            sensorType: map['sensorType'],
            humidity: map['humidity'],
            sensorCode: map['sensorCode'],
            room: Mapper.child<Room>(map['room']),
        );
    }
}