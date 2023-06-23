import 'package:mooweapp/export_files.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<ScaffoldState>();
  String? _phone;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        key: _key,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: Get.height * .40,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/ic_launcher.png",
                        width: Get.height * .30,
                        height: Get.height * .15,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: InternationalPhoneNumberInput(
                          // inputBorder: const OutlineInputBorder(),
                          countries: authController!.setCountries,
                          initialValue: authController?.interPhoneNumber.value,

                          onInputChanged: (PhoneNumber phone) async {
                            authController!.interPhoneNumber.value = phone;
                            if(phone.phoneNumber != null) {
                              authController!.phone.text = phone.phoneNumber!;
                            }
                            // if (!permissionController
                            //     .locationPermissionGranted.value) {
                            //   permissionController.getLocationPermission();
                            // } else {
                            //   if (kDebugMode) {
                            //     print(
                            //         "authController!.interPhoneNumber.value.isoCode");
                            //     print(authController!.interPhoneNumber.value.isoCode);
                            //     print(authController!.countryShortCode.value);
                            //   }
                            //   if (authController!.countryShortCode.value !=
                            //       authController!.interPhoneNumber.value.isoCode) {
                            //     authController?.locatePosition(() {});
                            //   }
                            // }
                            // authController?.interPhoneNumber.value = phone;
                          },
                          onInputValidated: (bool value) async {
                            if (kDebugMode) {
                              print("onInputVauniulidated");
                              print(value);
                              print(value);
                              print("validator $value");
                              // setState(() {});

                            }
                            // _formKey.currentState!.save();

                            if (value) {
                              // authController!.phone.text = value.number;
                              if (!authController!.isLoading.value) {
                                authController!.isLoading.value = true;
                                await authController!.phoneNumberAuth(
                                    "${authController?.interPhoneNumber.value.phoneNumber}");
                              }

                            } else {
                            }
                          },
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),

                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: const TextStyle(color: Colors.black),
                          // initialValue: number,
                          // textFieldController: controller,
                          autoFocus: true,
                          formatInput: false,
                          keyboardType: TextInputType.number,
                          // inputBorder: OutlineInputBorder(),
                          onSaved: (PhoneNumber number) {
                            if (kDebugMode) {
                              print('On Saved: $number');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: SizedBox(
                    height: 40,
                    child: Obx(
                        () => authController!.verificationCode.value.isNotEmpty
                            ? CustomBtn3(
                                bgColor: kPrimaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Enter Pin",
                                    style: themeData!.textTheme.bodyText1!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                                onTap: () {
                                  authController!.enterPin();
                                },
                              )
                            : Container()),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
