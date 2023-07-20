import 'package:mooweapp/export_files.dart';

class BusinessGroupMembersScreen extends StatelessWidget {
  // final Business? business;
  // BusinessGroupMembersScreen({required this.business});
  Storage storage = Storage();

  final ChatRoom? chatRoom;
   BusinessGroupMembersScreen({Key? key, required this.chatRoom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // gl.customProvider = CustomProvider(context: context);
    // ChatRoomPaths chatRoomPaths = ChatRoomPaths.fromMap(chat.chatRoomID);

    return Scaffold(
      body: Container(
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
                    child: Obx(() => ListView(
                      children: acceptPaymentsController.groupMembers
                          .map((element) => GestureDetector(
                        onTap: () {
                          switch (groupChatController.memberDisplayType) {
                            case GroupMemberDisplayType.TRANSFER_PAYMENT_FROM_GROUP_CARD:
                              Get.back();

                              if (paymentsController.hasePaymentMethod) {
                                paymentsController.checkPaymentMethod();
                                enumServices.transactionActionType = TransactionActionType.TRANSFER_FUNDS_FROM_GROUP_CHAT_TO_A_PEER;
                                enumServices.fundingActionType = FundingActionType.TRANSFER_FUNDS_FROM_GROUP_TO_A_PEER;

                                transactionService.member = element;
                                transactionService.chatRoom = groupChatController.chatRoom.value;
                                transactionService.context = context;
                                debugPrint("semd money in chat");

                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                    color: Colors.white,
                                    child: ChatMoneyKeyPad(
                                      member: element,
                                      chatRoom: groupChatController.chatRoom.value,
                                      // contract: Contract(),
                                    ),
                                  ),
                                );
                              } else {
                                addPaymentMethodController.addPaymentMethod();
                                // Get.to(() => const AddPlaidPaymentMethod());
                              }
                              break;
                            case GroupMemberDisplayType.DISPLAY_MEMBERS_OF_GROUP:
                              Get.put(StoreController());
                              if (element.get(memberModel.hasAStore)!) {
                                storeController.getStoreFromDatabase(element.get(memberModel.storePath).toString());
                              }
                              userProfileController.chatRoom = chatRoom;
                              userProfileController.member = element;
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  color: Colors.white,
                                  child: ShowUserProfileOptions(),
                                ),
                              );
                              break;
                            case GroupMemberDisplayType.DISPLAY_TYPE_NOT_SET:
                              // TODO: Handle this case.
                              break;
                          }

                          // Get.to(()=>GroupMemberActionScreen(chatRoom: chatRoom, member: memberSnapshot.data,));
                        },
                        child: ListTile(
                          leading: storage.checkImage(element.get(memberModel.imageUrl).toString())
                              ? CircleAvatar(
                            // radius: SizeConfig.heightMultiplier! * 2.0,
                            child: Container(
                              decoration: BoxDecoration(
                                // color: Colors.orange,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: storage.getImage(
                                        element.get(memberModel.imageUrl),
                                      ),
                                      fit: BoxFit.cover)),
                            ),
                          )
                              : Icon(
                            Icons.person,
                            size: Get.width * 0.1,
                          ),
                          title: Row(
                            children: [
                              element.get(memberModel.hasAStore)!
                                  ? const Icon(
                                Icons.store,
                                color: kPrimaryColor,
                                size: 15.0,
                              )
                                  : Container(),
                              Text(
                                "${element.get(memberModel.firstName).toString().capitalize!} ${element.get(memberModel.lastName).toString().capitalize!}",
                                overflow: TextOverflow.fade,
                                style: themeData!.textTheme.bodyText1!.copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          subtitle: MemberSubTitle(
                            member: element,
                            chatRoom: chatRoom,
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
                      ))
                          .toList(),
                    )))
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: chatRoom!.supperAdmin!.contains(chatServices.localMember!.get(memberModel.userUID)) || chatRoom!.admins!.contains(chatServices.localMember!.get(memberModel
          .userUID))
          ? FloatingActionButton(
        onPressed: () async {
          if (await Permission.contacts.request().isGranted) {
            enumServices.chatServicesActions = ChatServicesActions.ADD_MEMBER_TO_PROJECT_OR_GROUP;
            enumServices.openContactsScreenOrigin = OpenContactsScreenOrigin.FROM_GROUP_CHAT;
            enumServices.userActionType = UserActionType.ADD_NEW_MEMBER_TO_GROUP_OR_PROJECT;
            chatServices.chatRoom = chatRoom;
            enumServices.chatTypes = ChatTypes.GROUP_CHAT;

            initialChat.chatType = chatRoom!.chatType;

            // changeScreen(context, DisplayContacts(actionType: "newChat", backgroundColor: white,));
            Get.to(() => DisplayContacts(
              backgroundColor: Colors.white,
            ));
          }
        },
        child: const Icon(Icons.group_add_rounded),
      )
          : Container(),
    );
  }
}
