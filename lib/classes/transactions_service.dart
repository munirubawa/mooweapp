import 'package:mooweapp/export_files.dart';

class TransactionServices extends GetxController {
  static TransactionServices instance = Get.find();
  DocumentSnapshot? directTransMember;
  BuildContext? context;
  DocumentSnapshot? reciever;
  Stream<double>? doubleInstance;
  RxList<TransactionPayload> userTransactions = RxList([]);
  String? requestNote = "";
  // var keyPad = locator.get<CashKeyPadNotifyer>();
  // late Contract contract = locator.get<Contract>();

  RxDouble accountBalance = RxDouble(0.0);

  @override
  void onInit() {
    // userBalance().asStream();
    userTransactions.bindStream(getAllUserTransaction());
    ever(userTransactions, (callback) => userBalance());
    ever(displayAmount, (callback) => userBalance());
    super.onInit();
  }

  //TODO: CURRENCY CONVERSION VARIABLES

  Map<String, dynamic>? data;
  // late Contract? contract;

  String? actionType;
  DocumentSnapshot? member;
  // DocumentSnapshot membr;
  ChatRoom? chatRoom;
  DocumentSnapshot? message;
  DocumentSnapshot? approveDisapproveMessagePayload;

  String? remoteCurrency;
  String? localCurrency;

  // String? exchangeLocalCurrency;
  // String? exchangeRemoteCurrency;
  // Driver? tripDriver;
//TODO:
//   Function()? setNumberDisplayState;
  List<dynamic> dynamicTransactionAmount = [];
  String stringTransactionAmount = "";
  RxDouble transactionAmount = RxDouble(0.0);
  double transactionAmountCopy = 0.0;
  RxString displayAmount = RxString("0");

  void addNumber(int number) {
    if (dynamicTransactionAmount.length < 6) {
      if (dynamicTransactionAmount.isNotEmpty && dynamicTransactionAmount.length == 1 && dynamicTransactionAmount[0] == 0) {
        dynamicTransactionAmount.removeLast();
      }
      dynamicTransactionAmount.add(number);
      joinNumbers();
    }
  }

  void removeNumber() {
    if (dynamicTransactionAmount.isNotEmpty) {
      dynamicTransactionAmount.removeLast();
    }
    if (dynamicTransactionAmount.isEmpty) {
      addNumber(0);
    }
    joinNumbers();
  }

  void addPeriod() {
    dynamicTransactionAmount.add(".");
    joinNumbers();
  }

  void joinNumbers() {
    stringTransactionAmount = dynamicTransactionAmount.join(",");
    cleanUpNumber();
  }

  cleanUpNumber() {
    displayAmount.value = stringTransactionAmount.replaceAll(RegExp(','), '');
    transactionAmount.value = double.parse(displayAmount.value);
    // setNumberDisplayState!();
  }

  setPaymentToEmpty() {
    displayAmount.value = stringTransactionAmount.replaceAll(RegExp(','), '');
    displayAmount.value = "0";
    transactionAmount.value = 0.0;
    dynamicTransactionAmount.clear();
    exchangeController.exchangeSuccess.value = false;
    // setNumberDisplayState!();
    enumServices.sameCurrencyType = SameCurrencyType.SAME_CURRENCY;
  }

  Future<void> userBalance() async {
    double credit = userTransactions.value
        .where((element) => element.payloadType == TransactionPayloadType.TRANSACTION)
        .map((item) => MooweTransactions.fromJson(item.data).credit)
        .fold(0.0, (sum, item) => sum + item!.toDouble());
    double debit = userTransactions.value
        .where((element) => element.payloadType == TransactionPayloadType.TRANSACTION)
        .map((item) => MooweTransactions.fromJson(item.data).debit)
        .fold(0.0, (sum, item) => sum + item!.toDouble());
    // transactionAmount.value  = (debit - credit).toDouble() ;
    accountBalance.value = (debit - credit);
    print(accountBalance);
    print("accountBalance.value");
  }

  Stream<TransactionPayload> getTransactionHistory(String path) => firebaseFirestore.doc(path).snapshots().map((event) => TransactionPayload.fromSnap(event));

  Stream<List<TransactionPayload>> getAllUserTransaction() =>
      firebaseFirestore.collection(dbHelper.userTransaction()).orderBy("time", descending: true).snapshots().map((query) => query.docs.map((item) => TransactionPayload.fromSnap(item)).toList());

  Future<double> chatRoomBalance() async {
    List<TransactionPayload> trans =
        await FirebaseFirestore.instance.collection(chatRoom!.chatRoomCardTransactionCollection.toString()).get().then((value) => value.docs.map((e) => TransactionPayload.fromMap(e.data())).toList());
    double credit = trans
        .where((element) => element.payloadType == TransactionPayloadType.TRANSACTION)
        .map((item) => MooweTransactions.fromJson(item.data).credit)
        .fold(0.0, (sum, item) => sum + item!.toDouble());
    double debit =
        trans.where((element) => element.payloadType == TransactionPayloadType.TRANSACTION).map((item) => MooweTransactions.fromJson(item.data).debit).fold(0.0, (sum, item) => sum + item!.toDouble());
    // userAccountBalance =transactionAmount.value  <= (debit - credit).toDouble() ;
    return (debit - credit);
  }

