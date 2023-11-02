
import 'package:eksternal_app/engine/request/apis/api.dart';
import 'package:eksternal_app/engine/request/apis/user_api.dart';

import '../../flavors.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

class ApiMapping {

    static String BASE_URL = F.uri;

    Map<String, Type> apiMapping = {
        "api": API,
        "userApi": UserApi
    };
}