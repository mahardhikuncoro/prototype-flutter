import 'package:eksternal_app/component/button_fill/button_fill.dart';
import 'package:eksternal_app/component/button_outline/button_outline.dart';
import 'package:eksternal_app/component/edit_field/edit_field.dart';
import 'package:eksternal_app/component/password_field/password_field.dart';
import 'package:eksternal_app/engine/dao/impl/auth_impl.dart';
import 'package:eksternal_app/engine/dao/impl/profile_impl.dart';
import 'package:eksternal_app/engine/dao/impl/x_app_id_impl.dart';
import 'package:eksternal_app/engine/get_x_creator.dart';
import 'package:eksternal_app/engine/model/auth_model.dart';
import 'package:eksternal_app/engine/model/error/error.dart';
import 'package:eksternal_app/engine/model/response/auth_response.dart';
import 'package:eksternal_app/engine/model/response/profile_response.dart';
import 'package:eksternal_app/engine/model/user_model.dart';
import 'package:eksternal_app/engine/model/x_app_model.dart';
import 'package:eksternal_app/engine/request/service.dart';
import 'package:eksternal_app/engine/request/transport/interface/response_listener.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:eksternal_app/engine/util/list_api.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';
import 'package:eksternal_app/engine/util/route.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 04/07/23
 */

class LoginController extends GetxController {
    BuildContext context;
    LoginController({required this.context});
    // GoogleSignIn googleSignIn = GoogleSignIn();
    // final FirebaseAuth auth = FirebaseAuth.instance;
    // User? user;
    var isLoading = false.obs;
    String? error;
    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    late Future<bool> isFirstLogin;

    late EditField efNoHp = EditField(
        controller: GetXCreator.putEditFieldController(
            "efNoHp"),
        label: "Nomor Handphone",
        hint: "08xxxx",
        alertText: "Nomer Handphone Harus Di Isi",
        textUnit: "",
        inputType: TextInputType.number,
        maxInput: 20,
        action : TextInputAction.next,
        onTyping: (value, control) {
        }
    );
    late PasswordField efPassword = PasswordField(
        controller: GetXCreator.putPasswordFieldController(
            "efPassword"),
        label: "Password",
        hint: "Ketik Kata Sandi",
        alertText: "Password Harus Di Isi",
        action : TextInputAction.done,
        maxInput: 20, onTyping: (String ) {  },
    );
    late ButtonFill bfLogin = ButtonFill(
        controller: GetXCreator.putButtonFillController("bfLogin"),
        label: "Masuk",
        onClick: () {
            getAuth();
            },
    );
    late ButtonOutline boRegister = ButtonOutline(
        controller: GetXCreator.putButtonOutlineController("bfRegister"),
        label: "Daftar", onClick: () {
            Get.offNamed(RoutePage.registerAccountPage);
        },
    );

