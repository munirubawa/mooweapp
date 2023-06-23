import 'package:mooweapp/export_files.dart';

class ImageDisplayBuilder extends StatefulWidget {
  DocumentSnapshot? message;
  ChatRoom? chatRoom;

  // List<Message>? mediaMessage;
  ImageDisplayBuilder({
    Key? key,
    required this.message,
    required this.chatRoom,
  }) : super(key: key);

  @override
  State<ImageDisplayBuilder> createState() => _ImageDisplayBuilderState();
}

class _ImageDisplayBuilderState extends State<ImageDisplayBuilder> {
  bool _isDownloadking = false;

  @override
  Widget build(BuildContext context) {
    PictureMessage pictureMessage = PictureMessage.fromMap(widget.message!.get(messagePayloadModel.messages)[0]);
    switch (pictureMessage.imageUrls!.length) {
      case 1:
        return Row(
          mainAxisAlignment: chatServices.localMember!.get(memberModel.userUID) == widget.message!.get(messagePayloadModel.sender)[messageSenderModel.userUID]
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              width: Get.width * 0.6,
              height: Get.height * 0.4,
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
              margin: const EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: storage.checkImage(pictureMessage.imageUrls!.first, refresh: (){setState(() {

                  });}, downloadImage: false)
                      ? GestureDetector(
                    onTap: (){
                      Get.to(()=> ImagePageViewer( pictureMessage: pictureMessage,));
                    },
                        child: Container(
                    decoration: BoxDecoration(
                        // color: Colors.orange,
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: storage.getImage(pictureMessage.imageUrls!.first), fit: BoxFit.cover, ),
                    ),
                  ),
                      )
                      : Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: Get.height * 0.4,
                        child: storage.networkImage(pictureMessage.imageUrls!.first,
                          shape: BoxShape.rectangle,
                          blur: true,),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isDownloadking = !_isDownloadking;
                            storage.ifNullDownloadImage(pictureMessage.imageUrls!.first, refresh: (){setState(() {

                            });});
                          });
                        },
                        icon: const Icon(
                          Icons.download,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      case 2:
        return Container();
      case 7:
        return Container();
      default:
      return Container();
    }
  }

  Widget futurePrevImageBuilder(PictureMessage message, int index) {
    return Container(
      decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(10))),
      margin: const EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: storage.getImage(
                    message.imageUrls![index],
                  ),
                  fit: BoxFit.fill),
            ),
          ),
        ),
      ),
    );
  }
}
