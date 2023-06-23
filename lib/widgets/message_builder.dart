import 'package:mooweapp/export_files.dart';

class MessageBuilder extends StatefulWidget {
  DocumentSnapshot? message;
  MessageBuilder({Key? key, required this.message}) : super(key: key);

  @override
  _MessageBuilderState createState() => _MessageBuilderState();
}

class _MessageBuilderState extends State<MessageBuilder> {
  // final service = locator.get<FirestoreService>();
  @override
  Widget build(BuildContext context) {
    return chatServices.localMember!.get(memberModel.userUID) == widget.message!.get(messagePayloadModel.sender)[messageSenderModel.userUID]
        ? Container(
            child: Row(
              children: [
                Expanded(
                    child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.message!.get(messagePayloadModel.messages)!.length,
                  itemBuilder: (BuildContext context, int index) {
                    TextMessage textMessage = TextMessage.fromMap(widget.message!.get(messagePayloadModel.messages)![index]);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: kPrimaryColor.withOpacity(0.3),
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomLeft: Radius.circular(15))),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                textMessage.text.toString(),
                                style: themeData!.textTheme.bodyText1!.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // textMessage.read!
                              //     ? Icon(
                              //         Icons.done_all,
                              //         size: Get.height * 0.05,
                              //         color: Colors.blue,
                              //       )
                              //     : Icon(
                              //         Icons.done_outlined,
                              //         size: Get.height * 0.05,
                              //         color: Colors.grey,
                              //       ),
                              Text(
                                "${MyDateTimeFormat(textMessage.time!).chatDateFormat()}",
                                style: TextStyle(
                                  fontSize: Get.height * 0.01865,
                                  // fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ))
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 36,
                  ),
                  senderName(widget.message!)
                ],
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    child: storage.checkImage(widget.message!.get(messagePayloadModel.sender)![messageSenderModel.imageUrl].toString())
                        ? Container(
                            decoration: BoxDecoration(
                                // color: Colors.orange,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: storage.getImage(
                                      widget.message!.get(messagePayloadModel.sender)![messageSenderModel.imageUrl],
                                    ),
                                    fit: BoxFit.cover)),
                          )
                        : Icon(
                            Icons.person,
                            size: imageRadius,
                          ),
                  ),
                  Expanded(
                      child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: widget.message!.get(messagePayloadModel.messages)!.length,
                    itemBuilder: (BuildContext context, int index) {
                      // print("message.text![index]");
                      // print(message.text![index]);
                      // print("___");
                      TextMessage textMessage = TextMessage.fromMap(widget.message!.get(messagePayloadModel.messages)![index]);

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200], borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomRight: Radius.circular(15))),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  textMessage.text.toString(),
                                  style: themeData!.textTheme.bodyText1,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                // textMessage.read!
                                //     ? Icon(
                                //         Icons.done_all,
                                //         size: Get.width * 0.2,
                                //         color: Colors.blue,
                                //       )
                                //     : Icon(
                                //         Icons.done_outlined,
                                //         size: Get.width * 2,
                                //         color: Colors.grey,
                                //       ),
                                Text(
                                  "${MyDateTimeFormat(textMessage.time!).chatDateFormat()}",
                                  style: TextStyle(
                                    fontSize: Get.height * 0.01865,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ))
                ],
              ),
            ],
          );
  }

  Widget senderName(DocumentSnapshot message) {
    switch (EnumToString.fromString(ChatTypes.values, message.get(messagePayloadModel.messageGroupType))) {
      case ChatTypes.BUSINESS_CHAT:
      case ChatTypes.PROJECT_CHAT:
      case ChatTypes.GROUP_CHAT:
      case ChatTypes.FUND_RAISE:
      case ChatTypes.SUSU:
        return Text(
          "${message.get(messagePayloadModel.sender)![messageSenderModel.firstName].toString().capitalize!} ${message.get(messagePayloadModel.sender)![messageSenderModel.lastName].toString().capitalize!} ",
          style: themeData!.textTheme.bodySmall,
        );
      case ChatTypes.PRIVATE_CHAT:
        return Container();
      default:
        return Container();
    }
  }
}
