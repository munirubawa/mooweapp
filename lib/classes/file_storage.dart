
import 'package:mooweapp/export_files.dart';

import 'message_payload_model.dart';

class Storage extends GetxController {
  static Storage instance = Get.find();

  // RxBool storagePermissionGranted = RxBool(false);
  // RxBool photosPermissionGranted = RxBool(false);
  @override
  void onInit() {
    // checkStoragePermission();
    // checkPhotosPermission();
    super.onInit();
  }
  // Future<void> checkStoragePermission() async {
  //   PermissionStatus status = await Permission.storage.status;
  //   switch (status) {
  //
  //     case PermissionStatus.denied:
  //       storagePermissionGranted.value = false;
  //       break;
  //     case PermissionStatus.granted:
  //       storagePermissionGranted.value = true;
  //       break;
  //     case PermissionStatus.restricted:
  //       storagePermissionGranted.value = false;
  //       break;
  //     case PermissionStatus.limited:
  //       storagePermissionGranted.value = false;
  //       break;
  //     case PermissionStatus.permanentlyDenied:
  //       storagePermissionGranted.value = false;
  //       break;
  //   }
  // }
  // Future<void> checkPhotosPermission() async {
  //   PermissionStatus status = await Permission.photos.status;
  //   switch (status) {
  //
  //     case PermissionStatus.denied:
  //       storagePermissionGranted.value = false;
  //       break;
  //     case PermissionStatus.granted:
  //       storagePermissionGranted.value = true;
  //       break;
  //     case PermissionStatus.restricted:
  //       storagePermissionGranted.value = false;
  //       break;
  //     case PermissionStatus.limited:
  //       storagePermissionGranted.value = false;
  //       break;
  //     case PermissionStatus.permanentlyDenied:
  //       storagePermissionGranted.value = false;
  //       break;
  //   }
  // }
  bool checkImage(String url, {Function()? refresh, bool downloadImage = true}) {
    String appDocPath = appDocDir!.path;
    final path = appDocPath + "/Mowe/$url";
    if (!File(path).existsSync()) {
      if (downloadImage) {
        localPath(url);
      }
    }
    if (refresh != null) {
      refresh();
    }
    return File(path).existsSync();
  }

  bool checkVideoFile(
    String url,
    Function()? refresh,
  ) {
    String appDocPath = appDocDir!.path;

    final path = appDocPath + "/Mowe/$url";

    if (File(path).existsSync()) {
    } else {
      ifNullDownloadImage(url);
    }

    if (refresh != null) {
      refresh();
    }
    return File(path).existsSync();
  }

  Widget networkImage(String? imageUrl, {BoxShape shape = BoxShape.circle, bool blur = false, BoxFit fit = BoxFit
      .fill}) {
    Reference ref = FirebaseStorage.instance.ref().child(imageUrl?? "");
    return FutureBuilder<String>(
      future: ref.getDownloadURL(), // async work
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              color: Colors.white,
            );
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if(snapshot.hasData) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                    shape: shape,
                    image: DecorationImage(image: NetworkImage(snapshot.data!), fit: fit)),
                child: blur
                    ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                )
                    : Container(),
              );
            } else {
              return Container(color: Colors.white,);
            }

        }
      },
    );
  }

  Widget videoNetwork(String? imageUrl, {BoxShape shape = BoxShape.circle, bool blur = false}) {
    Reference ref = FirebaseStorage.instance.ref().child(imageUrl!);
    return FutureBuilder<String>(
      future: ref.getDownloadURL(), // async work
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Container(
                child: const Text("setNetwork player"),
                // child: NetworkPlayerWidget(imageUrl: snapshot.data!,),
              );
            }
        }
      },
    );
  }

  FileImage getImage(
    String? url,
  ) {
    String appDocPath = appDocDir!.path;

    final path = appDocPath + "/Mowe/$url";

    if (File(path).existsSync()) {
    } else {
      ifNullDownloadImage(url!);
    }
    return FileImage(File(path));
  }

  File getVideoFile(
    String? url,
  ) {
    String appDocPath = appDocDir!.path;

    final path = appDocPath + "/Mowe/$url";

    if (File(path).existsSync()) {
    } else {}
    return File(path);
  }

  String imagePath(
    String? url,
  ) {
    String appDocPath = appDocDir!.path;

    final path = appDocPath + "/Mowe/$url";

    if (File(path).existsSync()) {
    } else {
      ifNullDownloadImage(url!);
    }
    return path;
  }

  Future<void> ifNullDownloadImage(String imageUrl, {Function? refresh}) async {
    String appDocPath = appDocDir!.path;
    final path = appDocPath + "/Mowe/$imageUrl";
    Reference ref = FirebaseStorage.instance.ref().child(imageUrl);
    final Directory systemTempDir = Directory.current;
    final File tempFile = File(path);
    if (!tempFile.existsSync()) {
      ref.writeToFile(tempFile).asStream().listen((event) {
        if (refresh != null) {
          refresh();
        }
      });

      // prefs!.setString(imageUrl, tempFile.path);
    }
  }

  Future<bool> localPath(String imageUrl) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (permissionController.storagePermissionGranted.value) {
          directory = await getApplicationDocumentsDirectory();
          String newPath = "";
          print(directory);
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/Mowe";
          directory = Directory(newPath);
        } else {

          return false;
        }
      } else {
        if (permissionController.storagePermissionGranted.value) {
          directory = await getTemporaryDirectory();
        } else {
          // await Permission.photos.request();
          return false;
        }
      }
      File saveFile = File(directory.path + "/$imageUrl");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      if (!saveFile.existsSync()) {
        ifNullDownloadImage(imageUrl);
      }
      if (await directory.exists()) {
        // await dio.download(url, saveFile.path,
        //     onReceiveProgress: (value1, value2) {
        //       setState(() {
        //         progress = value1 / value2;
        //       });
        //     });
        if (Platform.isIOS) {
          // await ImageGallerySaver.saveFile(saveFile.path,
          //     isReturnPathOfIOS: true);
        }
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<DocumentSnapshot<Object?>> downloadImages(DocumentSnapshot message) async {
    PictureMessage pictureMessage = PictureMessage.fromMap(message.get(messagePayloadModel.messages)[0]);
    for (var url in pictureMessage.imageUrls!) {
      localPath(url);
    }
    return message;
  }
}
