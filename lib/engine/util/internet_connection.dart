import 'package:eksternal_app/engine/dao/impl/auth_impl.dart';
import 'package:eksternal_app/engine/dao/impl/profile_impl.dart';
import 'package:eksternal_app/engine/model/auth_model.dart';
import 'package:eksternal_app/engine/model/profile.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:eksternal_app/engine/util/route.dart';
import 'package:eksternal_app/ui/network_service/network_service_activity.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 04/07/23
 */


class NetworkStatusService extends GetxService {
    bool isInitial = true;
    NetworkStatusService() {
        InternetConnectionChecker().onStatusChange.listen(
                (status) async {
                _getNetworkStatus(status);
            },
        );
    }

    void _getNetworkStatus(InternetConnectionStatus status) {
        if (status == InternetConnectionStatus.connected) {
            _validateSession(); //after internet connected it will redirect to home page
        } else {
            Get.dialog(NetworkErrorItem(), useSafeArea: false); // If internet loss then it will show the NetworkErrorItem widget
        }
    }

    void _validateSession() async {
        if(isInitial) {
            isInitial = false;
            Get.offNamedUntil(RoutePage.splashPage, (_)=> false);
        } else {
            Auth? auth = await AuthImpl().get();
            Profile? userProfile = await ProfileImpl().get();
            if (auth == null ||userProfile == null ) {
                Get.offNamedUntil(RoutePage.loginPage, (_)=> false);
            } else {
                GlobalVar.auth = auth;
                GlobalVar.profileUser = userProfile;
                Get.back();
            }
        }
    }
}

class StreamInternetConnection {
    static void init() async {
        Get.put<NetworkStatusService>(NetworkStatusService(), permanent: true);
    }
}