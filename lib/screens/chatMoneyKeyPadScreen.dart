import 'package:mooweapp/export_files.dart';

class ChatMoneyKeyPad extends StatelessWidget {
  ChatRoom? chatRoom;
  // Member? member;
  DocumentSnapshot? member;
  // Contract? contract;
  String? moneyAction;
  ChatMoneyKeyPad({
    Key? key,
    this.chatRoom,
    this.member,
    this.moneyAction,
  });
  // String fullName = '';
  String displayName() {
    switch (enumServices.fundingActionType) {
      case FundingActionType.PEER_TO_PEER_TRANSFER:
        return "Send to: ${member!.get(memberModel.firstName)}";
      case FundingActionType.TRANSFER_FUNDS_FROM_GROUP_TO_A_PEER:
        return "Send to ${member!.get(memberModel.firstName)}";
      case FundingActionType.TRANSFER_FUNDS_INTO_GROUP:
        return "Send to ${chatRoom!.firstName!}";
      case FundingActionType.TRANSFER_FUNDS_FROM_GROUP_TO_A_BUSINESS:
        return "Pay to ${businessServices.business.value.businessName}";
      case FundingActionType.TRANSFER_FUNDS_FROM_WALLET_TO_A_BUSINESS:
        return "Pay to ${businessServices.business.value.businessName}";
    }
  }

  double accountBalance() {
    switch (enumServices.fundingActionType) {
      case FundingActionType.PEER_TO_PEER_TRANSFER:
        return transactionService.accountBalance.value;
      case FundingActionType.TRANSFER_FUNDS_FROM_GROUP_TO_A_PEER:
        return groupChatController.total.value;
      case FundingActionType.TRANSFER_FUNDS_INTO_GROUP:
        return transactionService.accountBalance.value;
      case FundingActionType.TRANSFER_FUNDS_FROM_GROUP_TO_A_BUSINESS:
        switch (enumServices.payBillActionLocation) {
          case PayBillActionLocation.BILL_LOCATION_NOT_SET:
            return transactionService.accountBalance.value;
          case PayBillActionLocation.PAY_A_BILL_FROM_GROUP:
            return groupChatController.total.value;
          case PayBillActionLocation.PAY_A_BILL_FROM_WALLET:
            return transactionService.accountBalance.value;
        }
      case FundingActionType.TRANSFER_FUNDS_FROM_WALLET_TO_A_BUSINESS:
        return transactionService.accountBalance.value;
    }
  }

