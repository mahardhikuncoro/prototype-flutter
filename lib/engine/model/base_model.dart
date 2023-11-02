import 'package:reflectable/reflectable.dart';
import 'package:flutter/cupertino.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 07/07/23
 */

const SetupModel = BaseModel();

class BaseModel extends Reflectable {
    const BaseModel() : super(invokingCapability,
        superclassQuantifyCapability,
        declarationsCapability,
        typeRelationsCapability,
        metadataCapability,
        newInstanceCapability,
        instanceInvokeCapability,
        typeCapability);

    static dynamic toResponseModel(Map<String, dynamic> map) {
        debugPrint('Persistance Type not contains function => toModel. Please extends to BaseEntity and add override "toModel"');
    }
}