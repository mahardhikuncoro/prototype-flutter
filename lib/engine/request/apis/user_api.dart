import 'package:eksternal_app/engine/model/error/error.dart';
import 'package:eksternal_app/engine/model/response/auth_response.dart';
import 'package:eksternal_app/engine/model/response/profile_response.dart';
import 'package:eksternal_app/engine/request/base_api.dart';

import '../annotation/mediatype/json.dart';
import '../annotation/property/header.dart';
import '../annotation/property/parameter.dart';
import '../annotation/request/get.dart';
import '../annotation/request/post.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */


@Rest
class UserApi {

    /// The `auth` function is a POST request to the "/v2/auth" endpoint that takes
    /// a JSON string as a parameter and expects an `AuthResponse` object as a
    /// response, or an `ErrorResponse` object in case of an error.
    ///
    /// Args:
    ///   params (String): The "params" parameter is a string that contains the
    /// authentication parameters required for the authentication process.
    @JSON(isPlaint: true)
    @POST(value: "v2/auth", as: AuthResponse, error: ErrorResponse)
    void auth(@Parameter("params") String params) {}

    /// The function "profile" is a GET request that retrieves member information
    /// with the specified headers and parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is used to pass the
    /// authentication token or credentials required to access the API endpoint. It
    /// is typically included in the request header.
    ///   xId (String): The `xId` parameter is a header parameter that represents
    /// the ID of the user making the request. It is typically used for
    /// authentication or identification purposes.
    ///   xAppId (String): The xAppId parameter is a header parameter that
    /// represents the application ID. It is used to identify the application making
    /// the API request.
    ///   params (String): The "params" parameter is a string that contains
    /// additional parameters for the API request. It is used to pass any extra
    /// information or filters that are required for the "profile" API endpoint.
    @GET(value: "v2/b2b/member-info", as: ProfileResponse, error: ErrorResponse)
    void profile(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Parameter("params") String params) {}


}