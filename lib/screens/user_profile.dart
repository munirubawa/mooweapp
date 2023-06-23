import 'package:mooweapp/export_files.dart';

class ShowUserProfileOptions extends StatelessWidget {
  // DocumentSnapshot<Object?>? member = member;
  // ChatRoom? chatRoom = userProfileController.chatRoom;
  ShowUserProfileOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: showCallButtons(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: CircleAvatar(
                radius: 50,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: storage.getImage(
                            userProfileController.member!.get(memberModel.imageUrl),
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                Text(
                  "${userProfileController.member!.get(memberModel.firstName).toString().capitalizeFirst!} ${userProfileController.member!.get(memberModel.lastName).toString().capitalizeFirst!}",
                  style: themeData!.textTheme.headline6,
                ),
                Text(userProfileController.member!.get(memberModel.phone).toString()),
              ],
            ),
          ),
          Expanded(
              child: Column(
            children: generalTiles(),
          ))
        ],
      ),
    );
  }

  Widget showCallButtons() {
    return Row(
      children: [
        Expanded(child: Container()),
        chatServices.localMember!.get(memberModel.userUID) != userProfileController.member!.get(memberModel.userUID)
            ? ButtonBar(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.back();
                      VoiceOrVideoCall(callType: CallType.VOICE_CALL, chatRoom: userProfileController.chatRoom!, member: userProfileController.member!);

                    },
                  ),
                  IconButton(
                      onPressed: () {
                        Get.back();
                        VoiceOrVideoCall(callType: CallType.VIDEO_CALL, chatRoom: userProfileController.chatRoom!, member: userProfileController.member!);

                      },
                      icon: const Icon(Icons.videocam, color: Colors.white))
                ],
              )
            : Container(),
        // IconButton(
        //     onPressed: () {},
        //     icon: const Icon(
        //       Icons.qr_code_scanner,
        //       color: Colors.white,
        //     )),
      ],
    );
  }

  Widget smartContract(ChatRoom chatRoom) {
    switch (chatRoom.chatType!) {
      case ChatTypes.PRIVATE_CHAT:
        return ListTile(
          onTap: () async {
            createContract(chatRoom);
            Get.back();
            Get.to(() => CreateContractScreen());
          },
          leading: const Icon(
            Icons.mark_chat_read_outlined,
            color: kPrimaryColor,
          ),
          title: Row(
            children: const [
              Text("Safe Contract"),
              // Text(
              //   member.firstName.toString(),
              // )
            ],
          ),
        );
      case ChatTypes.BUSINESS_CHAT:
      case ChatTypes.STORE_CHAT:
      case ChatTypes.GROUP_CHAT:
        return Container();
      case ChatTypes.PROJECT_CHAT:
        return Container();
      case ChatTypes.FUND_RAISE:
        return Container();
      case ChatTypes.SUSU:
        // TODO: Handle this case.
        return Container();
    }
  }

  void createContract(ChatRoom chatRoom) {
    contractController.contract[conModel.creator] = chatServices.localMember!.data() as Map<String, dynamic>;
    contractController.contract[conModel.receiver] = userProfileController.member!.data() as Map<String, dynamic>;

    // contractController.contract[conModel.receiver][conModel.currencyCode] = "GHS";

    contractController.contract[conModel.chatRoomId] = chatRoom.chatRoomPathDocId;
    contractController.contract[conModel.contractId] = chatRoom.chatRoomPathDocId;
    transactionService.chatRoom = chatRoom;
  }

  List<Widget> generalTiles() {
    return [
      userProfileController.member!.get(memberModel.hasAStore)!
          ? Obx(
              () => ListTile(
                onTap: () {
                  if (navController.callStatus.value == CallActionStatus.CALL_START) {
                    navController.pipPage = ChatStoreView();
                    navController.smallScreen();
                  } else {
                    Get.back();
                    Get.to(() => ChatStoreView());
                  }
                },
                leading: const Icon(
                  Icons.store,
                  color: kPrimaryColor,
                ),
                title: Text(
                  storeController.storeBusiness.value.businessName.toString(),
                  style: themeData!.textTheme.bodyLarge!.copyWith(color: kPrimaryColor),
                ),
              ),
            )
          : Container(),
      smartContract(userProfileController.chatRoom!),
    ];
  }

  List<Widget> groupAdminActions(ChatRoom chatRoom, BuildContext context) {
    switch (chatRoom.chatType!) {
      case ChatTypes.PRIVATE_CHAT:
        return [
          userProfileController.member!.get(memberModel.hasAStore)!
              ? Obx(
                  () => ListTile(
                    onTap: () {
                      Get.back();
                      Get.to(() => ChatStoreView());
                    },
                    leading: const Icon(
                      Icons.store,
                      color: kPrimaryColor,
                    ),
                    title: Text(
                      storeController.storeBusiness.value.businessName.toString(),
                      style: themeData!.textTheme.bodyLarge!.copyWith(color: kPrimaryColor),
                    ),
                  ),
                )
              : Container(),
          ListTile(
            onTap: () async {
              createContract(chatRoom);
              Get.to(() => CreateContractScreen());
            },
            leading: const Icon(
              Icons.mark_chat_read_outlined,
              color: kPrimaryColor,
            ),
            title: Row(
              children: const [
                Text("Smart Contract "),
                // Text(
                //   member.firstName.toString(),
                // )
              ],
            ),
          )
        ];
      case ChatTypes.GROUP_CHAT:
        return [
          ListTile(
            onTap: () async {
              createContract(chatRoom);
              Get.to(() => CreateContractScreen());
            },
            leading: const Icon(
              Icons.mark_chat_read_outlined,
              color: kPrimaryColor,
            ),
            title: Row(
              children: const [
                Text("Safe Contract "),
                // Text(
                //   member.firstName.toString(),
                // )
              ],
            ),
          ),
          chatRoom.supperAdmin!.contains(chatServices.localMember!.get(memberModel.userUID))
              ? ListTile(
                  leading: const Icon(Icons.money),
                  title: Text(
                    "Fund Member",
                    style: themeData!.textTheme.bodyText2,
                  ),
                  onTap: () {
                    showBarModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        color: Colors.white,
                        child: FundingMember(
                          member: userProfileController.member!,
                          chatRoom: chatRoom,
                        ),
                      ),
                    );
                    // Get.to(() => FundingMember(member: member, chatRoom: chatRoom,));
                  },
                )
              : Container(),
          chatRoom.supperAdmin!.contains(chatServices.localMember!.get(memberModel.userUID))
              ? ListTile(
                  leading: const Icon(Icons.admin_panel_settings_outlined),
                  title: Text(
                    "Grant Admin",
                    style: themeData!.textTheme.bodyText2,
                  ),
                  onTap: () async {
                    chatRoom.reference!.set({
                      "admins": FieldValue.arrayUnion([userProfileController.member!.get(memberModel.userUID)!])
                    }, SetOptions(merge: true));
                    Get.back();
                    showToastMessage(msg: "Granted Successful", backgroundColor: Colors.green);
                  },
                )
              : Container(),
          if (chatRoom.supperAdmin!.contains(chatServices.localMember!.get(memberModel.userUID)))
            ListTile(
              leading: const Icon(Icons.close),
              title: Text(
                "Revoke Admin rights",
                style: themeData!.textTheme.bodyText2,
              ),
              onTap: () async {
                chatRoom.reference!.set({
                  "admins": FieldValue.arrayRemove([userProfileController.member!.get(memberModel.userUID)])
                }, SetOptions(merge: true));
                Get.back();

                showToastMessage(msg: "Revoked Successful", backgroundColor: Colors.green);
              },
            )
          else
            Container(),
        ];
      case ChatTypes.PROJECT_CHAT:
        return [
          userProfileController.member!.get(memberModel.hasAStore)!
              ? Obx(
                  () => ListTile(
                    onTap: () {
                      Get.back();
                      Get.to(() => ChatStoreView());
                    },
                    leading: const Icon(
                      Icons.store,
                      color: kPrimaryColor,
                    ),
                    title: Text(
                      storeController.storeBusiness.value.businessName.toString(),
                      style: themeData!.textTheme.bodyLarge!.copyWith(color: kPrimaryColor),
                    ),
                  ),
                )
              : Container(),
          ListTile(
            onTap: () async {
              createContract(chatRoom);
              Get.to(() => CreateContractScreen());
            },
            leading: const Icon(
              Icons.mark_chat_read_outlined,
              color: kPrimaryColor,
            ),
            title: Row(
              children: const [
                Text("Smart Contract "),
                // Text(
                //   member.firstName.toString(),
                // )
              ],
            ),
          ),
          chatRoom.supperAdmin!.contains(chatServices.localMember!.get(memberModel.userUID))
              ? ListTile(
                  leading: const Icon(Icons.money),
                  title: Text(
                    "Fund Member",
                    style: themeData!.textTheme.bodyText2,
                  ),
                  onTap: () {
                    showBarModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        color: Colors.white,
                        child: FundingMember(
                          member: userProfileController.member!,
                          chatRoom: chatRoom,
                        ),
                      ),
                    );
                  },
                )
              : Container(),
          chatRoom.supperAdmin!.contains(chatServices.localMember!.get(memberModel.userUID))
              ? ListTile(
                  leading: const Icon(Icons.admin_panel_settings_outlined),
                  title: Text(
                    "Grant Admin",
                    style: themeData!.textTheme.bodyText2,
                  ),
                  onTap: () async {
                    chatRoom.reference!.set({
                      "admins": FieldValue.arrayUnion([userProfileController.member!.get(memberModel.userUID)!])
                    }, SetOptions(merge: true));
                    Get.back();
                    showToastMessage(msg: "Granted Successful", backgroundColor: Colors.green);
                  },
                )
              : Container(),
          if (chatRoom.supperAdmin!.contains(chatServices.localMember!.get(memberModel.userUID)))
            ListTile(
              leading: const Icon(Icons.close),
              title: Text(
                "Revoke Admin rights",
                style: themeData!.textTheme.bodyText2,
              ),
              onTap: () async {
                chatRoom.reference!.set({
                  "admins": FieldValue.arrayRemove([userProfileController.member!.get(memberModel.userUID)])
                }, SetOptions(merge: true));
                Get.back();

                showToastMessage(msg: "Revoked Successful", backgroundColor: Colors.green);
              },
            )
          else
            Container(),
          if (chatRoom.supperAdmin!.contains(chatServices.localMember!.get(memberModel.userUID)))
            ListTile(
              leading: const Icon(Icons.close),
              title: Text(
                "Grant Manager",
                style: themeData!.textTheme.bodyText2,
              ),
              onTap: () async {
                chatServices.chatRoom = chatRoom;
                chatServices.member = userProfileController.member;
                enumServices.chatServicesActions = ChatServicesActions.MAKE_MEMBER_PROJECT_MANAGER;
                chatServices.runChatServices();
                Get.back();

                showToastMessage(msg: "Revoked Successful", backgroundColor: Colors.green);
              },
            )
          else
            Container(),
          if (chatRoom.supperAdmin!.contains(chatServices.localMember!.get(memberModel.userUID)))
            ListTile(
              leading: const Icon(Icons.close),
              title: Text(
                "Revoke Manager rights",
                style: themeData!.textTheme.bodyText2,
              ),
              onTap: () async {
                chatServices.chatRoom = chatRoom;
                enumServices.chatServicesActions = ChatServicesActions.REVOKE_MANAGER_RIGHTS;
                chatServices.runChatServices();
                Get.back();
                showToastMessage(msg: "Revoked Successful", backgroundColor: Colors.green);
              },
            )
          else
            Container(),
          if (chatRoom.supperAdmin!.contains(chatServices.localMember!.get(memberModel.userUID)))
            ListTile(
              leading: const Icon(Icons.article_outlined),
              title: Text(
                "Safe Contract",
                style: themeData!.textTheme.bodyText2,
              ),
              onTap: () async {
                createContract(chatRoom);
                Get.to(() => CreateContractScreen());
              },
            )
          else
            Container(),
        ];
      case ChatTypes.BUSINESS_CHAT:
      case ChatTypes.STORE_CHAT:
      case ChatTypes.FUND_RAISE:
        return [Container()];
      case ChatTypes.SUSU:
        // TODO: Handle this case.
        return [Container()];
    }
  }
}

