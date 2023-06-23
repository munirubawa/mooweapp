import 'package:mooweapp/export_files.dart';
class MediaTypeButtons extends StatefulWidget {
  bool? isVideo;
  ChatRoom? chatRoom;
  List<XFile>? imageFileList;

  // bool? isMultiImage = false;
  void Function()? processImagePicker;
  MediaTypeButtons({
    Key? key,
    required this.processImagePicker,
  }) : super(key: key);

  @override
  _MediaTypeButtonsState createState() => _MediaTypeButtonsState();
}

class _MediaTypeButtonsState extends State<MediaTypeButtons> {
  // var service = locator.get<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Semantics(
          label: '${DateTime.now().microsecond}',
          child: FloatingActionButton(
            backgroundColor: Colors.red,
            mini: true,
            onPressed: () {
              widget.isVideo = false;
              enumServices.mediaTypeAction = MediaTypeAction.IMAGE;
              widget.processImagePicker!();
            },
            heroTag: '${DateTime.now().microsecondsSinceEpoch}',
            tooltip: 'Pick Image from gallery',
            child: const Icon(
              Icons.photo,
              size: 25,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.red,
            onPressed: () {
              widget.isVideo = false;
              enumServices.mediaTypeAction = MediaTypeAction.MULTIPLE_IMAGES;
              widget.processImagePicker!();
            },
            heroTag: 'image1',
            tooltip: 'Pick Multiple Image from gallery',
            child: const Icon(Icons.photo_library),
          ),
        ),
      ],
    );
  }
}
