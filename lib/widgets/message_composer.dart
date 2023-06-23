import 'package:mooweapp/export_files.dart';
class MessageComposer extends StatefulWidget {
  final ChatRoom? chatRoom;
  final Function()? chatScreenRefresh;
  final Function()? sendMedia;
  const MessageComposer({Key? key, this.chatRoom, required this.chatScreenRefresh, required this.sendMedia}) : super(key: key);

  @override
  _MessageComposerState createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  late FocusNode myFocusNode;
  late FocusNode rowKeyFocusNode = FocusNode();

  final FocusNode rawKbFocusNode = FocusNode();
  final FocusNode textFocusNode = FocusNode();
  bool readonley = false;
  double bottomPadding = 25;
  bool shoHelperTextFeild = false;
  bool showButtons = false;
  String rawText = "";
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      myFocusNode.hasFocus ? bottomPadding = 0 : runSystemOverlay();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    rowKeyFocusNode.dispose();
    super.dispose();
  }

  void addToTextController(String value) {
    chatScreenTextController.text = chatScreenTextController.text + value;
  }

  List<LogicalKeyboardKey> keys = [];
  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        final key = event.logicalKey;

        if(event is RawKeyDownEvent) {
          if(keys.contains(key)) return;
          keys.add(key);

          if(keys.contains(LogicalKeyboardKey.controlLeft) || keys.contains(LogicalKeyboardKey.controlRight) &&
          keys.contains(LogicalKeyboardKey.enter)){
            sendMessage();
          }

        } else {
          keys.remove(key);
        }
        // if (event is RawKeyDownEvent) {
        //   keys.add(key);
        //   print("evenetkeyspressed");
        //   print(key);
        //   print(keys);
        //   print(keys.contains(LogicalKeyboardKey.enter));
        //   if (keys.contains(LogicalKeyboardKey.control) && keys.contains(LogicalKeyboardKey.enter)) {
        //     sendMessage();
        //   }
        // }
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    myFocusNode.requestFocus();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    padding: const EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [BoxShadow(offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: themeData!.textTheme.bodyText1,
                            onChanged: (String value) {},
                            onSubmitted: (String value) {
                              print("On submit button");
                              print(value);
                            },
                            readOnly: readonley,
                            controller: chatScreenTextController,
                            focusNode: myFocusNode,
                            keyboardType: TextInputType.multiline,
                            maxLines: 12,
                            minLines: 1,
                            // maxLines: maxLinesTextField,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration.collapsed(
                              hintText: readonley ? 'You can not send message this this user' : 'Type a message',
                            ),
                          ),
                        ),
                        IconButton(
                          color: Colors.red,
                          icon: const Icon(Icons.add_a_photo_outlined),
                          onPressed: () async {
                            if (await Permission.camera.status.isGranted) {
                              myFocusNode.unfocus();
                              widget.chatScreenRefresh!();
                              // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                            } else {
                              await Permission.camera.request();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(right: 5.0),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: InkWell(
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onTap: sendMessage,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void sendMessage() {
    box.write("${widget.chatRoom!.reference!.id}messageCount", widget.chatRoom!.messageCount! + 1);
    switch (enumServices.chatScreenSendActionType) {
      case ChatScreenSendActionType.SEND_MEDIA:
        // TODO: Handle this case.
        widget.sendMedia!();
        break;
      case ChatScreenSendActionType.SEND_TEXT_MESSAGE:
        if (chatScreenTextController.text.isNotEmpty) {
          Map<String, dynamic> messagePayload = {
            messagePayloadModel.chatRoomChatsCollection: widget.chatRoom!.chatRoomChatsCollection,
            messagePayloadModel.time: Timestamp.now(),
            messagePayloadModel.sender: chatServices.sender,
            messagePayloadModel.messageType: EnumToString.convertToString(ChatMessageType.MESSAGE),
            messagePayloadModel.messageGroupType: widget.chatRoom!.chatType!,
            messagePayloadModel.messages: [
              TextMessage(
                time: Timestamp.now(),
                text: chatScreenTextController.text,
                read: false,
                senderID: chatServices.localMember!.get(memberModel.userUID),
              ).toMap(),
            ],
          };
          chatServices.sendToChatRoom = true;
          chatServices.textMessage =
              TextMessage(time: Timestamp.now(), text: "${chatServices.sender[messageSenderModel.firstName]}: ${chatScreenTextController.text}", read: false, senderID: chatServices.localMember!.get
                (memberModel.userUID));
          if (chatServices.currentMessage != null &&
              chatServices.currentMessage![messagePayloadModel.sender][messageSenderModel.userUID] == chatServices.localMember!.get(memberModel.userUID) &&
              chatServices.currentMessage![messagePayloadModel.messageType] == ChatMessageType.MESSAGE) {
            chatServices.currentMessage!.reference.set({
              "messages": FieldValue.arrayUnion([TextMessage(time: Timestamp.now(), text: chatScreenTextController.text, read: false, senderID: chatServices.localMember!.get(memberModel.userUID)).toMap()]),
            }, SetOptions(merge: true));
            widget.chatRoom!.reference!.set({
              "senderName": "${chatServices.sender[messageSenderModel.firstName]} ${chatServices.sender[messageSenderModel.lastName]}",
              "message": TextMessage(time: Timestamp.now(), text: "${chatServices.sender[messageSenderModel.firstName]}: ${chatScreenTextController.text}", read: false, senderID: chatServices
                  .localMember!.get(memberModel.userUID))
                  .toMap(),
              "messageCount": FieldValue.increment(1),
            }, SetOptions(merge: true));
            // chatRoomController.updateMessageCount(chatRoom: widget.chatRoom!);

            sendNotification(chatScreenTextController.text);
          } else {
            enumServices.chatServicesActions = ChatServicesActions.SEND_MESSAGE;
            chatServices.messagePayload = messagePayload;
            chatServices.messagePayload[messagePayloadModel.messageGroupType] = EnumToString.convertToString(widget.chatRoom!.chatType);
            chatServices.sendToChatRoom = true;
            chatServices.chatRoom = widget.chatRoom;
            chatServices.runChatServices();
          }
          chatScreenTextController.clear();
        }
        break;
    }
  }

  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList;
  int? imageIndex;
  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  void sendNotification(String message) {
    switch (widget.chatRoom!.chatType!) {
      case ChatTypes.PRIVATE_CHAT:
        // TODO: Handle this case.
        String token = widget.chatRoom!.members!.firstWhere((element) => element != chatServices.localMember!.get(memberModel.contactPath));
        AssistantMethods.sendANotification(
          title: "${chatServices.localMember!.get(memberModel.firstName)} ${chatServices.localMember!.get(memberModel.firstName)}",
          body: message,
          token: chatRoomController.tokens[token],
          notificationType: EnumToString.convertToString(NotificationDataType.CHAT_DATA),
          notificationDocPath: widget.chatRoom!.reference!.path,
        );
        break;
      case ChatTypes.STORE_CHAT:
      case ChatTypes.BUSINESS_CHAT:
      case ChatTypes.PROJECT_CHAT:
      case ChatTypes.FUND_RAISE:
      case ChatTypes.SUSU:
      case ChatTypes.GROUP_CHAT:
        // TODO: Handle this case.
        for (var element in widget.chatRoom!.members!) {
          AssistantMethods.sendANotification(
            title: "${widget.chatRoom!.groupName}",
            body: "${chatServices.localMember!.get(memberModel.firstName)}: $message",
            token: box.read("${element}deviceToken"),
            notificationType: EnumToString.convertToString(NotificationDataType.CHAT_DATA),
            notificationDocPath: widget.chatRoom!.reference!.path,
          );
        }
        break;
    }
  }
}
