import 'package:mooweapp/export_files.dart';
class FloatingActionButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingActionButtonWidget({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        child: const Icon(Icons.add, size: 32),
        onPressed: onPressed,
        backgroundColor: Colors.purple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );
}
