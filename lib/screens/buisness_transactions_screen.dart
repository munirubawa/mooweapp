import 'package:mooweapp/export_files.dart';

class BusinessTransactionScreen extends StatefulWidget {
  // final Business business;
  // final List<MessagePayload> mediaMessage = [];

  // const BusinessTransactionScreen({required this.business});

  @override
  _BusinessTransacionScreenState createState() => _BusinessTransacionScreenState();
}

class _BusinessTransacionScreenState extends State<BusinessTransactionScreen> {
  double sheetProgress = 0;
  @override
  void initState() {
    super.initState();
  }
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
          height: Get.height * 0.86 ,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [Colors.white, Colors.white],
            ),
          ),
          child: SlidingSheet(
            minHeight: Get.height,
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
                              child: Obx(
                                () => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Balance", style: themeData!.textTheme.bodyText1),
                                    Text("${paymentsController.numCurrency(acceptPaymentsController.total.value)} ${acceptPaymentsController.chatRoom.value.currencyCode}",
                                        style: themeData!.textTheme.headline4!.copyWith(fontWeight: FontWeight.bold)),
                                  ],
                                ),
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
                                 acceptPaymentsController.chatRoom.value.supperAdmin!.contains(chatServices.localMember!.get(memberModel.userUID))? InkWell(
                                    onTap: () {
                                      acceptPaymentsController.getTotal();
                                      transactionService.chatRoom = acceptPaymentsController.chatRoom.value;
                                      transactionService.transactionAmount.value = acceptPaymentsController.total.value;
                                      // enumServices.transactionActionType = TransactionActionType.TRANSFER_FUNDS_FROM_GROUP_CHAT_TO_A_PEER;
                                      // groupChatController.memberDisplayType = GroupMemberDisplayType.TRANSFER_PAYMENT_FROM_GROUP_CARD;
                                      enumServices.cashOutFrom = CashOutFrom.BUSINESS_CASH_OUT;
                                      Get.to(() => const CashOutScreen());
                                      // Get.to(() => const TransferMoneyToBankAccount());
                                    },
                                    child: Column(
                                      children: const [
                                        Icon(Icons.send),
                                        Text("Transfer"),
                                      ],
                                    ),
                                  ): Container(),
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
                        'Transactions',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                      ),
                    ],
                  ));
            },
            builder: (context, state) {
              // This is the content of the sheet that will get
              // scrolled, if the content is bigger than the available
              // height of the sheet.
              return Obx(
                () => SizedBox(
                  height: 500,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: acceptPaymentsController.chatRoom.value.creditCard != null ? _buildBottomSheet(acceptPaymentsController.chatRoom.value.creditCard!) : Container(),
                  ),
                ),
              );
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
    return SizedBox(
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

class TransferMoneyToBankAccount extends StatelessWidget {
  const TransferMoneyToBankAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
        title: const Text("Business Cash out"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(child: Obx(()=>  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("${paymentsController.numCurrency(acceptPaymentsController.total.value)} ${acceptPaymentsController.chatRoom.value.currencyCode}",
                  style: themeData!.textTheme.headline4!.copyWith(fontWeight: FontWeight.bold)),
            ),
            ))
          ],
        ),
      ),
    );
  }
}


// class TransactionWithAddress extends StatelessWidget {
//   final TransactionPayload payload;
//   const TransactionWithAddress({Key? key, required this.payload}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // TransactionWithUserAddress withUserAddress = TransactionWithUserAddress.fromMap(payload.data);
//     return Card(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TransactionSummary(
//             payload: payload,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 8.0),
//             child: Row(
//               children: [
//                 Expanded(flex: 2, child: Container()),
//                 Expanded(
//                     flex: 9,
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               "${withUserAddress.address.street.toString()} ",
//                               maxLines: 2,
//                               overflow: TextOverflow.fade,
//                             ),
//                             Text(
//                               withUserAddress.address.locality.toString(),
//                               maxLines: 2,
//                               overflow: TextOverflow.fade,
//                             )
//                           ],
//                         ),
//                         Row(
//                           children: [Text("${withUserAddress.address.administrativeArea.toString()} "), Text(withUserAddress.address.postalCode.toString())],
//                         )
//                       ],
//                     ))
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
