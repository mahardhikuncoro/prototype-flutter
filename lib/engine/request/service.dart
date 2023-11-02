import 'package:eksternal_app/engine/request/api_mapping.dart';
import 'package:eksternal_app/engine/request/base_api.dart';
import 'package:eksternal_app/engine/request/transport/body/body_builder.dart';
import 'package:eksternal_app/engine/request/transport/interface/response_listener.dart';
import 'package:eksternal_app/engine/request/transport/interface/service_body.dart';
import 'package:eksternal_app/engine/request/transport/transporter.dart';
import 'package:flutter/material.dart';
import 'package:reflectable/mirrors.dart';
import 'package:reflectable/reflectable.dart';
import '../util/mirror_feature.dart';
import 'annotation/mediatype/form_encoded.dart';
import 'annotation/mediatype/json.dart';
import 'annotation/mediatype/multipart.dart';
import 'annotation/mediatype/xml.dart';
import 'annotation/property/header.dart';
import 'annotation/property/headers.dart';
import 'annotation/property/parameter.dart';
import 'annotation/property/path.dart';
import 'annotation/property/query.dart';
import 'annotation/request/delete.dart';
import 'annotation/request/get.dart';
import 'annotation/request/patch.dart';
import 'annotation/request/post.dart';
import 'annotation/request/put.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */


class Service {

    /// It pushes a message to the server.
    ///
    /// Args:
    ///   service (String): The service name.
    ///   context (BuildContext): The context of the current screen.
    ///   listener (ResponseListener): The listener that will be called when the
    /// response is received.
    ///   body (List<dynamic>): The body of the request.
    static void push({String apiKey= "api", required String service, required BuildContext context, required List<dynamic> body, required ResponseListener listener}) {
        pushWithIdAndPacket(apiKey: apiKey, service: service, context: context, id: -1, packet: null, body: body, listener: listener);
    }

    /// Push a message to the Dart side of the Flutter app, with an ID and a body.
    ///
    /// Args:
    ///   service (String): The service name.
    ///   context (BuildContext): The context of the current screen.
    ///   listener (ResponseListener): The listener that will be called when the
    /// response is received.
    ///   id (int): The id of the request.
    ///   body (List<dynamic>): The body of the request.
    static void pushWithId({String apiKey= "api", required String service, required BuildContext context, required int id, required List<dynamic> body, required ResponseListener listener}) {
        pushWithIdAndPacket(apiKey: apiKey, service: service, context: context, id: id, packet: null, body: body, listener: listener);
    }

    /// It pushes a new screen with a packet and a body.
    ///
    /// Args:
    ///   service (String): The service name to call.
    ///   context (BuildContext): The context of the current screen.
    ///   listener (ResponseListener): The listener that will be called when the
    /// response is received.
    ///   packet (dynamic): This is the packet that will be sent to the server.
    ///   body (List<dynamic>): The body of the request.
    static void pushWithPacket({String apiKey= "api", required String service, required BuildContext context, required dynamic packet, required List<dynamic> body, required ResponseListener listener}) {
        pushWithIdAndPacket(apiKey: apiKey, service: service, context: context, id: -1, packet: packet, body: body, listener: listener);
    }

    /// The above function is a function that is used to send a request to the
    /// server.
    ///
    /// Args:
    ///   service (String): The name of the method in the API class
    ///   context (BuildContext): BuildContext
    ///   listener (ResponseListener): ResponseListener
    ///   id (int): The id is used to identify the request.
    ///   packet (dynamic): is a dynamic object that can be used to store data that
    /// will be used in the response listener.
    ///   body (List<dynamic>): The body of the request.
    static void pushWithIdAndPacket({String apiKey= "api", required String service, required BuildContext context, required int id, required dynamic packet, required List<dynamic> body, required ResponseListener listener}) {
        Transporter transporter = Transporter().id(id)
            .context(context)
            .packet(packet)
            .listener(listener)
            .url(ApiMapping.BASE_URL);

        _generateRequest(apiKey, service, transporter, body);
    }

