import '../base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

@SetupModel
class ErrorDetail {
    String? message;
    String? stack;

    ErrorDetail({required this.message, required this.stack});

    static ErrorDetail toResponseModel(Map<String, dynamic> map) {
        return ErrorDetail(
            message: map['message'],
            stack: map['stack']);
    }
}