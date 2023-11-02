import 'package:eksternal_app/engine/model/base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

@SetupModel
class Farm{

    String? id;
    String? name;
    String? status;

    Farm({this.id, this.name, this.status});

    static Farm toResponseModel(Map<String, dynamic> map) {
        return Farm(
            id: map['id'],
            name: map['name'],
            status: map['status'],
        );
    }
}