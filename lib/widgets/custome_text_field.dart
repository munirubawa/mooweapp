import 'package:mooweapp/export_files.dart';

Widget formFiled(
    {Widget icon = const Icon(Icons.person, color: Colors.grey),
      String? labelText = "labelText",
      String? hintText = "hintText",
      String initialValue = "",
      String? validateString = "Please enter a valid name",
      TextEditingController? controller,
      TextInputType keyboardType = TextInputType.name,
      TextCapitalization textCapitalization = TextCapitalization.sentences,
      Function(String? value)? onChange,  bool auto = true,}) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: TextFormField(
          initialValue: initialValue,
          style: themeData!.textTheme.bodyLarge,
          autofocus: auto,
          // controller: controller,
          onChanged: onChange,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          validator: (v) {
            if (v.toString().trim().isNotEmpty) {
              return null;
            } else {
              return validateString;
            }
          },
          // controller: authProvider.email,
          decoration: InputDecoration(
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            labelStyle: const TextStyle(color: Colors.grey),
            labelText: labelText,
            hintText: hintText,
            icon: icon,
          ),
        ),
      ),
    ),
  );
}