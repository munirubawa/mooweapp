import 'package:mooweapp/export_files.dart';
showLoading({String message = "Loading..."}){
  Get.defaultDialog(
      title: message,
      content: const CircularProgressIndicator(),
      barrierDismissible: false
  );
}

dismissLoadingWidget(){
  Get.back();
}