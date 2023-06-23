import 'package:mooweapp/export_files.dart';

class ContractController extends GetxController {
  static ContractController instance = Get.find();
  RxMap<String, dynamic> contract = RxMap();
  RxString creatorFirstName = RxString("");
  RxString receiverFirstName = RxString("");
  RxString creatorLastName = RxString("");
  RxString receiverLastName = RxString("");
  RxMap<String, dynamic> contractData = RxMap();
  DocumentSnapshot? contractSnap;
  String userContractIds = "userContractIds";
  RxList<DocumentSnapshot> userContracts = RxList<DocumentSnapshot>([]);

  @override
  void onInit() {
    contract.value[conModel.thisContract] =
        "This Safe contract is hereby entered in agreement between ";
    contract.value[conModel.and] = "and ";
    contract.value[conModel.toProtect] =
        "To protect both parties in this agreement, the agreed amount will be held in Moowe eScroll until this contract is for filed between ";
    contract.value[conModel.contractAccepted] = false;
    contract.value[conModel.receiverAccepted] = false;
    contract.value[conModel.receiverDispute] = false;
    contract.value[conModel.creatorDispute] = false;
    contract.value[conModel.releasePayment] = false;
    contract.value[conModel.contractDispute] = false;
    contract.value[conModel.cancelContract] = false;
    contract.value[conModel.rejected] = false;
    // userContracts.bindStream(getAllContracts());
    getAllUserContracts();
    super.onInit();
  }

  void saveContractId(String contractId) {
    print("contractId");
    print(contractId);
    List<dynamic> ids = box.read(userContractIds) ?? [];

    if (!ids.contains(contractId)) {
      ids.add(contractId);
      box.write(userContractIds, ids);
      getAllUserContracts();
    }
  }

  void getAllUserContracts() {
    List<dynamic> ids = box.read(userContractIds) ?? [];
    // ids.clear();
    // userContracts.value.clear();
    for (var value in ids) {
      firebaseFirestore
          .collection(dbHelper.contracts())
          .doc(value)
          .snapshots()
          .listen((event) {
        if (event.exists) {
          userContracts.value.removeWhere((element) => element.id == event.id);
          userContracts.add(event);
        }
      });
    }
  }

  // Stream<List<DocumentSnapshot>> getAllContracts() => firebaseFirestore.collection(dbHelper.contracts()).where(conModel.receiverId, isEqualTo: dbHelper.userId()).snapshots().map((query) => query.docs.map((item) => item).toList());

  void setupInfo() {
    creatorFirstName.value = contract[conModel.creator][conModel.firstName];
    creatorLastName.value = contract[conModel.creator][conModel.lastName];

    receiverFirstName.value = contract[conModel.receiver][conModel.firstName];
    receiverLastName.value = contract[conModel.receiver][conModel.lastName];
  }

  Future<void> getContract({required String contractId}) async {
    firebaseFirestore
        .collection(dbHelper.contracts())
        .doc(contractId)
        .snapshots()
        .listen((event) {
      contractSnap = event;
      contractController.saveContractId(event.id);
      contractData.value = contractSnap!.data() as Map<String, dynamic>;
      // contractSnap!.reference.update({
      //   conModel.contractDispute: false,
      //   conModel.cancelContract: false,
      //   conModel.rejected: false,
      // });
    });
  }

  getNumberOfDay() {
    final start = contractController.contractData[conModel.startDateEndDate]
            ["startDate"]
        .toDate();
    final end = contractController.contractData[conModel.startDateEndDate]
            ["endDate"]
        .toDate();
    final difference = end.difference(start).inDays;
    return difference;
  }

  getDaysTill() {
    final start = DateTime.now();
    final end = contractController.contractData[conModel.startDateEndDate]
            ["endDate"]
        .toDate();
    final difference = end.difference(start).inDays;
    return difference;
  }

  void disputeContract() {
    if (!contractController.contractData[conModel.contractDispute]) {
      if (contractController.contractData[conModel.receiver]
              [conModel.userUID] ==
          chatServices.localMember!.get(memberModel.userUID)) {
        contractController.contractSnap!.reference.update({
          conModel.contractDispute: true,
          conModel.receiverDispute: true,
          conModel.status:
              "${contractData[conModel.receiver][conModel.firstName]} dispute",
        });
      } else {
        contractController.contractSnap!.reference.update({
          conModel.contractDispute: true,
          conModel.creatorDispute: true,
          conModel.status:
              "${contractData[conModel.creator][conModel.firstName]} dispute",
        });
      }
    } else {
      Get.defaultDialog(
          barrierDismissible: false,
          title: "Disputed",
          content: const Text(
            "Contract Already in dispute",
            textAlign: TextAlign.center,
          ),
          confirm: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Okay"),
            ),
          ));
    }
  }
}
