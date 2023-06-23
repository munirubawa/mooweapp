import 'package:mooweapp/export_files.dart';
class MoneyBuilder extends StatelessWidget {
  DocumentSnapshot? message;

  MoneyBuilder({Key? key, required this.message}) : super(key: key);

  MoneyMessage? moneyMessage;
  @override
  Widget build(BuildContext context) {
    moneyMessage = MoneyMessage.fromMap(message!.get(messagePayloadModel.messages)[0]);
    return (chatServices.localMember!.get(memberModel.userUID) == message!.get(messagePayloadModel.sender)[messageSenderModel.userUID])
        ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: Get.height * 0.19,
                  // margin: const EdgeInsets.only(left: 50, right: 15, bottom: 10),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.5), borderRadius: const BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "You sent",
                              style: themeData!.textTheme.bodyText2!,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${paymentsController.numCurrency(moneyMessage!.transaction!.value!)} ${displayCurrencySign()}",
                                  style: currencyStyle("${moneyMessage!.transaction!.currencySign}${paymentsController.numCurrency(moneyMessage!.transaction!.value!)}"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            cashLabel(message!)
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
        )
        : SizedBox(
      width: Get.width,
          child: Row(
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
                      height: Get.height * 0.19,
                      margin: const EdgeInsets.only(left: 15, right: 0, bottom: 10),
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
                                          style: themeData!.textTheme.subtitle1,
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
                                        "${paymentsController.numCurrency(moneyMessage!.transaction!.value!)} ${displayCurrencySign()}",
                                        style: currencyStyle("${moneyMessage!.transaction!.currencySign}${paymentsController.numCurrency(moneyMessage!.transaction!.value!)}"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            cashLabel(message!),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
        );


  }

  String displayCurrencySign(){
    moneyMessage = MoneyMessage.fromMap(message!.get(messagePayloadModel.messages)[0]);
    // CurrencyTypes? types = EnumToString.fromString(CurrencyTypes.values, moneyMessage!.transaction!.currencyCode! );
    // switch(types!){
    //
    //   case CurrencyTypes.USD:
    //     // TODO: Handle this case.
    //     return moneyMessage!.transaction!.currencySign.toString();
    //   case CurrencyTypes.GHS:
    //     // TODO: Handle this case.
    //     return "${moneyMessage!.transaction!.currencyCode}";
    //
    //   case CurrencyTypes.NGN:
    //     // TODO: Handle this case.
    //     break;
    //   case CurrencyTypes.GBP:
    //     // TODO: Handle this case.
    //     break;
    // }
    return "${moneyMessage!.transaction!.currencyCode}";
  }

  Widget senderName(DocumentSnapshot message) {
    // print("object senderName");
    // print(message.get(messagePayloadModel.sender));
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
            "${message.get(messagePayloadModel.sender)[messageSenderModel.firstName].toString()} ${message.get(messagePayloadModel.sender)[messageSenderModel.lastName]} ",
            style: themeData!.textTheme.subtitle2,
          ),
        );
      case ChatTypes.PROJECT_CHAT:
        // TODO: Handle this case.
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          // width: SizeConfigOld.screenWidth,
          child: Text(
            message.get(messagePayloadModel.sender)[messageSenderModel.firstName].capitalize!,
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

Widget cashLabel(DocumentSnapshot message) {
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
          "contribution",
          style: themeData!.textTheme.bodyText1!.copyWith(color: Colors.white),
        ),
      );
    case ChatTypes.PROJECT_CHAT:
    // TODO: Handle this case.
      return Container();
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
TextStyle currencyStyle(String currency){
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
    case 14:
      return themeData!.textTheme.headline6!.copyWith(color: Colors.white);
    default:
      return themeData!.textTheme.headline2!.copyWith(color: Colors.white);
  }
}

