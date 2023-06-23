import 'package:mooweapp/export_files.dart';
class StoreTransactionsScreen extends StatelessWidget {
  StoreTransactionsScreen({Key? key}) : super(key: key);
   double sheetProgress = 0;


   // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       elevation: 0.0,
  //       backgroundColor: kPrimaryColor,
  //       leading: const Text(""),
  //       actions: const [],
  //     ),
  //     body: Container(
  //       color: Colors.white,
  //       child: SingleChildScrollView(
  //         child: Column(
  //           children: [
  //             Obx(() {
  //               storeController.storeTransactions.value.sort((b, a) => a.time!.compareTo(b.time!));
  //
  //               return Column(
  //                 children: [
  //                   SizedBox(
  //                     height: Get.height * 0.10,
  //                     child: Container(
  //                       color: kPrimaryColor,
  //                       child: Center(
  //                         child: Text(
  //                           "${storeController.storeBusiness.value.currencySign}${paymentsController.numCurrency(storeController.accountBalance.value)}",
  //                           style: themeData!.textTheme.headline4!.copyWith(color: Colors.white),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   ListView.builder(
  //                       itemCount: storeController.storeTransactions.value.length,
  //                       shrinkWrap: true,
  //                       physics: const NeverScrollableScrollPhysics(),
  //                       itemBuilder: (context, index) {
  //                         TransactionPayload payload = storeController.storeTransactions.value[index];
  //                         return Container(
  //                           color: index.isOdd ? Colors.white : Colors.black12,
  //                           child: TransactionSummary(
  //                             transaction: MooweTransactions.fromJson(payload.data),
  //                           ),
  //                         );
  //                       }),
  //                 ],
  //               );
  //             })
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {

    return Container(
      width: Get.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Container(
          height: Get.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [Colors.white, Colors.white],
            ),
          ),
          child: SlidingSheet(
            minHeight: Get.height * 0.8,
            elevation: 8,
            cornerRadius: 16,
            snapSpec: SnapSpec(
              snap: true,
              positioning: SnapPositioning.relativeToAvailableSpace,
              snappings: const [
                SnapSpec.headerFooterSnap,
                0.6,
                SnapSpec.expanded,
              ],
              onSnap: (state, snap) {
                print('Snapped to $snap');
              },
            ),
            parallaxSpec: const ParallaxSpec(
              enabled: true,
              amount: 0.35,
              endExtent: 0.6,
            ),
            body: PlayAnimationBuilder(
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOut,
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                // if (kDebugMode) {
                //   print( double.parse(value.toString()).toString());
                // }

                return Transform.scale(
                  scale: double.parse(value.toString()),
                  alignment: Alignment.center,
                  child: Opacity(
                      opacity: double.parse(value.toString()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 12,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 25.0),
                              child: DetailCard(sheetProgress: sheetProgress, card: acceptPaymentsController.chatRoom.value.creditCard),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child:  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Balance", style: themeData!.textTheme.bodyText1),
                                  Obx(() => Text("${acceptPaymentsController.total.value} ${acceptPaymentsController.chatRoom.value.currencyCode}",
                                      style: themeData!.textTheme.headline4!.copyWith(fontWeight: FontWeight.bold)),)
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 15,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 35),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      acceptPaymentsController.getTotal();
                                      transactionService.chatRoom = acceptPaymentsController.chatRoom.value;
                                      enumServices.transactionActionType = TransactionActionType.TRANSFER_FUNDS_FROM_GROUP_CHAT_TO_A_PEER;
                                      groupChatController.memberDisplayType = GroupMemberDisplayType.TRANSFER_PAYMENT_FROM_GROUP_CARD;

                                      Get.to(() => Scaffold(
                                        appBar: AppBar(
                                          elevation: 0.0,
                                          backgroundColor: kPrimaryColor,
                                          title: const Text("Select a Contact"),
                                        ),
                                        body: BusinessGroupMembersScreen(
                                          chatRoom: acceptPaymentsController.chatRoom.value,
                                        ),
                                      ));
                                    },
                                    child: Column(
                                      children: const [
                                        Icon(Icons.send),
                                        Text("Transfer"),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      enumServices.transactionActionType = TransactionActionType.PAY_BILL_FROM_GROUP_CHAT;
                                      transactionService.chatRoom = acceptPaymentsController.chatRoom.value;
                                      Get.to(() => DisplayBusinessContacts(), binding: BusinessBinding());
                                    },
                                    child: Column(
                                      children: const [
                                        Icon(Icons.payment),
                                        Text("Pay Bill"),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      transactionService.chatRoom = acceptPaymentsController.chatRoom.value;
                                      enumServices.transactionActionType = TransactionActionType.SCAN_FROM_GROUP_CHAT;
                                      enumServices.cameraScanLocation = CameraScanLocation.CAMERA_FROM_GROUP_CHAT;
                                      Get.to(() => const QRViewExample());
                                    },
                                    child: Column(
                                      children: const [
                                        Icon(Icons.qr_code_scanner),
                                        Text("Scan"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                );
              },
              child: DetailCard(sheetProgress: sheetProgress, card: acceptPaymentsController.business.value.creditCard),
            ),
            headerBuilder: (context, state) {
              return Container(
                  height: 56,
                  width: double.infinity,
                  color: kPrimaryColor,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Icon(Icons.arrow_drop_up),
                      Text(
                        'Contributions',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                      ),
                    ],
                  ));
            },
            builder: (context, state) {
              // This is the content of the sheet that will get
              // scrolled, if the content is bigger than the available
              // height of the sheet.
              return Obx(() => SizedBox(
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child:acceptPaymentsController.chatRoom.value.creditCard != null? _buildBottomSheet(acceptPaymentsController.chatRoom.value.creditCard!): Container(),
                ),
              ),);
            },
            footerBuilder: (context, state) {
              return Container(
                height: 56,
                width: double.infinity,
                color: kPrimaryColor,
                alignment: Alignment.center,
                child: Text(
                  '',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  _buildBottomSheet(CreditCard creditCard) {
    return Container(
      // color: Colors.red,
      width: Get.width,
      // constraints: BoxConstraints(
      //   minHeight: Get.width * 0.6,
      // ),
      child: Obx(() => ListView(
        children: acceptPaymentsController.transactions.value
            .map((TransactionPayload payload) => TransactionSummary(
          payload: payload,
        ))
            .toList(),
      )),
    );
  }
}
