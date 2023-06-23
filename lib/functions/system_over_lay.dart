import 'package:mooweapp/export_files.dart';
runSystemOverlay() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // systemNavigationBarContrastEnforced: true,
    // statusBarColor: kPrimaryColor,
    // systemNavigationBarColor: kPrimaryColor,
    // statusBarIconBrightness: Brightness.light,
  ));
}


// SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: Colors.white,
//       statusBarIconBrightness: Brightness.dark,
//       systemNavigationBarColor: Colors.white,
//       systemNavigationBarIconBrightness: Brightness.dark,
//     ));

