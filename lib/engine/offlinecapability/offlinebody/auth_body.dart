/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */


import 'package:eksternal_app/engine/request/transport/interface/service_body.dart';

import '../../model/auth_model.dart';
import '../../util/mapper/mapper.dart';

class AuthBody implements ServiceBody<Auth> {

    @override
    List body(Auth object) {
        Auth auth = Mapper.asJsonString(object) as Auth;
        return ["Bearer ${auth.token}"];
    }
}