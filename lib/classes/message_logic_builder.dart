import 'package:mooweapp/export_files.dart';
class MessageLogicBuilder extends StatelessWidget {
  DocumentSnapshot? message;

  // final bool? isMe;
  // ChatLogic? chatLogic,
  final ChatRoom? chatRoom;

  MessageLogicBuilder({Key? key, required this.message, this.chatRoom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(message!.messageType);
    switch (enumServices.chatMessageType!) {
      case ChatMessageType.MONEY:
        // TODO: Handle this case.
        return MoneyBuilder(message: message);
      case ChatMessageType.MESSAGE:
        // TODO: Handle this case.
        return MessageBuilder(message: message);
      case ChatMessageType.IMAGE:
        // TODO: Handle this case.
        return ImageDisplayBuilder(
          message: message,
          chatRoom: chatRoom,
        );
      case ChatMessageType.VIDEO_FILE:
        // TODO: Handle this case.
        return VideoMessageDisplay(message: message);
      case ChatMessageType.AUDIO_FILE:
        // TODO: Handle this case.
        return AudioMessage(message: message);
      case ChatMessageType.VOICE_FILE:
        // TODO: Handle this case.
        return Container();
      case ChatMessageType.ASK_FOR_PERMISSION_TO_CASH_OUT:
        // TODO: Handle this case.
        return Container();
      case ChatMessageType.SURVEY_QUESTION:
        // TODO: Handle this case.
        return Container();
      case ChatMessageType.APPROVE_DISAPPROVE:
        // TODO: Handle this case.
        return ApproveDisapprove(messagePayloadSnap: message, chatRoom: chatRoom);
      case ChatMessageType.APPROVE:
        // TODO: Handle this case.
        return Approve(
          message: message,
        );
      case ChatMessageType.DISAPPROVE:
        // TODO: Handle this case.
        return Container();
      case ChatMessageType.GROUP_CALL:
        // TODO: Handle this case.
        return Container();
      case ChatMessageType.FUNDING_COMPLETE:
        // TODO: Handle this case.
        return FundingComplete(message: message);

      case ChatMessageType.FUNDING:
        // TODO: Handle this case.
        return Funding(
          message: message,
        );
      case ChatMessageType.CALL_ANSWERED:
        // TODO: Handle this case.
        return Container();
      case ChatMessageType.MULTIPLE_IMAGES:
        // TODO: Handle this case.
        return MultipleImagesScreen(
          message: message,
        );
      case ChatMessageType.REQUESTING:
        // TODO: Handle this case.
        // debugPrint(message.toMap().toString());

        return RequestingMoneyWidget(
          message: message,
          chatRoom: chatRoom,
        );
      case ChatMessageType.CONTRACT:
        // TODO: Handle this case.

        return Column(
          crossAxisAlignment: chatServices.localMember!.get(memberModel.userUID) == message!.get(messagePayloadModel.sender)[messageSenderModel.userUID] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            MessageBuilder(message: message),
            Padding(
              padding: const EdgeInsets.only(bottom: 28.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 45,
                  ),
                  InkWell(
                    onTap: () {
                      // print(message.messages![0]["contractId"].toString());
                      contractController.getContract(contractId: message!.get(messagePayloadModel.messages)![0]["contractId"]).then((value){
                        Future.delayed(const Duration(seconds: 1), (){
                          Get.to(()=> ViewContract());
                        });
                      });
                    },
                    child: const Text("View Contract"),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                ],
              ),
            )
          ],
        );
    }
  }
}

class RequestingMoneyWidget extends StatelessWidget {
  DocumentSnapshot? message;
  final ChatRoom? chatRoom;