  String currencyCode() {
    switch (enumServices.fundingActionType) {
      case FundingActionType.PEER_TO_PEER_TRANSFER:
        return chatServices.localMember!.get(memberModel.currencyCode);
      case FundingActionType.TRANSFER_FUNDS_FROM_GROUP_TO_A_PEER:
        return groupChatController.chatRoom.value.currencyCode!;
      case FundingActionType.TRANSFER_FUNDS_INTO_GROUP:
        return chatServices.localMember!.get(memberModel.currencyCode);
      case FundingActionType.TRANSFER_FUNDS_FROM_GROUP_TO_A_BUSINESS:
        switch (enumServices.payBillActionLocation) {
          case PayBillActionLocation.BILL_LOCATION_NOT_SET:
            return groupChatController.chatRoom.value.currencyCode!;
          case PayBillActionLocation.PAY_A_BILL_FROM_GROUP:
            return groupChatController.chatRoom.value.currencyCode!;
          case PayBillActionLocation.PAY_A_BILL_FROM_WALLET:
            return chatServices.localMember!.get(memberModel.currencyCode);
        }
      case FundingActionType.TRANSFER_FUNDS_FROM_WALLET_TO_A_BUSINESS:
        return chatServices.localMember!.get(memberModel.currencyCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        toolbarHeight: 100.0,
        elevation: 0.0,
        title: SizedBox(
          height: 70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayName(), overflow: TextOverflow.ellipsis, style: themeData!.textTheme.headline6!.copyWith(color: Colors.white)),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Obx(() => Text(
                        "${paymentsController.numCurrency(accountBalance())} ",
                        style: themeData!.textTheme.headline6!.copyWith(color: Colors.white),
                      )),
                  Text(currencyCode()),
                ],
              )
            ],
          ),
        ),
      ),
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
                      text: "Send",
                      onTap: () {
                        if (transactionService.transactionAmount.value > 0) {
                          if (transactionService.transactionAmount.value <= transactionService.accountBalance.value) {
                            // transactionService.member = member;
                            transactionService.member = member;
                            // transactionService.contract = contract ?? Contract();
                            transactionService.chatRoom = chatRoom;

                            transactionService.context = context;
                            // transactionService.runTransaction();
                            switch (chatRoom?.chatType) {
                              case ChatTypes.PRIVATE_CHAT:
                                if (member!.get(memberModel.currencyCode) != chatServices.localMember!.get(memberModel.currencyCode)) {
                                  // enumServices.transactionActionType = TransactionActionType.EXCHANGE_IN_PRIVATE_CHAT;
                                  // enumServices.transactionActionType = TransactionActionType.SEND_CASH_IN_PRIVATE_CHAT;
                                  transactionService.localCurrency = chatServices.localMember!.get(memberModel.currencyCode);
                                  transactionService.remoteCurrency = member!.get(memberModel.currencyCode);
                                  transactionService.exchangeScreen();
                                } else {
                                  transactionService.runTransaction();
                                }
                                break;
                              case ChatTypes.GROUP_CHAT:
                                switch (enumServices.fundingActionType) {
                                  case FundingActionType.PEER_TO_PEER_TRANSFER:
                                    break;
                                  case FundingActionType.TRANSFER_FUNDS_FROM_GROUP_TO_A_PEER:
                                    if (groupChatController.chatRoom.value.currencyCode != member!.get(memberModel.currencyCode)) {
                                      enumServices.transactionActionType = TransactionActionType.EXCHANGE_IN_PRIVATE_CHAT;
                                      transactionService.localCurrency = chatServices.localMember!.get(memberModel.currencyCode);
                                      transactionService.remoteCurrency = member!.get(memberModel.currencyCode);
                                      transactionService.exchangeScreen();
                                    } else {
                                      Get.back();

                                      if (transactionService.transactionAmount.value < groupChatController.total.value) {
                                        if (chatServices.localMember!.get(memberModel.currencyCode).toString() == chatRoom!.currencyCode) {
                                          enumServices.transactionActionType = TransactionActionType.TRANSFER_FUNDS_FROM_GROUP_CHAT_TO_A_PEER;
                                          transactionService.localCurrency = chatServices.localMember!.get(memberModel.currencyCode);
                                          if (kDebugMode) {
                                            print("transfer funds");
                                          }
                                          transactionService.runTransaction();
                                        } else {
                                          enumServices.transactionActionType = TransactionActionType.EXCHANGE_IN_GROUP_CHAT_OR_PROJECT_CHAT;

                                          transactionService.localCurrency = chatServices.localMember!.get(memberModel.currencyCode);
                                          transactionService.remoteCurrency = chatRoom!.currencyCode;

                                          transactionService.exchangeScreen();
                                        }
                                      } else {
                                        showToastMessage(msg: "Low funds");
                                      }
                                    }
                                    break;
                                  case FundingActionType.TRANSFER_FUNDS_INTO_GROUP:
                                    if (chatRoom!.currencyCode != chatServices.localMember!.get(memberModel.currencyCode)) {
                                      // enumServices.transactionActionType = TransactionActionType.EXCHANGE_IN_GROUP_CHAT_OR_PROJECT_CHAT;
                                      transactionService.localCurrency = chatServices.localMember!.get(memberModel.currencyCode);
                                      transactionService.remoteCurrency = chatRoom!.currencyCode;
                                      transactionService.exchangeScreen();
                                    } else {
                                      transactionService.runTransaction();
                                    }
                                    break;
                                  case FundingActionType.TRANSFER_FUNDS_FROM_GROUP_TO_A_BUSINESS:
                                    if (transactionService.transactionAmount.value < groupChatController.total.value) {
                                      if (transactionService.transactionAmount.value > 0) {
                                        if (businessServices.business.value.currencyCode == groupChatController.chatRoom.value.currencyCode) {
                                          paymentsController.checkUserPasscode(onTap: () {
                                            // Get.back();
                                            enumServices.businessServiceAction = BusinessServiceAction.PAY_A_BILL;
                                            businessServices.runBusinessServices();
                                            // showToastMessage(msg: "Type an amount", backgroundColor: Colors.green, timeInSecForIosWeb: 22);

                                            // Get.to(() => DisplayBusinessContacts(), binding: BusinessBinding());
                                          });
                                        }
                                      } else {
                                        showToastMessage(msg: "Type an amount", backgroundColor: Colors.green, timeInSecForIosWeb: 22);
                                      }
                                    } else {
                                      showToastMessage(msg: "Low funds");
                                    }
                                    break;
                                  case FundingActionType.TRANSFER_FUNDS_FROM_WALLET_TO_A_BUSINESS:
                                    if (transactionService.transactionAmount.value < transactionService.accountBalance.value) {
                                      if (transactionService.transactionAmount.value > 0) {
                                        if (businessServices.business.value.currencyCode == chatServices.localMember!.get(memberModel.currencyCode)) {
                                          paymentsController.checkUserPasscode(onTap: () {
                                            // Get.back();
                                            enumServices.businessServiceAction = BusinessServiceAction.PAY_A_BILL;
                                            businessServices.runBusinessServices();
                                            // showToastMessage(msg: "Type an amount", backgroundColor: Colors.green, timeInSecForIosWeb: 22);

                                            // Get.to(() => DisplayBusinessContacts(), binding: BusinessBinding());
                                          });
                                        } else {}
                                      } else {
                                        showToastMessage(msg: "Type an amount", backgroundColor: Colors.green, timeInSecForIosWeb: 22);
                                      }
                                    } else {
                                      showToastMessage(msg: "Low funds");
                                    }
                                    break;
                                }

                                break;
                              case ChatTypes.PROJECT_CHAT:
                                if (chatRoom!.currencyCode != chatServices.localMember!.get(memberModel.currencyCode)) {
                                  enumServices.transactionActionType = TransactionActionType.EXCHANGE_IN_GROUP_CHAT_OR_PROJECT_CHAT;
                                  transactionService.localCurrency = chatServices.localMember!.get(memberModel.currencyCode);
                                  transactionService.remoteCurrency = chatRoom!.currencyCode;
                                  transactionService.exchangeScreen();
                                } else {
                                  transactionService.runTransaction();
                                }
                                break;
                              case ChatTypes.FUND_RAISE:
                                // TODO: Handle this case.
                                break;
                              case ChatTypes.SUSU:
                                // TODO: Handle this case.
                                break;
                              default:
                                break;
                            }
                          } else {
                            Get.defaultDialog(
                              barrierDismissible: false,
                              title: "Insufficient funds",
                              content: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Please add funds to your wallet",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              confirm: InkWell(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(18.0),
                                      child: Text("Okay"),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  Get.back();
                                },
                              ),
                            );
                          }
                        } else {
                          Get.defaultDialog(
                            barrierDismissible: false,
                            title: "Enter amount",
                            content: const Text("Please enter an amount"),
                            confirm: InkWell(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(18.0),
                                    child: Text("Okay"),
                                  )
                                ],
                              ),
                              onTap: () {
                                Get.back();
                              },
                            ),
                          );
                        }
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
      // body: Cashapp(
      //   flexPad: 5,
      //   actionWidget: Padding(
      //     padding: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 2.5),
      //     child: ,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: ,
    );
  }
}
