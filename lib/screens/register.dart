import 'package:mooweapp/export_files.dart';

bool locations = false;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _key = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }
  // final picker = ImagePicker();
  // bool passcodeEntered = false;

  static const _100_YEARS = Duration(days: 365 * 100);

  @override
  Widget build(BuildContext context) {
    // final controller = Provider.of<AuthController>(context);
    // controller.setDeviceToken();
    authController!.setDeviceToken();
    // contrkConnection();
    return Scaffold(
        key: _key,
        // backgroundColor: kPrimaryColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              authController?.interPhoneNumber.value = PhoneNumber();
              authController?.setAuthScreens(AuthScreens.LOGIN_SCREEN);
            },
          ),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // Container(
                    //   color: Colors.white,
                    //   height: 100,
                    // ),
                    const ProfilePictureImage(),
                    Container(
                      height: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    signupWidget(),
                    TextButton(
                        onPressed: () async {
                          // changeScreenReplacement(context, LoginScreen());
                        },
                        child: Text(
                          "GO BACK",
                          style: themeData!.textTheme.bodyLarge!.copyWith(color: Colors.white),
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              // controller.showLoading ? const CircularProgressIndicator() : Container(),
            ],
          ),
        ));
  }

  int userAge = 0;
  Widget signupWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextFormField(
                style: themeData!.textTheme.bodyLarge!.copyWith(color: kPrimaryColor),
                controller: authController!.controllerFirstName,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) async {},
                validator: (v) {
                  if (v.toString().trim().isNotEmpty) {
                    return null;
                  } else {
                    return 'Please enter a valid name';
                  }
                },
                autofocus: true,
                decoration: const InputDecoration(
                    hintStyle: TextStyle(color: kPrimaryColor),
                    border: InputBorder.none,
                    labelStyle: TextStyle(color: kPrimaryColor),
                    labelText: "First Name",
                    hintText: "First Name",
                    icon: Icon(
                      Icons.person,
                      color: Colors.black,
                    )),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextFormField(
                controller: authController!.controllerLastName,
                onChanged: (value) {},
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.sentences,
                validator: (v) {
                  if (v.toString().trim().isNotEmpty) {
                    return null;
                  } else {
                    return 'Please enter a valid name';
                  }
                },
                autofocus: true,

                style: themeData!.textTheme.bodyLarge!.copyWith(color: kPrimaryColor),

                // controller: authProvider.email,
                decoration: const InputDecoration(
                    hintStyle: TextStyle(color: kPrimaryColor),
                    border: InputBorder.none,
                    labelStyle: TextStyle(color: kPrimaryColor),
                    labelText: "Last Name",
                    hintText: "Sir. Name",
                    icon: Icon(
                      Icons.person,
                      color: Colors.black,
                    )),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextFormField(
                controller: authController!.email,
                onChanged: (value) {},
                autofocus: true,

                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                validator: (v) {
                  if (v.toString().trim().isNotEmpty) {
                    return null;
                  } else {
                    return 'Please enter a valid name';
                  }
                },
                style: themeData!.textTheme.bodyLarge!.copyWith(color: kPrimaryColor),

                // controller: authProvider.email,
                decoration: const InputDecoration(
                    hintStyle: TextStyle(color: kPrimaryColor),
                    border: InputBorder.none,
                    labelStyle: TextStyle(color: kPrimaryColor),
                    labelText: "Email Address",
                    hintText: "Email",
                    icon: Icon(
                      Icons.email,
                      color: Colors.black,
                    )),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextFormField(
                onTap: () async {
                  final DateTime? birthDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(_100_YEARS),
                    lastDate: DateTime.now(),
                  );
                  DateTime today = DateTime.now();
                  authController!.dateOfBirth.text = DateFormat.yMMMd().format(birthDate!);
                  authController?.dateOfBirthTimestamp = Timestamp.fromDate(birthDate);
                  var age = today.year - birthDate.year;
                  userAge = age;
                  debugPrint("$age");
                },
                autofocus: true,
                controller: authController!.dateOfBirth,
                onChanged: (value) {},
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                validator: (v) {
                  if (v.toString().trim().isNotEmpty) {
                    return null;
                  } else {
                    return 'Please enter a valid name';
                  }
                },
                style: themeData!.textTheme.bodyLarge!.copyWith(color: kPrimaryColor),

                // controller: authProvider.email,
                decoration: const InputDecoration(
                    hintStyle: TextStyle(color: kPrimaryColor),
                    border: InputBorder.none,
                    labelStyle: TextStyle(color: kPrimaryColor),
                    labelText: "Date of Birth",
                    hintText: "Date of Birth",
                    icon: Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                    )),
              ),
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 10.0, right: 10),
        //   child: IntlPhoneField(
        //     style: themeData!.textTheme.bodyLarge!.copyWith(color: kPrimaryColor),
        //     showCountryFlag: true,
        //     controller: authController!.phone,
        //     dropdownTextStyle: themeData!.textTheme.bodyLarge!.copyWith(color: kPrimaryColor),
        //     decoration: const InputDecoration(
        //       labelStyle: TextStyle(color: kPrimaryColor),
        //       labelText: 'Phone Number',
        //       focusedBorder: OutlineInputBorder(
        //         borderSide: BorderSide(color: Colors.white, width: 2.0),
        //       ),
        //       border: OutlineInputBorder(
        //         borderSide: BorderSide(),
        //       ),
        //     ),
        //     validator: (value) async {
        //       print("validator $value");
        //       return null;
        //       // authController!.phone.text = value.toString();
        //     },
        //     onChanged: (phone) {
        //       print("phone.completeNumber");
        //       print(phone.completeNumber);
        //     },
        //     onCountryChanged: (country) {
        //       print('Country changed to: ' + country.name);
        //     },
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () async {
              if (authController!.imageUrl != null) {
                if (authController!.controllerFirstName.text.isNotEmpty) {
                  if (authController!.controllerLastName.text.isNotEmpty) {
                    if (authController!.email.text.isNotEmpty) {
                      if (authController!.phone.text.isNotEmpty) {
                        if (authController!.dateOfBirth.text.isNotEmpty) {
                          if (userAge > 17) {
                            legalNamePrompt();
                          } else {
                            ageRestriction();
                          }
                        } else {
                          authController!.errorMessage(title: "Date of Birth", message: "Please Enter your Date of Birth");
                        }
                      } else {
                        authController!.errorMessage(title: "Phone", message: "Please Enter your Phone Number");
                      }
                    } else {
                      authController!.errorMessage(title: "Email", message: "Please Enter your Email");
                    }
                  } else {
                    authController!.errorMessage(title: "Last Name", message: "Please Enter your Last Name");
                  }
                } else {
                  authController!.errorMessage(title: "First Name", message: "Please Enter your first Name");
                }
                // await authController!.signUpUser();
              } else {
                authController!.errorMessage(title: "Profile Picture", message: "Please Upload profile picture!");
              }
              // print(controller.controllerFirstName.text);
              // print(controller.controllerLastName.text);
              // print(controller.phone.text);
              // authController!.signUpUser();
            },
            child: Container(
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Register",
                        style: themeData!.textTheme.button!.copyWith(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void legalNamePrompt() {
    Get.defaultDialog(
        title: "Legal Name",
        content: const Text(
          "Make sure your first and last names are your legal names, you wont be able to change it after your registrations",
          textAlign: TextAlign.center,
        ),
        confirm: SizedBox(
          height: permissionController.confirmButtonHeight,
          width: permissionController.confirmButtonWidth,
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Back"),
                  )),
              Expanded(child: Container()),
              InkWell(
                  onTap: () async {
                    Get.back();
                    authController!.signUpUser();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Agree"),
                  )),
            ],
          ),
        ));
  }

  void ageRestriction() {
    Get.defaultDialog(
        title: "Age restriction",
        content: const Text(
          "You do not meet the age requirements. You must be 18 or older",
          textAlign: TextAlign.center,
        ),
        confirm: SizedBox(
          height: permissionController.confirmButtonHeight,
          width: permissionController.confirmButtonWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Okay"),
                  )),
            ],
          ),
        ));
  }
}

