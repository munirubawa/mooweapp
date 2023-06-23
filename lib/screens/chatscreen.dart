import 'package:mooweapp/export_files.dart';
class ChatScreen extends StatefulWidget {
  ChatRoom? chatRoom;
  final UserChatRoom? userChatRoom;

  ChatScreen({required this.chatRoom, required this.userChatRoom});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool showOptionToSaveCantact = false;
  bool showMediaActionButtons = false;
  Widget groupHeader = Container();
  bool selectedFiles = false;
  List<XFile>? _imageFileList;
  bool isVideo = false;
  bool sendPress = false;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatServices.currentMessage = null;
  }

  @override
  void dispose() {
    // _disposeVideoController();

    super.dispose();
  }

  chatScreenRefresh() {
    setState(() {
      showMediaActionButtons = !showMediaActionButtons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<DocumentSnapshot>>(
                  stream:
                      FirebaseFirestore.instance.collection(widget.chatRoom!.chatRoomChatsCollection!).orderBy("time", descending: true).snapshots().map((event) => event.docs.map((e) => e).toList()),
                  builder: (BuildContext context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    if (snapshot.hasError) {
                      return Container(
                        child: Text("${snapshot.error}"),
                      );
                    }
                    List<DocumentSnapshot>? chatMessages = snapshot.data;
                    return Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          // colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
                          image: AssetImage("assets/whatsappchatbackground.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.builder(
                        reverse: true,
                        itemCount: chatMessages!.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot messagePayload = chatMessages[index];
                          enumServices.chatMessageType = EnumToString.fromString(ChatMessageType.values, messagePayload[messagePayloadModel.messageType]);
                          chatServices.currentMessage = chatMessages[0];
                          int count = box.read("${widget.chatRoom!.reference!.id}messageCount");
                          if (count < widget.chatRoom!.messageCount!) {
                            box.write("${widget.chatRoom!.reference!.id}messageCount", widget.chatRoom!.messageCount!);
                          }
                          return Column(children: [
                            MessageLogicBuilder(message: messagePayload, chatRoom: widget.chatRoom)]);
                        },
                      ),
                    );
                  },
                ),
              ),
              Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      // colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
                      image: AssetImage("assets/whatsappchatbackground.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: MessageComposer(
                    chatRoom: widget.chatRoom,
                    chatScreenRefresh: chatScreenRefresh,
                    sendMedia: sendMedia,
                  )),
            ],
          ),
        ),
        selectedFiles ? Positioned(bottom: 50, right: 60, width: Get.width * 0.1, child: displaySelectedFiles()) : Container(),
        showMediaActionButtons
            ? Positioned(
                bottom: 50,
                right: 20,
                child: MediaTypeButtons(processImagePicker: processImagePicker),
              )
            : Container(),
      ],
    );
  }

  final ImagePicker _picker = ImagePicker();

  processImagePicker() async {
    switch (enumServices.mediaTypeAction) {
      case MediaTypeAction.IMAGE:
        // TODO: Handle this case.
        chatScreenRefresh();
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

        setSelectedFileToTrueIfFileIsNotNull([image!]);

        break;
      case MediaTypeAction.MULTIPLE_IMAGES:
        // TODO: Handle this case.
        final List<XFile>? images = await _picker.pickMultiImage();
        setSelectedFileToTrueIfFileIsNotNull(images);
        break;
      case MediaTypeAction.TAKE_A_PHOTO:
        // TODO: Handle this case.
        final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
        setSelectedFileToTrueIfFileIsNotNull([photo!]);
        break;
      case MediaTypeAction.PICK_VIDEO_FROM_GALLERY:
        // TODO: Handle this case.
        final XFile? image = await _picker.pickVideo(source: ImageSource.gallery, maxDuration: const Duration(seconds: 10));
        break;
      case MediaTypeAction.TAKE_VIDEO:
        // TODO: Handle this case.
        final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
        setSelectedFileToTrueIfFileIsNotNull([video!]);
        break;
      default:
        break;
    }
  }

  Widget displaySelectedFiles() {
    switch (enumServices.mediaTypeAction!) {
      case MediaTypeAction.IMAGE:
      case MediaTypeAction.MULTIPLE_IMAGES:
      case MediaTypeAction.TAKE_A_PHOTO:
        // TODO: Handle this case.
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 99,
              decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  )),
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _imageFileList!.length,
                      itemBuilder: (BuildContext context, int index) => Stack(
                        children: [
                          Card(
                            // color: Colors.red,
                            child: Center(
                                child: Container(
                              height: 100.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  // shape: BoxShape.circle,
                                  image: DecorationImage(image: FileImage(File(_imageFileList![index].path.toString())), fit: BoxFit.cover)),
                            )),
                          ),
                          Positioned(
                              child: IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              var delete = _imageFileList as List;
                              setState(() {
                                if (_imageFileList!.length == 1) {
                                  selectedFiles = false;
                                  enumServices.chatScreenSendActionType = ChatScreenSendActionType.SEND_TEXT_MESSAGE;
                                }
                                delete.removeAt(index);
                              });
                            },
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            sendPress ? const LinearProgressIndicator() : Container(),
          ],
        );
      case MediaTypeAction.PICK_VIDEO_FROM_GALLERY:

      case MediaTypeAction.TAKE_VIDEO:
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 99,
              decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  )),
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 100.0,
                          width: 100.0,
                          // child: BetterPlayer.file(_imageFileList!.first.path,
                          // betterPlayerConfiguration: BetterPlayerConfiguration(
                          //   autoPlay: false,
                          //   fit: BoxFit.cover,
                          //   aspectRatio: 1
                          // ),),
                          child: FutureBuilder(
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
                        ),
                        Positioned(
                            child: IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            var delete = _imageFileList as List;
                            setState(() {
                              if (_imageFileList!.length == 1) {
                                selectedFiles = false;

                                _controller.dispose();
                                enumServices.chatScreenSendActionType = ChatScreenSendActionType.SEND_TEXT_MESSAGE;
                              }
                              // delete.removeAt(delete.first);
                            });
                          },
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            sendPress ? const LinearProgressIndicator() : Container(),
          ],
        );
    }
  }

  setSelectedFileToTrueIfFileIsNotNull(List<XFile>? images) async {
    print("image!.path");
    if (images != null) {
      enumServices.chatScreenSendActionType = ChatScreenSendActionType.SEND_MEDIA;
      selectedFiles = true;
      showMediaActionButtons = false;
      setState(() {
        _imageFileList = images;
      });
      if (isVideo) {
        setState(() {
          for (var element in images) {
            print("element.path");
          }
        });
      }
    } else {
      selectedFiles = false;
      setState(() {});
    }
  }

  sendMedia() {
    List<dynamic> _imageUrls = [];
    setState(() {
      sendPress = true;
    });
    for (var file in _imageFileList!) {
      // print(file.path);
      FirebaseStorageService().uploadMessageImage(file: File(file.path)).then((url) {
        _imageUrls.add(url);

        Map<String, dynamic> messagePayload = {
          messagePayloadModel.chatRoomChatsCollection: widget.chatRoom!.chatRoomChatsCollection,
          messagePayloadModel.time: Timestamp.now(),
          messagePayloadModel.sender: chatServices.sender,
          messagePayloadModel.messageType: EnumToString.convertToString(chatMessageType()),
          messagePayloadModel.messageGroupType: EnumToString.convertToString(widget.chatRoom!.chatType!),
          messagePayloadModel.messages: [fileMessage(_imageUrls)],
        };
        chatServices.textMessage =
            TextMessage(time: Timestamp.now(), text: "${chatServices.sender[messageSenderModel.firstName]}: image", read: false, senderID: chatServices.localMember!.get(memberModel.userUID));
        // chat!.chatRoom!.reference!.set({"currentBeneficiary": widget.member!.userUID!}, SetOptions(merge: true));

        if (_imageFileList!.length == _imageUrls.length) {
          chatServices.messagePayload = messagePayload;
          enumServices.chatServicesActions = ChatServicesActions.SEND_MESSAGE;
          chatServices.chatRoom = widget.chatRoom!;
          chatServices.runChatServices();
          // Navigator.of(context).pop();
          _imageUrls.clear();
          chatScreenTextController.clear();
          setState(() {
            sendPress = false;
            enumServices.chatScreenSendActionType = ChatScreenSendActionType.SEND_TEXT_MESSAGE;
            _imageFileList!.clear();
            selectedFiles = false;
            showMediaActionButtons = false;
          });
        }
      });
    }
    // isVideo = true;
    // _onImageButtonPressed(ImageSource.camera);
  }

  Map<String, dynamic> fileMessage(List<dynamic> _imageUrls) {
    switch (enumServices.mediaTypeAction!) {
      case MediaTypeAction.IMAGE:
        // TODO: Handle this case.
        return PictureMessage(imageUrls: _imageUrls, text: chatScreenTextController.text.isNotEmpty ? chatScreenTextController.text : "", time: Timestamp.now()).toMap();
      case MediaTypeAction.MULTIPLE_IMAGES:
        // TODO: Handle this case.
        return PictureMessage(imageUrls: _imageUrls, text: chatScreenTextController.text.isNotEmpty ? chatScreenTextController.text : "", time: Timestamp.now()).toMap();
      case MediaTypeAction.TAKE_A_PHOTO:
        // TODO: Handle this case.
        return PictureMessage(imageUrls: _imageUrls, text: chatScreenTextController.text.isNotEmpty ? chatScreenTextController.text : "", time: Timestamp.now()).toMap();
      case MediaTypeAction.PICK_VIDEO_FROM_GALLERY:
        // TODO: Handle this case.
        return VideoMessage(imageUrls: _imageUrls, text: chatScreenTextController.text.isNotEmpty ? chatScreenTextController.text : "", time: Timestamp.now()).toMap();
      case MediaTypeAction.TAKE_VIDEO:
        // TODO: Handle this case.
        return VideoMessage(imageUrls: _imageUrls, text: chatScreenTextController.text.isNotEmpty ? chatScreenTextController.text : "", time: Timestamp.now()).toMap();
    }
  }

  ChatMessageType chatMessageType() {
    switch (enumServices.mediaTypeAction!) {
      case MediaTypeAction.IMAGE:
        // TODO: Handle this case.
        return ChatMessageType.IMAGE;
      case MediaTypeAction.MULTIPLE_IMAGES:
        // TODO: Handle this case.
        return ChatMessageType.MULTIPLE_IMAGES;
      case MediaTypeAction.TAKE_A_PHOTO:
        // TODO: Handle this case.
        return ChatMessageType.IMAGE;
      case MediaTypeAction.PICK_VIDEO_FROM_GALLERY:
        // TODO: Handle this case.
        return ChatMessageType.VIDEO_FILE;
      case MediaTypeAction.TAKE_VIDEO:
        // TODO: Handle this case.
        return ChatMessageType.VIDEO_FILE;
    }
  }

//TODO video iimplimentation
// List<XFile>? _imageFileList;

}

class DecodeParam {
  final File file;
  final SendPort sendPort;

  DecodeParam(this.file, this.sendPort);
}

void decodeIsolate(DecodeParam param) {
  // Read an image from file (webp in this case).
  // decodeImage will identify the format of the image and use the appropriate
  // decoder.
  // var image = decodeImage(param.file.readAsBytesSync())!;
  // // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
  // var thumbnail = copyResize(image, width: 120);
  // param.sendPort.send(thumbnail);
}
