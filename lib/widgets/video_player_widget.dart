import 'package:mooweapp/export_files.dart';
class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoPlayerWidget({
     Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      controller.value.isInitialized
          ? Container(
          alignment: Alignment.topCenter, child: buildVideo())
          : const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );

  Widget buildVideo() => Stack(
        children: <Widget>[

          Positioned.fill(child: buildVideoPlayer(),),
          Positioned.fill(child: BasicOverlayWidget(controller: controller)),
        ],
      );

  Widget buildVideoPlayer() => AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: VideoPlayer(controller),
      );
}

class NetworkVideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;

  const NetworkVideoPlayerWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      controller.value.isInitialized
          ? Container(
          alignment: Alignment.topCenter, child: buildVideo())
          : const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );

  Widget buildVideo() => Stack(
    children: <Widget>[

      Positioned.fill(child: buildVideoPlayer(),),
      Positioned.fill( child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
        ),
      )),
      Positioned.fill(child: IconButton(
        onPressed: (){
          print("dowlinage vdeo");
        },
        icon: const Icon(Icons.download, color: Colors.white,),
      )),
    ],
  );

  Widget buildVideoPlayer() => AspectRatio(
    aspectRatio: controller.value.aspectRatio,
    child: VideoPlayer(controller),
  );
}