    /// The function `getAuth()` retrieves the appId from Firebase Remote Config,
    /// saves it if it doesn't exist, generates a login payload, and makes an API
    /// call to authenticate the user.
    Future<void> getAuth() async {
        if (validation()) {
            isLoading.value = true;
            String appId = await FirebaseRemoteConfig.instance.getString("appId");
            if(appId.isEmpty) {
                appId = await FirebaseRemoteConfig.instance.getString("appId");
            }
            if(await XAppIdImpl().getById(appId) ==null ) XAppIdImpl().save(XAppId(appId: appId));
            GlobalVar.xAppId = appId;
            User loginPayload = generatePayload();
            try {
                Service.push(
                    apiKey: 'userApi',
                    service: ListApi.auth,
                    context: context,
                    body: [Mapper.asJsonString(loginPayload)],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet){
                            GlobalVar.auth = (body as AuthResponse).data;
                            AuthImpl().save(body.data);
                            getProfile(body.data!, appId, body.data!.action);
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            isLoading.value = false;
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan, ${(body as ErrorResponse).error!
                                    .message}",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red,
                            );
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            isLoading.value = false;
                            Get.snackbar(
                                "Pesan",
                                "Terjadi kesalahan internal",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red,
                            );
                        },
                        onTokenInvalid: GlobalVar.invalidResponse()
                    )
                );
            }catch(e){}
        }
    }

    /// The function checks if the input fields for phone number and password are
    /// empty and returns true if they are not empty.
    ///
    /// Returns:
    ///   a boolean value. If both `efNoHp.getInput()` and `efPassword.getInput()`
    /// are not empty, the function will return `true`. Otherwise, it will return
    /// `false`.
    bool validation(){
        if (efNoHp.getInput().isEmpty) {
            efNoHp.controller.showAlert();
            Scrollable.ensureVisible(efNoHp.controller.formKey.currentContext!);
            return false;
        }
        if (efPassword.getInput().isEmpty) {
            efPassword.controller.showAlert();
            Scrollable.ensureVisible(efPassword.controller.formKey.currentContext!);
            return false;
        }
        return true;
    }

    /// The `getProfile` function retrieves the user's profile information and
    /// handles the response accordingly.
    ///
    /// Args:
    ///   auth (Auth): The `auth` parameter is an object of type `Auth` which
    /// contains the authentication token and user ID needed for the API request.
    ///   appId (String): The `appId` parameter is a string that represents the ID
    /// of the application. It is used as a parameter in the API request to retrieve
    /// the user's profile information.
    ///
    /// Returns:
    ///   The function does not have a return type specified, so it does not return
    /// anything.
    void getProfile(Auth auth, String appId, String? action){
        User loginPayload = generatePayload();
        Service.push(
            apiKey: 'userApi',
            service: ListApi.profile,
            context: context,
            body: [
                auth.token,
                auth.id,
                appId,
                Mapper.asJsonString(loginPayload)
            ],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) async {
                    isLoading.value = false;
                    ProfileImpl().save((body as ProfileResponse).data);
                    GlobalVar.profileUser = body.data;
                    isFirstLogin = prefs.then((SharedPreferences prefs) {
                        return prefs.getBool('isFirstLogin') ?? true;
                    });
                    if(await isFirstLogin){
                        Get.toNamed(RoutePage.privacyPage, arguments: true);
                    }else{
                        // if(action == "DEFAULT_PASSWORD"){
                        //     showInformation();
                        // }
                        // else {
                        //     Get.offAllNamed(RoutePage.homePage);
                        // }
                        //TODO: buat nanti kalau sudah phase 2 uncomment atas comment bawah
                        Get.offAllNamed(RoutePage.homePage);
                    }
                },
                onResponseFail: (code, message, body, id, packet) {
                    isLoading.value = false;
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${(body as ErrorResponse).error!
                            .message}",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    isLoading.value = false;
                    Get.snackbar(
                        "Pesan",
                        "Terjadi kesalahan internal",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );
                },
                onTokenInvalid: GlobalVar.invalidResponse()
            )
        );

    }

        void showInformation(){
        Get.dialog(
            Center(
            child: Container(
                width: 300,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Row(
                            children: [
                                SvgPicture.asset(
                                    "images/error_icon.svg",
                                    height: 24,
                                    width: 24,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Perhatian!",
                                    style: GlobalVar.blackTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, decoration: TextDecoration.none),
                                ),
                            ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                            "Kata Sandi bawaan harus segera ganti" ,
                            style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.normal, decoration: TextDecoration.none),
                        ),
                        Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Container(
                                        height: 32,
                                        width: 100,
                                        color: Colors.transparent,
                                    ),
                                    Container(
                                        width: 100,
                                        child: ButtonFill(
                                            controller:
                                            GetXCreator.putButtonFillController("Dialog"),
                                            label: "OK",
                                            onClick: () => {
                                                Get.offAllNamed(RoutePage.changePassPage, arguments: true)
                                            }
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    ],
                ),
            ),
        ),
        barrierDismissible: false
        );
    }


    /// The function generates a payload by creating a User object with a username
    /// and password.
    ///
    /// Returns:
    ///   An instance of the User class is being returned.
    User generatePayload() {
        return User(
            username: efNoHp.getInput(),
            password: efPassword.getInput()
        );
    }


    @override
    void onInit() {
    // TODO: implement onInit
         super.onInit();
    }

    @override
    void onReady() {
    // TODO: implement onReady
         super.onReady();
         // efNoHp.setInput("081012340011");
    }
}

class LoginActivityBindings extends Bindings {
    BuildContext context;

    LoginActivityBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => LoginController(context: context));
    }
}
