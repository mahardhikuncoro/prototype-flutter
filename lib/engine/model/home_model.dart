import 'package:eksternal_app/engine/model/base_model.dart';
import 'package:eksternal_app/engine/model/coop_model.dart';
import 'package:eksternal_app/engine/model/organization_model.dart';
import 'package:eksternal_app/engine/model/farm_model.dart';
import 'package:eksternal_app/engine/util/mapper/annotation/is_child.dart';
import 'package:eksternal_app/engine/util/mapper/annotation/is_children.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

@SetupModel
class Home{

    @IsChild()
    Farm? farm;

    @IsChild()
    Organization? organization;

    @IsChildren()
    List<Coop?>? coops;

    Home({this.organization, this.farm, this.coops});

    static Home toResponseModel(Map<String, dynamic> map) {
        return Home(
            farm: Mapper.child<Farm>(map['farm']),
            organization: Mapper.child<Organization>(map['organization']),
            coops: Mapper.children<Coop>(map['coops']),
        );
    }
}