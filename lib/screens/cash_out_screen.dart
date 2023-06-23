import 'package:mooweapp/export_files.dart';

class CashOutScreen extends StatelessWidget {
  const CashOutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get.put(DisbursementController());
    // exchangeController.cashOut();
    // DisbursementController controller = Get.find();
    // controller.getAPIKey();

    Get.put(CollectionController());
    CollectionController controller = Get.find();
    controller.getAPIKey();
    Future.delayed(const Duration(seconds: 5), () => {controller.getAccountBalance()});
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Cash Out",
              textAlign: TextAlign.center,
              style: themeData!.textTheme.headline6,
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
            transactionService.transactionAmount.value = 0;
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SizedBox(
        height: Get.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Obx(
                  () => Center(
                      child: Text(
                    paymentsController.numCurrency(transactionService.transactionAmount.value),
                    style: currencyStyle(transactionService.transactionAmount.value.toString()),
                  )),
                ),
              ),
              cashOutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Expanded cashOutButton() {
    switch (enumServices.cashOutFrom) {
      case CashOutFrom.CASH_OUT_NOT_SET:
        return Expanded(child: Container());

      case CashOutFrom.BUSINESS_CASH_OUT:
        return Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: button(
            onPress: () {
              Get.back();
              paymentsController.checkUserPasscode(onTap: () {
                enumServices.transactionActionType = TransactionActionType.CASH_OUT_TO_BANK_ACCOUNT;
                enumServices.cashOutType = CashOutType.INSTANT;
                transactionService.processTransact();
                if (kDebugMode) {
                  print("Instant cashout");
                }
              });
            },
            charge: Text(
              "${chatServices.localMember!.get(memberModel.currencyCode)}",
              style: themeData!.textTheme.headline6!.copyWith(fontSize: 18, color: Colors.white),
            ),
            message: "Instant",
          ),
        ));

      case CashOutFrom.WALLET_CASH_OUT:
        return Expanded(
          flex: 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: button(
                  onPress: () {
                    if (transactionService.transactionAmount.value > 0) {
                      paymentsController.checkUserPasscode(onTap: () {
                        enumServices.transactionActionType = TransactionActionType.CASH_OUT_TO_BANK_ACCOUNT;
                        enumServices.cashOutType = CashOutType.BUSINESS_DAY;
                        transactionService.processTransact();
                        print("3 Business Days");
                      });
                    } else {
                      showToastMessage(msg: "Type an amount", backgroundColor: Colors.green, timeInSecForIosWeb: 2);
                    }
                  },
                  charge: Text(
                    "Free",
                    style: themeData!.textTheme.headline6!.copyWith(fontSize: 18, color: Colors.white),
                  ),
                  message: "3 Business Days",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: button(
                  onPress: () {
                    if (transactionService.transactionAmount > 0) {
                      paymentsController.checkUserPasscode(onTap: () {
                        enumServices.transactionActionType = TransactionActionType.CASH_OUT_TO_BANK_ACCOUNT;
                        enumServices.cashOutType = CashOutType.INSTANT;
                        transactionService.processTransact();
                        print("Instant cashout");
                      });
                    } else {
                      showToastMessage(msg: "Type an amount", backgroundColor: Colors.green, timeInSecForIosWeb: 2);
                    }
                  },
                  charge: Obx(
                    () => Text(
                      "${chatServices.localMember!.get(memberModel.currencyCode)}${paymentsController.numCurrency(exchangeController.instantCashOutCharge.value)}",
                      style: themeData!.textTheme.headline6!.copyWith(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  message: "Instant",
                ),
              ),
            ],
          ),
        );
    }
  }

  get borderRadius => BorderRadius.circular(8.0);
  Widget button({
    required Function() onPress,
    required Widget charge,
    required String message,
  }) {
    return Center(
      child: Material(
        elevation: 10,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onPress,
          child: Container(
            padding: const EdgeInsets.all(0.0),
            height: 60.0, //MediaQuery.of(context).size.width * .08,
            width: Get.width, //MediaQuery.of(context).size.width * .3,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: borderRadius,
                    ),
                    child: Center(
                      child: charge,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle currencyStyle(String currency) {
    TextStyle style = themeData!.textTheme.headline2!.copyWith(color: Colors.black, fontSize: Get.height * 0.15);
    debugPrint(currency.length.toString());
    switch (currency.length) {
      case 3:
        return style;
      case 4:
        return style.copyWith(fontSize: Get.height * 0.13);
      case 5:
        return style.copyWith(fontSize: Get.height * 0.11);
      case 6:
        return style.copyWith(fontSize: Get.height * 0.1);
      case 7:
        return style.copyWith(fontSize: Get.height * 0.08);
      case 8:
        return style.copyWith(fontSize: Get.height * 0.06);
      case 9:
        return style.copyWith(fontSize: Get.height * 0.04);
      default:
        return style.copyWith(fontSize: Get.height * 0.15);
    }
  }
}

class CashOutCharges extends GetxController {
  static CashOutCharges instance = Get.find();
}
