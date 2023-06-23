import 'package:mooweapp/export_files.dart';

class ChatServices extends GetxController {
  static ChatServices instance = Get.find();
  // String contacts = "contacts";
  String drivers = "drivers";
  // String users = "users";
  DocumentSnapshot? localUser;
  DocumentSnapshot? localMember;
  // DocumentSnapshot? localMemberSnap;
  // Map<String, dynamic> memberMod = {};

  bool releaseCall = false;
  bool isContextPop = false;

  // UserProvider userProvider = Get.find();
  @override
  Future<void> onInit() async {
    super.onInit();

    if (auth.currentUser != null) {
      // enumServices.chatServicesActions = ChatServicesActions.LOCAL_FIREBASE_LISTENERS;
      // runChatServices();
    }
  }

  DocumentSnapshot? currentMessage;
  var mediaMessage = <DocumentSnapshot>{};

  Map<String, dynamic> get sender => {
        messageSenderModel.firstName: localMember!.get(memberModel.firstName),
        messageSenderModel.lastName: localMember!.get(memberModel.lastName),
        messageSenderModel.userUID: localMember!.get(memberModel.userUID),
        messageSenderModel.imageUrl: localMember!.get(memberModel.imageUrl),
      };
  // Map<String, dynamic> get callFrom => {
  //   messageSenderModel.firstName: localMember!.get(memberModel.firstName),
  //   messageSenderModel.lastName: localMember!.get(memberModel.lastName),
  //   messageSenderModel.userUID: localMember!.get(memberModel.userUID),
  //   messageSenderModel.imageUrl: localMember!.get(memberModel.imageUrl),
  // };
  Map<String, dynamic> callInfo(DocumentSnapshot member) {
    return {
      memberCallInfoModel.firstName: member.get(memberCallInfoModel.firstName),
      memberCallInfoModel.lastName: member.get(memberCallInfoModel.lastName),
      memberCallInfoModel.userUID: member.get(memberCallInfoModel.userUID),
      memberCallInfoModel.phone: member.get(memberCallInfoModel.phone),
      memberCallInfoModel.callPath: member.get(memberCallInfoModel.callPath),
      memberCallInfoModel.deviceToken: member.get(memberCallInfoModel.deviceToken),
      memberCallInfoModel.imageUrl: member.get(memberCallInfoModel.imageUrl),
    };
  }

  List<DocumentSnapshot>? members;
  DocumentSnapshot? member;
  Map<String, dynamic> messagePayload = {};
  DocumentReference? messageReference;
  TextMessage? textMessage;

  ChatRoom? chatRoom;
  bool sendToChatRoom = false;
  BuildContext? context;

  Business? business;

