// ignore_for_file: null_check_always_fails, prefer_typing_uninitialized_variables

import 'package:eksternal_app/engine/dao/annotation/attribute.dart';
import 'package:eksternal_app/engine/dao/annotation/table.dart';
import 'package:eksternal_app/engine/dao/base_entity.dart';
import 'package:eksternal_app/engine/dao/dao_interface.dart';
import 'package:eksternal_app/engine/dao/db_lite.dart';
import 'package:eksternal_app/engine/offlinecapability/offline.dart';
import 'package:eksternal_app/engine/util/mirror_feature.dart';
import 'package:reflectable/reflectable.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */


abstract class DaoImpl<T> implements DaoInterface {
    String? tableName;
    T? instance;

    static final List<String> formats = [
        "yyyy-MM-dd",
        "dd-MM-yyyy",
        "yyyy-MM-dd'T'HH:mm:ss'Z'",
        "yyyy-MM-dd'T'HH:mm:ssZ",
        "yyyy-MM-dd'T'HH:mm:ss",
        "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
        "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
        "yyyy-MM-dd HH:mm:ss",
        "MM/dd/yyyy HH:mm:ss",
        "MM/dd/yyyy'T'HH:mm:ss.SSS'Z'",
        "MM/dd/yyyy'T'HH:mm:ss.SSSZ",
        "MM/dd/yyyy'T'HH:mm:ss.SSS",
        "MM/dd/yyyy'T'HH:mm:ssZ",
        "MM/dd/yyyy'T'HH:mm:ss",
        "yyyy:MM:dd HH:mm:ss",
        "yyyyMMdd",
        "ddMMyyyy"
    ];

    /// It gets the table name from the class annotation.
    ///
    /// Args:
    ///   dao: The dao class that you want to use.
    DaoImpl(dao) {
        try {
            instance = dao;
            InstanceMirror instanceMirror = SetupEntity.reflect(dao);
            for (var table in instanceMirror.type.metadata) {
                if (table.runtimeType == Table) {
                    Table? t = table as Table?;
                    tableName = t?.tableName;
                }
            }
        } on Exception catch(e, stacktrace) {
            // ignore: avoid_print
            print(stacktrace);
        }
    }

    Future<List> getRecords(String orderBy) async {
        return await queryForModels(instance, 'SELECT * FROM $tableName ORDER BY $orderBy', []);
    }

    @override
    Future<int?> delete(String? arguments, List<String> parameters) async {
        print('delete() -> DELETE FROM $tableName WHERE $arguments (Parameter = $parameters)');
        final db = await DBLite().database;
        return await db.delete(tableName!, where: arguments, whereArgs: parameters);
    }