class ProfilePictureImage extends StatefulWidget {
  const ProfilePictureImage({Key? key}) : super(key: key);

  @override
  State<ProfilePictureImage> createState() => _ProfilePictureImageState();
}

class _ProfilePictureImageState extends State<ProfilePictureImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          authController!.isImagePicked
              ? GestureDetector(
                  onTap: () async {
                    if (!authController!.isLocationPermissionGranted) {
                      if (authController!.isLocationPermissionGranted) {
                        authController!.locatePosition(() {
                          setState(() {});
                        });
                      } else {
                        if (await Permission.location.isGranted) {
                          authController!.isLocationPermissionGranted = true;
                        } else {
                          await Permission.photos.request();
                          await Permission.location.request();
                          authController!.locatePosition(() {
                            setState(() {});
                          });
                        }
                      }
                    } else {
                      await Permission.photos.request();
                      await Permission.storage.request();
                      authController!.pickImage(() {
                        setState(() {});
                      });
                    }
                  },
                  child: authController!.imageUrl != null
                      ? CircleAvatar(
                          radius: 50.0,
                          child: ClipOval(
                            // borderRadius: BorderRadius.circular(50.0),
                            child: Image.file(
                              File(
                                authController!.imageUrl!.path,
                              ),
                              fit: BoxFit.fill,
                              width: 100,
                              height: 100,
                            ),
                          ))
                      : CircleAvatar(
                          radius: 50,
                          child: IconButton(
                            iconSize: 60,
                            icon: const Icon(FontAwesomeIcons.user),
                            onPressed: () {
                              authController!.pickImage(() {
                                setState(() {});
                              });
                            },
                          ),
                        ))
              : CircleAvatar(
                  radius: 50,
                  child: IconButton(
                    iconSize: 60,
                    icon: const Icon(FontAwesomeIcons.user),
                    onPressed: () {
                      authController!.pickImage(() {
                        setState(() {});
                      });
                    },
                  ),
                ),

          // Avatar(
          //   avatarUrl: localUser.imageUrl,
          //   onTap: () async {
          //     if(await permissionService(permission: Permission.camera)){
          //       camerHandler.getImage(refreshPage);
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
