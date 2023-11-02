import 'package:eksternal_app/engine/model/base_model.dart';
import 'package:eksternal_app/engine/model/sensor_model.dart';
import 'package:eksternal_app/engine/model/device_summary_model.dart';
import 'package:eksternal_app/engine/util/mapper/annotation/is_child.dart';
import 'package:eksternal_app/engine/util/mapper/annotation/is_children.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 01/08/23
 */

@SetupModel
class Device{

    String? id;
    String? deviceName;
    String? deviceType;
    String? deviceId;
    String? coopId;
    String? roomId;
    String? mac;
    String? status;
    int? sensorCount;

    @IsChildren()
    List<Sensor?> sensors;

    @IsChild()
    DeviceSummary? deviceSummary;

    Device({this.id, this.deviceName,this.deviceType, this.sensors = const [], this.coopId, this.roomId,
        this.status, this.mac, this.deviceId, this.deviceSummary, this.sensorCount});

    static Device toResponseModel(Map<String, dynamic> map) {
        if(map['status'] is bool) {
            map['status'] = map['status'].toString();
        }
        return Device(
            id: map['id'],
            deviceName: map['deviceName'],
            deviceType: map['deviceType'],
            coopId: map['coopId'],
            roomId: map['roomId'],
            status: map['status'],
            mac: map['mac'],
            deviceId: map['deviceId'],
            sensorCount: map['sensorCount'],
            sensors: Mapper.children<Sensor>(map['sensors']),
            deviceSummary: Mapper.child<DeviceSummary>(map['deviceSummary']),
        );
    }
}