    /// If the primary key exists, then update the data, otherwise insert the data
    ///
    /// Args:
    ///   object: The object to be saved.
    ///
    /// Returns:
    ///   The return value is the primary key of the object that was saved.
    @override
    Future<int?> save(object) async {
        String primaryKey = "";
        String autoIncrement = "";
        bool autoIncrementBool = false;
        dynamic dataType;

        Map<String, dynamic> column = {};
        try {
            InstanceMirror instanceMirror = SetupEntity.reflect(object);
            for (var v in instanceMirror.type.declarations.values) {
                if (v is VariableMirror) {
                    if (MirrorFeature.isAnnotationPresent(v, Attribute)) {
                        Attribute attribute = MirrorFeature.getAnnotation(v, Attribute);

                        String fieldName = attribute.name;
                        if (fieldName.contains("_")) {
                            List<String> fn = fieldName.split("_");

                            fieldName = "";
                            for (int i = 0; i < fn.length; i++) {
                                if (i == 0) {
                                    fieldName += fn[i];
                                } else {
                                    fieldName += fn[i].substring(0, 1).toUpperCase() + fn[i].substring(1);
                                }
                            }
                        }

                        InstanceMirror instanceMirror = SetupEntity.reflect(object);
                        dynamic fieldValue = instanceMirror.invokeGetter(fieldName);

                        if (fieldValue == null) {
                            column[attribute.name] = attribute.defaultValue;
                        } else {
                            column[attribute.name] = fieldValue;
                        }

                        if (attribute.primaryKey) {
                            autoIncrementBool = attribute.autoIncrements;
                            if (attribute.autoIncrements) {
                                autoIncrement = attribute.name;
                            }

                            primaryKey = attribute.name;
                            dataType = fieldValue.runtimeType;
                        }
                    }
                }
            }

            for (var v in instanceMirror.type.superclass!.declarations.values) {
                if (v is VariableMirror) {
                    if (MirrorFeature.isAnnotationPresent(v, Attribute)) {
                        Attribute attribute = MirrorFeature.getAnnotation(v, Attribute);

                        String fieldName = attribute.name;
                        if (fieldName.contains("_")) {
                            List<String> fn = fieldName.split("_");

                            fieldName = "";
                            for (int i = 0; i < fn.length; i++) {
                                if (i == 0) {
                                    fieldName += fn[i];
                                } else {
                                    fieldName += fn[i].substring(0, 1).toUpperCase() + fn[i].substring(1);
                                }
                            }
                        }

                        InstanceMirror instanceMirror = SetupEntity.reflect(object);
                        dynamic fieldValue = instanceMirror.invokeGetter(fieldName);

                        if (fieldValue == null) {
                            column[attribute.name] = attribute.defaultValue;
                        } else {
                            column[attribute.name] = fieldValue;
                        }

                        if (attribute.primaryKey) {
                            autoIncrementBool = attribute.autoIncrements;
                            if (attribute.autoIncrements) {
                                autoIncrement = attribute.name;
                            }

                            primaryKey = attribute.name;
                            dataType = fieldValue.runtimeType;
                        }
                    }
                }
            }

            final db = await DBLite().database;
            var selectResult;

            if (primaryKey != "" && dataType != Null) {
                String select = "SELECT * FROM $tableName WHERE $primaryKey = ";
                if (dataType == String) {
                    select += "'${column[primaryKey].toString()}'";
                } else if (dataType == int || dataType == double) {
                    select += column[primaryKey].toString();
                } else {
                    throw Exception("Data Type not valid. Apply only String, Integer, or Double");
                }

                selectResult = await db.rawQuery(select);
            }

            if (selectResult != null && selectResult.isNotEmpty) {
                // ignore: avoid_print
                print("save() on Select -> $select => Exists");

                String update = "UPDATE $tableName SET ";
                for (String key in column.keys) {
                    if (key != primaryKey) {
                        update += "$key = '${column[key].toString()}',";
                    }
                }

                update = update.substring(0, update.length - 1);
                update += " WHERE $primaryKey = '${column[primaryKey].toString()}'";

                // ignore: avoid_print
                print('save() on Update -> $update (Parameter = ${column[primaryKey].toString()})');
                var updateResult = await db.rawUpdate(update);
                return updateResult;

            } else {
                // ignore: avoid_print
                print("save() on Select -> $select => Dont Exists");

                String insert = "INSERT INTO $tableName (";
                String values = " VALUES (";

                for (String key in column.keys) {
                    if (key == autoIncrement && autoIncrementBool) {
                        continue;
                    }

                    insert += "$key,";
                    if (column[key] is int || column[key] is double) {
                        values += "${column[key]},";
                    } else {
                        values += "'${column[key].toString()}',";
                    }
                }

                insert = insert.substring(0, insert.length - 1);
                values = values.substring(0, values.length - 1);

                values += ")";
                insert += ") $values";

                // ignore: avoid_print
                print('save() on Insert -> $insert');
                var insertResult = await db.rawInsert(insert);

                return insertResult;
            }
        } on Exception catch(e, stacktrace) {
            // ignore: avoid_print
            print(stacktrace);
        }

        return null;
    }

    /// It takes a query and a list of parameters, and returns a model entity
    ///
    /// Args:
    ///   persistanceType (dynamic): The type of the model you want to return.
    ///   query (String): The query to be executed.
    ///   parameters (List<dynamic>):
    ///
    /// Returns:
    ///   A Future<T>
    Future<T?> _processingForModel(dynamic persistanceType, String query, List<dynamic>? parameters) async {
        final db = await DBLite().database;

        try {
            parameters ??= [];

            for (int i = 0; i < parameters.length; i++) {
                dynamic parameter = parameters[i];

                if (parameter.runtimeType == String) {
                    query = query.replaceFirst("?", "'${parameter.toString()}'");
                } else if (parameter.runtimeType == int || parameter.runtimeType == double) {
                    query = query.replaceFirst("?", parameter.toString());
                } else {
                    throw Exception("Parameter not valid. Apply only String, Integer, or Double");
                }
            }

            InstanceMirror instanceMirror = SetupEntity.reflect(persistanceType);
            var selectResult = await db.rawQuery(query);
            Map<String, dynamic> arguments = {};

            if (selectResult.isNotEmpty) {
                Map<String, dynamic> data = selectResult[0];

                for (var v in instanceMirror.type.declarations.values) {
                    if (v is VariableMirror) {
                        if (MirrorFeature.isAnnotationPresent(v, Attribute)) {
                            Attribute attribute = MirrorFeature.getAnnotation(v, Attribute);

                            String fieldName = attribute.name;
                            if (fieldName.contains("_")) {
                                List<String> fn = fieldName.split("_");

                                fieldName = "";
                                for (int i = 0; i < fn.length; i++) {
                                    if (i == 0) {
                                        fieldName += fn[i];
                                    } else {
                                        fieldName += fn[i].substring(0, 1).toUpperCase() + fn[i].substring(1);
                                    }
                                }
                            }

                            dynamic fieldValue = instanceMirror.invokeSetter(fieldName, data[attribute.name]);
                            arguments[attribute.name] = fieldValue;
                        }
                    }
                }

                persistanceType = instanceMirror.invoke("toModelEntity", [arguments]);

                // Setting super in Offline capability model
                if (instanceMirror.type.superclass!.reflectedType == Offline) {
                    (persistanceType as Offline).idOffline = data['idOffline'];
                    persistanceType.expiredDate = data['expiredDate'];
                    persistanceType.flag = data['flag'];
                }

                return persistanceType;
            } else {
                return null;
            }
        } on Exception catch(e, stacktrace) {
            // ignore: avoid_print
            print(stacktrace);
        }

        return null;
    }

