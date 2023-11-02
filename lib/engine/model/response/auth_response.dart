
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

import '../auth_model.dart';
import '../base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

@SetupModel
class AuthResponse {

    int code;
    Auth? data;

    AuthResponse({required this.code, required this.data});

    static AuthResponse toResponseModel(Map<String, dynamic> map) {
        return AuthResponse(
            code: map['code'],
            data: Mapper.child<Auth>(map['data'])
        );
    }
}