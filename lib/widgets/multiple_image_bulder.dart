import 'package:mooweapp/export_files.dart';

class MultipleImagesScreen extends StatelessWidget {
  DocumentSnapshot? message;
   MultipleImagesScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<DocumentSnapshot>(
      future: storage.downloadImages(message!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Text("${snapshot.error}"),
          );
        }
        if (snapshot.hasData) {
          PictureMessage images = PictureMessage.fromMap(message!.get(messagePayloadModel.messages)[0]);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // height:  SizeConfig.heightMultiplier! * 40,
              padding: chatServices.localMember!.get(memberModel.userUID) == message!.get(messagePayloadModel.sender)[messageSenderModel.userUID]
                  ? EdgeInsets.only(left: Get.width * 0.3)
                  : EdgeInsets.only(right: Get.width * 0.3),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(3),
                        gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: images.imageUrls!.length,
                        itemBuilder: (context, index) {

                          // print(storage.imagePath(
                          //   images.imageUrls![index],
                          // ));
                          return InkWell(
                            onTap: (){
                              Get.to(()=> ChatPhotoViewer(images: images, tabIndex: index,), routeName: "ImageString");
                            },
                            child: storage.checkImage(
                              images.imageUrls![index],
                            )? ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: storage.getImage(
                                        images.imageUrls![index],
                                      ),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ): ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                              child: storage.networkImage(
                                  images.imageUrls![index], shape: BoxShape.rectangle, fit: BoxFit.cover
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Positioned(
                  //   child: Text(
                  //     "+${images.imageUrls!.length < 4 ? (images.imageUrls!.length - 2) : (images.imageUrls!.length - 4)}",
                  //     style: themeData!.textTheme.headline2!.copyWith(color: Colors.white),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