    /// It takes a query and a list of parameters, and returns a list of models
    ///
    /// Args:
    ///   persistanceType (dynamic): The type of the model you want to retrieve.
    ///   query (String): The query to be executed.
    ///   parameters (List<dynamic>):
    ///
    /// Returns:
    ///   A list of models.
    Future<List<T>> _processingForModels(dynamic persistanceType, String query, List<dynamic>? parameters) async {
        final db = await DBLite().database;
        List<T> result = [];

        try {
            parameters ??= [];

            for (int i = 0; i < parameters.length; i++) {
                dynamic parameter = parameters[i];

                if (parameter.runtimeType == String) {
                    query = query.replaceFirst("?", "'${parameter.toString()}'");
                } else if (parameter.runtimeType == int || parameter.runtimeType == double) {
                    query = query.replaceFirst("?", parameter.toString());
                } else {
                    throw Exception("Parameter not valid. Apply only String, Integer, or Double");
                }
            }

            InstanceMirror instanceMirror = SetupEntity.reflect(persistanceType);
            var selectResult = await db.rawQuery(query);

            if (selectResult.isNotEmpty) {
                List<Map<String, dynamic>> listData = selectResult;

                for (Map<String, dynamic> data in listData) {
                    Map<String, dynamic> arguments = {};

                    for (var v in instanceMirror.type.declarations.values) {
                        if (v is VariableMirror) {
                            if (MirrorFeature.isAnnotationPresent(v, Attribute)) {
                                Attribute attribute = MirrorFeature.getAnnotation(v, Attribute);

                                String fieldName = attribute.name;
                                if (fieldName.contains("_")) {
                                    List<String> fn = fieldName.split("_");

                                    fieldName = "";
                                    for (int i = 0; i < fn.length; i++) {
                                        if (i == 0) {
                                            fieldName += fn[i];
                                        } else {
                                            fieldName += fn[i].substring(0, 1).toUpperCase() + fn[i].substring(1);
                                        }
                                    }
                                }

                                dynamic fieldValue = instanceMirror.invokeSetter(fieldName, data[attribute.name]);
                                arguments[fieldName] = fieldValue;
                            }
                        }
                    }

                    T persistance = instanceMirror.invoke("toModelEntity", [arguments]) as T;

                    // Setting super in Offline capability model
                    if (instanceMirror.type.superclass!.reflectedType == Offline) {
                        (persistance as Offline).idOffline = data['idOffline'];
                        persistance.expiredDate = data['expiredDate'];
                        persistance.flag = data['flag'];
                    }

                    result.add(persistance);
                }

                return result;
            } else {
                return null!;
            }
        } on Exception catch(e, stacktrace) {
            // ignore: avoid_print
            print(stacktrace);
        }

        return null!;
    }

    /// > This function takes a query and parameters, and returns a model of type T
    ///
    /// Args:
    ///   persistanceType (dynamic): The type of the model you want to return.
    ///   query (String): The query to be executed.
    ///   parameters (List<dynamic>):
    ///
    /// Returns:
    ///   null!
    Future<T?> queryForModel(dynamic persistanceType, String query, List<dynamic>? parameters) async {
        if (T.toString() != persistanceType.runtimeType.toString()) {
            throw Exception("T general (${T.toString()}) not same persistanceType (${persistanceType.runtimeType})");
        }

        return await _processingForModel(persistanceType, query, parameters);
    }

    /// > This function takes a persistanceType, query, and parameters and returns a
    /// list of models
    ///
    /// Args:
    ///   persistanceType (dynamic): The type of the model you want to return.
    ///   query (String): The query to be executed.
    ///   parameters (List<dynamic>):
    ///
    /// Returns:
    ///   A list of models.
    Future<List<T?>> queryForModels(dynamic persistanceType, String query, List<dynamic>? parameters) async {
        if (T.toString() != persistanceType.runtimeType.toString()) {
            throw Exception("T general (${T.toString()}) not same persistanceType (${persistanceType.runtimeType})");
        }

        return await _processingForModels(persistanceType, query, parameters);
    }
}