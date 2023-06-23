import 'package:mooweapp/export_files.dart';
class CustomBtn extends StatelessWidget {
  final String? text;
  final Color? txtColor;
  final Color? bgColor;
  final Color? shadowColor;
  final Function()? onTap;

  const CustomBtn(
      {Key? key,
      @required this.text,
      this.txtColor,
      this.bgColor,
      this.shadowColor,
      @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: bgColor ?? Colors.black,
            boxShadow: [
              BoxShadow(
                  color: shadowColor == null
                      ? Colors.grey.withOpacity(0.5)
                      : shadowColor!.withOpacity(0.5),
                  offset: const Offset(2, 3),
                  blurRadius: 4)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: CustomText(
            text: text!,
            color: txtColor ?? Colors.white,
            size: 22,
            weight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class CustomBtn2 extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color? txtColor;
  final Color? bgColor;
  final Color? shadowColor;
  final Function()? onTap;

  const CustomBtn2(
      {Key? key,
        this.text,
        this.txtColor,
        this.child,
        this.bgColor,
        this.shadowColor,
        @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: bgColor ?? Colors.black,
            boxShadow: [
              BoxShadow(
                  color: shadowColor == null
                      ? Colors.grey.withOpacity(0.5)
                      : shadowColor!.withOpacity(0.5),
                  offset: const Offset(2, 3),
                  blurRadius: 4)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: child?? Text(
            text!,
            style: themeData!.textTheme.bodyText1!.copyWith(color: txtColor?? Colors.white),
          ),
        ),
      ),
    );
  }
}
class CustomBtn3 extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color? txtColor;
  final Color? bgColor;
  final Color? shadowColor;
  final Function()? onTap;

  const CustomBtn3(
      {Key? key,
        this.text,
        this.txtColor,
        this.child,
        this.bgColor,
        this.shadowColor,
        @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: bgColor ?? Colors.black,
            boxShadow: [
              BoxShadow(
                  color: shadowColor == null
                      ? Colors.grey.withOpacity(0.2)
                      : shadowColor!.withOpacity(0.2),
                  offset: const Offset(2, 1),
                  blurRadius: 4)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: child?? Text(
            text!,
            style: themeData!.textTheme.bodyText1!.copyWith(color: txtColor?? Colors.white),
          ),
        ),
      ),
    );
  }
}