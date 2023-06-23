import 'package:mooweapp/export_files.dart';

class StoreQRCode extends StatelessWidget {
  const StoreQRCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat.MMM();
    final String formatted = formatter.format(now);
    // AddProductController productController = Get.find();
    return Column(
      children: [
        Expanded(
          flex: 7,
          child: Container(
            color: kPrimaryColor,
            width: double.infinity,
            child: Obx(() => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Sale', style: themeData!.textTheme.headline5!.copyWith(color: Colors.white)),
                    Expanded(
                      child: Text(
                        "${addProductController.business.value.currencySign ?? ""}${paymentsController.numCurrency(transactionService.transactionAmount.value)}",
                        style: themeData!.textTheme.headline2!.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                )),
          ),
        ),
        Expanded(
          flex: 15,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Obx(() => QrImage(
                  data: jsonEncode({
                    scanPaymentModel.paymentPath: storeController.storeBusiness.value.cardTransactionPath.toString(),
                    scanPaymentModel.storeName: storeController.storeBusiness.value.businessName.toString(),
                    scanPaymentModel.currencyCode: storeController.storeBusiness.value.currencyCode.toString(),
                    scanPaymentModel.currencySign: storeController.storeBusiness.value.currencySign.toString(),
                    scanPaymentModel.amount: transactionService.transactionAmount.value,
                    scanPaymentModel.deviceToken: chatServices.localMember!.get(memberModel.deviceToken),
                  }),
                  version: QrVersions.auto,
                  size: 250,
                  gapless: true,
                  errorStateBuilder: (cxt, err) {
                    return const Center(
                      child: Text(
                        "Uh oh! Something went wrong...",
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                  // embeddedImage: const AssetImage('assets/ic_launcher_round.png'),
                  // embeddedImageStyle: QrEmbeddedImageStyle(
                  //   size: const Size(44, 44),
                  // ),
                )),
          ),
        ),
        Expanded(
          flex: 3,
          child: Obx(() => Column(
                children: [
                  Text(acceptPaymentsController.business.value.businessName.toString()),
                  Text(acceptPaymentsController.business.value.phone.toString()),
                ],
              )),
        ),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  transactionService.setPaymentToEmpty();
                  showBarModalBottomSheet(
                    context: context,
                    builder: (context) => Scaffold(
                      backgroundColor: kPrimaryColor,
                      body: Column(
                        children: [
                          Expanded(
                            flex: 9,
                            child: Column(
                              children: [
                                NumberDisplay(),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 9,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40.0),
                              child: Column(
                                children: [
                                  KeyPadDisplay(),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    // CustomBtn(
                                    //   text: "Request",
                                    //   onTap: () {
                                    //     enumServices.transactionActionType = TransactionActionType.REQUEST_PAYMENT;
                                    //     enumServices.userActionType = UserActionType.REQUEST_PAYMENT;
                                    //     transactionService.runTransaction();
                                    //   },
                                    //   bgColor: kPrimaryColor,
                                    // ),
                                    CustomBtn(
                                      text: "Done",
                                      onTap: () {
                                        Get.back();
                                      },
                                      bgColor: kPrimaryColor,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                padding: const EdgeInsets.only(bottom: 10),
                icon: const Icon(
                  Icons.price_change_outlined,
                  size: 44.0,
                ),
                alignment: Alignment.center,
              )
            ],
          ),
        ),
      ],
    );
  }
}
