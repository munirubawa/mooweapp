import 'package:mooweapp/export_files.dart';
class ImagePageViewer extends StatefulWidget {
  late PictureMessage pictureMessage;

  ImagePageViewer({
    Key? key,
    required this.pictureMessage,
  }) : super(key: key);

  @override
  _ImagePageViewerState createState() => _ImagePageViewerState();
}

class _ImagePageViewerState extends State<ImagePageViewer> {
  refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
              color: Colors.red,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.pictureMessage.imageUrls!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return imageView(
                      widget.pictureMessage.imageUrls![index].toString(),
                    );
                  },),
            ),)
          ],
        ),
      ),
    );
  }

  Widget imageView(String url) {
    return Container(
      height: Get.height,
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.all(5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,

              image: DecorationImage(
                image: storage.getImage(url),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget imagePage(DocumentSnapshot message, PictureMessage pictureMessage, int index) {
    return GestureDetector(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
        child: SizedBox(
          height: Get.height * 0.7,
          child: Column(
            children: [
              ListTile(
                  leading: CircleAvatar(
                    child: storage.checkImage(message.get(messagePayloadModel.sender)[messageSenderModel.imageUrl].toString())
                        ? Container(
                            width: Get.width * 0.185,
                            height: Get.height * 0.185,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: storage.getImage(message.get(messagePayloadModel.sender)[messageSenderModel.imageUrl]),
                              ),
                            ),
                          )
                        : const Icon(Icons.person),
                  ),
                  title: Text("${message.get(messagePayloadModel.sender)[messageSenderModel.firstName]} ${message.get(messagePayloadModel.sender)!.lastName}"),
                  subtitle: Container(
                    // color: Colors.red,
                    child: Text(
                      DateFormat.jm().format(message.get(messagePayloadModel.time)!.toDate()),
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: Get.height * 0.13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () => print("ListTile")),
              Expanded(
                child: Container(
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: storage.checkImage(pictureMessage.imageUrls![index])
                          ? Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: storage.getImage(
                                      pictureMessage.imageUrls![index],
                                    ),
                                    fit: BoxFit.scaleDown),
                              ),
                            )
                          : Container(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
