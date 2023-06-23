import 'package:mooweapp/export_files.dart';
class CustomText extends StatelessWidget {
  final String? text;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  
  // name constructor that has a positional parameters with the text required
  // and the other parameters optional
  const CustomText({@required this.text, this.size,this.color,this.weight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text!, textAlign: TextAlign.center,style: TextStyle(fontSize: size ?? 16, color: color ?? Colors.black, fontWeight:
    weight
        ??
        FontWeight
        .normal),
    );
  }
}