import 'package:mooweapp/export_files.dart';

class CallHistoryController extends GetxController{
  static CallHistoryController instance = Get.find();
  RxList<DocumentSnapshot> userCallHistory = RxList<DocumentSnapshot>([]);
  @override
  void onInit() {
    ever(chatServices.localMember.obs, (callback) => userCallHistory.bindStream(getAllCalls()));

    super.onInit();
  }
  Stream<List<DocumentSnapshot>> getAllCalls() => firebaseFirestore.collection(chatServices.localMember!.get(memberModel.callPath)).orderBy("time", descending: true).snapshots().map((query) =>
      query.docs.map((item) => item).toList());

}