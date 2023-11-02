
import 'package:eksternal_app/engine/model/home_model.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

import '../base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

@SetupModel
class HomeRespone {

    int code;
    Home? data;

    HomeRespone({required this.code, required this.data});

    static HomeRespone toResponseModel(Map<String, dynamic> map) {
        return HomeRespone(
            code: map['code'],
            data: Mapper.child<Home>(map['data'])
        );
    }
}