import 'package:mooweapp/export_files.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    required Key key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
