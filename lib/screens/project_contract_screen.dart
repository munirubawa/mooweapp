import 'package:mooweapp/export_files.dart';
class ProjectContractScreen extends StatelessWidget {
  final ChatRoom? chatRoom;
  const ProjectContractScreen({Key? key, required this.chatRoom}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // gl.customProvider = CustomProvider(context: context);
    // print("chat.docId");
    return Scaffold(
      body: Container(
        child: Container(
          // width: SizeConfigOld.screenWidth,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Stack(
            children: [
              Container(
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("contracts")
                          .where(
                        "contractId",
                        isEqualTo: chatRoom!.chatRoomPathDocId,
                      )
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) => snapshot.connectionState == ConnectionState.waiting
                          ? const Center(
                            child: CircularProgressIndicator(),
                          )
                          : Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> newContract = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                            // Member creator = Member.fromMap(newContract.contractParties![0]);
                            // Member rece = Member.fromMap(newContract.contractParties![1]);
                            // print(member.toMap());
                            return Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 0.0),
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                  decoration: const BoxDecoration(
                                    // color: chat.unread ? Color(0xFFFFEFEE) : Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // Get.to(()=>  ViewContract(view_contract: newContract,));
                                          if (chatRoom!.supperAdmin == chatServices.localUser!.get(localUserModel.userUID)) {
                                            // showDialog(
                                            //   context: context,
                                            //   builder: (BuildContext context) => ProjectGroupCallPopUp(
                                            //     chat: chat,
                                            //     member: member,
                                            //   ),
                                            // );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 90,
                                              height: 40,
                                              child: Stack(
                                                children: [
                                                  Align(
                                                    alignment: Alignment.centerRight,
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.white,
                                                      child: CircleAvatar(
                                                        radius: 21,
                                                        child: ClipOval(
                                                          // borderRadius: BorderRadius.circular(100.0),

                                                          child: storage.checkImage(newContract[conModel.creator][conModel.imageUrl])
                                                              ? Container(
                                                            width: 80,
                                                            height: 80,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              image: DecorationImage(
                                                                fit: BoxFit.cover,
                                                                image: storage.getImage(newContract[conModel.creator].imageUrl!),
                                                              ),
                                                            ),
                                                          )
                                                              : const Icon(Icons.person),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.white,
                                                      child: CircleAvatar(
                                                        radius: 21,
                                                        child: ClipOval(
                                                          // borderRadius: BorderRadius.circular(100.0),

                                                          child: storage.checkImage(newContract[conModel.creator][conModel.imageUrl])
                                                              ? Container(
                                                            width: 80,
                                                            height: 80,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              image: DecorationImage(
                                                                fit: BoxFit.cover,
                                                                image: storage.getImage(newContract[conModel.creator][conModel.imageUrl]),
                                                              ),
                                                            ),
                                                          )
                                                              : const Icon(Icons.person),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${newContract[conModel.creator][conModel.firstName]} - ${newContract[conModel.creator][conModel.currencyCode]}',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.grey[900],
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  '${newContract[conModel.receiver][conModel.firstName]} - ${newContract[conModel.receiver][conModel.currencyCode]}',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.grey[900],
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                // gl.chatRoomSettings.manager == member1.docId ? Text("Manager") : Container(),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      chatRoom!.supperAdmin!.contains(chatServices.localUser!.get(localUserModel.userUID))
                                          ? ButtonBar(
                                        mainAxisSize: MainAxisSize.max, // this will take space as minimum as posible(to center)
                                        children: <Widget>[
                                          // IconButton(
                                          //   icon: Icon(Icons.message_outlined),
                                          //   onPressed: null,
                                          // ),
                                          IconButton(
                                            icon: const Icon(Icons.monetization_on_outlined),
                                            onPressed: () {
                                              enumServices.userActionType = UserActionType.PROCESS_CONTRACT;
                                              enumServices.transactionActionType = TransactionActionType.PROCESS_CONTRACT;
                                              Get.to(()=>  ChatMoneyKeyPad(
                                                moneyAction: "contract",
                                                member: newContract[conModel.creator]!,
                                                chatRoom: chatRoom,
                                                // contract: newContract,
                                              ));

                                            },
                                          ),
                                        ],
                                      )
                                          : newContract[conModel.creator][conModel.userUID] != chatServices.localUser!.get(localUserModel.userUID)
                                          ? ButtonBar(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.monetization_on_outlined),
                                            onPressed: () {},
                                          )
                                        ],
                                      )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                  indent: 0,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: chatRoom!.supperAdmin == chatServices.localUser!.get(localUserModel.userUID)
          ? FloatingActionButton(
        onPressed: () async {
          // print(gl.localUser.member.toMap());

          // contract.creator = chatServices.localUser!.member;
          // contract.contractOwnerDocId = chatServices.localUser!.userUID;
          // contract.contractChatRoomId = chat!.chatRoom!.chatRoomChatsCollection;
          // contract.contractOwnerCardDocId = chatServices.localUser!.member!.cardPathDocId;
          if (await Permission.contacts.request().isGranted) {
            enumServices.userActionType = UserActionType.CREATE_CONTRACT;
            // showSearch(context: context, delegate: StartNewChat( chatRoom: chatRoom));
          }
          // print("adding members ${chat.chatRoomID}");
          // locator.get<ChatHomeScreenLogic>().getPermissions(context: context, actionType: "addMember", chat: chat);
        },
        child: Icon(
          Icons.content_paste_rounded,
          size: Get.width * 0.2,
        ),
      )
          : Container(),
    );
  }
}