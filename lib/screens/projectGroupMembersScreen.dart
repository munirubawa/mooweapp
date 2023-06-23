import 'package:mooweapp/export_files.dart';
class ProjectGroupMembersScreen extends StatefulWidget {
  final ChatRoom? chatRoom;
  const ProjectGroupMembersScreen({required this.chatRoom});

  @override
  _ProjectGroupMembersScreenState createState() => _ProjectGroupMembersScreenState();
}

class _ProjectGroupMembersScreenState extends State<ProjectGroupMembersScreen> {
  @override
  Widget build(BuildContext context) {
    // gl.customProvider = CustomProvider(context: context);
    // ChatRoomPaths chatRoomPaths = ChatRoomPaths.fromMap(chat.chatRoomID);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          width: Get.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: StreamBuilder<ChatRoom>(
                        stream: FirebaseFirestore.instance
                            .doc(widget.chatRoom!.chatRoomPathDocId!)
                            .snapshots()
                            .map((event) => ChatRoom.fromSnap(event)),
                        builder: (BuildContext context, AsyncSnapshot<ChatRoom> chatRoomSnapshot) {
                          if (!chatRoomSnapshot.hasData) {
                            return const Loading();
                          }
                          if (chatRoomSnapshot.connectionState == ConnectionState.done) {}
                          return ListView.builder(
                            itemCount: chatRoomSnapshot.data!.members!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .doc(chatRoomSnapshot.data!.members![index])
                                    .snapshots()
                                    .map((event) => event),
                                builder: (context, AsyncSnapshot<DocumentSnapshot> memberSnapshot) {
                                  if (memberSnapshot.connectionState == ConnectionState.waiting) {
                                    return Container();
                                  }
                                  Get.put(StoreController());
                                  return GestureDetector(
                                    onTap: () {
                                      debugPrint(memberSnapshot.data!.get(memberModel.storePath));
                                      debugPrint(storeController.storeBusiness.value.businessName);
                                      if(memberSnapshot.data!.get(memberModel.hasAStore)!){
                                        storeController.getStoreFromDatabase(memberSnapshot.data!.get(memberModel.storePath).toString());
                                      }
                                      userProfileController.chatRoom = chatRoomSnapshot.data!;
                                      userProfileController.member = memberSnapshot.data!;
                                      showBarModalBottomSheet(
                                        context: context,
                                        builder: (context) => Container(
                                          color: Colors.white,
                                          child: ShowUserProfileOptions(),
                                        ),
                                      );
                                      // Get.to(() => ShowUserProfileOptions(
                                      //   member: memberSnapshot.data!,
                                      //   chatRoom: chatRoomSnapshot.data!,
                                      // ));
                                      // Get.to(() => ProjectMemberActionScreen(
                                      //       chatRoom: widget.chatRoom,
                                      //       member: memberSnapshot.data,
                                      //     ));
                                    },
                                    child: ListTile(
                                      leading: storage.checkImage(memberSnapshot.data!.get(memberModel.imageUrl).toString())
                                          ? CircleAvatar(
                                              radius: Get.width * 0.2,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    // color: Colors.orange,
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: storage.getImage(
                                                          memberSnapshot.data!.get(memberModel.imageUrl),
                                                        ),
                                                        fit: BoxFit.cover)),
                                              ),
                                            )
                                          : Icon(
                                            Icons.person,
                                            size: Get.width * 0.2,
                                          ),
                                      title: Row(
                                        children: [
                                          memberSnapshot.data!.get(memberModel.hasAStore)!?
                                          const Icon(Icons.store, color: kPrimaryColor,size: 15.0,): Container(),
                                          Text(
                                            "${memberSnapshot.data!.get(memberModel.firstName).toString().capitalize!} ${memberSnapshot.data!
                                                .get(memberModel.lastName).toString().capitalize!}",
                                            overflow: TextOverflow.fade,
                                            style: themeData!.textTheme.bodyText1!.copyWith(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      isThreeLine: true,
                                      subtitle: MemberSubTitle(
                                        member: memberSnapshot.data!,
                                        chatRoom: widget.chatRoom,
                                      ),
                                      trailing: GestureDetector(
                                        onTap: () {
                                          print("red button");
                                        },
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.red,
                                                child: const Text(''),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            shrinkWrap: true,
                          );
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: widget.chatRoom!.supperAdmin!.contains(chatServices.localMember!.get(memberModel.userUID)) ||
              widget.chatRoom!.admins!.contains(chatServices.localMember!.get(memberModel.userUID))
          ? FloatingActionButton(
              onPressed: () async {
                if (await Permission.contacts.request().isGranted) {
                  enumServices.chatServicesActions = ChatServicesActions.ADD_MEMBER_TO_PROJECT_OR_GROUP;
                  enumServices.openContactsScreenOrigin = OpenContactsScreenOrigin.FROM_GROUP_CHAT;
                  enumServices.userActionType = UserActionType.ADD_NEW_MEMBER_TO_GROUP_OR_PROJECT;

                  enumServices.chatTypes = widget.chatRoom!.chatType;
                  chatServices.context = context;
                  Get.to(() => DisplayContacts(
                    backgroundColor: Colors.white,
                  ));
                  // showSearch(context: context, delegate: StartNewChat(chatRoom: widget.chatRoom));
                }
              },
              child: const Icon(Icons.group_add),
            )
          : Container(),
    );
  }
}
