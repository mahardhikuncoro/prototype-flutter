import 'package:eksternal_app/engine/dao/dao.dart';

import '../../model/auth_model.dart';
import '../dao_impl.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

@Dao("t_auth")
class AuthImpl extends DaoImpl<Auth> {
    AuthImpl() : super(Auth());

    Future<Auth?> get() async {
        return await queryForModel(Auth(), "SELECT * FROM t_auth", null);
    }

    @override
    List? select(persistance, String arguments, List<String> parameters) {
        throw UnimplementedError();
    }
}
