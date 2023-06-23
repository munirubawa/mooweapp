import 'package:mooweapp/export_files.dart';
class FilePlayerWidget extends StatefulWidget {
   final File? file;
  const FilePlayerWidget({Key? key, required this.file}): super(key: key);
  @override
  _FilePlayerWidgetState createState() => _FilePlayerWidgetState();
}

class _FilePlayerWidgetState extends State<FilePlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  // final File file = File(
  //     '/data/user/0/com.example.video_example/cache/file_picker/big_buck_bunny_720p_10mb.mp4');

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file!)..addListener(() => setState(() {}));

    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            Expanded(child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: VideoPlayerWidget(controller: _controller,),
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),),
            // buildAddButton(),
          ],
        ),
      );

  Widget buildAddButton() => Container(
        padding: const EdgeInsets.all(32),
        child: FloatingActionButtonWidget(
          onPressed: () async {
            final file = await pickVideoFile();
            if (file == null) return;

            _controller = VideoPlayerController.file(file)
              ..addListener(() => setState(() {}))
              ..setLooping(true)
              ..initialize().then((_) {
                _controller.play();
                setState(() {});
              });
          },
        ),
      );

  Future<File?> pickVideoFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result == null) return null;

    return File(result.files.single.path.toString());
  }
}


class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Butterfly Video'),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(_controller),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