  RequestingMoneyWidget({Key? key, required this.message, required this.chatRoom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MoneyMessage? moneyMessage;

    MooweTransactions transaction = MooweTransactions.fromJson(message!.get(messagePayloadModel.messages)[0]);
    // debugPrint(transaction.toMap().toString());
    // return const Text("data");
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: senderName(message!),
                )
              ],
            ),
            Container(
              height: Get.height * 0.20,
              margin: const EdgeInsets.only(left: 15, right: 50, bottom: 10),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.5), borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          EnumToString.fromString(ChatTypes.values, message!.get(messagePayloadModel.messageGroupType)) == ChatTypes.PRIVATE_CHAT
                              ? Text(
                                  message!.get(messagePayloadModel.sender)[messageSenderModel.firstName],
                                  style: themeData!.textTheme.titleMedium,
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "${transaction.currencySign}${paymentsController.numCurrency(transaction.value!)}",
                                style: currencyStyle("${transaction.currencySign}${paymentsController.numCurrency(transaction.value!)}"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Reject"),
                          const SizedBox(
                            width: 100,
                          ),
                          InkWell(
                              onTap: () {
                                transactionService.displayAmount.value = transaction.value!.toString();
                                // ChatMoneyKeyPad(
                                //                                       member: Member(),
                                //                                       chatRoom: chatRoom,
                                //                                       contract: Contract(),
                                //    showBarModalBottomSheet                                 )
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Scaffold(
                                    backgroundColor: kPrimaryColor,
                                    body: Column(
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Center(
                                            child: Text(
                                              transactionService.displayAmount.value.toString(),
                                              style: currencyStyle(transactionService.displayAmount.value.toString()),
                                            ),
                                          ),
                                        ),
                                        Expanded(flex: 6, child: Container()),
                                        Expanded(
                                            flex: 6,
                                            child: Center(
                                              child: CustomBtn3(
                                                bgColor: kPrimaryColor,
                                                onTap: () {},
                                                child: Text(
                                                  "Pay",
                                                  style: themeData!.textTheme.headline3,
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: const Text("Pay")),
                        ],
                      ),
                    ),
                    // cashLabel(message!),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  TextStyle currencyStyle(String currency) {
    debugPrint(currency.length.toString());
    switch (currency.length) {
      case 6:
        return themeData!.textTheme.headline2!.copyWith(color: Colors.white);
      case 7:
        return themeData!.textTheme.headline2!.copyWith(color: Colors.white);
      case 8:
        return themeData!.textTheme.headline3!.copyWith(color: Colors.white);
      case 9:
        return themeData!.textTheme.headline3!.copyWith(color: Colors.white);
      case 10:
        return themeData!.textTheme.headline4!.copyWith(color: Colors.white);
      case 11:
        return themeData!.textTheme.headline5!.copyWith(color: Colors.white);
      case 13:
        return themeData!.textTheme.headline6!.copyWith(color: Colors.white);
      default:
        return themeData!.textTheme.headline2!.copyWith(color: Colors.white);
    }
  }

  Widget senderName(DocumentSnapshot message) {
    switch (EnumToString.fromString(ChatTypes.values, message.get(messagePayloadModel.messageGroupType))) {
      case ChatTypes.PRIVATE_CHAT:
        // TODO: Handle this case.
        return Container();
      case ChatTypes.GROUP_CHAT:
        // TODO: Handle this case.
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          // width: SizeConfigOld.screenWidth,
          child: Text(
            "${message.get(messagePayloadModel.sender)[messageSenderModel.firstName].toString().capitalize!} ${message.get(messagePayloadModel.sender)[messageSenderModel.lastName].toString().capitalize!} ",
            style: themeData!.textTheme.subtitle2,
          ),
        );
      case ChatTypes.PROJECT_CHAT:
        // TODO: Handle this case.
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          // width: SizeConfigOld.screenWidth,
          child: Text(
            message.get(messagePayloadModel.sender)[messageSenderModel.firstName].toString().capitalize!,
            style: themeData!.textTheme.subtitle2,
          ),
        );
      case ChatTypes.FUND_RAISE:
        // TODO: Handle this case.
        return Container();
      case ChatTypes.SUSU:
        // TODO: Handle this case.
        return Container();
      default:
        return Container();
    }
  }
}
