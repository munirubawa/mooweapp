import 'package:mooweapp/export_files.dart';
showToastMessage({required String? msg, Color backgroundColor = Colors.red, Color textColor = Colors.white, int timeInSecForIosWeb = 1, double fontSize = 16.0}) {
  Get.defaultDialog(
      barrierDismissible: false,
      title: "",
      content: Text(msg!, textAlign: TextAlign.center,),
      confirm: InkWell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Text("Okay"),
            )
          ],
        ),
        onTap: () {
          Get.back();
        },
      ));
}