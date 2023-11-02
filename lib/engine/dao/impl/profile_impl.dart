import 'package:eksternal_app/engine/dao/dao.dart';
import 'package:eksternal_app/engine/model/profile.dart';
import '../dao_impl.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

@Dao("m_profile")
class ProfileImpl extends DaoImpl<Profile> {

    ProfileImpl() : super(Profile());
    Future<Profile?> get() async {
        return await queryForModel(Profile(), "SELECT * FROM m_profile LIMIT 1", null);
    }

    @override
    List? select(persistance, String arguments, List<String> parameters) {
        throw UnimplementedError();
    }
}