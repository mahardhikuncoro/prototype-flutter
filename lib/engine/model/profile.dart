import 'package:eksternal_app/engine/dao/base_entity.dart';

import '../dao/annotation/attribute.dart';
import '../dao/annotation/table.dart';
import 'base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

@SetupEntity
@SetupModel
@Table("m_profile")
class Profile extends BaseEntity {
    @Attribute(name: "id", primaryKey: true, notNull: true)
    String? id;

    @Attribute(name: "name", length: 100)
    String? name;

    @Attribute(name: "email", length: 100)
    String? email;

    @Attribute(name: "phoneNumber", length: 16)
    String? phoneNumber;

    @Attribute(name: "waNumber", length: 16)
    String? waNumber;

    @Attribute(name: "role", length: 50)
    String? role;

    @Attribute(name: "organizationId", length: 50)
    String? organizationId;

    @Attribute(name: "organizationName", length: 100)
    String? organizationName;

    @Attribute(name: "createdDate", length: 100)
    String? createdDate;

    Profile({this.id, this.name, this.email, this.phoneNumber, this.waNumber, this.role, this.organizationId, this.createdDate, this.organizationName,
    });

    @override
    Profile toModelEntity(Map<String, dynamic> map) {
        return Profile(
            id: map['id'],
            name: map['name'],
            email: map['email'],
            phoneNumber: map['phoneNumber'],
            waNumber: map['waNumber'],
            role: map['role'],
            organizationId: map['organizationId'],
            organizationName: map['organizationName'],
            createdDate: map['createdDate'],
        );
    }

    static Profile toResponseModel(Map<String, dynamic> map) {
        return Profile(
            id: map['id'],
            name: map['name'],
            email: map['email'],
            phoneNumber: map['phoneNumber'],
            waNumber: map['waNumber'],
            role: map['role'],
            organizationId: map['organizationId'],
            organizationName: map['organizationName'],
            createdDate: map['createdDate'],

        );
    }
}