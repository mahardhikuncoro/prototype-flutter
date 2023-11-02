/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */


import 'package:eksternal_app/engine/request/transport/interface/response_listener.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:intl/intl.dart';

import '../dao/dao_impl.dart';
import '../request/service.dart';
import '../util/interface/schedule_listener.dart';
import '../util/scheluder.dart';
import 'offline.dart';

class OfflineAutomation {
    Map<DaoImpl, ServicePeripheral?> registered = {};

    OfflineAutomation put(DaoImpl persistance) {
        registered[persistance] = null;
        return this;
    }

    OfflineAutomation putWithRequest(DaoImpl persistance, ServicePeripheral servicePeripheral) {
        registered[persistance] = servicePeripheral;
        return this;
    }

    Future<List> _getRecords(DaoImpl daoImpl) async {
        return await daoImpl.getRecords('idOffline');
    }

    T _getRecord<T extends Offline>(DaoImpl daoImpl, int idOffline) {
        return daoImpl.queryForModel(daoImpl.instance, 'SELECT * FROM ${daoImpl.tableName} WHERE idOffline = ?', [idOffline]) as T;
    }

    void _deleteByExpiredDateAndFlag(Offline record, DaoImpl daoImpl) {
        try {
            int expiredDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(record.expiredDate!).millisecondsSinceEpoch;

            if (DateTime.now().millisecondsSinceEpoch >= expiredDate && record.flag == 1) {
                daoImpl.delete("idOffline = ?", [record.idOffline.toString()]);
            }
        } on Exception catch(e, stacktrace) {
            print(stacktrace);
        }
    }

    void _deleteByExpiredDate(Offline record, DaoImpl daoImpl) {
        try {
            int expiredDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(record.expiredDate!).millisecondsSinceEpoch;

            if (DateTime.now().millisecondsSinceEpoch >= expiredDate) {
                daoImpl.delete("idOffline = ?", [record.idOffline.toString()]);
            }
        } on Exception catch(e, stacktrace) {
            print(stacktrace);
        }
    }

    Future<int?> _updateFlag<T extends Offline>(DaoImpl daoImpl, int idOffline) async {
        T data = daoImpl.queryForModel(daoImpl.instance, "SELECT * FROM ${daoImpl.tableName} WHERE idOffline = ?", [idOffline]) as T;
        data.flag = 1;

        return await daoImpl.save(data);
    }

    void launch() async {
        await Scheduler()
            .listener(SchedulerListener(
                onTick: (packet) {
                    registered.forEach((key, value) async {
                        for (Offline record in await _getRecords(key)) {
                            if (value == null) {
                                _deleteByExpiredDate(record, key);
                            } else  {
                                if (record.flag == 0) {
                                    value.push(
                                        GlobalVar.getContext(),
                                        value.getRequestBody().body(_getRecord(key, record.idOffline!)),
                                        ResponseListener(
                                            onResponseDone: (code, message, body, id, packet) async {
                                                int? updateStatus = await _updateFlag(key, record.idOffline!);
                                                if (updateStatus != null && updateStatus > 0) {
                                                    _deleteByExpiredDateAndFlag(await _getRecord(key, record.idOffline!), key);
                                                }
                                            },
                                            onResponseFail: (code, message, body, id, packet) {},
                                            onResponseError: (exception, stacktrace, id, packet) {},
                                            onTokenInvalid: () {}
                                        ));
                                } else {
                                    _deleteByExpiredDateAndFlag(record, key);
                                }
                            }
                        }
                        ;
                    });

                    return true;
                },
                onTickDone: (packet) {

                },
                onTickFail: (packet) {

                }))
            .always(true)
            .run(const Duration(minutes: 1));
    }
}