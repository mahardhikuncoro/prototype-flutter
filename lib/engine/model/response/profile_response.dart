
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

import '../base_model.dart';
import '../profile.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

@SetupModel
class ProfileResponse {

    int code;
    Profile? data;

    ProfileResponse({required this.code, required this.data});

    static ProfileResponse toResponseModel(Map<String, dynamic> map) {
        return ProfileResponse(
            code: map['code'],
            data: Mapper.child<Profile>(map['data'])
        );
    }
}