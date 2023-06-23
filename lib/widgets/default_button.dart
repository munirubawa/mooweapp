import 'package:mooweapp/export_files.dart';

class DefaultButton extends StatelessWidget {
  double? height;
  double? width;
  Color? color;
  DefaultButton({
    Key? key,
    this.text,
    this.press,
    this.height = 55,
    this.width = 200,
    this.color = kPrimaryColor,
  }) : super(key: key);
  final String? text;
  final Function()? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor, //background color
        ),
        onPressed: press,
        child: Text(
          text!,
          style: TextStyle(
            fontSize: Get.width * 0.04888,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
