import 'package:eksternal_app/engine/model/base_model.dart';
import 'package:eksternal_app/engine/util/mapper/annotation/is_child.dart';
import 'package:eksternal_app/engine/model/room_model.dart';
import 'package:eksternal_app/engine/util/mapper/annotation/is_children.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

@SetupModel
class Coop{

    String? id;
    String? name;
    String? status;
    String? coopId;
    String? coopName;
    String? coopType;
    String? coopStatus;
    String? farmId;

    @IsChild()
    Room? room;

    @IsChildren()
    List<Room?>? rooms;

    Coop({this.id, this.name, this.coopName, this.coopType, this.farmId, this.status, this.coopStatus, this.room, this.rooms, this.coopId});

    static Coop toResponseModel(Map<String, dynamic> map) {
        return Coop(
            id: map['id'],
            name: map['name'],
            status: map['status'],
            coopName: map['coopName'],
            coopType: map['coopType'],
            coopStatus: map['coopStatus'],
            farmId: map['farmId'],
            coopId: map['coopId'],
            room: Mapper.child<Room>(map['room']),
            rooms: Mapper.children<Room>(map['rooms']),
        );
    }
}