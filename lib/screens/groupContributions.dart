import 'package:mooweapp/export_files.dart';

class GroupContributionsScreen extends StatefulWidget {
  final ChatRoom? chatRoom;
  final List<DocumentSnapshot> mediaMessage = [];

  GroupContributionsScreen({super.key, required this.chatRoom});

  @override
  _GroupContributionsScreenState createState() => _GroupContributionsScreenState();
}

class _GroupContributionsScreenState extends State<GroupContributionsScreen> with SingleTickerProviderStateMixin {
  double sheetProgress = 0;

  // late AnimationController controller;
  //  late Animation colorAnimation;
  //  late Animation sizeAnimation;

  @override
  void initState() {
    super.initState();
    // controller =  AnimationController(vsync: this, duration: const Duration(seconds: 2));
    // colorAnimation = ColorTween(begin: Colors.blue, end: Colors.yellow).animate(controller);
    // sizeAnimation = Tween<double>(begin: 100.0, end: 200.0).animate(controller);
    // controller.addListener(() {
    //   setState(() {});
    // });
    //
    // controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
        title: Text(
          '${widget.chatRoom!.firstName}',
          overflow: TextOverflow.ellipsis,
          style: themeData!.textTheme.headline5!.copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: Get.height * 0.9,
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
                              child: DetailCard(sheetProgress: sheetProgress, card: widget.chatRoom!.creditCard),
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
                                    Text("${paymentsController.numCurrency(groupChatController.total.value)} ${groupChatController.chatRoom.value.currencyCode}",
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
                                  InkWell(
                                    onTap: () {
                                      groupChatController.getTotal();
                                      transactionService.chatRoom = widget.chatRoom;
                                      enumServices.transactionActionType = TransactionActionType.TRANSFER_FUNDS_FROM_GROUP_CHAT_TO_A_PEER;
                                      groupChatController.memberDisplayType = GroupMemberDisplayType.TRANSFER_PAYMENT_FROM_GROUP_CARD;

                                      Get.to(() => Scaffold(
                                            appBar: AppBar(
                                              elevation: 0.0,
                                              backgroundColor: kPrimaryColor,
                                              title: const Text("Select a Contact"),
                                            ),
                                            body: GroupMembersScreen(
                                              chatRoom: widget.chatRoom,
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
                                      enumServices.payBillActionLocation = PayBillActionLocation.PAY_A_BILL_FROM_GROUP;
                                      transactionService.chatRoom = widget.chatRoom;
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
                                      transactionService.chatRoom = widget.chatRoom;
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
              child: DetailCard(sheetProgress: sheetProgress, card: widget.chatRoom!.creditCard),
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
              return SizedBox(
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: _buildBottomSheet(widget.chatRoom!.creditCard!),
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
    return Container(
      // color: Colors.red,
      width: Get.width,
      // constraints: BoxConstraints(
      //   minHeight: Get.width * 0.6,
      // ),
      child: Obx(() => ListView(
            children: groupChatController.transactions.value
                .map((TransactionPayload payload) => TransactionSummary(
              payload: payload,
                    ))
                .toList(),
          )),
    );
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }
}
