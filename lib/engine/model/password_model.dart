import 'package:eksternal_app/engine/model/base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 28/08/23
 */

@SetupModel
class Password{

    String? oldPassword;
    String? newPassword;
    String? confirmationPassword;

    Password({this.oldPassword, this.newPassword, this.confirmationPassword});

    static Password toResponseModel(Map<String, dynamic> map) {
        return Password(
            oldPassword: map['oldPassword'],
            newPassword: map['newPassword'],
            confirmationPassword: map['confirmationPassword'],
        );
    }
}