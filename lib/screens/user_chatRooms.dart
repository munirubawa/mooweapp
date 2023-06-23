import 'package:mooweapp/export_files.dart';
import 'package:shimmer/shimmer.dart';

String capitalize(String string) {
  if (string == null) {
    throw ArgumentError.notNull('string');
  }

  if (string.isEmpty) {
    return string;
  }

  return string[0].toUpperCase() + string.substring(1);
}

class UserChatRoomWidget extends StatelessWidget {
   UserChatRoomWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(child: StreamBuilder(
            stream: chatRoomController.getAllUserChatRooms(),
            builder: (context, AsyncSnapshot<List<UserChatRoom>> userChatRoomSnap) {
              if (userChatRoomSnap.connectionState == ConnectionState.waiting) {
                return LoadingListPage(count: 10);
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: userChatRoomSnap.data!.length,
                itemBuilder: (context, index) {
                  return StreamBuilder<DocumentSnapshot>(
                      stream: firebaseFirestore.doc(userChatRoomSnap.data![index].chatRoom).snapshots().map((event) => event),
                      // stream: chatRoomController.getChatRoom(userChatRoomSnap.data![index].chatRoom),
                      builder: (context, chatRoomSnapshot) {
                        if (!chatRoomSnapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 48.0,
                                  height: 48.0,
                                  color: Colors.white,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: 40.0,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {

                          UserChatRoom userChatRoom = userChatRoomSnap.data![index];
                          ChatRoom? chat = ChatRoom.fromSnap(chatRoomSnapshot.data!);
                          chat.members?.forEach((element) {
                            if (!chatRoomController.membersByContactPath.containsKey(element)) {
                              chatRoomController.getMemberStreams(element);
                            }
                          });
                          return Container(
                            // height: 88,
                            color: index.isOdd ? Colors.white : Colors.black12,
                            // margin: const EdgeInsets.all(2.0),
                            child: ChatRoomWidget(
                              userChatRoom: userChatRoom,
                              chatRoom: chat,
                            ),
                          );
                        }
                      });
                },
              );
            },
          ),
          )
        ],
      ),
    );
  }
}

class ChatRoomWidget extends StatefulWidget {
  final ChatRoom chatRoom;
  final UserChatRoom userChatRoom;
  const ChatRoomWidget({Key? key, required this.chatRoom, required this.userChatRoom}) : super(key: key);

  @override
  State<ChatRoomWidget> createState() => _ChatRoomWidgetState();
}

