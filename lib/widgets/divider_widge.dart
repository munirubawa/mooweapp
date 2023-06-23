import 'package:mooweapp/export_files.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1.0,
      thickness: 1.0,
      color: kPrimaryColor,
    );
  }
}
