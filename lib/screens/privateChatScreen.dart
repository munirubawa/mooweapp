import 'package:mooweapp/export_files.dart';

enum MakeCallOptions { call, video }

class PrivateChatScreen extends StatefulWidget {
  final ChatRoom? chatRoom;
  final UserChatRoom? userChatRoom;
  const PrivateChatScreen({required this.chatRoom, required this.userChatRoom});

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  bool showCallButton = false;
  @override
  void initState() {
    addPaymentMethodController.initializePaymentMethod();
    super.initState();

    ///whatever you want to run on page build
  }

  @override
  Widget build(BuildContext context) {
    String contactPath = widget.chatRoom!.members!.firstWhere((element) => element != dbHelper.user());

    DocumentSnapshot mem = chatRoomController.membersByContactPath.value[contactPath]!;
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
        // backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            if (navController.callStatus.value == CallActionStatus.CALL_START) {
              navController.pipPage = const MyHomeScreen();
              navController.smallScreen();
            } else {
              Get.back();
            }
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            // color: keepPrimaryColor? Colors.white: Colors.black,
          ),
        ),
        // backgroundColor: kPrimaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mem.get(memberModel.hasAStore)!
                        ? GestureDetector(
                            onTap: () {
                              Get.put(StoreController());
                              // debugPrint(mem.storePath);
                              if (mem.get(memberModel.hasAStore)!) {
                                storeController.getStoreFromDatabase(mem.get(memberModel.storePath).toString());
                              }
                              userProfileController.chatRoom = widget.chatRoom;
                              userProfileController.member = mem;
                              showBarModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  color: Colors.white,
                                  child: ShowUserProfileOptions(),
                                ),
                              );
                              // Get.to(() => ShowUserProfileOptions(
                              //   member: mem,
                              // ));
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CircleAvatar(
                                    radius: 15,
                                    child: avatar(mem.get(memberModel.imageUrl).toString()),
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.35,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.store,
                                            color: Colors.white,
                                            size: 15.0,
                                          ),
                                          Expanded(
                                              child: Text(
                                            "${mem.get(memberModel.firstName).toString().capitalize!} "
                                            "${mem.get(memberModel.lastName).toString().capitalize!}",
                                            overflow: TextOverflow.fade,
                                            style: themeData!.textTheme.bodyText1!.copyWith(color: Colors.white),
                                          )),
                                        ],
                                      ),
                                      lastSeenOrActive(mem),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              userProfileController.chatRoom = widget.chatRoom!;
                              userProfileController.member = mem;
                              showBarModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  color: Colors.white,
                                  child: ShowUserProfileOptions(),
                                ),
                              );
                              // Get.to(() => ShowUserProfileOptions(
                              //   member: mem,
                              // ));
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CircleAvatar(radius: 15, child: avatar(mem.get(memberModel.imageUrl).toString())),
                                ),
                                SizedBox(
                                  width: Get.width * 0.35,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${mem.get(memberModel.firstName).toString().capitalize!} ${mem.get(memberModel.lastName).toString().capitalize!}",
                                        overflow: TextOverflow.fade,
                                        style: themeData!.textTheme.bodyText1!.copyWith(
                                          // color: Colors.black,
                                          color: Colors.white,
                                        ),
                                      ),
                                      lastSeenOrActive(mem)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
                Expanded(child: Container()),
                IconButton(
                  icon: const Icon(
                    Icons.monetization_on_outlined,
                    color: Colors.white,
                  ),
                  tooltip: 'Send money in chat',
                  onPressed: () {
                    if (paymentsController.hasePaymentMethod) {
                      paymentsController.checkPaymentMethod();
                      enumServices.transactionActionType = TransactionActionType.SEND_CASH_IN_PRIVATE_CHAT;
                      enumServices.fundingActionType = FundingActionType.PEER_TO_PEER_TRANSFER;
                      transactionService.member = mem;
                      transactionService.chatRoom = widget.chatRoom;
                      transactionService.context = context;
                      debugPrint("semd money in chat");

                      showBarModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          color: Colors.white,
                          child: ChatMoneyKeyPad(
                            member: mem,
                            chatRoom: widget.chatRoom,
                            // contract: Contract(),
                          ),
                        ),
                      );
                    } else {
                      addPaymentMethodController.addPaymentMethod();
                      // Get.to(() => const AddPlaidPaymentMethod());
                    }

                    // Get.to(() => ChatMoneyKeyPad(
                    //   member: mem,
                    //   chatRoom: chatRoom,
                    //   contract: Contract(),
                    // ));
                  },
                ),
                showCallButton?  Expanded(
                  child: PopupMenuButton<MakeCallOptions>(
                    icon: const Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                    onSelected: (MakeCallOptions result) {
                      switch (result) {
                        case MakeCallOptions.call:
                          VoiceOrVideoCall(callType: CallType.VOICE_CALL, chatRoom: widget.chatRoom!, member: mem);
                          break;
                        case MakeCallOptions.video:
                          VoiceOrVideoCall(callType: CallType.VIDEO_CALL, chatRoom: widget.chatRoom!, member: mem);

                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<MakeCallOptions>>[
                      PopupMenuItem<MakeCallOptions>(
                        value: MakeCallOptions.call,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.call, color: Colors.black),
                            Text(
                              "Voice",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                      PopupMenuItem<MakeCallOptions>(
                        value: MakeCallOptions.video,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.videocam_sharp, color: Colors.black),
                            Text(
                              "Video",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ) : Container(),
              ],
            ),
          ],
        ),
        // automaticallyImplyLeading: false, // hides leading widget
      ),
      body: ChatScreen(chatRoom: widget.chatRoom, userChatRoom: widget.userChatRoom),
    );
  }

  Widget lastSeenOrActive(DocumentSnapshot member) {
    return Obx(() {
      String contactPath = widget.chatRoom!.members!.firstWhere((element) => element != dbHelper.user());
      chatRoomController.getMemberStreams(contactPath);
      DocumentSnapshot mem = chatRoomController.membersByContactPath.value[contactPath]!;

      return chatRoomController.currentMember.value[memberModel.online] != null
          ? chatRoomController.currentMember.value[memberModel.online]!
              ? Text(
                  "Online",
                  style: themeData!.textTheme.bodyText1!.copyWith(color: Colors.white, fontSize: 10),
                )
              : MyDateTimeFormat(mem.get(memberModel.lastSeen)).dateFormat()
          : Container();
    });
  }

//MarqueeWidget(
  Widget avatar(String imageUrl) {
    return storage.checkImage(imageUrl.toString())
        ? CircleAvatar(
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: storage.getImage(
                        imageUrl,
                      ),
                      fit: BoxFit.cover)),
            ),
          )
        : CircleAvatar(
            child: Center(
              child: Icon(
                Icons.person,
                size: Get.width * 0.07,
              ),
            ),
          );
  }
}
