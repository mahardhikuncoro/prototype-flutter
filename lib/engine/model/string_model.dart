import 'package:eksternal_app/engine/model/base_model.dart';
/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

@SetupModel
class StringModel {
    String? data;
    StringModel({this.data});

    static StringModel toResponseModel(Map<String, dynamic> map) {
        return StringModel(
            data: map['data']
        );
    }
}
