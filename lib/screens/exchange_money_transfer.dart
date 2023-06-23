import 'package:mooweapp/export_files.dart';

class MoneyTransfer extends StatefulWidget {
  const MoneyTransfer({Key? key}) : super(key: key);

  @override
  _MoneyTransferState createState() => _MoneyTransferState();
}

class _MoneyTransferState extends State<MoneyTransfer> {
  final sendTrans = transactionService;

  bool dataExist = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: Get.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: Get.width * 0.1,
              ),
              SizedBox(
                height: Get.height * 0.80,
                // flex: 9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    displayNameOfReceiver(),
                    SizedBox(
                      height: Get.width * 0.1,
                    ),
                    SizedBox(
                      height: Get.height * 0.20,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              height: Get.height * 0.3,
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),

                              // color: Colors.blueAccent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("SEND",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black45,
                                      )),
                                  // SizedBox(
                                  //   width: Get.width * 0.20,
                                  // ),
                                  Text(
                                    "${paymentsController.numCurrency(transactionService.transactionAmount.value)} ${chatServices.localMember!.get(memberModel.currencyCode)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.0254,
                          ),
                          Expanded(
                            child: Container(
                              height: Get.height * 0.2,
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "RECEIVE",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: Colors.black45,
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      "${paymentsController.numCurrency(exchangeController.moweReceiveRate.value)} ${transactionService.remoteCurrency}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () => Text(
                        "Rate: 1: ${transactionService.localCurrency} = ${paymentsController.numCurrency(exchangeController.moweExchangeRate.value)} ${transactionService.remoteCurrency} with no fees",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black38,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DefaultButton(
                      text: "Send",
                      color: Colors.blue,
                      press: () {
                        if (exchangeController.exchangeSuccess.value) {
                          paymentsController.checkUserPasscode(onTap: () {
                            enumServices.sameCurrencyType = SameCurrencyType.CURRENCY_EXCHANGE;
                            exchangeController.completeTransaction();
                          });
                        } else {
                          showToastMessage(msg: "Sorry Something went wrong");
                        }
                      },
                    ),
                    Expanded(
                      flex: 10,
                      child: Container(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String displayReceiverRate() {
    CurrencyTypes? type = EnumToString.fromString(CurrencyTypes.values, transactionService.remoteCurrency!);
    // switch (type!) {
    //   case CurrencyTypes.USD:
    //     // TODO: Handle this case.
    //     return "${paymentsController.numCurrency(exchangeController.moweReceiveRate.value)} ${transactionService.remoteCurrency}";
    //   case CurrencyTypes.GHS:
    //     // TODO: Handle this case.
    //     return "${paymentsController.numCurrency(exchangeController.moweReceiveRate.value)} ${"${transactionService.remoteCurrency}"}";
    //   case CurrencyTypes.NGN:
    //     // TODO: Handle this case.
    //     break;
    //   case CurrencyTypes.GBP:
    //     // TODO: Handle this case.
    //     break;
    // }
    return "${paymentsController.numCurrency(exchangeController.moweReceiveRate.value)} ${transactionService.remoteCurrency}";

  }

  Widget displayNameOfReceiver() {
    switch (transactionService.chatRoom!.chatType!) {
      case ChatTypes.PRIVATE_CHAT:
        // TODO: Handle this case.
        return Flexible(
          flex: 4,
          child: Container(
            // color: Colors.green,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${transactionService.member!.get(memberModel.firstName).toString().capitalizeFirst} "
                  "${transactionService.member!.get(memberModel.lastName).toString().capitalizeFirst}",
                  maxLines: 1,
                  style: themeData!.textTheme.headline6,
                ),
                Text(transactionService.member!.get(memberModel.phone).toString())
              ],
            )),
          ),
        );
      case ChatTypes.GROUP_CHAT:
        // TODO: Handle this case.
        return receiverNameDisplay();
      case ChatTypes.PROJECT_CHAT:
        // TODO: Handle this case.
        return receiverNameDisplay();
      case ChatTypes.FUND_RAISE:
        // TODO: Handle this case.
        return Container();
      case ChatTypes.SUSU:
        // TODO: Handle this case.
        return Container();
      case ChatTypes.BUSINESS_CHAT:
        return receiverNameDisplay();
      case ChatTypes.STORE_CHAT:
        return receiverNameDisplay();
    }
  }

  Widget receiverNameDisplay() {
    return Flexible(
      flex: 3,
      child: Container(
        height: Get.height * 0.4,
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            transactionService.chatRoom!.groupName.toString().capitalizeFirst.toString(),
            maxLines: 1,
            style: themeData!.textTheme.headline4,
          ),
        ),
      ),
    );
  }
}
