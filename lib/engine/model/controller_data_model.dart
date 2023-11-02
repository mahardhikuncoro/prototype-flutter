import 'package:eksternal_app/engine/model/base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 29/08/23
 */

@SetupModel
class ControllerData{

    String? id;
    String? deviceId;
    String? name;
    String? onlineTime;
    String? offlineTime;
    double? temperature;
    double? cold;
    double? hot;
    int? day;
    int? online;
    int? offline;
    bool? status;

    ControllerData({this.id, this.deviceId, this.temperature, this.day, this.status,
    this.online, this.offline, this.name, this.onlineTime, this.offlineTime, this.cold, this.hot});

    static ControllerData toResponseModel(Map<String, dynamic> map) {
        if(map['temperature'] is int) {
            map['temperature'] = map['temperature'].toDouble();
        }
        if(map['cold'] is int) {
            map['cold'] = map['cold'].toDouble();
        }
        if(map['hot'] is int) {
            map['hot'] = map['hot'].toDouble();
        }

        return ControllerData(
            id: map['id'],
            deviceId: map['deviceId'],
            temperature: map['temperature'],
            day: map['day'],
            online: map['online'],
            offline: map['offline'],
            status: map['status'],
            name: map['name'],
            onlineTime: map['onlineTime'],
            offlineTime: map['offlineTime'],
            cold: map['cold'],
            hot: map['hot'],
        );
    }
}