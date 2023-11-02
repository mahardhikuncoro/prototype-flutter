import 'package:eksternal_app/engine/model/base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

@SetupModel
class User{

    String? username;
    String? password;

    User({this.username, this.password,});

    static User toResponseModel(Map<String, dynamic> map) {
        return User(
            username: map['username'],
            password: map['password'],
        );
    }
}