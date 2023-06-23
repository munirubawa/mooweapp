import 'package:mooweapp/export_files.dart';

class QRCodeController extends GetxController {
  static QRCodeController instance = Get.find();
  Rx<Barcode> barCode = Barcode("", BarcodeFormat.unknown, []).obs;
  BuildContext? context;
  RxBool hasDataScanned = RxBool(false);
  Map<String, dynamic> scanPaymentData = {};
  RxBool hasScanPaymentData = RxBool(false);

  @override
  onReady() {
    ever(barCode, (callback) {
      if (!hasScanPaymentData.value) {
        hasScanPaymentData.value = true;
        showData();
      }
    });
    super.onReady();
  }

  RxDouble storeTotalAmount = RxDouble(0.0);
  RxDouble storeAmount = RxDouble(0.0);
  Map<String, dynamic> exchangeData = {};
  showData() async {
    scanPaymentData = jsonDecode(barCode.value.code!);

    if (scanPaymentData[scanPaymentModel.currencyCode] != chatServices.localMember!.get(memberModel.currencyCode)) {
      enumServices.sameCurrencyType = SameCurrencyType.CURRENCY_EXCHANGE;
      // transactionService.transactionAmount.value = scanPaymentData[scanPaymentModel.amount];
      transactionService.localCurrency = chatServices.localMember!.get(memberModel.currencyCode);
      transactionService.remoteCurrency = scanPaymentData[scanPaymentModel.currencyCode];
      exchangeData = await exchangeController.currencyExchangeConverter();
      // debugPrint("exchangeData");
      // debugPrint("$exchangeData");
      // exchangeData["storeExchangeRate"];
      storeTotalAmount.value = exchangeData["storeExchangeRate"] * scanPaymentData[scanPaymentModel.amount];
      storeAmount.value = scanPaymentData[scanPaymentModel.amount];
      // storeTotalAmount.value = exchangeData["storeExchangeRate"] * transactionService.transactionAmount.value;
      transactionService.data = exchangeData;
    } else {
      enumServices.sameCurrencyType = SameCurrencyType.SAME_CURRENCY;

      if (transactionService.transactionAmount.value > scanPaymentData[scanPaymentModel.amount]) {
        scanPaymentData[scanPaymentModel.amount] = transactionService.transactionAmount.value;
      } else if (scanPaymentData[scanPaymentModel.amount] > transactionService.transactionAmount.value) {
        transactionService.transactionAmount.value = scanPaymentData[scanPaymentModel.amount];
      } else {
        transactionService.transactionAmount.value = scanPaymentData[scanPaymentModel.amount];
      }
      transactionService.transactionAmount.value = scanPaymentData[scanPaymentModel.amount];
      storeTotalAmount.value = scanPaymentData[scanPaymentModel.amount];
    }

    // debugPrint("$scanPaymentData");
    if (!hasDataScanned.value) {
      Get.back();
      hasDataScanned.value = true;
      Get.to(
        () => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                hasScanPaymentData.value = false;
                hasDataScanned.value = false;
                Get.back();
              },
            ),
            title: Text(
              "Payment confirmation",
              style: themeData!.textTheme.headline6!.copyWith(color: Colors.white),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: Center(
              child: Column(
                children: [
                  const Spacer(
                    flex: 5,
                  ),
                  Text(
                    scanPaymentData[scanPaymentModel.storeName],
                    style: themeData!.textTheme.headline6,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text(, style: themeData!.textTheme.headline2,),
                        Obx(
                          () => Text(
                            "${paymentsController.numCurrency(storeTotalAmount.value)} ${chatServices.localMember!.get(memberModel.currencyCode)}",
                            style: themeData!.textTheme.headline3,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(
                    flex: 5,
                  ),
                  DefaultButton(
                    text: "Confirm Payment",
                    color: kPrimaryColor,
                    press: () {
                      hasScanPaymentData.value = false;
                      switch (enumServices.cameraScanLocation) {
                        case CameraScanLocation.CAMERA_FROM_GROUP_CHAT:
                          if (groupChatController.chatRoom.value.currencyCode != chatServices.localMember!.get(memberModel.currencyCode)) {
                            if (exchangeData["exchangeSuccess"]) {
                              if (storeTotalAmount.value <= groupChatController.total.value) {
                                enumServices.transactionActionType = TransactionActionType.STORE_SCANNED_PAYMENT;
                                transactionService.runTransaction();
                              } else {
                                showToastMessage(msg: "Funds too low for this transaction", backgroundColor: Colors.green, timeInSecForIosWeb: 2);
                              }
                            } else {
                              showToastMessage(msg: "Something went wrong, try again later", backgroundColor: Colors.green);
                            }
                          } else {
                            if (storeTotalAmount.value <= groupChatController.total.value) {
                              enumServices.transactionActionType = TransactionActionType.STORE_SCANNED_PAYMENT;
                              transactionService.runTransaction();
                            } else {
                              showToastMessage(msg: "Funds too low for this transaction", backgroundColor: Colors.green, timeInSecForIosWeb: 2);
                            }
                          }

                          break;
                        case CameraScanLocation.CAMERA_FROM_WALLET:
                          if (scanPaymentData[scanPaymentModel.currencyCode] != chatServices.localMember!.get(memberModel.currencyCode)) {
                            if (exchangeData["exchangeSuccess"]) {
                              if (storeTotalAmount.value <= transactionService.accountBalance.value) {
                                enumServices.transactionActionType = TransactionActionType.STORE_SCANNED_PAYMENT;
                                transactionService.runTransaction();
                                // debugPrint(exchangeData["exchangeSuccess"]);
                              } else {
                                showToastMessage(msg: "Funds too low for this transaction", backgroundColor: Colors.green, timeInSecForIosWeb: 2);
                              }
                            } else {
                              showToastMessage(msg: "Something went wrong, try again later", backgroundColor: Colors.green);
                            }
                          } else {
                            if (storeTotalAmount.value <= transactionService.accountBalance.value) {
                              enumServices.transactionActionType = TransactionActionType.STORE_SCANNED_PAYMENT;
                              transactionService.runTransaction();
                            } else {
                              showToastMessage(msg: "Funds too low for this transaction", backgroundColor: Colors.green, timeInSecForIosWeb: 2);
                            }
                          }

                          break;
                      }

                      // exchangeController.completeTransaction();
                    },
                  ),
                  const Spacer(
                    flex: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      // showBarModalBottomSheet(
      //   context: context!,
      //   builder: (context) => ,
      // );
    }
  }
}

ScanPaymentDataModel scanPaymentModel = ScanPaymentDataModel();

class ScanPaymentDataModel {
  String imageUrl = "imageUrl";
  String storeName = "storeName";
  String amount = "amount";
  String paymentPath = "paymentPath";
  String currencyCode = "currencyCode";
  String currencySign = "currencySign";
  String deviceToken = "deviceToken";
}