  void exchangeScreen() {
    exchangeController.amountToBeExchange.value = transactionAmount.value;
    exchangeController.exchangeFrom.value = localCurrency!;
    exchangeController.exchangeTo.value = remoteCurrency!;
    showModalBottomSheet(
      context: Get.context!,
      builder: (context) => Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            "Money Transfer",
            style: themeData!.textTheme.headline5!.copyWith(color: Colors.white),
          ),
        ),
        body: const MoneyTransfer(),
      ),
    );
  }

  runTransaction() async {
    print("runTransaction");
    if (paymentsController.hasePaymentMethod) {
      // transactionAmount.value = double.parse(paymentsController.numCurrency(transactionAmount.value.toDouble()));

      paymentsController.checkUserPasscode(onTap: () {
        if (enumServices.transactionActionType == TransactionActionType.RELEASE_CONTRACT_PAYMENT) {
          processTransact();
        } else {
          if (transactionAmount.value <= accountBalance.value) {
            processTransact();
          } else {
            transactionAmountCopy = transactionAmount.value;
            // paymentsController.payWithExistingPaymentMethod(amount: amount, currency: currency)
            paymentsController.payWithExistingPaymentMethod(
              amount: (transactionAmount.value.toInt().toString()),
              currency: chatServices.localMember!.get(memberModel.currencyCode)!,
            );
          }
        }
      });
    } else {
      addPaymentMethodController.addPaymentMethod();
    }
  }

  late Map<String, dynamic> remoteTransaction;
  late Map<String, dynamic> localTransaction;
  void processTransact() async {
    switch (enumServices.transactionActionType!) {
      case TransactionActionType.PAY_BILL_FROM_GROUP_CHAT:
        break;
      case TransactionActionType.SCAN_FROM_GROUP_CHAT:
        break;
      case TransactionActionType.TRANSFER_FUNDS_FROM_GROUP_CHAT_TO_A_PEER:
        switch (enumServices.sameCurrencyType) {
          case SameCurrencyType.SAME_CURRENCY:
            remoteTransaction = {
              mooweTransactionModel.firstName: "${chatRoom!.groupName}",
              mooweTransactionModel.lastName: "",
              mooweTransactionModel.currencyCode: member!.get(memberModel.currencyCode),
              mooweTransactionModel.currencySign: member!.get(memberModel.currencySign),
              mooweTransactionModel.imageUrl: chatRoom!.imageUrl,
              mooweTransactionModel.value: transactionAmount.value,
              mooweTransactionModel.credit: 0.0,
              mooweTransactionModel.debit: transactionAmount.value,
              mooweTransactionModel.timeStamp: '${DateTime.now()}',
            };

            localTransaction = {
              mooweTransactionModel.firstName: member!.get(memberModel.firstName),
              mooweTransactionModel.lastName: member!.get(memberModel.lastName),
              mooweTransactionModel.currencyCode: chatRoom!.currencyCode,
              mooweTransactionModel.currencySign: chatRoom!.currencySign,
              mooweTransactionModel.imageUrl: member!.get(memberModel.imageUrl),
              mooweTransactionModel.value: transactionAmount.value,
              mooweTransactionModel.credit: transactionAmount.value,
              mooweTransactionModel.debit: 0.0,
              mooweTransactionModel.timeStamp: '${DateTime.now()}',
            };
            break;
          case SameCurrencyType.CURRENCY_EXCHANGE:
            remoteTransaction = {
              mooweTransactionModel.firstName: "${chatRoom!.groupName}",
              mooweTransactionModel.lastName: "",
              mooweTransactionModel.currencyCode: member!.get(memberModel.currencyCode),
              mooweTransactionModel.currencySign: member!.get(memberModel.currencySign),
              mooweTransactionModel.imageUrl: chatRoom!.imageUrl,
              mooweTransactionModel.value: exchangeController.receiveRate.value,
              mooweTransactionModel.credit: 0.0,
              mooweTransactionModel.debit: exchangeController.receiveRate.value,
              mooweTransactionModel.timeStamp: '${DateTime.now()}',
            };

            localTransaction = {
              mooweTransactionModel.firstName: member!.get(memberModel.firstName),
              mooweTransactionModel.lastName: member!.get(memberModel.lastName),
              mooweTransactionModel.currencyCode: chatRoom!.currencyCode,
              mooweTransactionModel.currencySign: chatRoom!.currencySign,
              mooweTransactionModel.imageUrl: member!.get(memberModel.imageUrl),
              mooweTransactionModel.value: transactionAmount.value,
              mooweTransactionModel.credit: transactionAmount.value,
              mooweTransactionModel.debit: 0.0,
              mooweTransactionModel.timeStamp: '${DateTime.now()}',
            };
            break;
        }

        TransactionPayload remotePayload = TransactionPayload(
          data: remoteTransaction,
          cardTransactionCollectionPath: member!.get(memberModel.cardTransactionCollection),
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.INCOME,
        );
        remotePayload.sendPayload(remotePayload);

        TransactionPayload localPayload = TransactionPayload(
          data: localTransaction,
          cardTransactionCollectionPath: groupChatController.chatRoom.value.chatRoomCardTransactionCollection,
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.EXPENSE,
        );
        localPayload.sendPayload(localPayload);

        // Map<String, dynamic> moneyMessage = {
        //   moneyMessageModel.transaction: remoteTransaction,
        //   moneyMessageModel.transactionStatus: "Expense",
        //   moneyMessageModel.isTransactionReleased: false,
        //   moneyMessageModel.isTransactionProcessed: false,
        //   moneyMessageModel.transactionSentFrom: member!
        //       .get(memberModel.cardTransactionCollection),
        //   moneyMessageModel.transactionSentTo: chatRoom!.chatRoomCardTransactionCollection,
        // };
        String sentMessageString = "${chatServices.sender[memberCallInfoModel.firstName]} sent ${transactionAmount.value} ${chatRoom!.currencyCode} to ${member!.get(memberModel.firstName)}";

        chatServices.textMessage = TextMessage(time: Timestamp.now(), text: sentMessageString, read: false, senderID: chatServices.localMember!.get(memberModel.userUID));

        Map<String, dynamic> message = {
          messagePayloadModel.chatRoomChatsCollection: chatRoom!.chatRoomChatsCollection,
          messagePayloadModel.time: Timestamp.now(),
          messagePayloadModel.sender: chatServices.sender,
          messagePayloadModel.messageType: EnumToString.convertToString(ChatMessageType.MESSAGE),
          messagePayloadModel.messageGroupType: EnumToString.convertToString(chatRoom!.chatType),
          messagePayloadModel.messages: [chatServices.textMessage!.toMap()],
        };

        // chatRoom!.reference!.set({"currentBeneficiary": widget.member!.userUID!}, SetOptions(merge: true));
        chatServices.messagePayload = message;
        enumServices.chatServicesActions = ChatServicesActions.SEND_MESSAGE;
        chatServices.chatRoom = chatRoom;
        chatServices.sendToChatRoom = true;

        setPaymentToEmpty();

        for (var mem in groupChatController.groupMembers) {
          if (mem.get(memberModel.contactPath) != chatServices.localMember!.get(memberModel.contactPath)) {
            AssistantMethods.sendANotification(
              title: "${chatRoom!.groupName} expense",
              body: sentMessageString,
              token: mem.get(memberModel.deviceToken),
              notificationType: EnumToString.convertToString(NotificationDataType.MONEY_DATA),
              notificationDocPath: "",
            );
          }
        }

        chatServices.runChatServices();
        // Get.back();
        setPaymentToEmpty();
        break;
      case TransactionActionType.STORE_SCANNED_PAYMENT:
        switch (enumServices.sameCurrencyType) {
          case SameCurrencyType.SAME_CURRENCY:
            remoteTransaction = {
              mooweTransactionModel.firstName: chatServices.localMember!.get(memberModel.firstName),
              mooweTransactionModel.lastName: chatServices.localMember!.get(memberModel.lastName),
              mooweTransactionModel.currencyCode: chatServices.localMember!.get(memberModel.currencyCode),
              mooweTransactionModel.currencySign: chatServices.localMember!.get(memberModel.currencySign),
              mooweTransactionModel.imageUrl: chatServices.localMember!.get(memberModel.imageUrl),
              mooweTransactionModel.value: transactionAmount.value,
              mooweTransactionModel.credit: 0.0,
              mooweTransactionModel.debit: transactionAmount.value,
              mooweTransactionModel.timeStamp: '${DateTime.now()}',
            };

            localTransaction = {
              mooweTransactionModel.firstName: "${qrCodeController.scanPaymentData[scanPaymentModel.storeName]}",
              mooweTransactionModel.lastName: "",
              mooweTransactionModel.currencyCode: qrCodeController.scanPaymentData[scanPaymentModel.currencyCode],
              mooweTransactionModel.currencySign: qrCodeController.scanPaymentData[scanPaymentModel.currencySign],
              mooweTransactionModel.imageUrl: chatServices.localMember!.get(memberModel.imageUrl),
              mooweTransactionModel.value: transactionAmount.value,
              mooweTransactionModel.credit: transactionAmount.value,
              mooweTransactionModel.debit: 0.0,
              mooweTransactionModel.timeStamp: '${DateTime.now()}',
            };
            break;
          case SameCurrencyType.CURRENCY_EXCHANGE:
            remoteTransaction = {
              mooweTransactionModel.firstName: chatServices.localMember!.get(memberModel.firstName),
              mooweTransactionModel.lastName: chatServices.localMember!.get(memberModel.lastName),
              mooweTransactionModel.currencyCode: qrCodeController.scanPaymentData[scanPaymentModel.currencyCode],
              mooweTransactionModel.currencySign: qrCodeController.scanPaymentData[scanPaymentModel.currencySign],
              mooweTransactionModel.imageUrl: chatServices.localMember!.get(memberModel.imageUrl),
              mooweTransactionModel.value: qrCodeController.storeAmount.value,
              mooweTransactionModel.credit: 0.0,
              mooweTransactionModel.debit: qrCodeController.storeAmount.value,
              mooweTransactionModel.timeStamp: '${DateTime.now()}',
            };

            localTransaction = {
              mooweTransactionModel.firstName: "${qrCodeController.scanPaymentData[scanPaymentModel.storeName]}",
              mooweTransactionModel.lastName: "",
              mooweTransactionModel.currencyCode: chatServices.localMember!.get(memberModel.currencyCode),
              mooweTransactionModel.currencySign: chatServices.localMember!.get(memberModel.currencySign),
              mooweTransactionModel.imageUrl: chatServices.localMember!.get(memberModel.imageUrl),
              mooweTransactionModel.value: (data!["storeExchangeRate"] * qrCodeController.storeAmount.value),
              mooweTransactionModel.credit: (data!["storeExchangeRate"] * qrCodeController.storeAmount.value),
              mooweTransactionModel.debit: 0.0,
              mooweTransactionModel.timeStamp: '${DateTime.now()}',
            };
            break;
        }

        TransactionPayload remotePayload = TransactionPayload(
          data: remoteTransaction,
          cardTransactionCollectionPath: qrCodeController.scanPaymentData[scanPaymentModel.paymentPath],
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.INCOME,
        );

        TransactionPayload localPayload = TransactionPayload(
          data: localTransaction,
          cardTransactionCollectionPath: chatServices.localMember!.get(memberModel.cardTransactionCollection),
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.EXPENSE,
        );

        //##TODO if the data is coming from a group wallet camera, create a charge
        // ##TODO with group wallet data and credit the group wallet and debit the store wallet
        switch (enumServices.cameraScanLocation) {
          case CameraScanLocation.CAMERA_FROM_GROUP_CHAT:
            remoteTransaction[mooweTransactionModel.firstName] = groupChatController.chatRoom.value.groupName;
            remoteTransaction[mooweTransactionModel.lastName] = "";
            remoteTransaction[mooweTransactionModel.currencyCode] = groupChatController.chatRoom.value.currencyCode;
            remoteTransaction[mooweTransactionModel.currencySign] = groupChatController.chatRoom.value.currencySign;
            remoteTransaction[mooweTransactionModel.imageUrl] = groupChatController.chatRoom.value.imageUrl;

            localPayload.cardTransactionCollectionPath = groupChatController.chatRoom.value.chatRoomCardTransactionCollection;
            // remotePayload.sendPayload(remotePayload);
            // localPayload.sendPayload(localPayload);

            //##TODO send a message to the group about transactions
            String sentMessageString =
                "${chatServices.sender[memberCallInfoModel.firstName]} spent ${paymentsController.numCurrency(remoteTransaction[mooweTransactionModel.value])} ${chatRoom!.currencyCode} at ${qrCodeController.scanPaymentData[scanPaymentModel.storeName]}";
            chatServices.textMessage = TextMessage(time: Timestamp.now(), text: sentMessageString, read: false, senderID: chatServices.localMember!.get(memberModel.userUID));

            Map<String, dynamic> message = {
              messagePayloadModel.chatRoomChatsCollection: chatRoom!.chatRoomChatsCollection,
              messagePayloadModel.time: Timestamp.now(),
              messagePayloadModel.sender: chatServices.sender,
              messagePayloadModel.messageType: EnumToString.convertToString(ChatMessageType.MESSAGE),
              messagePayloadModel.messageGroupType: EnumToString.convertToString(chatRoom!.chatType),
              messagePayloadModel.messages: [chatServices.textMessage!.toMap()],
            };
            chatServices.messagePayload = message;
            enumServices.chatServicesActions = ChatServicesActions.SEND_MESSAGE;
            chatServices.chatRoom = chatRoom;
            chatServices.sendToChatRoom = true;
            chatServices.runChatServices();
            //##TODO -------------------------

            //##TODO send notification to everyone on this group chat
            for (var mem in groupChatController.groupMembers) {
              if (mem.get(memberModel.contactPath) != chatServices.localMember!.get(memberModel.contactPath)) {
                AssistantMethods.sendANotification(
                  title: "${chatRoom!.groupName} expense",
                  body: sentMessageString,
                  token: mem.get(memberModel.deviceToken),
                  notificationType: EnumToString.convertToString(NotificationDataType.MONEY_DATA),
                  notificationDocPath: "",
                );
              }
            }
            //##TODO -------------------------

            break;
          case CameraScanLocation.CAMERA_FROM_WALLET:
            // debugPrint("${remotePayload.toMap()}");
            // debugPrint("${localPayload.toMap()}");
            remotePayload.sendPayload(remotePayload);
            localPayload.sendPayload(localPayload);

            break;
        }

        //##TODO send notification to store owner, that payment was success
        AssistantMethods.sendANotification(
          title: "Money",
          body:
              "${chatServices.sender[memberCallInfoModel.firstName]} sent ${paymentsController.numCurrency(remoteTransaction[mooweTransactionModel.value])} ${qrCodeController.scanPaymentData[scanPaymentModel.currencyCode]}",
          token: qrCodeController.scanPaymentData[scanPaymentModel.deviceToken],
          notificationType: EnumToString.convertToString(NotificationDataType.STORE_PAYMENT),
          notificationDocPath: "",
        );
        //##TODO -------------------------

        // chatServices.runChatServices();
        Get.back();
        // qrCodeController.showSuccess();
        // setPaymentToEmpty();
        break;

      case TransactionActionType.RELEASE_CONTRACT_PAYMENT:
        TransactionPayload localPayload = TransactionPayload.fromMap(contractController.contractSnap![conModel.payments][0]);
        localPayload.data[conModel.firstName] = contractController.contractSnap![conModel.creator][conModel.firstName];
        localPayload.data[conModel.lastName] = "Contract";
        localPayload.data["timeStamp"] = '${DateTime.now()}';
        localPayload.cardTransactionCollectionPath = contractController.contractSnap![conModel.receiver]["cardTransactionCollection"];
        transactionAmount.value = localPayload.data["debit"];

        if (contractController.contractSnap![conModel.creator][conModel.currencyCode] == contractController.contractSnap![conModel.receiver][conModel.currencyCode]) {
          localPayload.sendPayload(localPayload);
        } else {
          localCurrency = contractController.contractSnap![conModel.creator][conModel.currencyCode];
          remoteCurrency = contractController.contractSnap![conModel.receiver][conModel.currencyCode];
          exchangeController.exchangeFrom.value = contractController.contractSnap![conModel.creator][conModel.currencyCode];
          exchangeController.exchangeTo.value = contractController.contractSnap![conModel.receiver][conModel.currencyCode];
          exchangeController.amountToBeExchange.value = localPayload.data["debit"];

          exchangeController.currencyExchangeConverter().then((Map<String, dynamic> data) {
            exchangeController.processContractExchange();

            localPayload.data["debit"] = exchangeController.receiveRate.value;
            localPayload.data["value"] = exchangeController.receiveRate.value;
            localPayload.sendPayload(localPayload);
            print("localPayload.toMap()");
            print(localPayload.toMap());
          });
        }
        break;
      case TransactionActionType.CHECK_OUT_PAYMENT:
        MooweTransactions remoteTransaction = MooweTransactions(
          firstName: chatServices.localMember!.get(memberModel.firstName),
          lastName: chatServices.localMember!.get(memberModel.lastName),
          currencyCode: '',
          currencySign: '',
          imageUrl: chatServices.localMember!.get(memberModel.imageUrl),
          value: transactionAmount.value,
          credit: 0.0,
          debit: transactionAmount.value,
          timeStamp: '${DateTime.now()}',
        );


        MooweTransactions localTransaction = MooweTransactions(
          firstName: "Mowe",
          lastName: "Shopping",
          currencyCode: chatServices.localMember!.get(memberModel.currencyCode),
          currencySign: chatServices.localMember!.get(memberModel.currencySign),
          imageUrl: chatServices.localMember!.get(memberModel.imageUrl),
          value: transactionAmount.value,
          credit: transactionAmount.value,
          debit: 0.0,
          timeStamp: '${DateTime.now()}',
        );

        Map<String, dynamic> data = cartController.checkOutCart.map((key, value) {
          remoteTransaction.value = value[checkOutModel.price];
          remoteTransaction.debit = value[checkOutModel.price];
          remoteTransaction.currencyCode =  value[checkOutModel.currencyCode];
          remoteTransaction.currencySign =  value[checkOutModel.currencySign];

          localTransaction.value = cartController.totalCartPrice.value;
          localTransaction.credit = cartController.totalCartPrice.value;
          value["payment"] = remoteTransaction.toMap();
          return MapEntry(key, value);
        });
        TransactionPayload localPayload = TransactionPayload(
          data: localTransaction.toMap(),
          cardTransactionCollectionPath: chatServices.localMember!.get(memberModel.cardTransactionCollection),
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.EXPENSE,
        );
        localPayload.sendPayload(localPayload);

        Map<String, dynamic> order = {};
        order["order"] = data;
        order["orderId"] = DateTime.now().microsecondsSinceEpoch.toString();
        order["buyerId"] = auth.currentUser!.uid;
        order["shipToAddress"] = cartController.shippingAddress;
        order["dateTime"] = Timestamp.now();
        order["totalAmount"] = paymentsController.numCurrency(double.parse(cartController.totalCartPrice.value.toString()));
        order["subTotalAmount"] = transactionAmount.value.toString();
        order["shippingFee"] = cartController.shippingFee;

        cartController.cart.clear();
        cartController.checkOutCart.clear();
        // print("Order transactions");
        // print(data);
        // print("Order transactionstransactionAmount.value");
        // print(paymentsController.numCurrency(transactionAmount.value.toDouble()));
        Get.back();
        Get.back();
        firebaseFirestore.collection(dbHelper.addToStoreOrders()).add(order).then((value) {
          firebaseFirestore.collection(dbHelper.addToStoreOrders()).add({"order": value.path});
          value.get().then((DocumentSnapshot snapshot) {
            enumServices.shoppingCartOrigin = ShoppingCartOrigin.SHOPPING;
            Get.to(() => OrderSuccessScreen(orderData: snapshot));
          });
        });
        break;
      case TransactionActionType.MOOWE_RIDE_CHARGE:
        // if (tripDriver!.currencyCode == chatServices.localMember!.get(memberModel.currencyCode)) {
        //   MooweTransactions localTransaction = MooweTransactions(
        //     firstName: "Mowi Ride",
        //     lastName: "",
        //     currencyCode: tripDriver!.currencyCode,
        //     currencySign: tripDriver!.currencySign,
        //     imageUrl: EnumToString.convertToString(tripDriver!.rideType),
        //     value: transactionAmount.value,
        //     credit: transactionAmount.value,
        //     debit: 0.0,
        //     timeStamp: '${DateTime.now()}',
        //   );
        //
        //   TransactionPayload localPayload = TransactionPayload(
        //     data: localTransaction.toMap(),
        //     cardTransactionCollectionPath: chatServices.localMember!.get(memberModel.cardTransactionCollection),
        //     payloadType: TransactionPayloadType.TRANSACTION,
        //     time: Timestamp.now(),
        //     transactionType: TransactionType.EXPENSE,
        //   );
        //   localPayload.sendPayload(localPayload);
        // }

        break;
      case TransactionActionType.SEND_CASH_TO_MOMO:
        // TODO: Handle this case.
        break;
      case TransactionActionType.SEND_CASH_TO_BANK_ACCOUNT:
        // TODO: Handle this case.
        break;
      case TransactionActionType.CASH_OUT_TO_BANK_ACCOUNT:
        switch (enumServices.cashOutType) {
          case CashOutType.BUSINESS_DAY:
            MooweTransactions localTransaction = MooweTransactions(
              firstName: "Cash",
              lastName: "Out",
              currencyCode: chatServices.localMember!.get(memberModel.currencyCode),
              currencySign: chatServices.localMember!.get(memberModel.currencySign),
              imageUrl: chatServices.localMember!.get(memberModel.imageUrl),
              value: transactionAmount.value,
              credit: transactionAmount.value,
              debit: 0.0,
              timeStamp: '${DateTime.now()}',
            );

            TransactionPayload localPayload = TransactionPayload(
              data: localTransaction.toMap(),
              cardTransactionCollectionPath: chatServices.localMember!.get(memberModel.cardTransactionCollection),
              payloadType: TransactionPayloadType.TRANSACTION,
              time: Timestamp.now(),
              transactionType: TransactionType.EXPENSE,
            );
            localPayload.sendPayload(localPayload);

            Get.back();
            setPaymentToEmpty();

            break;
          case CashOutType.INSTANT:
            // TODO: Handle this case.
            print(exchangeController.instantCashOutTransactionAmount.value);
            print(transactionAmount.value - exchangeController.instantCashOutCharge.value);
            exchangeController.completeInstantCashOut();
            setPaymentToEmpty();
            Get.back();

            break;
        }
        break;
      case TransactionActionType.CASH_IN_FROM_BANK:
        // TODO: Handle this case.
        MooweTransactions remoteTransaction = MooweTransactions(
          firstName: paymentsController.bankName,
          lastName: "",
          currencyCode: chatServices.localMember!.get(memberModel.currencyCode),
          currencySign: chatServices.localMember!.get(memberModel.currencySign),
          imageUrl: chatServices.localMember!.get(memberModel.imageUrl),
          value: transactionAmount.value,
          credit: 0.0,
          debit: transactionAmount.value,
          timeStamp: '${DateTime.now()}',
        );
        TransactionPayload payload = TransactionPayload(
          data: remoteTransaction.toMap(),
          cardTransactionCollectionPath: chatServices.localMember!.get(memberModel.cardTransactionCollection),
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.INCOME,
        );
        payload.sendPayload(payload);
        setPaymentToEmpty();
        break;
      case TransactionActionType.FUND_A_MEMBER:
        // TODO: Handle this case.

        var today = DateTime.now();
        var fiftyDaysFromNow = today.add(const Duration(days: 500));

        Map<String, dynamic> ApproveDisapproveData = {
          approveDisapproveMessageModel.fundReceiver: member!.data() as Map<String, dynamic>,
          approveDisapproveMessageModel.fundingAmount: transactionAmount.value,
          approveDisapproveMessageModel.approvedIds: [],
          approveDisapproveMessageModel.disapprovedIds: [],
          approveDisapproveMessageModel.message: TextMessage(
              time: Timestamp.now(), text: "Approve or Disapprove funds for ${member!.get(memberModel.firstName)}", read: false, senderID: chatServices.localMember!.get(memberModel.userUID)),
        };
        Map<String, dynamic> approveDiasapproveMessage = {
          messagePayloadModel.chatRoomChatsCollection: chatRoom!.chatRoomChatsCollection,
          messagePayloadModel.time: Timestamp.fromDate(fiftyDaysFromNow),
          messagePayloadModel.sender: chatServices.sender,
          messagePayloadModel.messageType: ChatMessageType.APPROVE_DISAPPROVE,
          messagePayloadModel.messageGroupType: chatRoom!.chatType,
          messagePayloadModel.messages: [
            ApproveDisapproveData,
          ],
        };
        chatServices.textMessage = TextMessage(
            time: Timestamp.now(), text: "Approve or Disapprove funds for ${member!.get(memberModel.firstName)}", read: false, senderID: chatServices.localMember!.get(memberModel.userUID));

        chatServices.messagePayload = approveDiasapproveMessage;
        enumServices.chatServicesActions = ChatServicesActions.SEND_MESSAGE;
        chatServices.chatRoom = chatRoom;
        chatServices.runChatServices();

        Map<String, dynamic> funding = {
          messagePayloadModel.chatRoomChatsCollection: chatRoom!.chatRoomChatsCollection,
          messagePayloadModel.time: Timestamp.now(),
          messagePayloadModel.sender: chatServices.sender,
          messagePayloadModel.messageType: ChatMessageType.FUNDING,
          messagePayloadModel.messageGroupType: chatRoom!.chatType,
          messagePayloadModel.messages: [
            FundingMessage(
              message: TextMessage(
                  time: Timestamp.now(),
                  text: "${chatServices.localUser!.get(localUserModel.firstName)} is funding ${member!.get(memberModel.firstName)} for $transactionAmount.value ${chatRoom!.currencyCode}",
                  read: false,
                  senderID: chatServices.localMember!.get(memberModel.userUID)),
            ).toMap(),
          ],
        };
        setPaymentToEmpty();
        chatServices.messagePayload = funding;
        enumServices.chatServicesActions = ChatServicesActions.SEND_MESSAGE;
        chatServices.chatRoom = chatRoom;
        chatServices.runChatServices();
        setPaymentToEmpty();
        Get.back();
        Get.back();
        showToastMessage(msg: "Funding request sent to group", backgroundColor: Colors.green);

        break;
      case TransactionActionType.SEND_CASH_DIRECT_FROM_MOOWE_PAY:
        // TODO: Handle this case.
        if (transactionAmount.value > 0) {
          // print('passed');

          // CreditCard? defaultCard = chatServices.localUser!.creditCard;
          if (chatServices.localMember!.get(memberModel.currencyCode) == member!.get(memberModel.currencyCode)) {
            MooweTransactions remoteTransaction = MooweTransactions(
              firstName: chatServices.localMember!.get(memberModel.firstName),
              lastName: chatServices.localMember!.get(memberModel.lastName),
              currencyCode: chatServices.localMember!.get(memberModel.currencyCode),
              currencySign: chatServices.localMember!.get(memberModel.currencySign),
              imageUrl: chatServices.localMember!.get(memberModel.imageUrl),
              value: transactionAmount.value,
              credit: 0.0,
              debit: transactionAmount.value,
              timeStamp: '${DateTime.now()}',
            );

            MooweTransactions localTransaction = MooweTransactions(
              firstName: "${member!.get(memberModel.firstName)}",
              lastName: "${member!.get(memberModel.lastName)}",
              currencyCode: member!.get(memberModel.currencyCode),
              currencySign: member!.get(memberModel.currencySign),
              imageUrl: member!.get(memberModel.imageUrl),
              value: transactionAmount.value,
              credit: transactionAmount.value,
              debit: 0.0,
              timeStamp: '${DateTime.now()}',
            );

            TransactionPayload payload = TransactionPayload(
              data: remoteTransaction.toMap(),
              cardTransactionCollectionPath: member!.get(memberModel.cardTransactionCollection),
              payloadType: TransactionPayloadType.TRANSACTION,
              time: Timestamp.now(),
              transactionType: TransactionType.INCOME,
            );
            payload.sendPayload(payload);

            TransactionPayload localPayload = TransactionPayload(
              data: localTransaction.toMap(),
              cardTransactionCollectionPath: chatServices.localMember!.get(memberModel.cardTransactionCollection),
              payloadType: TransactionPayloadType.TRANSACTION,
              time: Timestamp.now(),
              transactionType: TransactionType.EXPENSE,
            );
            localPayload.sendPayload(localPayload);

            showToastMessage(msg: "Success", backgroundColor: Colors.green, timeInSecForIosWeb: 6);
            setPaymentToEmpty();
          } else {
            enumServices.transactionActionType = TransactionActionType.EXCHANGE_FROM_MOOWE_PAY;
            localCurrency = chatServices.localMember!.get(memberModel.currencyCode);
            remoteCurrency = member!.get(memberModel.currencyCode);
            exchangeScreen();
          }
        } else {
          Get.back();
          showToastMessage(msg: "Enter an amount!", backgroundColor: Colors.red, timeInSecForIosWeb: 6);
        }
        break;
      case TransactionActionType.SEND_CASH_IN_PRIVATE_CHAT:
        switch (enumServices.sameCurrencyType) {
          case SameCurrencyType.SAME_CURRENCY:
            remoteTransaction = {
              mooweTransactionModel.firstName: chatServices.localMember!.get(memberModel.firstName),
              mooweTransactionModel.lastName: chatServices.localMember!.get(memberModel.lastName),
              mooweTransactionModel.currencyCode: chatServices.localMember!.get(memberModel.currencyCode),
              mooweTransactionModel.currencySign: chatServices.localMember!.get(memberModel.currencySign),
              mooweTransactionModel.imageUrl: chatServices.localMember!.get(memberModel.imageUrl),
              mooweTransactionModel.value: transactionAmount.value,
              mooweTransactionModel.credit: 0.0,
              mooweTransactionModel.debit: transactionAmount.value,
              mooweTransactionModel.timeStamp: '${DateTime.now()}',
            };

            localTransaction = {
              mooweTransactionModel.firstName: "${member!.get(memberModel.firstName)}",
              mooweTransactionModel.lastName: "${member!.get(memberModel.lastName)}",
              mooweTransactionModel.currencyCode: member!.get(memberModel.currencyCode),
              mooweTransactionModel.currencySign: member!.get(memberModel.currencySign),
              mooweTransactionModel.imageUrl: member!.get(memberModel.imageUrl),
              mooweTransactionModel.value: transactionAmount.value,
              mooweTransactionModel.credit: transactionAmount.value,
              mooweTransactionModel.debit: 0.0,
              mooweTransactionModel.timeStamp: '${DateTime.now()}',
            };
            break;
          case SameCurrencyType.CURRENCY_EXCHANGE:
            remoteTransaction = {
              mooweTransactionModel.firstName: chatServices.localMember!.get(memberModel.firstName),
              mooweTransactionModel.lastName: chatServices.localMember!.get(memberModel.lastName),
              mooweTransactionModel.currencyCode: member!.get(memberModel.currencyCode),
              mooweTransactionModel.currencySign: member!.get(memberModel.currencySign),
              mooweTransactionModel.imageUrl: chatServices.localMember!.get(memberModel.imageUrl),
              mooweTransactionModel.value: double.parse(data!["moweReceiveRate"]).toDouble(),
              mooweTransactionModel.credit: 0.0,
              mooweTransactionModel.debit: double.parse(data!["moweReceiveRate"]).toDouble(),
              mooweTransactionModel.timeStamp: '${DateTime.now()}',
            };

            localTransaction = {
              mooweTransactionModel.firstName: "${member!.get(memberModel.firstName)}",
              mooweTransactionModel.lastName: "${member!.get(memberModel.lastName)}",
              mooweTransactionModel.currencyCode: chatServices.localMember!.get(memberModel.currencyCode),
              mooweTransactionModel.currencySign: chatServices.localMember!.get(memberModel.currencySign),
              mooweTransactionModel.imageUrl: member!.get(memberModel.imageUrl),
              mooweTransactionModel.value: transactionAmount.value,
              mooweTransactionModel.credit: transactionAmount.value,
              mooweTransactionModel.debit: 0.0,
              mooweTransactionModel.timeStamp: '${DateTime.now()}',
            };
            break;
        }

        TransactionPayload payload = TransactionPayload(
          data: remoteTransaction,
          cardTransactionCollectionPath: member!.get(memberModel.cardTransactionCollection),
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.INCOME,
        );
        payload.sendPayload(payload);

        TransactionPayload localPayload = TransactionPayload(
          data: localTransaction,
          cardTransactionCollectionPath: chatServices.localMember!.get(memberModel.cardTransactionCollection),
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.EXPENSE,
        );
        localPayload.sendPayload(localPayload);

        Map<String, dynamic> moneyMessage = {
          moneyMessageModel.transaction: remoteTransaction,
          moneyMessageModel.transactionStatus: "",
          moneyMessageModel.isTransactionReleased: false,
          moneyMessageModel.isTransactionProcessed: false,
          moneyMessageModel.transactionSentFrom: chatServices.localMember!.get(memberModel.cardTransactionCollection),
          moneyMessageModel.transactionSentTo: member!.get(memberModel.cardTransactionCollection),
        };

        Map<String, dynamic> message = {
          messagePayloadModel.chatRoomChatsCollection: chatRoom!.chatRoomChatsCollection,
          messagePayloadModel.time: Timestamp.now(),
          messagePayloadModel.sender: chatServices.sender,
          messagePayloadModel.messageType: EnumToString.convertToString(ChatMessageType.MONEY),
          messagePayloadModel.messageGroupType: EnumToString.convertToString(chatRoom!.chatType),
          messagePayloadModel.messages: [moneyMessage],
        };
        String msg = "${chatServices.sender[memberCallInfoModel.firstName]} sent ${paymentsController.numCurrency(remoteTransaction[mooweTransactionModel.value])} "
            "${remoteTransaction[mooweTransactionModel.currencyCode]}";

        chatServices.textMessage = TextMessage(time: Timestamp.now(), text: msg, read: false, senderID: chatServices.localMember!.get(memberModel.userUID));
        // chatRoom!.reference!.set({"currentBeneficiary": widget.member!.userUID!}, SetOptions(merge: true));
        chatServices.messagePayload = message;
        enumServices.chatServicesActions = ChatServicesActions.SEND_MESSAGE;
        chatServices.chatRoom = chatRoom;

        AssistantMethods.sendANotification(
          title: "Money",
          body: msg,
          token: member!.get(memberModel.deviceToken).toString(),
          notificationType: EnumToString.convertToString(NotificationDataType.MONEY_DATA),
          notificationDocPath: "",
        );

        chatServices.runChatServices();
        Get.back();
        setPaymentToEmpty();

        break;
      case TransactionActionType.SEND_CASH_IN_GROUP_CHAT:
        switch (enumServices.sameCurrencyType) {
          case SameCurrencyType.SAME_CURRENCY:
            remoteTransaction = {
              mooweTransactionModel.firstName: chatServices.localMember!.get(memberModel.firstName),
              mooweTransactionModel.lastName: chatServices.localMember!.get(memberModel.lastName),
              mooweTransactionModel.currencyCode: chatServices.localMember!.get(memberModel.currencyCode),
              mooweTransactionModel.currencySign: chatServices.localMember!.get(memberModel.currencySign),
              mooweTransactionModel.imageUrl: chatServices.localMember!.get(memberModel.imageUrl),
              mooweTransactionModel.value: transactionAmount.value,
              mooweTransactionModel.credit: 0.0,
              mooweTransactionModel.debit: transactionAmount.value,
              mooweTransactionModel.timeStamp: '${DateTime.now()}',
            };

            localTransaction = {
              mooweTransactionModel.firstName: "${chatRoom!.groupName}",
              mooweTransactionModel.lastName: "",
              mooweTransactionModel.currencyCode: chatRoom!.currencyCode,
              mooweTransactionModel.currencySign: chatRoom!.currencySign,
              mooweTransactionModel.imageUrl: chatRoom!.imageUrl,
              mooweTransactionModel.value: transactionAmount.value,
              mooweTransactionModel.credit: transactionAmount.value,
              mooweTransactionModel.debit: 0.0,
              mooweTransactionModel.timeStamp: '${DateTime.now()}',
            };
            break;
          case SameCurrencyType.CURRENCY_EXCHANGE:
            remoteTransaction = {
              mooweTransactionModel.firstName: chatServices.localMember!.get(memberModel.firstName),
              mooweTransactionModel.lastName: chatServices.localMember!.get(memberModel.lastName),
              mooweTransactionModel.currencyCode: chatRoom!.currencyCode,
              mooweTransactionModel.currencySign: chatRoom!.currencySign,
              mooweTransactionModel.imageUrl: chatServices.localMember!.get(memberModel.imageUrl),
              mooweTransactionModel.value: double.parse(data!["moweReceiveRate"]).toDouble(),
              mooweTransactionModel.credit: 0.0,
              mooweTransactionModel.debit: double.parse(data!["moweReceiveRate"]).toDouble(),
              mooweTransactionModel.timeStamp: '${DateTime.now()}',
            };

            localTransaction = {
              mooweTransactionModel.firstName: "${chatRoom!.groupName}",
              mooweTransactionModel.lastName: "",
              mooweTransactionModel.currencyCode: chatServices.localMember!.get(memberModel.currencyCode),
              mooweTransactionModel.currencySign: chatServices.localMember!.get(memberModel.currencySign),
              mooweTransactionModel.imageUrl: chatRoom!.imageUrl,
              mooweTransactionModel.value: transactionAmount.value,
              mooweTransactionModel.credit: transactionAmount.value,
              mooweTransactionModel.debit: 0.0,
              mooweTransactionModel.timeStamp: '${DateTime.now()}',
            };
            break;
        }

        TransactionPayload payload = TransactionPayload(
          data: remoteTransaction,
          cardTransactionCollectionPath: chatRoom!.chatRoomCardTransactionCollection,
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.INCOME,
        );
        payload.sendPayload(payload);

        TransactionPayload localPayload = TransactionPayload(
          data: localTransaction,
          cardTransactionCollectionPath: chatServices.localMember!.get(memberModel.cardTransactionCollection),
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.EXPENSE,
        );
        localPayload.sendPayload(localPayload);
        Map<String, dynamic> moneyMessage = {
          moneyMessageModel.transaction: remoteTransaction,
          moneyMessageModel.transactionStatus: "CONTRIBUTION",
          moneyMessageModel.isTransactionReleased: false,
          moneyMessageModel.isTransactionProcessed: false,
          moneyMessageModel.transactionSentFrom: chatServices.localMember!.get(memberModel.cardTransactionCollection),
          moneyMessageModel.transactionSentTo: chatRoom!.chatRoomCardTransactionCollection,
        };
        Map<String, dynamic> message = {
          messagePayloadModel.chatRoomChatsCollection: chatRoom!.chatRoomChatsCollection,
          messagePayloadModel.time: Timestamp.now(),
          messagePayloadModel.sender: chatServices.sender,
          messagePayloadModel.messageType: EnumToString.convertToString(ChatMessageType.MONEY),
          messagePayloadModel.messageGroupType: EnumToString.convertToString(chatRoom!.chatType),
          messagePayloadModel.messages: [moneyMessage],
        };
        chatServices.textMessage = TextMessage(
            time: Timestamp.now(),
            text:
                "${chatServices.sender[memberCallInfoModel.firstName]} ${paymentsController.numCurrency(remoteTransaction[mooweTransactionModel.value])} ${remoteTransaction[mooweTransactionModel.currencyCode]}",
            read: false,
            senderID: chatServices.localMember!.get(memberModel.userUID));
        // chatRoom!.reference!.set({"currentBeneficiary": widget.member!.userUID!}, SetOptions(merge: true));
        chatServices.messagePayload = message;
        enumServices.chatServicesActions = ChatServicesActions.SEND_MESSAGE;
        chatServices.chatRoom = chatRoom;
        chatServices.sendToChatRoom = true;

        for (var contactPath in chatRoom!.members!) {
          if (contactPath != chatServices.localMember!.get(memberModel.contactPath)) {
            FirebaseFirestore.instance.doc(contactPath).get().then((value) {
              DocumentSnapshot receiver = value;
              AssistantMethods.sendANotification(
                title: "Contribution",
                body:
                    "${chatServices.sender[memberCallInfoModel.firstName]} sent ${paymentsController.numCurrency(remoteTransaction[mooweTransactionModel.value])} ${remoteTransaction[mooweTransactionModel.currencyCode]}",
                token: receiver.get(memberModel.deviceToken),
                notificationType: EnumToString.convertToString(NotificationDataType.MONEY_DATA),
                notificationDocPath: "",
              );
            });
          }
        }

        chatServices.runChatServices();

        Get.back();
        setPaymentToEmpty();
        break;
      case TransactionActionType.SEND_CASH_PROJECT_CHAT:
        // TODO: Handle this case.
        // final keyPad = locator.get<CashKeyPadNotifyer>();

        // CreditCard? groupCard = creditCard;
        if (transactionAmount.value > 0 && transactionAmount.value <= accountBalance.value) {
          print('balance');

          // CreditCard defaultCard = CreditCard.fromMap(chatServices.localUser!.get(localUserModel.creditCard));
          if (chatServices.localMember!.get(memberModel.currencyCode) == chatRoom!.currencyCode) {
            Map<String, dynamic> remoteTransaction = {
              mooweTransactionModel.firstName: chatServices.localMember!.get(memberModel.firstName),
              mooweTransactionModel.lastName: chatServices.localMember!.get(memberModel.lastName),
              mooweTransactionModel.currencyCode: chatServices.localMember!.get(memberModel.currencyCode),
              mooweTransactionModel.currencySign: chatServices.localMember!.get(memberModel.currencySign),
              mooweTransactionModel.imageUrl: chatServices.localMember!.get(memberModel.imageUrl),
              mooweTransactionModel.value: transactionAmount.value,
              mooweTransactionModel.credit: 0.0,
              mooweTransactionModel.debit: transactionAmount.value,
              mooweTransactionModel.timeStamp: '${DateTime.now()}',
            };

            Map<String, dynamic> localTransaction = {
              mooweTransactionModel.firstName: "${chatRoom!.groupName}",
              mooweTransactionModel.lastName: "",
              mooweTransactionModel.currencyCode: chatRoom!.currencyCode,
              mooweTransactionModel.currencySign: chatRoom!.currencySign,
              mooweTransactionModel.imageUrl: chatRoom!.imageUrl,
              mooweTransactionModel.value: transactionAmount.value,
              mooweTransactionModel.credit: transactionAmount.value,
              mooweTransactionModel.debit: 0.0,
              mooweTransactionModel.timeStamp: '${DateTime.now()}',
            };

            TransactionPayload payload = TransactionPayload(
              data: remoteTransaction,
              cardTransactionCollectionPath: chatRoom!.chatRoomCardTransactionCollection,
              payloadType: TransactionPayloadType.TRANSACTION,
              time: Timestamp.now(),
              transactionType: TransactionType.INCOME,
            );
            payload.sendPayload(payload);

            TransactionPayload localPayload = TransactionPayload(
              data: localTransaction,
              cardTransactionCollectionPath: chatServices.localMember!.get(memberModel.cardTransactionCollection),
              payloadType: TransactionPayloadType.TRANSACTION,
              time: Timestamp.now(),
              transactionType: TransactionType.EXPENSE,
            );
            localPayload.sendPayload(localPayload);
            Map<String, dynamic> moneyMessage = {
              moneyMessageModel.transaction: remoteTransaction,
              moneyMessageModel.transactionStatus: "CONTRIBUTION",
              moneyMessageModel.isTransactionReleased: false,
              moneyMessageModel.isTransactionProcessed: false,
              moneyMessageModel.transactionSentFrom: chatServices.localMember!.get(memberModel.cardTransactionCollection),
              moneyMessageModel.transactionSentTo: chatRoom!.chatRoomCardTransactionCollection,
            };
            Map<String, dynamic> message = {
              messagePayloadModel.chatRoomChatsCollection: chatRoom!.chatRoomChatsCollection,
              messagePayloadModel.time: Timestamp.now(),
              messagePayloadModel.sender: chatServices.sender,
              messagePayloadModel.messageType: EnumToString.convertToString(ChatMessageType.MONEY),
              messagePayloadModel.messageGroupType: EnumToString.convertToString(chatRoom!.chatType),
              messagePayloadModel.messages: [moneyMessage],
            };
            chatServices.textMessage = TextMessage(
                time: Timestamp.now(),
                text: "${chatServices.sender[messageSenderModel.firstName]} ${transactionAmount.value} ${chatServices.localMember!.get(memberModel.currencyCode)}",
                read: false,
                senderID: chatServices.localMember!.get(memberModel.userUID));
            chatServices.messagePayload = message;
            enumServices.chatServicesActions = ChatServicesActions.SEND_MESSAGE;
            chatServices.chatRoom = chatRoom;
            chatServices.runChatServices();

            Get.back();
            setPaymentToEmpty();
          } else {
            enumServices.transactionActionType = TransactionActionType.EXCHANGE_IN_GROUP_CHAT_OR_PROJECT_CHAT;
            localCurrency = chatServices.localMember!.get(memberModel.currencyCode);
            remoteCurrency = chatRoom!.currencyCode;

            exchangeScreen();
          }
        } else {
          if (kDebugMode) {
            print('cash is empty');
          }
          showToastMessage(msg: "Enter an amount!", backgroundColor: Colors.red, timeInSecForIosWeb: 6);
        }
        break;

      case TransactionActionType.PAY_INTO_CONTRACT:
        break;
      case TransactionActionType.PROCESS_CONTRACT:
        // TODO: Handle this case.
        // if (groupCard!.balance() >= (contract!.contractAmount! / contract!.numberOfPayment!)) {
        MooweTransactions remoteTransaction = MooweTransactions(
          firstName: chatRoom!.groupName,
          lastName: "",
          currencyCode: chatServices.localMember!.get(memberModel.currencyCode),
          currencySign: chatServices.localMember!.get(memberModel.currencySign),
          imageUrl: chatRoom!.imageUrl,
          value: transactionAmount.value,
          credit: 0.0,
          debit: transactionAmount.value,
          timeStamp: '${DateTime.now()}',
        );

        MooweTransactions localTransaction = MooweTransactions(
          firstName: "Contract eScroll",
          lastName: "",
          currencyCode: chatServices.localMember!.get(memberModel.currencyCode),
          currencySign: chatServices.localMember!.get(memberModel.currencySign),
          imageUrl: chatRoom!.imageUrl,
          value: transactionAmount.value,
          credit: transactionAmount.value,
          debit: 0.0,
          timeStamp: '${DateTime.now()}',
        );

        TransactionPayload payload = TransactionPayload(
          data: remoteTransaction.toMap(),
          cardTransactionCollectionPath: "",
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.INCOME,
        );
        // payload.sendPayload(payload);

        TransactionPayload localPayload = TransactionPayload(
          data: localTransaction.toMap(),
          cardTransactionCollectionPath: chatServices.localMember!.get(memberModel.cardTransactionCollection),
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.EXPENSE,
        );
        localPayload.sendPayload(localPayload);

        // contract!.contractProjectName = chatRoom!.groupName;
        // contract!.contractStatus = "Pending";
        // contract!.timeStamp = Timestamp.now();

        Map<String, dynamic> texMessage = {
          'time': Timestamp.now(),
          'text': "A contract was successfully created between "
              " ${contractController.creatorFirstName.value}  ${contractController.creatorLastName.value} "
              " and ${contractController.receiverFirstName.value} ${contractController.receiverLastName.value}",
          'read': false,
          'senderID': chatServices.localMember!.get(memberModel.userUID),
        };

        Map<String, dynamic> message = {
          messagePayloadModel.chatRoomChatsCollection: chatRoom!.chatRoomChatsCollection,
          messagePayloadModel.time: Timestamp.now(),
          messagePayloadModel.sender: chatServices.sender,
          messagePayloadModel.messageType: EnumToString.convertToString(ChatMessageType.CONTRACT),
          messagePayloadModel.messageGroupType: EnumToString.convertToString(chatRoom!.chatType),
          messagePayloadModel.messages: [
            texMessage,
          ],
        };
        chatServices.textMessage = TextMessage(
          time: Timestamp.now(),
          text: "A contract was successfully created between "
              " ${contractController.creatorFirstName.value}  ${contractController.creatorLastName.value} "
              " and ${contractController.receiverFirstName.value} ${contractController.receiverLastName.value}",
          read: false,
          senderID: chatServices.localMember!.get(memberModel.userUID),
        );

        contractController.contract[conModel.status] = "Pending";
        contractController.contract[conModel.payments] = [payload.toMap()];
        DocumentReference contractReference = await firebaseFirestore.collection(dbHelper.contracts()).add(contractController.contract);
        texMessage["contractId"] = contractReference.id;
        chatServices.messagePayload = message;
        enumServices.chatServicesActions = ChatServicesActions.SEND_MESSAGE;
        chatServices.chatRoom = chatRoom;
        // DocumentReference contractReference = await FirebaseFirestore.instance.collection("contracts").add(contract!.toMap());
        // DocumentReference cardReference = await FirebaseFirestore.instance.collection("contracts/${contractReference.id}/card").add(contract!.creditCard!.toMap());
        // FirebaseFirestore.instance.collection("contracts/${contractReference.id}/transactions").add(remoteTransaction.toMap());
        // contractReference.update({
        //   "cardDocId": cardReference.path,
        //   "transactionCollection": "contracts/${contractReference.id}/transactions",
        //   "profOfWorkCollection": "contracts/${contractReference.id}/profOfWork",
        // });
        // cardReference.update(
        //   {
        //     'leanAmount': FieldValue.arrayUnion(
        //       [(contract!.contractAmount! - (contract!.contractAmount! / contract!.numberOfPayment!))],
        //     )
        //   },
        // );
        chatServices.runChatServices();
        Get.back();
        // setNumberDisplayState = () {};
        setPaymentToEmpty();
        break;
      case TransactionActionType.SEND_CONVERTED_CURRENCY:
        // TODO: Handle this case
        break;
      case TransactionActionType.EXCHANGE_IN_PRIVATE_CHAT:
        // TODO: Handle this case.
        Map<String, dynamic> remoteTransaction = {
          mooweTransactionModel.firstName: chatServices.localMember!.get(memberModel.firstName),
          mooweTransactionModel.lastName: chatServices.localMember!.get(memberModel.lastName),
          mooweTransactionModel.currencyCode: member!.get(memberModel.currencyCode),
          mooweTransactionModel.currencySign: member!.get(memberModel.currencySign),
          mooweTransactionModel.imageUrl: chatServices.localMember!.get(memberModel.imageUrl),
          mooweTransactionModel.value: double.parse(data!["moweReceiveRate"]).toDouble(),
          mooweTransactionModel.credit: 0.0,
          mooweTransactionModel.debit: double.parse(data!["moweReceiveRate"]).toDouble(),
          mooweTransactionModel.timeStamp: '${DateTime.now()}',
        };

        Map<String, dynamic> localTransaction = {
          mooweTransactionModel.firstName: "${member!.get(memberModel.firstName)}",
          mooweTransactionModel.lastName: "${member!.get(memberModel.lastName)}",
          mooweTransactionModel.currencyCode: chatServices.localMember!.get(memberModel.currencyCode),
          mooweTransactionModel.currencySign: chatServices.localMember!.get(memberModel.currencySign),
          mooweTransactionModel.imageUrl: member!.get(memberModel.imageUrl),
          mooweTransactionModel.value: transactionAmount.value,
          mooweTransactionModel.credit: transactionAmount.value,
          mooweTransactionModel.debit: 0.0,
          mooweTransactionModel.timeStamp: '${DateTime.now()}',
        };

        TransactionPayload payload = TransactionPayload(
          data: remoteTransaction,
          cardTransactionCollectionPath: member!.get(memberModel.cardTransactionCollection),
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.INCOME,
        );
        payload.sendPayload(payload);

        TransactionPayload localPayload = TransactionPayload(
          data: localTransaction,
          cardTransactionCollectionPath: chatServices.localMember!.get(memberModel.cardTransactionCollection),
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.EXPENSE,
        );
        localPayload.sendPayload(localPayload);
        Map<String, dynamic> moneyMessageData = {
          moneyMessageModel.transaction: remoteTransaction,
          moneyMessageModel.transactionStatus: "eScroll",
          moneyMessageModel.isTransactionReleased: false,
          moneyMessageModel.isTransactionProcessed: false,
          moneyMessageModel.transactionSentFrom: chatServices.localMember!.get(memberModel.cardTransactionCollection),
          moneyMessageModel.transactionSentTo: member!.get(memberModel.cardTransactionCollection),
        };
        Map<String, dynamic> message = {
          messagePayloadModel.chatRoomChatsCollection: chatRoom!.chatRoomChatsCollection,
          messagePayloadModel.time: Timestamp.now(),
          messagePayloadModel.sender: chatServices.sender,
          messagePayloadModel.messageType: EnumToString.convertToString(ChatMessageType.MONEY),
          messagePayloadModel.messageGroupType: EnumToString.convertToString(chatRoom!.chatType),
          messagePayloadModel.messages: [moneyMessageData],
        };
        chatServices.textMessage = TextMessage(
            time: Timestamp.now(),
            text:
                "${chatServices.sender[messageSenderModel.firstName]} sent ${paymentsController.numCurrency(double.parse(data!["moweReceiveRate"]).toDouble())} ${member!.get(memberModel.currencyCode)}",
            read: false,
            senderID: chatServices.localMember!.get(memberModel.userUID));
        chatServices.messagePayload = message;
        enumServices.chatServicesActions = ChatServicesActions.SEND_MESSAGE;
        chatServices.chatRoom = chatRoom;
        chatServices.runChatServices();
        Get.back();
        Get.back();
        // setNumberDisplayState = (){};
        // setPaymentToEmpty();

        break;
      case TransactionActionType.EXCHANGE_IN_GROUP_CHAT_OR_PROJECT_CHAT:
        // TODO: Handle this case.
        Map<String, dynamic> remoteTransaction = {
          mooweTransactionModel.firstName: chatServices.localMember!.get(memberModel.firstName),
          mooweTransactionModel.lastName: chatServices.localMember!.get(memberModel.lastName),
          mooweTransactionModel.currencyCode: chatRoom!.currencyCode,
          mooweTransactionModel.currencySign: chatRoom!.currencySign,
          mooweTransactionModel.imageUrl: chatServices.localMember!.get(memberModel.imageUrl),
          mooweTransactionModel.value: double.parse(data!["moweReceiveRate"]).toDouble(),
          mooweTransactionModel.credit: 0.0,
          mooweTransactionModel.debit: double.parse(data!["moweReceiveRate"]).toDouble(),
          mooweTransactionModel.timeStamp: '${DateTime.now()}',
        };

        Map<String, dynamic> localTransaction = {
          mooweTransactionModel.firstName: "${chatRoom!.groupName}",
          mooweTransactionModel.lastName: "",
          mooweTransactionModel.currencyCode: chatServices.localMember!.get(memberModel.currencyCode),
          mooweTransactionModel.currencySign: chatServices.localMember!.get(memberModel.currencySign),
          mooweTransactionModel.imageUrl: chatRoom!.imageUrl,
          mooweTransactionModel.value: transactionAmount.value,
          mooweTransactionModel.credit: transactionAmount.value,
          mooweTransactionModel.debit: 0.0,
          mooweTransactionModel.timeStamp: '${DateTime.now()}',
        };

        TransactionPayload payload = TransactionPayload(
          data: remoteTransaction,
          cardTransactionCollectionPath: chatRoom!.chatRoomCardTransactionCollection,
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.INCOME,
        );
        payload.sendPayload(payload);

        TransactionPayload localPayload = TransactionPayload(
          data: localTransaction,
          cardTransactionCollectionPath: chatServices.localMember!.get(memberModel.cardTransactionCollection),
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.EXPENSE,
        );
        localPayload.sendPayload(localPayload);
        Map<String, dynamic> moneyMessage = {
          moneyMessageModel.transaction: remoteTransaction,
          moneyMessageModel.transactionStatus: "CONTRIBUTION",
          moneyMessageModel.isTransactionReleased: false,
          moneyMessageModel.isTransactionProcessed: false,
          moneyMessageModel.transactionSentFrom: chatServices.localMember!.get(memberModel.cardTransactionCollection),
          moneyMessageModel.transactionSentTo: chatRoom!.chatRoomCardTransactionCollection,
        };
        Map<String, dynamic> message = {
          messagePayloadModel.chatRoomChatsCollection: chatRoom!.chatRoomChatsCollection,
          messagePayloadModel.time: Timestamp.now(),
          messagePayloadModel.sender: chatServices.sender,
          messagePayloadModel.messageType: EnumToString.convertToString(ChatMessageType.MONEY),
          messagePayloadModel.messageGroupType: EnumToString.convertToString(chatRoom!.chatType),
          messagePayloadModel.messages: [moneyMessage],
        };
        chatServices.textMessage = TextMessage(
            time: Timestamp.now(),
            text: "${chatServices.sender[messageSenderModel.firstName]} sent ${paymentsController.numCurrency(double.parse(data!["moweReceiveRate"]).toDouble())} ${chatRoom!.currencyCode}",
            read: false,
            senderID: chatServices.localMember!.get(memberModel.userUID));
        chatServices.messagePayload = message;
        enumServices.chatServicesActions = ChatServicesActions.SEND_MESSAGE;
        chatServices.chatRoom = chatRoom;
        chatServices.sendToChatRoom = true;

        for (var contactPath in chatRoom!.members!) {
          if (contactPath != chatServices.localMember!.get(memberModel.contactPath)) {
            FirebaseFirestore.instance.doc(contactPath).get().then((value) {
              DocumentSnapshot receiver = value;
              AssistantMethods.sendANotification(
                title: "Contribution",
                body: "${chatServices.sender[messageSenderModel.firstName]} sent ${double.parse(data!["moweReceiveRate"]).toDouble()} ${chatRoom!.currencyCode}",
                token: receiver.get(memberModel.deviceToken),
                notificationType: EnumToString.convertToString(NotificationDataType.MONEY_DATA),
                notificationDocPath: "",
              );
            });
          }
        }

        chatServices.runChatServices();

        Get.back();
        Get.back();
        setPaymentToEmpty();

        break;
      case TransactionActionType.EXCHANGE_FROM_MOOWE_PAY:
        // TODO: Handle this case.
        MooweTransactions remoteTransaction = MooweTransactions(
          firstName: chatServices.localMember!.get(memberModel.firstName),
          lastName: chatServices.localMember!.get(memberModel.lastName),
          currencyCode: member!.get(memberModel.currencyCode),
          currencySign: member!.get(memberModel.currencySign),
          imageUrl: chatServices.member!.get(memberModel.imageUrl),
          value: double.parse(data!["moweReceiveRate"]).toDouble(),
          credit: 0.0,
          debit: double.parse(data!["moweReceiveRate"]).toDouble(),
          timeStamp: '${DateTime.now()}',
        );

        MooweTransactions localTransaction = MooweTransactions(
          firstName: "${member!.get(memberModel.firstName)}",
          lastName: "${member!.get(memberModel.lastName)}",
          currencyCode: chatRoom!.currencyCode,
          currencySign: chatRoom!.currencySign,
          imageUrl: member!.get(memberModel.imageUrl),
          value: transactionAmount.value,
          credit: transactionAmount.value,
          debit: 0.0,
          timeStamp: '${DateTime.now()}',
        );

        TransactionPayload payload = TransactionPayload(
          data: remoteTransaction.toMap(),
          cardTransactionCollectionPath: member!.get(memberModel.cardTransactionCollection),
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.INCOME,
        );
        payload.sendPayload(payload);

        TransactionPayload localPayload = TransactionPayload(
          data: localTransaction.toMap(),
          cardTransactionCollectionPath: chatRoom!.chatRoomCardTransactionCollection,
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.EXPENSE,
        );
        localPayload.sendPayload(localPayload);

        AssistantMethods.sendANotification(
          title: "Contribution",
          body: "${chatServices.sender[messageSenderModel.firstName]} sent ${paymentsController.numCurrency(double.parse(data!["moweReceiveRate"]).toDouble())} ${chatRoom!.currencyCode}",
          token: member!.get(memberModel.deviceToken).toString(),
          notificationType: EnumToString.convertToString(NotificationDataType.MONEY_DATA),
          notificationDocPath: "",
        );
        break;
      case TransactionActionType.SEND_CASH_WITH_PROJECT_SCAN_CAMERA:
        break;
      case TransactionActionType.OFFLINE_TRANSACTION:
        break;
      case TransactionActionType.SCAN_QR_CODE_FROM_MOOWE_PAY:
        break;
      case TransactionActionType.PROCESS_CHAT_GROUP_FUNDING:
        // TODO: Handle this case.
        print("process successful");
        print(transactionAmount.value);

        print("chatRoomBalance()");
        print(await chatRoomBalance());

        if (transactionAmount.value > 0) {
          // print('passed');
          ApproveDisapproveMessage appDisApp = ApproveDisapproveMessage.fromMap(approveDisapproveMessagePayload!.get(messagePayloadModel.messages)[0]);
          DocumentSnapshot? beneficiary = appDisApp.fundReceiver;
          if (chatRoom!.currencyCode == beneficiary!.get(memberModel.currencyCode)) {
            MooweTransactions remoteTransaction = MooweTransactions(
              firstName: chatRoom!.groupName,
              lastName: "",
              currencyCode: beneficiary.get(memberModel.currencyCode),
              currencySign: beneficiary.get(memberModel.currencySign),
              imageUrl: chatRoom!.imageUrl,
              value: appDisApp.fundingAmount,
              credit: 0.0,
              debit: appDisApp.fundingAmount,
              timeStamp: '${DateTime.now()}',
            );

            MooweTransactions localTransaction = MooweTransactions(
              firstName: "${beneficiary.get(memberModel.firstName)}",
              lastName: "${beneficiary.get(memberModel.lastName)}",
              currencyCode: chatRoom!.currencyCode,
              currencySign: chatRoom!.currencySign,
              imageUrl: chatRoom!.imageUrl,
              value: appDisApp.fundingAmount,
              credit: appDisApp.fundingAmount,
              debit: 0.0,
              timeStamp: '${DateTime.now()}',
            );

            TransactionPayload payload = TransactionPayload(
              data: remoteTransaction.toMap(),
              cardTransactionCollectionPath: chatRoom!.chatRoomCardTransactionCollection,
              payloadType: TransactionPayloadType.TRANSACTION,
              time: Timestamp.now(),
              transactionType: TransactionType.INCOME,
            );
            payload.sendPayload(payload);

            TransactionPayload localPayload = TransactionPayload(
              data: localTransaction.toMap(),
              cardTransactionCollectionPath: chatServices.localMember!.get(memberModel.cardTransactionCollection),
              payloadType: TransactionPayloadType.TRANSACTION,
              time: Timestamp.now(),
              transactionType: TransactionType.EXPENSE,
            );
            localPayload.sendPayload(localPayload);

            Map<String, dynamic> messagePayload = {
              messagePayloadModel.chatRoomChatsCollection: chatRoom!.chatRoomChatsCollection,
              messagePayloadModel.time: Timestamp.now(),
              messagePayloadModel.sender: chatServices.sender,
              messagePayloadModel.messageType: ChatMessageType.FUNDING_COMPLETE,
              messagePayloadModel.messageGroupType: chatRoom!.chatType,
              messagePayloadModel.messages: [
                FundingCompleteMessage(
                  message: TextMessage(time: Timestamp.now(), text: "FUNDING COMPLETE", read: false, senderID: chatServices.localMember!.get(memberModel.userUID)),
                ).toMap(),
              ],
            };
            chatServices.textMessage = TextMessage(time: Timestamp.now(), text: "FUNDING COMPLETE", read: false, senderID: chatServices.localMember!.get(memberModel.userUID));
            // chatRoom!.reference!.set({"currentBeneficiary": widget.member!.userUID!}, SetOptions(merge: true));
            chatServices.messagePayload = messagePayload;
            enumServices.chatServicesActions = ChatServicesActions.SEND_MESSAGE;
            chatServices.chatRoom = chatRoom;
            chatServices.runChatServices();
            //setNumberDisplayState = () {};
            setPaymentToEmpty();
          } else {
            enumServices.transactionActionType = TransactionActionType.EXCHANGE_GROUP_FUNDING;
            localCurrency = chatServices.localMember!.get(memberModel.currencyCode);
            remoteCurrency = beneficiary.get(memberModel.currencyCode);
            Get.back();
            exchangeScreen();
          }
        } else {
          showToastMessage(msg: "Enter an amount!", backgroundColor: Colors.red, timeInSecForIosWeb: 6);
        }

        break;
      case TransactionActionType.EXCHANGE_GROUP_FUNDING:
        // TODO: Handle this case.
        ApproveDisapproveMessage appDisApp = ApproveDisapproveMessage.fromMap(approveDisapproveMessagePayload!.get(messagePayloadModel.messages)[0]);
        MooweTransactions remoteTransaction = MooweTransactions(
          firstName: chatRoom!.groupName,
          lastName: "",
          currencyCode: member!.get(memberModel.currencyCode),
          currencySign: member!.get(memberModel.currencySign),
          imageUrl: chatServices.member!.get(memberModel.imageUrl),
          value: double.parse(data!["moweReceiveRate"]).toDouble(),
          credit: 0.0,
          debit: double.parse(data!["moweReceiveRate"]).toDouble(),
          timeStamp: '${DateTime.now()}',
        );

        MooweTransactions localTransaction = MooweTransactions(
          firstName: "${member!.get(memberModel.firstName)}",
          lastName: "${member!.get(memberModel.lastName)}",
          currencyCode: chatRoom!.currencyCode,
          currencySign: chatRoom!.currencySign,
          imageUrl: member!.get(memberModel.imageUrl),
          value: appDisApp.fundingAmount,
          credit: appDisApp.fundingAmount,
          debit: 0.0,
          timeStamp: '${DateTime.now()}',
        );

        TransactionPayload payload = TransactionPayload(
          data: remoteTransaction.toMap(),
          cardTransactionCollectionPath: member!.get(memberModel.cardTransactionCollection),
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.INCOME,
        );
        payload.sendPayload(payload);

        TransactionPayload localPayload = TransactionPayload(
          data: localTransaction.toMap(),
          cardTransactionCollectionPath: chatRoom!.chatRoomCardTransactionCollection,
          payloadType: TransactionPayloadType.TRANSACTION,
          time: Timestamp.now(),
          transactionType: TransactionType.EXPENSE,
        );
        localPayload.sendPayload(localPayload);

        Map<String, dynamic> message = {
          messagePayloadModel.chatRoomChatsCollection: chatRoom!.chatRoomChatsCollection,
          messagePayloadModel.time: Timestamp.now(),
          messagePayloadModel.sender: chatServices.sender,
          messagePayloadModel.messageType: ChatMessageType.FUNDING_COMPLETE,
          messagePayloadModel.messageGroupType: chatRoom!.chatType,
          messagePayloadModel.messages: [
            FundingCompleteMessage(
              message: TextMessage(time: Timestamp.now(), text: "FUNDING COMPLETE", read: false, senderID: chatServices.localMember!.get(memberModel.userUID)),
            ).toMap(),
          ],
        };

        chatServices.textMessage = TextMessage(time: Timestamp.now(), text: "FUNDING COMPLETE", read: false, senderID: chatServices.localMember!.get(memberModel.userUID));
        // chatRoom!.reference!.set({"currentBeneficiary": widget.member!.userUID!}, SetOptions(merge: true));
        chatServices.messagePayload = message;
        enumServices.chatServicesActions = ChatServicesActions.SEND_MESSAGE;
        chatServices.chatRoom = chatRoom;
        chatServices.runChatServices();
        //setNumberDisplayState = () {};
        setPaymentToEmpty();

        break;
      case TransactionActionType.BILL_PAY:
        // TODO: Handle this case.
        break;
      case TransactionActionType.REQUEST_PAYMENT:
        // TODO: Handle this case.
        MooweTransactions remoteTransaction = MooweTransactions(
          firstName: chatServices.localMember!.get(memberModel.firstName),
          lastName: chatServices.localMember!.get(memberModel.lastName),
          currencyCode: chatServices.localMember!.get(memberModel.currencyCode),
          currencySign: chatServices.localMember!.get(memberModel.currencySign),
          imageUrl: chatServices.localMember!.get(memberModel.imageUrl),
          value: transactionAmount.value,
          credit: 0.0,
          debit: 0.0,
          timeStamp: '${DateTime.now()}',
        );

        Map<String, dynamic> message = {
          messagePayloadModel.chatRoomChatsCollection: chatRoom!.chatRoomChatsCollection,
          messagePayloadModel.time: Timestamp.now(),
          messagePayloadModel.sender: chatServices.sender,
          messagePayloadModel.messageType: ChatMessageType.REQUESTING,
          messagePayloadModel.messageGroupType: chatRoom!.chatType,
          messagePayloadModel.messages: [
            remoteTransaction.toMap(),
            // FundingCompleteMessage(
            //   message: TextMessage(
            //       time: Timestamp.now(),
            //       text: "REQUESTING",
            //       read: false,senderID: chatServices.localUser!.member!.userUID
            //   ),
            // ).toMap(),
          ],
        };

        TransactionPayload payload = TransactionPayload(
          note: requestNote,
          data: remoteTransaction.toMap(),
          cardTransactionCollectionPath: member!.get(memberModel.cardTransactionCollection),
          contactPath: chatServices.localMember!.get(memberModel.contactPath),
          payloadType: TransactionPayloadType.REQUEST_PAYMENT,
          time: Timestamp.now(),
          transactionType: TransactionType.REQUEST_PAYMENT,
        );
        DocumentReference reference = await payload.sendPayload(payload);

        AssistantMethods.sendANotification(
          title: "Money",
          body: "${chatServices.sender[messageSenderModel.firstName]} Requests ${transactionAmount.value} ${chatServices.localMember!.get(memberModel.currencyCode)}",
          token: member!.get(memberModel.deviceToken).toString(),
          notificationType: EnumToString.convertToString(NotificationDataType.REQUEST_PAYMENT),
          notificationDocPath: reference.path,
        );

        chatServices.messagePayload = message;
        enumServices.chatServicesActions = ChatServicesActions.SEND_MESSAGE;
        chatServices.chatRoom = chatRoom;
        chatServices.runChatServices();
        //setNumberDisplayState = () {};
        setPaymentToEmpty();

        Get.back();
        showToastMessage(msg: "Request sent", timeInSecForIosWeb: 6, backgroundColor: Colors.green);

        break;
      case TransactionActionType.PROCESS_REQUEST_PAYMENT:
        // TODO: Handle this case.
        if (member!.get(memberModel.currencyCode) == chatServices.localMember!.get(memberModel.currencyCode)) {
          MooweTransactions remoteTransaction = MooweTransactions(
            firstName: chatServices.localMember!.get(memberModel.firstName),
            lastName: chatServices.localMember!.get(memberModel.lastName),
            currencyCode: chatServices.localMember!.get(memberModel.currencyCode),
            currencySign: chatServices.localMember!.get(memberModel.currencySign),
            imageUrl: chatServices.localMember!.get(memberModel.imageUrl),
            value: transactionAmount.value,
            credit: 0.0,
            debit: transactionAmount.value,
            timeStamp: '${DateTime.now()}',
          );
          TransactionPayload payload = TransactionPayload(
            note: requestNote,
            data: remoteTransaction.toMap(),
            cardTransactionCollectionPath: member!.get(memberModel.cardTransactionCollection),
            contactPath: chatServices.localMember!.get(memberModel.contactPath),
            payloadType: TransactionPayloadType.TRANSACTION,
            time: Timestamp.now(),
            transactionType: TransactionType.INCOME,
          );
          DocumentReference reference = await payload.sendPayload(payload);
          // print(payload.toMap());
          AssistantMethods.sendANotification(
            title: "Money",
            body:
                "${chatServices.sender[messageSenderModel.firstName]} Requests ${paymentsController.numCurrency(transactionAmount.value.toDouble())} ${chatServices.localMember!.get(memberModel.currencyCode)}",
            token: member!.get(memberModel.deviceToken).toString(),
            notificationType: EnumToString.convertToString(NotificationDataType.REQUEST_PAYMENT),
            notificationDocPath: reference.path,
          );
          showToastMessage(msg: "Payment was sent", timeInSecForIosWeb: 6, backgroundColor: Colors.green);
        } else {
          enumServices.transactionActionType = TransactionActionType.EXCHANGE_FROM_MOOWE_PAY;
          localCurrency = chatServices.localMember!.get(memberModel.currencyCode);
          remoteCurrency = member!.get(memberModel.currencyCode);
          exchangeScreen();
        }
        break;
      case TransactionActionType.DECLINE_PAYMENT_REQUEST:
        // TODO: Handle this case.
        AssistantMethods.sendANotification(
          title: "Declined Payment Request",
          body: "${chatServices.sender[messageSenderModel.firstName]} Declined ${transactionAmount.value} ${chatServices.localMember!.get(memberModel.currencyCode)}",
          token: member!.get(memberModel.deviceToken).toString(),
          notificationType: EnumToString.convertToString(NotificationDataType.REQUEST_PAYMENT),
          notificationDocPath: "reference.path",
        );
        showToastMessage(msg: "Payment was sent", timeInSecForIosWeb: 6, backgroundColor: Colors.green);
        break;
      case TransactionActionType.TRANSFER_CASH_TO_BANK:
        // TODO: Handle this case.
        break;
    }
  }
}
