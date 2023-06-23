import 'package:mooweapp/export_files.dart';
class VideoMessageDisplay extends StatefulWidget {
  DocumentSnapshot? message;
  VideoMessageDisplay({Key? key, this.message}) : super(key: key);

  @override
  State<VideoMessageDisplay> createState() => _VideoMessageDisplayState();
}

class _VideoMessageDisplayState extends State<VideoMessageDisplay> {
   VideoPlayerController? controller;
  bool _isDownloading = false;
  @override
  Widget build(BuildContext context) {
   var video = VideoMessage.fromMap(widget.message!.get(messagePayloadModel.messages)[0]);
   // controller = storage.file(video.imageUrls![0]) !=null? VideoPlayerController.file(storage.file(video
   //     .imageUrls![0])!) : null;
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
             child: storage.checkVideoFile(video.imageUrls!.first, (){setState(() {});})
                 ? Container(
               color: Colors.white,
               // child: Container(),
               child:Platform.isIOS?  FilePlayerWidget(file: storage.getVideoFile(video.imageUrls!.first),): Container(
                 color: Colors.white,
               ),
             )
                 : Stack(
               alignment: Alignment.center,
               children: [
                 Container(
                   color: Colors.red,
                   height: Get.height * 0.4,
                   child: storage.videoNetwork(video.imageUrls!.first,
                     shape: BoxShape.rectangle,
                     blur: true,),
                 ),
                 IconButton(
                   onPressed: () {
                     setState(() {
                       _isDownloading = !_isDownloading;
                       // storage.ifNullDownloadImage(video.imageUrls!.first, refresh: (){setState(() {
                       //
                       // });});
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
  }
}