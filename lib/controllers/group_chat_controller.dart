import 'package:mooweapp/export_files.dart';

class GrouchChatController extends GetxController {
  static GrouchChatController instance = Get.find();
  RxList<TransactionPayload> transactions = RxList<TransactionPayload>();
  Rx<ChatRoom> chatRoom = Rx<ChatRoom>(ChatRoom());
  RxDouble total = RxDouble(0.0);
  RxList<DocumentSnapshot> groupMembers = RxList([]);
  GroupMemberDisplayType memberDisplayType = GroupMemberDisplayType.DISPLAY_TYPE_NOT_SET;
  RxList<ChatRoom> groupChatRoom = RxList<ChatRoom>([]);
  @override
  void onInit() {
    super.onInit();
    ever(chatRoom, (callback) => getAllTransactions());
    ever(chatRoom, (callback) => getMembers());
  }

  void getMembers() async {
    groupMembers.clear();
    for (var member in chatRoom.value.members!) {
      DocumentSnapshot mem = await FirebaseFirestore.instance.doc(member).get();
      groupMembers.add(mem);
    }
  }

  void getAllTransactions() async {
    if(chatRoom.value.creditCard!.cardTransactionPath == "") return;
    FirebaseFirestore.instance.collection(chatRoom.value.creditCard!.cardTransactionPath!).orderBy("time", descending: true).snapshots().listen((event) {
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
    total.value = (debit - credit);
  }
}