class _ChatRoomWidgetState extends State<ChatRoomWidget> {
  @override
  Widget build(BuildContext context) {
    var chat = currentChats.firstWhereOrNull((element) {
      return element.chatRoomChatsCollection == widget.chatRoom.chatRoomChatsCollection;
    });
    if (chat == null) {
      currentChats.add(widget.chatRoom);
    }
    var userChatRoomInfo = userChatRoom.firstWhereOrNull((element) {
      return element.chatRoom == widget.userChatRoom.chatRoom;
    });
    if (userChatRoomInfo == null) {
      userChatRoom.add(widget.userChatRoom);
    }

    box.read("${widget.chatRoom.reference!.id}messageCount") ?? box.write("${widget.chatRoom.reference!.id}messageCount", widget.chatRoom.messageCount);
    int messageCount = box.read("${widget.chatRoom.reference!.id}messageCount") ?? 0;
    if (messageCount != widget.chatRoom.messageCount!) setState(() {});

    box.read("${widget.chatRoom.reference!.id}userPathCount") ?? box.write("${widget.chatRoom.reference!.id}userPathCount", widget.chatRoom.messageCount);
    int userPathCount = box.read("${widget.chatRoom.reference!.id}userPathCount") ?? 0;

    if (widget.chatRoom.messageCount! != userPathCount) {
      box.write("${widget.chatRoom.reference!.id}userPathCount", widget.chatRoom.messageCount);
      widget.userChatRoom.reference?.update({"time": Timestamp.now()});
    }

    return ListTile(
      // contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
      // contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 10, bottom: 10),
      horizontalTitleGap: 10,
      minVerticalPadding: 10,

      // dense:true,
      onTap: () {
        if (permissionController.storagePermissionGranted.value) {
          if (widget.chatRoom.messageCount! > messageCount) {
            box.write("${widget.chatRoom.reference!.id}messageCount", widget.chatRoom.messageCount);
            setState(() {});
          }
          switch (widget.chatRoom.chatType!) {
            case ChatTypes.PRIVATE_CHAT:
              enumServices.currentScreen = CurrentScreen.MOOWE_PRIVATE_CHAT_SCREEN;
              box.write("${widget.chatRoom.reference!.id}messageCount", widget.chatRoom.messageCount);
              navController.pipPage = PrivateChatScreen(chatRoom: widget.chatRoom, userChatRoom: widget.userChatRoom);

              if (navController.callStatus.value == CallActionStatus.CALL_START) {
                navController.smallScreen();
              } else {
                Get.to(() => PrivateChatScreen(chatRoom: widget.chatRoom, userChatRoom: widget.userChatRoom));
              }

              break;
            case ChatTypes.GROUP_CHAT:
              groupChatController.chatRoom.value = widget.chatRoom;
              enumServices.currentScreen = CurrentScreen.MOOWE_GROUP_CHAT_SCREEN;
              box.write("${widget.chatRoom.reference!.id}messageCount", widget.chatRoom.messageCount);
              navController.pipPage = GroupChatScreen(chatRoom: widget.chatRoom, userChatRoom: widget.userChatRoom);

              if (navController.callStatus.value == CallActionStatus.CALL_START) {
                navController.smallScreen();
              } else {
                Get.to(() => GroupChatScreen(chatRoom: widget.chatRoom, userChatRoom: widget.userChatRoom));
              }

              break;
            case ChatTypes.PROJECT_CHAT:
              box.write("${widget.chatRoom.reference!.id}messageCount", widget.chatRoom.messageCount);

              enumServices.currentScreen = CurrentScreen.MOOWE_PROJECT_CHAT_SCREEN;
              navController.pipPage = ProjectChatScreen(chatRoom: widget.chatRoom, userChatRoom: widget.userChatRoom);

              if (navController.callStatus.value == CallActionStatus.CALL_START) {
                navController.smallScreen();
              } else {
                Get.to(() => ProjectChatScreen(chatRoom: widget.chatRoom, userChatRoom: widget.userChatRoom));
              }
              break;
            case ChatTypes.FUND_RAISE:
              break;
            case ChatTypes.SUSU:
              break;
            case ChatTypes.BUSINESS_CHAT:
              // groupChatController.chatRoom.value = widget.chatRoom;
              enumServices.currentScreen = CurrentScreen.MOOWE_GROUP_CHAT_SCREEN;
              box.write("${widget.chatRoom.reference!.id}messageCount", widget.chatRoom.messageCount);
              navController.pipPage = BusinessAccountScreen(
                chatRoom: widget.chatRoom,
              );

              if (navController.callStatus.value == CallActionStatus.CALL_START) {
                navController.smallScreen();
              } else {
                groupChatController.chatRoom.value = widget.chatRoom;
                acceptPaymentsController.businessPath.value = widget.chatRoom.businessPath!;
                acceptPaymentsController.chatRoom.value = widget.chatRoom;
                widget.userChatRoom.reference!.update({"time": Timestamp.now()});
                Get.to(() => BusinessAccountScreen(chatRoom: widget.chatRoom));
                // Future.delayed(const Duration(seconds: 1), ()=>Get.to(() => const BusinessAccountScreen()));
              }

              break;
            case ChatTypes.STORE_CHAT:
              groupChatController.chatRoom.value = widget.chatRoom;
              enumServices.currentScreen = CurrentScreen.MOOWE_GROUP_CHAT_SCREEN;
              box.write("${widget.chatRoom.reference!.id}messageCount", widget.chatRoom.messageCount);

              navController.pipPage = const StoreHomeScreen();
              if (navController.callStatus.value == CallActionStatus.CALL_START) {
                navController.smallScreen();
              } else {
                widget.userChatRoom.reference!.update({"time": Timestamp.now()});
                groupChatController.chatRoom.value = widget.chatRoom;
                acceptPaymentsController.businessPath.value = widget.chatRoom.businessPath!;
                acceptPaymentsController.chatRoom.value = widget.chatRoom;
                Get.to(() => const StoreHomeScreen());
              }
              break;
          }
        } else {
          permissionController.getStoragePermission();
        }
      },
      leading: CircleAvatar(
        child: ChatAvator(chat: widget.chatRoom),
      ),
      // leading: ChatAvator(chat: widget.chatRoom),

      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              // width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${MyDateTimeFormat(widget.chatRoom.message!.time!).chatDateFormat()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: themeData!.textTheme.bodyText1,
                  )
                ],
              ),
            ),
            ChatRoomTitle(chatRoom: widget.chatRoom),
          ],
        ),
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: widget.chatRoom.message!.text != ""
                ? Text(
                    widget.chatRoom.message!.text.toString().inCaps,
                    maxLines: 1,
                    style: themeData!.textTheme.subtitle2,
                  )
                : Text(
                    widget.chatRoom.message!.text.toString(),
                    maxLines: 1,
                    style: themeData!.textTheme.subtitle2,
                  ),
          ),
          Container(
            child: widget.chatRoom.messageCount! > messageCount
                ? CircleAvatar(
                    maxRadius: 15,
                    backgroundColor: Colors.lightGreen,
                    child: Text(
                      "${widget.chatRoom.messageCount! - messageCount}",
                      style: themeData!.textTheme.bodyLarge!.copyWith(color: Colors.white),
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${substring(1)}';
  String get allInCaps => toUpperCase();
  String get capitalizeFirstofEach => split(" ").map((str) => str.capitalize).join(" ");
}

class ChatRoomTitle extends StatelessWidget {
  final ChatRoom chatRoom;
  const ChatRoomTitle({Key? key, required this.chatRoom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = themeData!.textTheme.titleMedium!;
    switch (chatRoom.chatType!) {
      case ChatTypes.PRIVATE_CHAT:
        // TODO: Handle this case.
        String sender = chatRoom.members!.firstWhere((element) => element != dbHelper.user());
        // chatRoomController.getMemberStreams(sender);
        // chatRoomController.currentMember.value[memberModel.online];
        debugPrint("contactPath");
        // debugPrint(chatRoomController.membersByContactPath.value.length.toString());
        // chatRoomController.getMemberStreams(sender);
        return StreamBuilder<DocumentSnapshot>(
          stream: firebaseFirestore.doc(sender).snapshots().map((event) => event),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              return Text(
                "${snapshot.data!.get(memberModel.firstName).toString().capitalizeFirst} ${snapshot.data!.get(memberModel.lastName).toString().capitalizeFirst}",
                style: style,
              );
            } else {
              return Container();
            }
          },
        );
      // return Obx(() {
      //   if(chatRoomController.membersByContactPath.value[sender] == null) return Container();
      //   DocumentSnapshot mem = chatRoomController.membersByContactPath.value[sender]!;
      //   return chatRoomController.currentMember.value[memberModel.firstName] !=null? Text(
      //     "${chatRoomController.currentMember.value[memberModel.firstName].toString().capitalizeFirst} ${chatRoomController.currentMember.value[memberModel.firstName].toString().capitalizeFirst}",
      //     style: style,
      //   ): Text(chatRoomController.currentMember.value[memberModel.firstName]);
      // },
      // );
      case ChatTypes.GROUP_CHAT:
        // TODO: Handle this case.
        return Text(
          chatRoom.groupName.toString().capitalizeFirst!,
          style: style,
        );
      case ChatTypes.PROJECT_CHAT:
        // TODO: Handle this case.
        return Text(
          chatRoom.groupName.toString().capitalizeFirst!,
          style: style,
        );
      case ChatTypes.FUND_RAISE:
        // TODO: Handle this case.
        return Text(
          chatRoom.groupName.toString().capitalizeFirst!,
          style: themeData!.textTheme.bodyText1,
        );
      case ChatTypes.SUSU:
        // TODO: Handle this case.
        return Text(
          chatRoom.groupName.toString(),
          style: themeData!.textTheme.bodyText1,
        );
      case ChatTypes.BUSINESS_CHAT:
        return Text(
          chatRoom.groupName.toString().capitalizeFirst!,
          style: style,
        );
      case ChatTypes.STORE_CHAT:
        return Text(
          chatRoom.groupName.toString().capitalizeFirst!,
          style: style,
        );
    }
  }
}
