import 'package:eksternal_app/engine/model/base_model.dart';
import 'package:eksternal_app/engine/model/device_model.dart';
import 'package:eksternal_app/engine/model/coop_model.dart';
import 'package:eksternal_app/engine/util/mapper/annotation/is_child.dart';
import 'package:eksternal_app/engine/util/mapper/annotation/is_children.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

@SetupModel
class Room{

    String? id;
    String? name;
    String? status;
    int? level;
    String? roomCode;

    @IsChildren()
    List<Device?> devices;

    @IsChild()
    Coop? roomType;

    @IsChild()
    Coop? building;

    Room({this.id, this.name, this.status, this.level, this.devices= const[], this.roomCode,
    this.roomType, this.building});

    static Room toResponseModel(Map<String, dynamic> map) {
        return Room(
            id: map['id'],
            name: map['name'],
            status: map['status'],
            level: map['level'],
            roomCode: map['roomCode'],
            devices: Mapper.children<Device>(map['devices']),
            roomType: Mapper.child<Coop>(map['roomType']),
            building: Mapper.child<Coop>(map['building']),
        );
    }
}