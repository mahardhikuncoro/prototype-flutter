import 'package:eksternal_app/engine/model/error/error_detail.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';
import '../base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

@SetupModel
class ErrorResponse {
    int code;
    ErrorDetail? error;

    ErrorResponse({required this.code, required this.error});

    static ErrorResponse toResponseModel(Map<String, dynamic> map) {
        return ErrorResponse(
            code: map['code'],
            error: Mapper.child<ErrorDetail>(map['error'])
        );
    }
}