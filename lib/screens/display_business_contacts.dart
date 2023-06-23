import 'package:mooweapp/export_files.dart';

class DisplayBusinessContacts extends StatelessWidget {
  final Color? backgroundColor;

  DisplayBusinessContacts({Key? key, this.backgroundColor = kPrimaryColor, this.selectedContact}) : super(key: key);
  PayBillToBusinessController payBillController = Get.put(PayBillToBusinessController());
  DocumentSnapshot? selectedContact;
  final Chat newChat = Chat(
    firstTimeMessage: true,
    read: false,
    time: Timestamp.now(),
  );
  List<LogicalKeyboardKey> keys = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        title: Obx(
          () => payBillController.marketAppBarActions.value == MarketAppBarActions.SEARCH
              ? RawKeyboardListener(
                  autofocus: true,
                  focusNode: FocusNode(),
                  onKey: (RawKeyEvent event) {
                    final key = event.logicalKey;
                    if (event is RawKeyDownEvent) {
                      // keys.add(key);
                      // print("evenetkeyspressed");
                      // print(key);
                      // print(keys);
                      // print(keys.contains(LogicalKeyboardKey.enter));
                      if (keys.contains(LogicalKeyboardKey.control) && keys.contains(LogicalKeyboardKey.enter)) {}
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (String value) {
                            payBillController.searchWord.value = value;
                          },
                          decoration: const InputDecoration(
                            hintText: 'search business name...',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ),
                      IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: kPrimaryColor,
                          ),
                          onPressed: () {
                            payBillController.changeSearchBar(MarketAppBarActions.CANCEL_SEARCH);
                          }),
                    ],
                  ),
                )
              : Container(),
        ),
        actions: [
          Obx(
            () => payBillController.marketAppBarActions.value == MarketAppBarActions.CANCEL_SEARCH
                ? Row(
                    children: [
                      IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: kPrimaryColor,
                          ),
                          onPressed: () {
                            payBillController.changeSearchBar(MarketAppBarActions.SEARCH);
                          }),
                    ],
                  )
                : Container(),
          ),
        ],
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Obx(() {
                  return ListView.builder(
                    itemCount: payBillController.stores.value.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      Business business = payBillController.stores.value[index];

                      return InkWell(
                        onTap: () {
                          switch(enumServices.payBillActionLocation) {

                            case PayBillActionLocation.BILL_LOCATION_NOT_SET:
                              // TODO: Handle this case.
                              break;
                            case PayBillActionLocation.PAY_A_BILL_FROM_GROUP:
                              paymentsController.checkPaymentMethod();
                              enumServices.userActionType = UserActionType.BILL_PAY;
                              enumServices.transactionActionType = TransactionActionType.SEND_CASH_IN_GROUP_CHAT;
                              enumServices.fundingActionType = FundingActionType.TRANSFER_FUNDS_FROM_GROUP_TO_A_BUSINESS;
                              // transactionService.chatRoom = widget.chatRoom;
                              // Get.to(()=>  ChatMoneyKeyPad(chatRoom: chatRoom, contract: Contract(),));
                            businessServices.business.value = business;
                              showBarModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  color: Colors.white,
                                  child: ChatMoneyKeyPad(
                                    chatRoom: groupChatController.chatRoom.value,
                                    // contract: Contract(),
                                  ),
                                ),
                              );

                              break;
                            case PayBillActionLocation.PAY_A_BILL_FROM_WALLET:
                              enumServices.fundingActionType = FundingActionType.TRANSFER_FUNDS_FROM_WALLET_TO_A_BUSINESS;
                              enumServices.userActionType = UserActionType.BILL_PAY;
                              businessServices.business.value = business;
                              showBarModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  color: Colors.white,
                                  child: ChatMoneyKeyPad(
                                    chatRoom: ChatRoom(chatType: ChatTypes.GROUP_CHAT),
                                    // contract: Contract(),
                                  ),
                                ),
                              );
                              break;
                          }

                        },
                        child: Container(
                          color: index.isOdd ? Colors.white : Colors.black12,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BusinessContactBody(business: business),
                          ),
                        ),
                      );
                    },
                  );
                })
              ],
            ),
          )),
    );
  }
}
