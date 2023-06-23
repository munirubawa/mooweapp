import 'package:mooweapp/export_files.dart';

class BusinessAcceptPaymentsController extends GetxController {
  static BusinessAcceptPaymentsController instance = Get.find();
  RxString businessPath = RxString("");
  Rx<ChatRoom> chatRoom = ChatRoom().obs;
  RxList<DocumentSnapshot> groupMembers = RxList([]);
  Rx<Business> business = Rx<Business>(Business());
  RxList<TransactionPayload> transactions = RxList<TransactionPayload>();
  Rx<StoreShowQRCodOrChat> qrCodOrChat = StoreShowQRCodOrChat.SHOW_STORE_QRCODE.obs;
  Rx<StoreShowQRCodOrChat> qrCodOrChatSwitch = StoreShowQRCodOrChat.SHOW_STORE_QRCODE.obs;
  var total = 0.0.obs;

  @override
  void onInit() {
    ever(chatRoom, (callback) {
      if (chatRoom.value.chatType == null) return;
      getAllTransactions();
    });
    ever(chatRoom, (callback) {
      if (chatRoom.value.members != null) {
        getMembers();
      }
    });
    ever(businessPath, (callback) {
      if (businessPath.value.isNotEmpty) {
        getAllServiceBasedBusiness();
      }
    });
    ever(transactions, (callback) => getTotal());
    super.onInit();
  }

  void getAllServiceBasedBusiness() {
    firebaseFirestore.doc(businessPath.value).snapshots().listen((query) {
      if (query.exists) {
        business.value = Business.fromSnap(query);
        addProductController.business.value = Business.fromSnap(query);
        storeController.storeBusiness.value = Business.fromSnap(query);
        storeController.business = Business.fromSnap(query);
      }
    });
  }

  void getMembers() async {
    groupMembers.clear();
    for (var member in chatRoom.value.members!) {
      DocumentSnapshot mem = await FirebaseFirestore.instance.doc(member).get();
      groupMembers.add(mem);
    }
  }

  void getAllTransactions() async {
    // if(chatRoom.value.creditCard!.cardTransactionPath == "") return;
    print("chatRoom.value.chatRoomCardTransactionCollection");
    print(chatRoom.value.chatRoomCardTransactionCollection);
    // transactions.value.clear();
    FirebaseFirestore.instance.collection(chatRoom.value.chatRoomCardTransactionCollection!).orderBy("time", descending: true).snapshots().listen((event) {
      transactions.value = event.docs.map((e) => TransactionPayload.fromMap(e.data())).toList();
      getTotal();
    });
  }

  getTotal() {
    double credit = transactions.value
        .where((element) => element.payloadType == TransactionPayloadType.TRANSACTION)
        .map((item) => MooweTransactions.fromJson(item.data).credit)
        .fold(0.0, (sum, item) => sum + item!.toDouble());
    double debit = transactions.value
        .where((element) => element.payloadType == TransactionPayloadType.TRANSACTION)
        .map((item) => MooweTransactions.fromJson(item.data).debit)
        .fold(0.0, (sum, item) => sum + item!.toDouble());
    print(transactions.value.length);
    transactions.value.forEach((item) {
      // print(item.time);
      print(MooweTransactions.fromJson(item.data).debit);
    });
    total.value = (debit - credit);
  }
}
