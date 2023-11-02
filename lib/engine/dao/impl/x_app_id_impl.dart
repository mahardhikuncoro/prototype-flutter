import 'package:eksternal_app/engine/dao/dao.dart';

import '../../model/x_app_model.dart';
import '../dao_impl.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

@Dao("t_xapp")
class XAppIdImpl extends DaoImpl<XAppId> {
    XAppIdImpl() : super(XAppId());

    Future<XAppId?> get() async {
        return await queryForModel(XAppId(), "SELECT * FROM t_xapp", null);
    }

    Future<XAppId?> getById(String xId) async {
        return await queryForModel(XAppId(), "SELECT * FROM t_xapp WHERE appId = ?", [xId]);
    }

    @override
    List? select(persistance, String arguments, List<String> parameters) {
        throw UnimplementedError();
    }
}
