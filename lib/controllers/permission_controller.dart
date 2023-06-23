import 'package:mooweapp/export_files.dart';

class PermissionController extends GetxController {
  static PermissionController instance = Get.find();
  RxBool contactsPermissionGranted = RxBool(false);
  RxBool cameraPermissionGranted = RxBool(false);
// RxBool locationPermissionGranted = RxBool(false);
  RxBool storagePermissionGranted = RxBool(false);
  RxBool audioPermissionGranted = RxBool(false);

  @override
  void onInit() {
    checkCameraPermission();
    checkContactPermission();
    storageCameraPermission();
    microphonePermission();
    // ever(locationPermissionGranted, (callback) => authController!.locatePosition((){}));
    ever(contactsPermissionGranted, (callback) {
      if (contactsPermissionGranted.value) {
        // contactServices.getAllContacts();
        // contactServices.listenToContacts();
      }
    });
    super.onInit();
  }

  Future<void> microphonePermission() async {
    PermissionStatus status = await Permission.microphone.status;
    if (kDebugMode) {
      print("microphonePermission");
      print(status);
    }
    if (status == PermissionStatus.granted) {
      audioPermissionGranted.value = true;
    } else {
      audioPermissionGranted.value = false;
    }
  }

  Future<void> storageCameraPermission() async {
    PermissionStatus status = await Permission.storage.status;
    if (kDebugMode) {
      print("storageCameraPermission");
      print(status);
    }
    if (status == PermissionStatus.granted) {
      storagePermissionGranted.value = true;
    } else {
      storagePermissionGranted.value = false;
    }
  }

  // Future<void> locationPermission() async {
  //   PermissionStatus status = await Permission.location.status;
  //   if (kDebugMode) {
  //     print(status);
  //   }
  //   if(status == PermissionStatus.granted) {
  //     locationPermissionGranted.value = true;
  //   } else {
  //     locationPermissionGranted.value = false;
  //   }
  // }
  Future<void> checkCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (kDebugMode) {
      print("checkCameraPermission");
      print(status);
    }
    if (status == PermissionStatus.granted) {
      cameraPermissionGranted.value = true;
    } else {
      cameraPermissionGranted.value = false;
    }
  }

  Future<void> checkContactPermission() async {
    PermissionStatus status = await Permission.contacts.status;
    if (kDebugMode) {
      print("checkContactPermission");
      print(status);
    }
    if (status == PermissionStatus.granted) {
      contactsPermissionGranted.value = true;
    } else {
      contactsPermissionGranted.value = false;
    }
  }

  double confirmButtonHeight = Get.width * 0.1;
  double confirmButtonWidth = Get.width * 0.9;
  void getMicrophonePermission() {
    Get.defaultDialog(
      title: "Audio",
      content: const Text(
        "Allow Mowe to access your microphone and audio permissions",
        textAlign: TextAlign.center,
      ),
      confirm: SizedBox(
        height: confirmButtonHeight,
        width: confirmButtonWidth,
        child: Row(
          children: [
            InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Later"),
                )),
            Expanded(child: Container()),
            InkWell(
                onTap: () async {
                  Get.back();
                  await Permission.microphone.request();
                  audioPermissionGranted.value = true;
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Agree"),
                )),
          ],
        ),
      ),
    );
  }

  void getStoragePermission() {
    Get.defaultDialog(
        title: "Storage",
        content: const Text(
          "Mowe need access to your photos, media and files for a better experience",
          textAlign: TextAlign.center,
        ),
        confirm: SizedBox(
          height: confirmButtonHeight,
          width: confirmButtonWidth,
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Later"),
                  )),
              Expanded(child: Container()),
              InkWell(
                  onTap: () async {
                    Get.back();
                    await Permission.storage.request();
                    storagePermissionGranted.value = true;
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Agree"),
                  )),
            ],
          ),
        ));
  }

  // void getLocationPermission() {
  //   Get.defaultDialog(
  //       title: "location",
  //       content: const Text("Mowe uses location data to enable your wallet signup process and for proper app functionality even when the app is closed or not in use", textAlign: TextAlign.center,),
  //       confirm: SizedBox(
  //         height: confirmButtonHeight,
  //         width: confirmButtonWidth,
  //         child: Row(
  //           children: [
  //             InkWell(
  //                 onTap: () {
  //                   Get.back();
  //                 },
  //                 child: const Padding(
  //                   padding: EdgeInsets.all(8.0),
  //                   child: Text("Later"),
  //                 )),
  //             Expanded(child: Container()),
  //             InkWell(
  //                 onTap: () async {
  //                   Get.back();
  //                    await Permission.location.request();
  //                   locationPermissionGranted.value = true;
  //
  //                 },
  //                 child: const Padding(
  //                   padding: EdgeInsets.all(8.0),
  //                   child: Text("Agree"),
  //                 )),
  //           ],
  //         ),
  //       ));
  // }
  void getContactPermission() {
    Get.defaultDialog(
        title: "Contact",
        content: const Text(
          "Allow Mowe to access your contacts",
          textAlign: TextAlign.center,
        ),
        confirm: SizedBox(
          height: confirmButtonHeight,
          width: confirmButtonWidth,
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Later"),
                  )),
              Expanded(child: Container()),
              InkWell(
                  onTap: () async {
                    Get.back();
                    await Permission.contacts.request();
                    contactsPermissionGranted.value = true;
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Agree"),
                  )),
            ],
          ),
        ));
  }

  void getCameraPermission() {
    Get.defaultDialog(
        title: "Camera Access required",
        content: const Text(
          "Allow Mowe to access your camera",
          textAlign: TextAlign.center,
        ),
        confirm: SizedBox(
          height: confirmButtonHeight,
          width: confirmButtonWidth,
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Text("Later")),
              Expanded(child: Container()),
              InkWell(
                  onTap: () async {
                    Get.back();
                    await Permission.camera.request();
                    cameraPermissionGranted.value = true;
                  },
                  child: const Text("Agree")),
            ],
          ),
        ));
  }
}
