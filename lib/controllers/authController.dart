import 'package:mooweapp/export_files.dart';

enum OTPStatus { GETOTP, VERIFY_PHONE }
// enum ImageSetter { IMAGE_IS_SET, IMAGE_NOT_SET }

class AuthController extends GetxController {
  late BuildContext context;
  User? firebaseUser;
  Rx<AuthScreens> authScreens = AuthScreens.LOGIN_SCREEN.obs;
  OTPStatus otpStatus = OTPStatus.GETOTP;
  String? get userId => firebaseUser?.uid;
  late User _user;
  // late final String _verificationCode = "";
  TextEditingController controllerFirstName = TextEditingController();
  TextEditingController controllerLastName = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController phone = TextEditingController();
  RxString phoneNumber = RxString("");
  TextEditingController confirmCode = TextEditingController();
  TextEditingController confirmPhone = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String phoneString = "";
  TextEditingController email = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  late Timestamp dateOfBirthTimestamp;

  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  List<String> setCountries = const ['GH', 'US', 'NG', 'GB'];
  Rx<PhoneNumber> interPhoneNumber = Rx<PhoneNumber>(PhoneNumber(isoCode: "US"));
  String initialCountry = 'US';
  bool isImagePicked = false;
  RxBool isLoading = RxBool(false);

