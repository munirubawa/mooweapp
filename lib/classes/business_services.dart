import 'package:mooweapp/export_files.dart';

class BusinessServices extends GetxController {
  static BusinessServices instance = Get.find();
  Rx<Business> business = Rx<Business>(Business());
  BuildContext? context;
  bool isAddressUpdated = false;
  // Placemark? customerAddress;
  DocumentSnapshot? member;
  CreditCard card = CreditCard();
  late DocumentSnapshot businessSnapshot;
  @override
  void onInit() {
    business.value.businessName = "Regus Office Spaces";
    business.value.phone = "+12565858061";
    business.value.address = "424 Church Street";
    business.value.city = "Nashville";
    business.value.state = "Tennessee";
    business.value.zip = "37219";
    super.onInit();
  }

  ChatTypes chatTypes() {
    switch (business.value.userBusinessType!) {
      case UserBusinessType.MERCHANT_STORE:
        return ChatTypes.STORE_CHAT;

      case UserBusinessType.ACCEPT_PAYMENT_SERVICE:
        return ChatTypes.BUSINESS_CHAT;
    }
  }

  Future<void> runBusinessServices() async {
    switch (enumServices.businessServiceAction!) {
      case BusinessServiceAction.CREATE_BUSINESS_CHAT_ROOM:
        groupOrProjectMembers.add(chatServices.localMember!);
        initialChat.time = Timestamp.now();
        ChatRoom chatRoom = ChatRoom();

        final now = DateTime.now();
        final today = DateTime(now.year + 20, now.month, now.day);
        Timestamp myTimeStamp = Timestamp.fromDate(today);

        chatRoom.creditCard = CreditCard.fromMap(businessSnapshot.get("creditCard"));
        chatRoom.chatType = chatTypes();
        chatRoom.groupName = business.value.businessName;
        chatRoom.supperAdmin = [chatServices.localMember!.get(memberModel.userUID)];
        chatRoom.firstName = chatServices.localMember!.get(memberModel.firstName);
        chatRoom.lastName = chatServices.localMember!.get(memberModel.lastName);
        chatRoom.chatRoomCardPath = '';
        chatRoom.admins = [chatServices.localMember!.get(memberModel.userUID).toString()];
        chatRoom.members = groupOrProjectMembers.map((m) => m.get(memberModel.contactPath)).toList();
        chatRoom.groupImages = groupOrProjectMembers.map((m) => m.get(memberModel.imageUrl)).toList();
        chatRoom.deviceTokens = groupOrProjectMembers.map((m) => m.get(memberModel.deviceToken)).toList();
        chatRoom.imageUrl = chatServices.localMember!.get(memberModel.imageUrl);
        chatRoom.chatRoomDecorumLimit = 2;
        chatRoom.messageCount = 1;
        chatRoom.chatRoomCardTransactionCollection = "${businessSnapshot.reference.path}/transactions";
        chatRoom.currencyCode = card.currencyCode;
        chatRoom.currencySign = card.currencySign;
        chatRoom.chatRoomPathDocId = "";
        chatRoom.accountType = "";
        chatRoom.manager = chatServices.localMember!.get(memberModel.userUID);
        chatRoom.senderName = "";
        chatRoom.businessPath = businessSnapshot.reference.path;
        chatRoom.message = TextMessage(time: Timestamp.now(), text: "Welcome to mowe, this is a business account", read: false, senderID: chatServices.localMember!.get(memberModel.userUID));

        chatRoom.creditCard!.cardDocId = "";
        chatRoom.creditCard!.cardTransactionPath = "";
        // print("chatRoom.businessPath");
        // print(chatRoom.businessPath);
        // print(chatRoom.creditCard!.toMap());
        ChatRoom newChatRoom = await FirebaseFirestore.instance.collection('chatRoom').add(chatRoom.toMap()).then((chatType) => chatType.get().then((value) {
              value.reference.update({
                "chatRoomChatsCollection": "${value.reference.path}/chats",
                "chatRoomCardPath": value.reference.path,
                "chatRoomPathDocId": value.reference.path,
              });
              return ChatRoom.fromSnapSetup(value);
            }));
        // chatRoom.creditCard!.cardTransactionPath = newChatRoom.chatRoomCardTransactionCollection;
        // chatRoom.creditCard!.cardDocId = newChatRoom.chatRoomCardPath;
        //
        // await firebaseFiretor.doc(newChatRoom.chatRoomCardPath!).set(initialChat.creditCard!.toMap());

        // initialChat.chatRoom = newChatRoom;
        // initialChat.displayName = "${remoteMember.firstName} ${remoteMember.lastName}";
        // initialChat.deviceToken = chatServices.localUser!.deviceToken;
        // initialChat.isNew = true;
        await FirebaseFirestore.instance.collection(chatServices.localMember!.get(memberModel.recentChatCollectionPath)).add({
          "chatRoom": newChatRoom.chatRoomPathDocId,
          "time": myTimeStamp,
          "isNew": true,
        });

        // List chatPaths = groupOrProjectMembers.map((m) => m.get(memberModel.recentChatCollectionPath)).toList();
        // for (var element in chatPaths) {
        //   // initialChat.displayName = "${chatServices.localMember!.get(memberModel.firstName)} ${chatServices.localMember!.get(memberModel.lastName)}";
        //   // initialChat.deviceToken = remoteMember!.get(memberModel.deviceToken);
        //   // initialChat.isNew = false;
        //   await FirebaseFirestore.instance.collection(element!).add({
        //     "chatRoom": newChatRoom.chatRoomPathDocId,
        //     "time": Timestamp.now(),
        //     "isNew": true,
        //   });
        // }
        chatRoom = ChatRoom();
        business.value = Business();
        Get.back();
        Get.back();
        Get.back();
        break;
      case BusinessServiceAction.CREATE_NEW_BUSINESS_ACCOUNT:
        showLoading();
        card = CreditCard.fromMap(chatServices.localUser!.get(localUserModel.creditCard));
        card.nameOnCard = business.value.businessName;

        business.value.firstName = chatServices.localMember!.get(memberModel.firstName);
        business.value.lastName = chatServices.localMember!.get(memberModel.lastName);
        business.value.phone = chatServices.localMember!.get(memberModel.phone);
        business.value.creditCard = card;
        business.value.manager = chatServices.localMember!.get(memberModel.userUID);
        business.value.country = "";
        business.value.position = "";
        business.value.locality = "";
        // busin.valuess!.creditCard!.nameOnCard = business!.businessName;
        business.value.currencyCode = chatServices.localUser!.get(localUserModel.creditCard)[memberModel.currencyCode];
        business.value.currencySign = chatServices.localUser!.get(localUserModel.creditCard)[memberModel.currencySign];
        business.value.supperAdmin = [auth.currentUser!.uid];
        business.value.admins = [auth.currentUser!.uid];
        business.value.members = [chatServices.localMember!.get(memberModel.contactPath)];
        business.value.deviceTokens = [chatServices.localMember!.get(memberModel.deviceToken)];
        business.value.userBusinessPath = [];
        business.value.time = Timestamp.now();
        business.value.search = business.value.businessName!.substring(0, 1).toUpperCase();
        // business.value.userBusinessType = enumServices.userBusinessType;
        // business!.name = statePro!.placemarkAddress!.name;
        // business!.street = statePro!.placemarkAddress!.street;
        // business!.isoCountryCode = statePro!.placemarkAddress!.isoCountryCode;
        // business!.country = statePro!.placemarkAddress!.country;
        // business!.postalCode = statePro!.placemarkAddress!.postalCode;
        // business!.administrativeArea = statePro!.placemarkAddress!.administrativeArea;
        // business!.subAdministrativeArea = statePro!.placemarkAddress!.subAdministrativeArea;
        // business!.locality = statePro!.placemarkAddress!.locality;
        // business!.subLocality = statePro!.placemarkAddress!.subLocality;
        // business!.thoroughfare = statePro!.placemarkAddress!.thoroughfare;
        // business!.subThoroughfare = statePro!.placemarkAddress!.subThoroughfare;

        DocumentReference busRefe = await FirebaseFirestore.instance.collection("businesses").add({}).then((value) => value);
        business.value.cardTransactionPath = "businesses/${busRefe.id}/transactions";
        business.value.businessPath = "businesses/${busRefe.id}";
        business.value.creditCard!.cardTransactionPath = "businesses/${busRefe.id}/transactions";
        card.cardTransactionPath = "businesses/${busRefe.id}/transactions";

        busRefe.update(business.value.toMap());

        // UserBusiness userBusiness = UserBusiness(userBusinessType: enumServices.userBusinessType, businessAccountPath: "businesses/${busRefe.id}", time: Timestamp.now());
        // DocumentReference user = await FirebaseFirestore.instance.collection("contacts/${auth.currentUser!.uid}/businesses")
        //     .add(userBusiness.toMap());

        // busRefe.set({
        //   "userBusinessPath": FieldValue.arrayUnion([user.path]),
        // }, SetOptions(merge: true));
        // showToastMessage(msg: "Business Account was Created successfully", timeInSecForIosWeb: 6, backgroundColor: Colors.green);
        enumServices.businessServiceAction = BusinessServiceAction.CREATE_BUSINESS_CHAT_ROOM;
        busRefe.get().then((value) {
          if (value.exists) {
            businessSnapshot = value;
            // print("value.get(businessPath)");
            // print(value.get("businessPath"));
            // print(value.get("creditCard"));
            // business.value = Business.fromSnap(value);
            businessServices.runBusinessServices();
          }
        });

        break;
      case BusinessServiceAction.PAY_A_BILL:
        // TODO: Handle this case.
        if (kDebugMode) {
          print("bill is paid thank you");
          print(enumServices.payBillActionLocation);
        }

        switch (enumServices.payBillActionLocation) {
          case PayBillActionLocation.BILL_LOCATION_NOT_SET:
            // TODO: Handle this case.
            break;
          case PayBillActionLocation.PAY_A_BILL_FROM_GROUP:

            // CreditCard? defaultCard = CreditCard.fromMap(chatServices.localUser!.get(localUserModel.creditCard));
            MooweTransactions remoteTransaction = MooweTransactions(
              firstName: groupChatController.chatRoom.value.groupName,
              lastName: "",
              currencyCode: groupChatController.chatRoom.value.currencyCode,
              currencySign: groupChatController.chatRoom.value.currencySign,
              imageUrl: groupChatController.chatRoom.value.imageUrl,
              value: transactionService.transactionAmount.value,
              credit: 0.0,
              debit: transactionService.transactionAmount.value,
              timeStamp: '${DateTime.now()}',
            );

            MooweTransactions localTransaction = MooweTransactions(
              firstName: "${business.value.businessName}",
              lastName: "",
              currencyCode: business.value.currencyCode,
              currencySign: business.value.currencySign,
              imageUrl: "",
              value: transactionService.transactionAmount.value,
              credit: transactionService.transactionAmount.value,
              debit: 0.0,
              timeStamp: '${DateTime.now()}',
            );

            TransactionPayload payload = TransactionPayload(
              data: remoteTransaction.toMap(),
              cardTransactionCollectionPath: business.value.cardTransactionPath,
              payloadType: TransactionPayloadType.TRANSACTION,
              time: Timestamp.now(),
              transactionType: TransactionType.INCOME,
            );

            TransactionPayload localPayload = TransactionPayload(
              data: localTransaction.toMap(),
              cardTransactionCollectionPath: groupChatController.chatRoom.value.chatRoomCardTransactionCollection,
              payloadType: TransactionPayloadType.TRANSACTION,
              time: Timestamp.now(),
              transactionType: TransactionType.EXPENSE,
            );

            payload.sendPayload(payload);
            localPayload.sendPayload(localPayload);

            String sentMessageString = "${chatServices.sender[memberCallInfoModel.firstName]} sent ${transactionService.transactionAmount.value} ${groupChatController.chatRoom.value.currencyCode}"
                " to ${business.value.businessName}";

            chatServices.textMessage = TextMessage(time: Timestamp.now(), text: sentMessageString, read: false, senderID: chatServices.localMember!.get(memberModel.userUID));

            Map<String, dynamic> message = {
              messagePayloadModel.chatRoomChatsCollection: groupChatController.chatRoom.value.chatRoomChatsCollection,
              messagePayloadModel.time: Timestamp.now(),
              messagePayloadModel.sender: chatServices.sender,
              messagePayloadModel.messageType: EnumToString.convertToString(ChatMessageType.MESSAGE),
              messagePayloadModel.messageGroupType: EnumToString.convertToString(groupChatController.chatRoom.value.chatType),
              messagePayloadModel.messages: [chatServices.textMessage!.toMap()],
            };

            // chatRoom!.reference!.set({"currentBeneficiary": widget.member!.userUID!}, SetOptions(merge: true));
            chatServices.messagePayload = message;
            enumServices.chatServicesActions = ChatServicesActions.SEND_MESSAGE;
            chatServices.chatRoom = groupChatController.chatRoom.value;
            chatServices.sendToChatRoom = true;

            chatServices.runChatServices();

            for (var mem in groupChatController.groupMembers) {
              if (mem.get(memberModel.contactPath) != chatServices.localMember!.get(memberModel.contactPath)) {
                AssistantMethods.sendANotification(
                  title: "${groupChatController.chatRoom.value.groupName} expense",
                  body: sentMessageString,
                  token: mem.get(memberModel.deviceToken),
                  notificationType: EnumToString.convertToString(NotificationDataType.MONEY_DATA),
                  notificationDocPath: "",
                );
              }
            }

            transactionService.setPaymentToEmpty();
            Get.back();
            Get.back();
            showToastMessage(msg: "Success", backgroundColor: Colors.green, timeInSecForIosWeb: 6);
            break;
          case PayBillActionLocation.PAY_A_BILL_FROM_WALLET:
            MooweTransactions remoteTransaction = MooweTransactions(
              firstName: chatServices.localMember!.get(memberModel.firstName),
              lastName: chatServices.localMember!.get(memberModel.lastName),
              currencyCode: chatServices.localMember!.get(memberModel.currencyCode),
              currencySign: chatServices.localMember!.get(memberModel.currencySign),
              imageUrl: chatServices.localMember!.get(memberModel.imageUrl),
              value: transactionService.transactionAmount.value,
              credit: 0.0,
              debit: transactionService.transactionAmount.value,
              timeStamp: '${DateTime.now()}',
            );

            MooweTransactions localTransaction = MooweTransactions(
              firstName: "${business.value.businessName}",
              lastName: "",
              currencyCode: business.value.currencyCode,
              currencySign: business.value.currencySign,
              imageUrl: "",
              value: transactionService.transactionAmount.value,
              credit: transactionService.transactionAmount.value,
              debit: 0.0,
              timeStamp: '${DateTime.now()}',
            );

            TransactionPayload payload = TransactionPayload(
              data: remoteTransaction.toMap(),
              cardTransactionCollectionPath: business.value.cardTransactionPath,
              payloadType: TransactionPayloadType.TRANSACTION,
              time: Timestamp.now(),
              transactionType: TransactionType.INCOME,
            );

            TransactionPayload localPayload = TransactionPayload(
              data: localTransaction.toMap(),
              cardTransactionCollectionPath: chatServices.localMember!.get(memberModel.cardTransactionCollection),
              payloadType: TransactionPayloadType.TRANSACTION,
              time: Timestamp.now(),
              transactionType: TransactionType.EXPENSE,
            );

            payload.sendPayload(payload);
            localPayload.sendPayload(localPayload);
            transactionService.setPaymentToEmpty();
            Get.back();
            showToastMessage(msg: "Success", backgroundColor: Colors.green, timeInSecForIosWeb: 6);

            break;
        }

        if (business.value.requireCustomerAddress!) {
          // TransactionWithUserAddress withUserAddress = TransactionWithUserAddress(
          //   transactions: remoteTransaction,
          //   address: customerAddress!,
          // );

          // localPayload.sendPayload(localPayload);

          // showToastMessage(msg: "Success", backgroundColor: Colors.green, timeInSecForIosWeb: 6);
          // transactionService.setPaymentToEmpty();
        } else {}
        break;
    }
  }
}