    static void _generateRequest(String apiKey, String service, Transporter transporter, List<dynamic> body) {
        try {
            var classMirror = Rest.reflectType(ApiMapping().apiMapping[apiKey]!) as ClassMirror;

            for (var v in classMirror.declarations.values) {
                if (v is MethodMirror) {
                    if (v.simpleName == service) {
                        // Setup Headers
                        if (MirrorFeature.isAnnotationPresent(v, Headers)) {
                            Headers headers = MirrorFeature.getAnnotation(v, Headers);

                            List<String> keys = headers.keys;
                            List<String> values = headers.value;

                            for (int i = 0; i < keys.length; i++) {
                                transporter.header(keys[i], values[i]);
                            }
                        }

                        // Setup PATH_PARAMETER
                        int indexPathParameter = 0;
                        bool pathParameterExist = false;

                        if (MirrorFeature.isAnnotationPresent(v, POST)) {
                            POST request = MirrorFeature.getAnnotation(v, POST);
                            if (request.value == POST.PATH_PARAMETER) {
                                pathParameterExist = true;
                            }
                        } else if (MirrorFeature.isAnnotationPresent(v, GET)) {
                            GET request = MirrorFeature.getAnnotation(v, GET);
                            if (request.value == GET.PATH_PARAMETER) {
                                pathParameterExist = true;
                            }
                        } else if (MirrorFeature.isAnnotationPresent(v, PUT)) {
                            PUT request = MirrorFeature.getAnnotation(v, PUT);
                            if (request.value == PUT.PATH_PARAMETER) {
                                pathParameterExist = true;
                            }
                        } else if (MirrorFeature.isAnnotationPresent(v, DELETE)) {
                            DELETE request = MirrorFeature.getAnnotation(v, DELETE);
                            if (request.value == DELETE.PATH_PARAMETER) {
                                pathParameterExist = true;
                            }
                        } else if (MirrorFeature.isAnnotationPresent(v, PATCH)) {
                            PATCH request = MirrorFeature.getAnnotation(v, PATCH);
                            if (request.value == PATCH.PATH_PARAMETER) {
                                pathParameterExist = true;
                            }
                        } else {
                            throw Exception("Not Find Annotation Method POST, GET, PUT, PATCH, or DELETE");
                        }

                        // Checking Body for POST and PUT
                        if (MirrorFeature.isAnnotationPresent(v, PUT) || MirrorFeature.isAnnotationPresent(v, POST) || MirrorFeature.isAnnotationPresent(v, PATCH)) {
                            if (pathParameterExist) {
                                if (body.length < 2) {
                                    throw Exception("Body is empty. For method POST and PUT must be have Body (@Parameter and @Path)");
                                }
                            } else {
                                if (body.length < 1) {
                                    throw Exception("Body is empty. For method POST and PUT must be have Body");
                                }
                            }
                        }

                        // Setup Body
                        List<ParameterMirror> parameters = v.parameters;
                        Map<String, String> bodyForm = {};
                        Map<String, dynamic> bodyJsonObject = {};
                        Map<String, dynamic> bodyMultipart = {};
                        String queryString = "";
                        int index = 0;

                        // Checking json parent format
                        bool isJsonObject = true;

                        stop:
                        for (int j = 0; j < parameters.length; j++) {
                            ParameterMirror parameter = parameters[j];
                            if (MirrorFeature.isParameterPresent(parameter, Parameter)) {
                                Parameter param = MirrorFeature.getParameter(parameter, Parameter);
                                if (MirrorFeature.isAnnotationPresent(v, FormEncoded)) {
                                    transporter.header("Content-type", "application/x-www-form-urlencoded");

                                    if (body[index] == null) {
                                        print("Form Add ${param.value} => ${body[index]}");
                                        bodyForm[param.value] = "";
                                    } else {
                                        print("Form Add ${param.value} => ${body[index].toString()}");
                                        bodyForm[param.value] = _encodeValue(body[index].toString())!;
                                    }
                                } else if (MirrorFeature.isAnnotationPresent(v, JSON)) {
                                    JSON json = MirrorFeature.getAnnotation(v, JSON);
                                    transporter.header("Content-type", "application/json; charset=utf-8");

                                    if (json.isPlaint) {
                                        transporter.body(BodyBuilder(BodyBuilder.JSON).toJsonFromText(body[index]));
                                    } else if (isJsonObject) {
                                        bodyJsonObject[param.value] = body[index];
                                    }
                                } else if (MirrorFeature.isAnnotationPresent(v, Multipart)) {
                                    transporter.header("Content-type", "multipart/form-data; boundary=${DateTime.now().millisecondsSinceEpoch}");
                                    bodyMultipart[param.value] = body[index];
                                    print("Multipart Add ${param.value} => ${body[index].toString()}");
                                } else if (MirrorFeature.isAnnotationPresent(v, XML)) {
                                    transporter.header("Content-type", "text/xml; charset=utf-8");
                                    print("XML Add ${param.value} => ${body[index].toString()}");
                                } else {
                                    transporter.header("Content-type", "text/plain; charset=utf-8");
                                    transporter.body(BodyBuilder(BodyBuilder.PLAIN).toPlain(body[index].toString()));
                                    break stop;
                                }
                            } else if (MirrorFeature.isParameterPresent(parameter, Path)) {
                                indexPathParameter = index;
                            } else if (MirrorFeature.isAnnotationPresent(parameter, Header)) {
                                Header header = MirrorFeature.getAnnotation(parameter, Header);
                                transporter.header(header.key, body[index]);
                            } else if (MirrorFeature.isAnnotationPresent(parameter, Query)) {
                                Query query = MirrorFeature.getAnnotation(parameter, Query);

                                if (queryString.trim() == "") {
                                    queryString += '?${query.value}=${_encodeValue(body[index].toString()) != null ? body[index].toString() : ""}';
                                } else {
                                    queryString += '&${query.value}=${_encodeValue(body[index].toString()) != null ? body[index].toString() : ""}';
                                }
                            }

                            index++;
                        }

                        if (MirrorFeature.isAnnotationPresent(v, FormEncoded)) {
                            transporter.body(BodyBuilder(BodyBuilder.FORM_ENCODED).toFormEncoded(bodyForm));
                        } else if (MirrorFeature.isAnnotationPresent(v, JSON)) {
                            JSON json = MirrorFeature.getAnnotation(v, JSON);

                            if (isJsonObject && !json.isPlaint) {
                                transporter.body(BodyBuilder(BodyBuilder.JSON).toJson(bodyJsonObject));
                            }
                        } else if (MirrorFeature.isAnnotationPresent(v, Multipart)) {
                            transporter.body(BodyBuilder(BodyBuilder.MULTIPART).toMultipart(bodyMultipart))
                                       .multipart();
                        } else if (MirrorFeature.isAnnotationPresent(v, XML)) {
                            // not support
                        }

                        // Setup METHOD Request
                        if (MirrorFeature.isAnnotationPresent(v, POST)) {
                            POST request = MirrorFeature.getAnnotation(v, POST);
                            transporter
                                .route((pathParameterExist ? body[indexPathParameter].toString() : request.value) + queryString)
                                .post()
                                .as(request.as)
                                .error(request.error)
                                .execute();
                        } else if (MirrorFeature.isAnnotationPresent(v, GET)) {
                            GET request = MirrorFeature.getAnnotation(v, GET);
                            transporter
                                .route((pathParameterExist ? body[indexPathParameter].toString() : request.value) + queryString)
                                .get()
                                .as(request.as)
                                .error(request.error)
                                .execute();
                        } else if (MirrorFeature.isAnnotationPresent(v, PUT)) {
                            PUT request = MirrorFeature.getAnnotation(v, PUT);
                            transporter
                                .route((pathParameterExist ? body[indexPathParameter].toString() : request.value) + queryString)
                                .put()
                                .as(request.as)
                                .error(request.error)
                                .execute();
                        } else if (MirrorFeature.isAnnotationPresent(v, DELETE)) {
                            print('pathParameterExist : $pathParameterExist -> index : $indexPathParameter');
                            DELETE request = MirrorFeature.getAnnotation(v, DELETE);
                            transporter
                                .route((pathParameterExist ? body[indexPathParameter].toString() : request.value) + queryString)
                                .delete()
                                .as(request.as)
                                .error(request.error)
                                .execute();
                        } else if (MirrorFeature.isAnnotationPresent(v, PATCH)) {
                            PATCH request = MirrorFeature.getAnnotation(v, PATCH);
                            transporter
                                .route((pathParameterExist ? body[indexPathParameter].toString() : request.value) + queryString)
                                .patch()
                                .as(request.as)
                                .error(request.error)
                                .execute();
                        }
                    }
                }
            }
        } on Exception catch (e, stacktrace) {
            print("Location error : $stacktrace");
        }
    }

    /// It encodes a string value and returns the encoded value
    ///
    /// Args:
    ///   value (String): The value to encode.
    ///
    /// Returns:
    ///   A string that is encoded.
    static String? _encodeValue(String value) {
        try {
            return Uri.encodeFull(value);
        } on Exception catch (e, stacktrace) {
            print(stacktrace);
        }

        return null;
    }
}

class ServicePeripheral {
    final String keyMap;
    final String service;
    final ServiceBody requestBody;

    ServicePeripheral({this.keyMap = "api", required this.service, required this.requestBody});

    ServiceBody getRequestBody() {
        return requestBody;
    }

    void push(BuildContext context, List<dynamic> body, ResponseListener listener) {
        Transporter transporter = new Transporter()
            .id(-1)
            .context(context)
            .listener(listener)
            .url(ApiMapping.BASE_URL);

        Service._generateRequest(keyMap, service, transporter, body);
    }
}