  Future<void> runChatServices() async {
    switch (enumServices.chatServicesActions!) {
      case ChatServicesActions.UPDATE_MEMBER_STATUS_ON_LINE:
        FirebaseFirestore.instance.doc(dbHelper.user()).update({"online": true, "lastSeen": Timestamp.now()});
        break;
      case ChatServicesActions.UPDATE_MEMBER_STATUS_OFF_LINE:
        FirebaseFirestore.instance.doc(dbHelper.user()).update({"online": false,  "lastSeen": Timestamp.now()});
        break;
      case ChatServicesActions.SAVE_DEVICE_TOKEN:
        // TODO: Handle this case.
        FirebaseMessaging.instance.getToken().then((token) {
          if (localMember != null || box.read("deviceToken") != token) {
            FirebaseFirestore.instance.doc(dbHelper.user()).update({"deviceToken": token}).then((value) => {
                  box.write("oldDeviceToken", localMember!.get(memberModel.deviceToken).toString()),
                  FirebaseFirestore.instance.doc(dbHelper.user()).collection("account").doc(auth.currentUser!.uid).update({"member.deviceToken": token})
                });
          }
        });
        break;
      case ChatServicesActions.SEND_MESSAGE:
        // TODO: Handle this case.
        // chatRoomController.updateMessageCount(chatRoom: chatRoom!);

        FirebaseFirestore.instance.collection(chatRoom!.chatRoomChatsCollection!).add(messagePayload).then((value) {
          if (EnumToString.fromString(ChatMessageType.values, messagePayload[messagePayloadModel.messageType]) == ChatMessageType.GROUP_CALL) {
            messageReference = value;
          }
        });
        // print(chatRoom!.deviceTokens!.contains(prefs!.value.getString("oldDeviceToken")));
        chatRoom!.reference!.set({
          "message": textMessage!.toMap(),
          "messageCount": FieldValue.increment(1),
          "senderName": "${sender[memberCallInfoModel.firstName]} ${sender[memberCallInfoModel.lastName]}",
        }, SetOptions(merge: true));
        FirebaseMessaging.instance.getToken().then((token) {
          // print("oldDeviceToken");
          // print(prefs!.getString("oldDeviceToken"));
          if (!chatRoom!.deviceTokens!.contains(token)) {
            chatRoom!.reference!.set({
              "deviceTokens": FieldValue.arrayUnion([token]),
            }, SetOptions(merge: true));
          }
        });
        if (box.read("oldDeviceToken") != null && chatRoom!.deviceTokens!.contains(box.read("oldDeviceToken"))) {
          chatRoom!.reference!.set({
            "deviceTokens": FieldValue.arrayRemove([box.read("oldDeviceToken")]),
          }, SetOptions(merge: true));
        }
        switch (chatRoom!.chatType!) {
          case ChatTypes.PRIVATE_CHAT:
            // TODO: Handle this case.
            String token = chatRoom!.members!.firstWhere((element) => element != localMember!.get(memberModel.contactPath));
            debugPrint("token.toString()");
            debugPrint(token.toString());
            AssistantMethods.sendANotification(
              title: "${localMember!.get(memberModel.firstName)} ${localMember!.get(memberModel.firstName)}",
              body: "${localMember!.get(memberModel.firstName)}: ${textMessage!.text}",
              token: chatRoomController.tokens[token],
              notificationType: EnumToString.convertToString(NotificationDataType.CHAT_DATA),
              notificationDocPath: chatRoom!.reference!.path,
            );
            break;
          case ChatTypes.GROUP_CHAT:
            // TODO: Handle this case.
            // List<String> tokens = box.read("${chatRoom?.chatRoomPathDocId}deviceToken")?? [];
            //  for (var element in tokens) {
            //    AssistantMethods.sendANotification(
            //      title: "${chatRoom!.groupName}",
            //      body: "${localMember!.get(memberModel.firstName)}: ${textMessage!.text}",
            //      token: box.read("${element}deviceToken"),
            //      notificationType: EnumToString.convertToString(NotificationDataType.CHAT_DATA),
            //      notificationDocPath: chatRoom!.reference!.path,
            //    );
            //  }
            break;
          case ChatTypes.PROJECT_CHAT:
            // TODO: Handle this case.
            break;
          case ChatTypes.FUND_RAISE:
            // TODO: Handle this case.
            break;
          case ChatTypes.SUSU:
            // TODO: Handle this case.
            break;
          case ChatTypes.BUSINESS_CHAT:
            // TODO: Handle this case.
            break;
          case ChatTypes.STORE_CHAT:
            // TODO: Handle this case.
            break;
        }
        break;
      case ChatServicesActions.UPDATE_IS_READ_MESSAGE:
        // TODO: Handle this case.
        break;
      case ChatServicesActions.CREATE_NEW_GROUP_OR_PROJECT_CHAT:
        // TODO: Handle this case.
        groupOrProjectMembers.add(localMember!);
        initialChat.time = Timestamp.now();
        ChatRoom chatRoom = ChatRoom();
        initialChat.creditCard = CreditCard.fromMap(chatServices.localUser!.get(localUserModel.creditCard));

        chatRoom.chatType = initialChat.chatType;
        chatRoom.groupName = initialChat.displayName;
        chatRoom.supperAdmin = [chatServices.localMember!.get(memberModel.userUID)];
        chatRoom.firstName = initialChat.displayName;
        chatRoom.lastName = "";
        chatRoom.chatRoomCardPath = '';
        chatRoom.admins = [chatServices.localMember!.get(memberModel.userUID).toString()];
        chatRoom.members = groupOrProjectMembers.map((m) => m.get(memberModel.contactPath)).toList();
        chatRoom.groupImages = groupOrProjectMembers.map((m) => m.get(memberModel.imageUrl)).toList();
        chatRoom.deviceTokens = groupOrProjectMembers.map((m) => m.get(memberModel.deviceToken)).toList();
        chatRoom.imageUrl = chatServices.localMember!.get(memberModel.imageUrl);
        chatRoom.chatRoomDecorumLimit = 2;
        chatRoom.messageCount = 0;
        chatRoom.chatRoomChatsCollection = "";
        chatRoom.chatRoomMembersCollection = "";
        chatRoom.currencySign = initialChat.creditCard!.currencySign;
        chatRoom.chatRoomPathDocId = "";
        chatRoom.accountType = "";
        chatRoom.manager = "";
        chatRoom.senderName = "";
        chatRoom.currencyCode = initialChat.creditCard!.currencyCode;
        chatRoom.message = TextMessage(time: Timestamp.now(), text: "", read: false, senderID: localMember!.get(memberModel.userUID));

        initialChat.creditCard!.firstName = chatServices.localMember!.get(memberModel.firstName);
        initialChat.creditCard!.lastName = chatServices.localMember!.get(memberModel.lastName);
        initialChat.creditCard!.nameOnCard = initialChat.displayName;
        chatRoom.creditCard = initialChat.creditCard;
        chatRoom.creditCard!.cardDocId = "";
        chatRoom.creditCard!.cardTransactionPath = "";
        ChatRoom newChatRoom = await FirebaseFirestore.instance.collection('chatRoom').add(chatRoom.toMap()).then((chatType) => chatType.get().then((value) {
              ChatRoom insideChatRoom = ChatRoom.fromSnapSetup(value);
              insideChatRoom.creditCard!.cardTransactionPath = "chatRoom/${value.id}/transactions";
              value.reference.update(insideChatRoom.toMap());
              return ChatRoom.fromSnapSetup(value);
            }));
        initialChat.creditCard!.cardTransactionPath = newChatRoom.chatRoomCardTransactionCollection;
        initialChat.creditCard!.cardDocId = newChatRoom.chatRoomCardPath;

        // await firebaseFiretor.doc(newChatRoom.chatRoomCardPath!).set(initialChat.creditCard!.toMap());

        // initialChat.chatRoom = newChatRoom;
        // initialChat.displayName = "${remoteMember.firstName} ${remoteMember.lastName}";
        // initialChat.deviceToken = chatServices.localUser!.deviceToken;
        // initialChat.isNew = true;
        // await FirebaseFirestore.instance.collection(chatServices.localUser!.member!.recentChatCollectionPath!).add({
        //   "chatRoom": newChatRoom.chatRoomPathDocId,
        //   "time": Timestamp.now(),
        //   "isNew": true,
        // });

        List chatPaths = groupOrProjectMembers.map((m) => m.get(memberModel.recentChatCollectionPath)).toList();
        for (var element in chatPaths) {
          await FirebaseFirestore.instance.collection(element!).add({
            "chatRoom": newChatRoom.chatRoomPathDocId,
            "time": Timestamp.now(),
            "isNew": true,
          });
        }

        groupOrProjectMembers.clear();

        initialChat = Chat();
        break;
      case ChatServicesActions.CREATE_NEW_PRIVATE_CHAT:
        // TODO: Handle this case.
        groupOrProjectMembers.add(localMember!);

        initialChat.time = Timestamp.now();
        ChatRoom chatRoom = ChatRoom();
        DocumentReference chatRoomRefere = await FirebaseFirestore.instance.collection('chatRoom').add({});
        chatRoom.chatType = initialChat.chatType;
        chatRoom.creditCard = CreditCard.fromMap(chatServices.localUser!.get(localUserModel.creditCard));
        chatRoom.groupName = "";
        chatRoom.supperAdmin = [chatServices.localMember!.get(memberModel.userUID)];
        chatRoom.firstName = chatServices.localMember!.get(memberModel.firstName);
        chatRoom.lastName = chatServices.localMember!.get(memberModel.lastName);
        chatRoom.chatRoomCardPath = '';
        chatRoom.admins = [chatServices.localMember!.get(memberModel.userUID).toString()];
        chatRoom.members = groupOrProjectMembers.map((m) => m.get(memberModel.contactPath)).toList();
        chatRoom.groupImages = groupOrProjectMembers.map((m) => m.get(memberModel.imageUrl)).toList();
        chatRoom.deviceTokens = groupOrProjectMembers.map((m) => m.get(memberModel.deviceToken)).toList();
        chatRoom.imageUrl = chatServices.localMember!.get(memberModel.imageUrl);
        chatRoom.groupImages = groupOrProjectMembers.map((m) => m.get(memberModel.imageUrl)).toList();

        chatRoom.chatRoomDecorumLimit = 2;
        chatRoom.messageCount = 0;
        chatRoom.chatRoomChatsCollection = "${chatRoomRefere.path}/chats";
        chatRoom.chatRoomMembersCollection = "${chatRoomRefere.path}/members";
        chatRoom.groupName = "";
        chatRoom.currencySign = "";
        chatRoom.chatRoomPathDocId = chatRoomRefere.path;
        chatRoom.accountType = "";
        chatRoom.manager = "";
        chatRoom.chatRoomCardTransactionCollection = "";
        chatRoom.fundBeneficiaries = "";
        chatRoom.currentBeneficiary = "";
        chatRoom.businessPath = "";
        chatRoom.senderName = "";
        chatRoom.currencyCode = "";
        chatRoom.message = TextMessage(time: Timestamp.now(), text: "", read: false, senderID: localMember!.get(memberModel.userUID).toString());

        // ChatRoom newChatRoom = await FirebaseFirestore.instance
        //     .collection('chatRoom')
        //     .add(chatRoom.toMap())
        //     .then((chatType) => chatType.value.get().then((value) => ChatRoom.fromSnapSetup(value)));

        chatRoomRefere.update(chatRoom.toMap());

        initialChat.chatRoom = chatRoom;
        initialChat.displayName = "${remoteMember!.get(memberModel.firstName)} ${remoteMember!.get(memberModel.lastName)}";
        initialChat.deviceToken = chatServices.localMember!.get(memberModel.deviceToken);
        initialChat.isNew = true;
        await FirebaseFirestore.instance.collection(chatServices.localMember!.get(memberModel.recentChatCollectionPath)!).add({
          "chatRoom": chatRoom.chatRoomPathDocId,
          "time": Timestamp.now(),
          "isNew": true,
        });

        initialChat.displayName = "${chatServices.localMember!.get(memberModel.firstName)} ${chatServices.localMember!.get(memberModel.lastName)}";
        initialChat.deviceToken = remoteMember!.get(memberModel.deviceToken);
        initialChat.isNew = false;
        await FirebaseFirestore.instance.collection(remoteMember!.get(memberModel.recentChatCollectionPath)!).add({
          "chatRoom": chatRoom.chatRoomPathDocId,
          "time": Timestamp.now(),
          "isNew": true,
        });
        initialChat = Chat();
        groupOrProjectMembers.clear();
        break;

      case ChatServicesActions.APPROVE_BENEFICIARY:
        // // TODO: Handle this case.
        // FirebaseFirestore.instance.collection(message!.chatRoomChatsCollection!).doc(message!.messageDocId).update({
        //   "beneficiaryConfirmations": FieldValue.arrayUnion([auth.currentUser!.uid])
        // });
        break;
      case ChatServicesActions.DISAPPROVE_BENEFICIARY:
        // TODO: Handle this case.
        // FirebaseFirestore.instance.collection(message!.chatRoomChatsCollection!).doc(message!.messageDocId).update({
        //   "beneficiaryDisAprove": FieldValue.arrayUnion([auth.currentUser!.uid])
        // });
        break;
      case ChatServicesActions.ADD_MEMBER_TO_PROJECT_OR_GROUP:
        for (var mem in groupOrProjectMembers) {
          member = mem;
          if (!chatRoom!.members!.contains(member!.get(memberModel.contactPath))) {
            chatRoom!.reference!.set({
              "members": FieldValue.arrayUnion([member!.get(memberModel.contactPath)]),
              "deviceTokens": FieldValue.arrayUnion([member!.get(memberModel.deviceToken)]),
            }, SetOptions(merge: true));

            await FirebaseFirestore.instance.collection(member!.get(memberModel.recentChatCollectionPath)!).add({
              "chatRoom": chatRoom!.chatRoomPathDocId,
              "time": Timestamp.now(),
              "isNew": true,
            });
            // groupOrProjectMembers.removeWhere((element) => element.get(memberModel.userUID) == member?.get(memberModel.userUID));

            // if (groupOrProjectMembers.isEmpty) {
            //   showToastMessage(msg: "Member successfully added!", backgroundColor: Colors.green);
            // }
          } else {
            // groupOrProjectMembers.removeWhere((element) => element.get(memberModel.userUID) == member?.get(memberModel.userUID));

            // if (groupOrProjectMembers.isEmpty) {
            //   showToastMessage(msg: "Member already exist!", backgroundColor: Colors.green);
            // }
          }
          if (chatRoom!.chatType == ChatTypes.GROUP_CHAT) {
            if (chatRoom!.members!.length == 6) {
              chatRoom!.reference!.set({"chatRoomDecorumLimit": 2}, SetOptions(merge: true));
            }
            if (chatRoom!.members!.length == 10) {
              chatRoom!.reference!.set({"chatRoomDecorumLimit": 3}, SetOptions(merge: true));
            }
            if (chatRoom!.members!.length == 15) {
              chatRoom!.reference!.set({"chatRoomDecorumLimit": 4}, SetOptions(merge: true));
            }
          }
        }
        groupOrProjectMembers.clear();
        // Navigator.of(context!).pop();
        break;
      case ChatServicesActions.MAKE_MEMBER_PROJECT_MANAGER:
        // TODO: Handle this case.
        chatRoom!.reference!.update({"manager": member!.get(memberModel.userUID)});
        showToastMessage(msg: "Granted Successful", backgroundColor: Colors.green);
        break;
      case ChatServicesActions.REVOKE_MANAGER_RIGHTS:
        // TODO: Handle this case.
        chatRoom!.reference!.update({"manager": ''});
        showToastMessage(msg: "Revoked Successful", backgroundColor: Colors.green);
        break;
      case ChatServicesActions.LOCAL_FIREBASE_LISTENERS:
        Get.put(PaymentsController());
        //TODO always update the local user instance by listing to changes
        FirebaseFirestore.instance.doc(dbHelper.user()).snapshots().listen((snapshot) {
          if (snapshot.exists) {
            localMember = snapshot;
            productsController.isLocalMemberSet = RxBool(true);
            productsController.inItProducts();
            paymentsController.checkPaymentMethod();
            Get.put(CallHistoryController());
            if(snapshot.get(memberModel.accountBanned)) {
              authController!.signOut();
            }
            if(snapshot.get(memberModel.deviceToken) != deviceToken.value) {
              snapshot.reference.update({"deviceToken": deviceToken.value});
            }
            // print(deviceToken.value);
          }
        });
        //TODO ---------------------------------------
        FirebaseFirestore.instance.doc(dbHelper.user()).collection('account').doc(auth.currentUser!.uid).snapshots().listen((event) {
          // print("LOCAL_FIREBASE_LISTENERS");
          if (kDebugMode) {
            print("event.reference.path");
            print(event.reference.path);
          }
          if (!event.exists) {
            authController!.signOut();
          } else {
            localUser = event;
            // Get.put(UserController());
            // UserController userController = Get.find();
            FirebaseFirestore.instance.doc(dbHelper.user()).snapshots().listen((event) {
              if (event.exists) {
                // userController.userModel?.value = event;
              }
            });

            FirebaseMessaging.instance.getToken().then((token) {
              if (localUser != null) {
                if (box.read("deviceToken") == null || box.read("deviceToken") != token) {
                  localUser!.reference.update({"deviceToken": token});
                  box.write("deviceToken", token.toString());
                }
              }
            });
            if (localUser != null) {
              if (localUser!.get(localUserModel.subscribedServices)!.contains(EnumToString.convertToString(SubscribedServices.MOOWE_DRIVER))) {
                FirebaseFirestore.instance.collection(drivers).doc(auth.currentUser!.uid).snapshots().listen((DocumentSnapshot snapshot) {
                  driverSnapshot = snapshot;
                  // Driver driver = Driver.fromSnap(driverSnapshot!);
                  // driverController.mainDriver = driver;
                  // newRideController.mainDriver = driver;
                  FirebaseMessaging.instance.getToken().then((token) {
                    if (box.read("deviceToken") == null || box.read("deviceToken") != token) {
                      // driver.reference!.update({"token": token});
                    }
                  });
                });
                enumServices.rideSharScreen = SubscribedServices.MOOWE_DRIVER;
              }
            } else {
              // Get.put(RiderHomeScreenController());
            }
          }
        });

        break;
      case ChatServicesActions.ADD_MEMBER_TO_BUSINESS_ACCOUNT:
        // TODO: Handle this case.
        if (!business!.members!.contains(member!.get(memberModel.contactPath))) {
          business!.snapshot!.reference.set({
            "members": FieldValue.arrayUnion([member!.get(memberModel.contactPath)]),
            "deviceTokens": FieldValue.arrayUnion([member!.get(memberModel.deviceToken)]),
          }, SetOptions(merge: true));

          UserBusiness userBusiness = UserBusiness(userBusinessType: business!.userBusinessType, businessAccountPath: business!.businessPath.toString(), time: Timestamp.now());
          DocumentReference user = await FirebaseFirestore.instance.collection("contacts/${member!.get(memberModel.userUID)}/businesses").add(userBusiness.toMap());

          business!.snapshot!.reference.set({
            "members": FieldValue.arrayUnion([member!.get(memberModel.contactPath)]),
            "deviceTokens": FieldValue.arrayUnion([member!.get(memberModel.deviceToken)]),
            "userBusinessPath": FieldValue.arrayUnion([user.path]),
          }, SetOptions(merge: true));
          showToastMessage(msg: "Member successfully added!", backgroundColor: Colors.green);
        } else {
          showToastMessage(msg: "Member already exist!", backgroundColor: Colors.green);
        }
        break;
    }
  }
}
