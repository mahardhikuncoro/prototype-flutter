import 'package:eksternal_app/engine/dao/annotation/attribute.dart';
import 'package:eksternal_app/engine/dao/annotation/table.dart';
import 'package:eksternal_app/engine/dao/base_entity.dart';
import 'package:eksternal_app/engine/model/base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 04/07/23
 */

@SetupEntity
@SetupModel
@Table("t_xapp")
class XAppId extends BaseEntity {
    @Attribute(name: "appId", type: "VARCHAR", length: 100, defaultValue: "", notNull: true,)
    String? appId;


    XAppId({this.appId});

    XAppId toModelEntity(Map<String, dynamic> map) {
        return XAppId(appId: map['appId']);
    }

    static XAppId toResponseModel(Map<String, dynamic> map) {
        return XAppId(appId: map['appId']);
    }
}