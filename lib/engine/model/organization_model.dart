import 'package:eksternal_app/engine/model/base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

@SetupModel
class Organization{

    String? id;
    String? name;
    String? image;

    Organization({this.id, this.name, this.image});

    static Organization toResponseModel(Map<String, dynamic> map) {
        return Organization(
            id: map['id'],
            name: map['name'],
            image: map['image'],
        );
    }
}