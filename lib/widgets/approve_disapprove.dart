import 'package:mooweapp/export_files.dart';

class ApproveDisapprove extends StatelessWidget {
  DocumentSnapshot? messagePayloadSnap;
  ChatRoom? chatRoom;

  ApproveDisapprove({Key? key, this.messagePayloadSnap, this.chatRoom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApproveDisapproveMessage appDisApp = ApproveDisapproveMessage.fromMap(messagePayloadSnap!.get(messagePayloadModel.messages)[0]);

    return appDisApp.disapprovedIds!.isEmpty &&
            !appDisApp.approvedIds!.contains(chatServices.localMember!.get(memberModel.userUID))
        ? Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
              width: Get.width * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        appDisApp.message!.text.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          child: const Text("Disapprove"),
                          onPressed: () async {
                            Map<String, dynamic> messagePayload = {
                              messagePayloadModel.chatRoomChatsCollection: chatRoom!.chatRoomChatsCollection,
                              messagePayloadModel.time: Timestamp.now(),
                              messagePayloadModel.sender: chatServices.sender,
                              messagePayloadModel.messageType: ChatMessageType.DISAPPROVE,
                              messagePayloadModel.messageGroupType: chatRoom!.chatType,
                              messagePayloadModel.messages: [
                                TextMessage(
                                    time: Timestamp.now(),
                                    text: "DISAPPROVED",
                                    read: false,
                                    senderID: chatServices.localMember!.get(memberModel.userUID)
                                ).toMap(),
                              ],
                            };
                            appDisApp.disapprovedIds!.add(chatServices.localMember!.get(memberModel.userUID));

                            chatServices.textMessage = TextMessage(
                              time: Timestamp.now(),
                              text: "DISAPPROVED",
                              read: false,
                                senderID: chatServices.localMember!.get(memberModel.userUID)
                            );
                            // transactionService.setNumberDisplayState = () {};
                            transactionService.setPaymentToEmpty();
                            // chatRoom!.reference!.set({"currentBeneficiary": widget.member!.userUID!}, SetOptions(merge: true));
                            chatServices.messagePayload = messagePayload;
                            enumServices.chatServicesActions = ChatServicesActions.SEND_MESSAGE;
                            chatServices.chatRoom = chatRoom;
                            chatServices.runChatServices();

                            appDisApp.approvedIds!.add(chatServices.localMember!.get(memberModel.userUID));
                            messagePayloadSnap!.reference.update({
                              "time": Timestamp.now(),
                            });
                          },
                        ),
                        ElevatedButton(
                          child: const Text("Approve"),
                          onPressed: () async {
                            Map<String, dynamic> newMessagePayload = {
                              messagePayloadModel.chatRoomChatsCollection: chatRoom!.chatRoomChatsCollection,
                              messagePayloadModel.time: Timestamp.now(),
                              messagePayloadModel.sender: chatServices.sender,
                              messagePayloadModel.messageType: ChatMessageType.APPROVE,
                              messagePayloadModel.messageGroupType: chatRoom!.chatType,
                              messagePayloadModel.messages: [
                                TextMessage(
                                    time: Timestamp.now(),
                                    text: "APPROVED",
                                    read: false,
                                    senderID: chatServices.localMember!.get(memberModel.userUID)
                                ).toMap(),
                              ],
                            };
                            chatServices.textMessage = TextMessage(
                              time: Timestamp.now(),
                              text: "APPROVED",
                              read: false,
                                senderID: chatServices.localMember!.get(memberModel.userUID)
                            );


                            // chatRoom!.reference!.set({"currentBeneficiary": widget.member!.userUID!}, SetOptions(merge: true));
                            appDisApp.approvedIds!.add(chatServices.localMember!.get(memberModel.userUID)!);
                            messagePayloadSnap!.reference.update({
                              "messages": [appDisApp.toMap()],
                            });


                            chatServices.messagePayload = newMessagePayload;
                            enumServices.chatServicesActions = ChatServicesActions.SEND_MESSAGE;
                            chatServices.chatRoom = chatRoom;
                            chatServices.sendToChatRoom = true;
                            chatServices.runChatServices();



                            print("message!.beneficiaryConfirmationsDecorum!");
                            if(appDisApp.disapprovedIds!.isEmpty && appDisApp.approvedIds!.length + 1 == chatRoom!
                                .chatRoomDecorumLimit) {
                              enumServices.transactionActionType =TransactionActionType.PROCESS_CHAT_GROUP_FUNDING;
                              transactionService.transactionAmount.value = appDisApp.fundingAmount!;
                              transactionService.chatRoom = chatRoom;
                              transactionService.approveDisapproveMessagePayload = messagePayloadSnap;
                              transactionService.runTransaction();
                            }
                            // transactionService.setNumberDisplayState = () {};
                            transactionService.setPaymentToEmpty();

                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }
}