  final ImagePicker _picker = ImagePicker();
  XFile? imageUrl;
  Map<String, dynamic> member = {};
  Map<String, dynamic> localUser = {};
  // LocalUser localUser = LocalUser();
  final pinPutFocusNode = FocusNode();
  final pinPutController = TextEditingController();
  RxString verificationCode = RxString("");
  RxBool locationGranted = RxBool(false);
  // final getOptions = GetOptions(source: Source.serverAndCache);
  final smartAuth = SmartAuth();
  Future<DocumentSnapshot> checkLocalUserExists(String id) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.doc("${dbHelper.users()}/$id").get();
    return snapshot;
  }

  void setAuthScreens(AuthScreens authScreen) {
    authScreens.value = authScreen;
    // notifyListeners();
  }

  @override
  Future<void> onInit() async {
    bool isUserLoggedIn = box.read("isUserLoggedIn") ?? false;
    if (kDebugMode) {
      print("isUserLoggedIn onInit");
      print(isUserLoggedIn);
      userDeviceToken();
    }

    if (isUserLoggedIn) {
      authScreens.value = AuthScreens.HOME_SCREEN;
    } else {
      // authScreens.value = AuthScreens.LOGIN_SCREEN;
      print('User is NOT signed in!');
    }

    auth.authStateChanges().listen((event) {
      if (event != null) {
      } else {
        print('User is NOT signed in!');
      }
    });
    ever(verificationCode, (callback) {
      if (verificationCode.isNotEmpty) {
        isLoading.value = false;
        dismissLoadingWidget();
      }
    });
    ever(interPhoneNumber, (callback) => setUpCurrency());
    super.onInit();
  }

  void userDeviceToken() async {
    FirebaseMessaging.instance.getToken().then((token) {
      if (token == null) return;
      deviceToken.value = token;
      box.write("deviceToken", token.toString());
      if (kDebugMode) {
        print("onTokenRefresh");
        print(deviceToken.value);
      }
    });
  }

  void errorMessage({required String title, required String message}) {
    Get.defaultDialog(
        title: title,
        content: Column(
          children: [
            Text(message.toString()),
          ],
        ),
        confirm: SizedBox(
          height: 35,
          child: CustomBtn2(
            bgColor: kPrimaryColor,
            onTap: () {
              dismissLoadingWidget();
            },
            child: Text(
              "Okay",
              style: themeData!.textTheme.bodyLarge,
            ),
          ),
        ));
  }

  Future phoneNumberAuth(String phone) async {
    showLoading();
    auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        debugPrint("$e");
        dismissLoadingWidget();
        Get.defaultDialog(
            content: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        e.message.toString(),
                        style: themeData!.textTheme.bodyText1,
                      ),
                      Text(
                        e.code.toString(),
                        style: themeData!.textTheme.bodyText1,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
      },
      codeSent: (String verificationId, int? resendToken) async {
        // dismissLoadingWidget();
        verificationCode.value = verificationId;

        debugPrint('martAuth.getSmsCode');
        // Update the UI - wait for the user to enter the SMS code
        final res = await smartAuth.getSmsCode();
        if (res.succeed) {
          debugPrint('martAuth.getSmsCode: ${res.code}');

          try {
            // Create a PhoneAuthCredential with the code
            PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationCode.value, smsCode: res.code!);

            // Sign the user in (or link) with the credential
            auth.signInWithCredential(credential).then((UserCredential credential) async {
              DocumentSnapshot snapshot = await checkLocalUserExists(credential.user!.uid);
              _user = credential.user!;
              // dbHelper.userId = credential.user!.uid;

              if (snapshot.exists) {
                box.write("isUserLoggedIn", true);
                setAuthScreens(AuthScreens.HOME_SCREEN);
              } else {
                setAuthScreens(AuthScreens.REGISTER_SCREEN);
              }
            });
          } on FirebaseAuthException catch (e) {
            Get.defaultDialog(
                content: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                          child: Text(
                    e.message.toString(),
                    style: themeData!.textTheme.bodyText1,
                  )))
                ],
              ),
            ));
          }
        } else {
          debugPrint('SMS Failure:');
          verificationCode.value = "";
          if (verificationCode.value.isNotEmpty) {
            showModalBottomSheet(
              context: Get.context!,
              builder: (context) => Container(
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * .1,
                    ),
                    Text(
                      "Enter Passcode 2",
                      style: themeData!.textTheme.headline4,
                    ),
                    SizedBox(
                      height: Get.height * .15,
                    ),
                    Pinput(
                      autofocus: true,
                      // preFilledWidget: ,
                      // autofillHints: ,
                      length: 6,
                      obscureText: false,
                      obscuringCharacter: "*",
                      pinContentAlignment: Alignment.center,
                      onCompleted: (pin) => print(pin),

                      validator: (s) {
                        // return s == '2222' ? null : 'Pin is incorrect';
                        if (s != null) {
                          Get.back();
                          String smsCode = 'xxxx';
                          print("smsCode");
                          try {
                            // Create a PhoneAuthCredential the code with
                            PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationCode.value, smsCode: s);
                            print("smsCode credential");
                            print(credential.asMap());

                            // Sign the user in (or link) with the credential
                            auth.signInWithCredential(credential).then((UserCredential credential) async {
                              DocumentSnapshot snapshot = await checkLocalUserExists(credential.user!.uid);
                              _user = credential.user!;

                              if (snapshot.exists) {
                                box.write("isUserLoggedIn", true);
                                setAuthScreens(AuthScreens.HOME_SCREEN);
                              } else {
                                setAuthScreens(AuthScreens.REGISTER_SCREEN);
                              }
                            });
                          } on FirebaseAuthException catch (e) {
                            Get.defaultDialog(
                                content: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    e.message.toString(),
                                    style: themeData!.textTheme.bodyText1,
                                  )))
                                ],
                              ),
                            ));
                          }
                          return null;
                        } else {
                          return 'Pin is incorrect';
                        }
                      },
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                    ),
                  ],
                ),
              ),
            );
          }
        }
        print("verificationId");
        print(verificationId);
        verificationCode.value = verificationId;

        print("_verificationId");
        print(verificationCode);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: const Duration(seconds: 60),
    );
  }

  void enterPin() {
    print("enterPin_verificationId");
    print(verificationCode);
    showModalBottomSheet(
      isScrollControlled: true,
      context: Get.context!,
      builder: (context) => Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: Get.height * .1,
            ),
            Text(
              "Enter Passcode 5",
              style: themeData!.textTheme.headline4,
            ),
            SizedBox(
              height: Get.height * .15,
            ),
            Pinput(
              autofocus: true,
              // preFilledWidget: ,
              // autofillHints: ,
              length: 6,
              obscureText: false,
              obscuringCharacter: "*",
              pinContentAlignment: Alignment.center,
              onCompleted: (pin) => print(pin),

              validator: (s) {
                if (s != null) {
                  Get.back();
                  String smsCode = 'xxxx';
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationCode.value, smsCode: s);

                  try {
                    if (verificationCode.isNotEmpty) {
                      if (kDebugMode) {
                        print("smsCode credential");
                        print(credential.asMap());
                      }

                      // Sign the user in (or link) with the credential
                      auth.signInWithCredential(credential).then((UserCredential credential) async {
                        if (kDebugMode) {
                          print("signInWithCredential signInWithCredential");
                          print(credential.user!.uid);
                        }
                        DocumentSnapshot snapshot = await checkLocalUserExists(credential.user!.uid);
                        _user = credential.user!;
                        if (snapshot.exists) {
                          debugPrint("has a user");
                          box.write("isUserLoggedIn", true);
                          verificationCode.value = "";
                          // chatServices.localMember = snapshot;
                          setAuthScreens(AuthScreens.HOME_SCREEN);
                        } else {
                          debugPrint("has no user");

                          setAuthScreens(AuthScreens.REGISTER_SCREEN);
                        }
                      });
                    } else {
                      Get.back();
                      Get.defaultDialog(title: "Phone number invalid");
                    }
                  } on FirebaseAuthException catch (e) {
                    Get.defaultDialog(
                        content: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Center(
                                  child: Text(
                            e.message.toString(),
                            style: themeData!.textTheme.bodyText1,
                          )))
                        ],
                      ),
                    ));
                  }
                  return null;
                } else {
                  return 'Pin is incorrect';
                }
              },
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
            ),
          ],
        ),
      ),
    );
  }

  // void getAppSignature() async {
  //   final res = await smartAuth.getAppSignature();
  //   debugPrint('Signature: $res');
  // }

  void getSmsCode() async {
    final res = await smartAuth.getSmsCode();
    if (res.succeed) {
      debugPrint('SMS: ${res.code}');
    } else {
      debugPrint('SMS Failure:');
    }
  }

  Future<bool> signIn() async {
    setAuthScreens(AuthScreens.LOGIN_SCREEN);

    try {
      await auth.signInWithEmailAndPassword(email: email.text.trim(), password: password.text.trim()).then((UserCredential userCredential) {
        userCredential.user;

        box.write("isUserLoggedIn", true);
        setAuthScreens(AuthScreens.HOME_SCREEN);
      });
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    }
    return true;
  }

  Future signOut() async {
    debugPrint("signOut");
    box.write("isUserLoggedIn", false);
    await FirebaseAuth.instance.signOut();
    // setAuthScreens(AuthScreens.LOGIN_SCREEN);
    authScreens.value = AuthScreens.LOGIN_SCREEN;
    return false;
  }

  void pickImage(Function setState) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      isImagePicked = true;
      imageUrl = image;
      // notifyListeners();
      setState();
    }
  }

  Uuid uuid = Uuid();
  Future<bool> signUpUser() async {
    showLoading();
    try {
      // if (_user.email != email.text.trim()) {
      //   _user.updateEmail(email.text.trim().toLowerCase()).catchError((err){
      //   }, test:(error){
      //     return error is int;
      //   } );
      // }
      _user.updateEmail(email.text.trim().toLowerCase());

      setAuthScreens(AuthScreens.REGISTER_SCREEN);
      member[memberModel.imageUrl] = await chatUploader(
        file: File(imageUrl!.path),
        path: basename(imageUrl!.path),
        contentType: 'image/png',
      );
      member[memberModel.userUID] = _user.uid;
      member[memberModel.lastSeen] = Timestamp.now();
      member[memberModel.dateJoined] = Timestamp.now();
      member[memberModel.currencySign] = localUser[localUserModel.countryModel][countryModelModel.currencySign].trim();
      member[memberModel.phone] = _user.phoneNumber;
      member[memberModel.firstName] = controllerFirstName.text;
      member[memberModel.lastName] = controllerLastName.text;
      member[memberModel.accountType] = "PERSONAL";
      member[memberModel.cardTransactionCollection] = "${dbHelper.user()}/transactions";
      member[memberModel.cardPathDocId] = "${dbHelper.user()}/card/${dbHelper.userId()}";
      member[memberModel.account] = "${dbHelper.user()}/account/${dbHelper.userId()}";
      member[memberModel.dateOfBirth] = dateOfBirthTimestamp;
      member[memberModel.contactPath] = dbHelper.user();
      member[memberModel.recentChatCollectionPath] = "${dbHelper.user()}/recentChats";
      member[memberModel.callPath] = "${dbHelper.user()}/calls";
      member[memberModel.accountBanned] = false;
      member[memberModel.accountBanned] = false;
      member[memberModel.hasAStore] = false;
      member[memberModel.affiliateActive] = false;
      member[memberModel.fraudReport] = [];
      member[memberModel.blocked] = [];
      member[memberModel.affiliateId] = uuid.v4();

      localUser[localUserModel.currencySign] = localUser[localUserModel.countryModel][countryModelModel.currencySign].trim();
      localUser[localUserModel.phone] = _user.phoneNumber;
      localUser[localUserModel.firstName] = controllerFirstName.text;
      localUser[localUserModel.lastName] = controllerLastName.text;
      localUser[localUserModel.imageUrl] = member[memberModel.imageUrl];
      await FirebaseFirestore.instance.collection(dbHelper.users()).doc(auth.currentUser!.uid).set(member);
      // Member? newMember = Member.fromMap(member.toMapSetup());
      localUser[localUserModel.userUID] = _user.uid;
      // print(newMember.toMap());
      CreditCard creditCard = CreditCard(
        firstName: "${localUser[localUserModel.firstName]}".trim(),
        lastName: "${localUser[localUserModel.lastName]}".trim(),
        nameOnCard: "${localUser[localUserModel.firstName]} ${localUser[localUserModel.lastName]}",
        securityCode: "123 456",
        number: "${DateTime.now().microsecondsSinceEpoch}".replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} "),
        brand: '${CardBrand.visa}'.trim(),
        amount: 0.0,
        cardDocId: member[memberModel.cardTransactionCollection],
        imageUrl: member[memberModel.imageUrl].toString(),
        cardTransactionPath: member[memberModel.cardTransactionCollection],
        isDefault: false,
        userDocId: _user.uid,
        accountType: "Personal".trim(),
        currencyCode: member[memberModel.currencyCode].trim(),
        currencySign: member[memberModel.currencySign].trim(),
        // transactions: List<MooweTransactions>.empty(growable: true),
        colors: [
          const Color(0xFF0000FF).toString(),
          const Color(0XFF377CFF).toString(),
        ],
        isCardActivated: true,
      );

      print("creditCard");
      // print(newMember.cardPathDocId!);
      localUser[localUserModel.creditCard] = creditCard.toMap();
      // localUser.member = newMember;
      localUser[localUserModel.subscribedServices] = [EnumToString.convertToString(SubscribedServices.MOOWE_RIDER)];
      await FirebaseFirestore.instance.doc(member[memberModel.cardPathDocId]!).set(creditCard.toMap());
      await FirebaseFirestore.instance.doc(member[memberModel.account]).set(localUser);

      dismissLoadingWidget();
      setAuthScreens(AuthScreens.HOME_SCREEN);

      box.write("isUserLoggedIn", true);
    } on FirebaseAuthException catch (e) {
      Get.defaultDialog(content: Text(e.code));
    }

    return Future.value(true);
  }

  // Future<String> uploadMessageImage() async => await chatUploader(
  //       file: File(imageUrl!.path),
  //       path: Path.basename(imageUrl!.path),
  //       contentType: 'image/png',
  //     );

  /// Generic file upload for any [path] and [contentType]
  Future<String> chatUploader({required File file, required String path, required String contentType}) async {
    if (kDebugMode) {
      print('uploading to: $path');
    }
    final storageReference = fireStorage.ref().child(path);
    await storageReference.putFile(file, SettableMetadata());
    // final downloadUrl = await uploadTask.ref.getDownloadURL();
    // if (kDebugMode) {
    //   print('downloadUrl: $downloadUrl');
    // }
    return path;
  }

  Future<String> uploadReturnUrl({required File file, required String path, required String contentType}) async {
    if (kDebugMode) {
      print('uploading to: $path');
    }
    final storageReference = fireStorage.ref().child(path);
    await storageReference.putFile(file, SettableMetadata());
    final downloadUrl = await storageReference.getDownloadURL();

    // if (kDebugMode) {
    //   print('downloadUrl: $downloadUrl');
    // }
    return downloadUrl;
  }

  // void networkConnection() async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       print('connected');
  //       print(result[0].address);
  //     }
  //   } on SocketException catch (_) {
  //     print('not connected');
  //   }
  // }

  setDeviceToken() async {
    localUser[localUserModel.deviceToken] = await FirebaseMessaging.instance.getToken();
    member[memberModel.deviceToken] = localUser[localUserModel.deviceToken];
    if (kDebugMode) {
      print(localUser[localUserModel.deviceToken]);
    }
  }

  bool isLocationPermissionGranted = false;
  bool isLocationCurrencySet = false;
  RxString countryShortCode = RxString("");
  void locatePosition(Function setState) async {
    PermissionStatus status = await Permission.location.status;
    switch (status) {
      case PermissionStatus.denied:
        // TODO: Handle this case.
        locationGranted.value = false;
        break;
      case PermissionStatus.granted:
        // TODO: Handle this case.

        // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        if (kDebugMode) {
          print("position.toString()");
          // print(position.toString());
        }

        // currentPosition = position;

        // LatLng latLngPosition = LatLng(position.latitude, position.longitude);
        // CameraPosition cameraPosition = new CameraPosition(target: latLngPosition, zoom: 14);
        // newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        //  await AssistantMethods.searchCoordinateAddress(position);
        // RiderAppData appData = Get.find();
        // List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        // Future.delayed(const Duration(seconds: 1), () {
        //   countryShortCode.value = "${placemarks[0].isoCountryCode}";
        //   // interPhoneNumber.value =
        //   //     PhoneNumber(isoCode: "${placemarks[0].isoCountryCode}");
        // });
        // localUser[localUserModel.countryModel] = countryInformation[placemarks[0].isoCountryCode];
        // if (kDebugMode) {
        //   print("localUser[localUserModel.countryModel]");
        //   print(placemarks[0].isoCountryCode);
        //   print(localUser[localUserModel.countryModel]);
        // }
        //
        // member[memberModel.currencyCode] = localUser[localUserModel.countryModel][memberModel.currencyCode];
        // member[memberModel.currencySign] = localUser[localUserModel.countryModel][memberModel.currencySign];
        // localUser[localUserModel.address] = placemarks[0];
        // localUser[localUserModel.address] = Timestamp.now();
        // isLocationCurrencySet = true;
        // isLocationPermissionGranted = true;
        // locationGranted.value = true;

        setState();
        if (kDebugMode) {
          // print("this is your addd ${localUser.countryModel!.toJson()}");
        }

        break;
      case PermissionStatus.restricted:
        // TODO: Handle this case.
        locationGranted.value = false;
        break;
      case PermissionStatus.limited:
        // TODO: Handle this case.
        locationGranted.value = false;
        break;
      case PermissionStatus.permanentlyDenied:
        // TODO: Handle this case.
        locationGranted.value = false;
        break;
    }
    if (status.isGranted) {}
  }

  void setUpCurrency() {
    // countryShortCode.value = countryInformation[interPhoneNumber.value.isoCode];

    localUser[localUserModel.countryModel] = countryInformation[interPhoneNumber.value.isoCode];
    if (kDebugMode) {
      print("localUser[localUserModel.countryModel]");
      print(interPhoneNumber.value.isoCode);
      print(localUser[localUserModel.countryModel]);
    }

    member[memberModel.currencyCode] = localUser[localUserModel.countryModel][memberModel.currencyCode];
    member[memberModel.currencySign] = localUser[localUserModel.countryModel][memberModel.currencySign];
    localUser[localUserModel.address] = "";
    localUser[localUserModel.address] = Timestamp.now();
    isLocationCurrencySet = true;
    isLocationPermissionGranted = true;
    locationGranted.value = true;
  }
}
