import 'package:mooweapp/export_files.dart';

class RoundedInputField extends StatefulWidget {
  final String hintText;
  final String data;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextInputType textInputType;
  const RoundedInputField({
    required Key key,
    required this.hintText,
    this.data = "",
    this.icon = Icons.person,
    required this.onChanged,
    required this.textInputType,
  }) : super(key: key);

  @override
  _RoundedInputFieldState createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.data;
    return TextFieldContainer(
      key: UniqueKey(),
      child: TextFormField(

        textCapitalization: TextCapitalization.words,
        controller: _controller,
        keyboardType: widget.textInputType,
        onChanged: widget.onChanged,
        cursorColor: Colors.white,
        style: themeData!.textTheme.bodyText2!.copyWith(fontSize: Get.width * 0.04, color: Colors.white),
        decoration: InputDecoration(
          fillColor: Colors.white,
          icon: Icon(
            widget.icon,
            color: Colors.white,
          ),
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    super.dispose();
  }
}
