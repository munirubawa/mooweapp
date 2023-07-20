
import 'package:mooweapp/export_files.dart';

Widget android_ios_number_display(Phone contact){
  return Text(Platform.isIOS? contact.number : contact.normalizedNumber,
    style: themeData!.textTheme.titleMedium,
  );
}