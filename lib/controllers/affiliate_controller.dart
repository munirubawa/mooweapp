// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:mooweapp/Screens/MarketPlace/constants/firebase.dart';
// import 'package:mooweapp/global.dart';
//
// import '../classes/member_model.dart';
import 'package:mooweapp/export_files.dart';
class AffiliateController extends GetxController {
  static AffiliateController instance = Get.find();
  RxList<DocumentSnapshot> members = RxList<DocumentSnapshot>([]);
  DocumentSnapshot? memberUserIsAffiliatedTo;
  DocumentSnapshot? localMemberAffiliateData;
  RxBool hasActivatedAffiliateProgram = RxBool(false);

  @override
  void onInit() {
    getAffiliate();
    updateOnboard();
    getMemberUserIsAffiliatedTo();
    super.onInit();
  }

  void getAffiliate() {
    firebaseFirestore
        .collection("affiliates")
        .where("affiliate", isEqualTo: auth.currentUser!.uid)
        .snapshots()
        .listen((event) {
      hasActivatedAffiliateProgram.value = event.docs.isNotEmpty;
      if (event.docs.isNotEmpty) {
        localMemberAffiliateData = event.docs.first;
        var model = AffiliateModel.fromSnap(event.docs.first);
        // print(AffiliateModel.fromSnap(event.docs.first).toMap());

        firebaseFirestore
            .collection("affiliateMembers")
            .where("affiliate", isEqualTo: model.affiliate)
            .where("onboard", isEqualTo: true)
            .snapshots()
            .listen((event) {
          if (event.docs.isNotEmpty) {
            // List<AffiliateMemberModel> members = event.docs.map((e) => AffiliateMemberModel.fromSnap(e)).toList();
            List<DocumentSnapshot> mem = event.docs.map((e) => e).toList();
            print("members AffiliateMemberModel");
            members.value = mem;
            print(members.length);
            // getMembers(members);
          }
        });
      }
    });
  }

  void updateOnboard(){
    print("updateOnboard AffiliateMemberModel");

    firebaseFirestore
        .collection("affiliateMembers")
        .where("affiliateMember", isEqualTo: auth.currentUser!.uid)
        .where("onboard", isEqualTo: false)
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        // List<AffiliateMemberModel> members = event.docs.map((e) => AffiliateMemberModel.fromSnap(e)).toList();
        List<DocumentSnapshot> members = event.docs.map((e) => e).toList();
        print("members AffiliateMemberModel");
        var update = members.first;
        // update.onboard = true;
        update.reference.update({
          "onboard": true,
          "earned": 0.0,
          "currencyCode": chatServices.localMember!.get(memberModel.currencyCode),
          "imageUrl": chatServices.localMember!.get(memberModel.imageUrl),
          "firstName": chatServices.localMember!.get(memberModel.firstName),
          "lastName": chatServices.localMember!.get(memberModel.lastName),
        });
      }
    });
  }
  void getMemberUserIsAffiliatedTo(){
    print("getMemberUserIsAffiliatedTo");

    firebaseFirestore
        .collection("affiliateMembers")
        .where("affiliateMember", isEqualTo: auth.currentUser!.uid)
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        List<DocumentSnapshot> members = event.docs.map((e) => e).toList();
        print("members AffiliateMemberModel");
        memberUserIsAffiliatedTo = members.first;
        print(memberUserIsAffiliatedTo!.data());
      // update.reference.update(data)
      //   update.reference.update(update.);
      }
    });
  }

  // Future<void> getMembers(List<AffiliateMemberModel> memberModels) async {
  //   List<Member> localMem = [];
  //   for (var affiliateMember in memberModels) {
  //     print("affiliateMember");
  //     print(affiliateMember);
  //     Member member = await firebaseFirestore
  //         .collection("contacts")
  //         .doc(affiliateMember.affiliateMember)
  //         .get()
  //         .then((value) => Member.fromSnap(value));
  //     localMem.add(member);
  //     print("member AffiliateMemberModel");
  //     print(member.toMap());
  //   }
  //   // members.value = localMem;
  // }
}

class AffiliateMemberModel {
  String? affiliate;
  String? affiliateMember;
  String? affiliateMemberNumber;
  bool? onboard;
  DocumentReference? reference;


  factory AffiliateMemberModel.fromSnap(DocumentSnapshot snapshot) {
    return AffiliateMemberModel(
      reference: snapshot.reference,
      affiliate: snapshot.get("affiliate") as String,
      affiliateMember: snapshot.get("affiliateMember") as String,
      affiliateMemberNumber: snapshot.get("affiliateMemberNumber") as String,
      onboard: snapshot.get("onboard") as bool,
    );
  }

//<editor-fold desc="Data Methods">

  AffiliateMemberModel({
    this.affiliate,
    this.affiliateMember,
    this.affiliateMemberNumber,
    this.onboard,
    this.reference,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AffiliateMemberModel &&
          runtimeType == other.runtimeType &&
          affiliate == other.affiliate &&
          affiliateMember == other.affiliateMember &&
          affiliateMemberNumber == other.affiliateMemberNumber &&
          onboard == other.onboard &&
          reference == other.reference);

  @override
  int get hashCode =>
      affiliate.hashCode ^
      affiliateMember.hashCode ^
      affiliateMemberNumber.hashCode ^
      onboard.hashCode ^
      reference.hashCode;

  @override
  String toString() {
    return 'AffiliateMemberModel{' ' affiliate: $affiliate,' ' affiliateMember: $affiliateMember,' ' affiliateMemberNumber: $affiliateMemberNumber,' ' onboard: $onboard,' +
        ' reference: $reference,' +
        '}';
  }

  AffiliateMemberModel copyWith({
    String? affiliate,
    String? affiliateMember,
    String? affiliateMemberNumber,
    bool? onboard,
    DocumentReference? reference,
  }) {
    return AffiliateMemberModel(
      affiliate: affiliate ?? this.affiliate,
      affiliateMember: affiliateMember ?? this.affiliateMember,
      affiliateMemberNumber: affiliateMemberNumber ?? this.affiliateMemberNumber,
      onboard: onboard ?? this.onboard,
      reference: reference ?? this.reference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'affiliate': affiliate,
      'affiliateMember': affiliateMember,
      'affiliateMemberNumber': affiliateMemberNumber,
      'onboard': onboard,
    };
  }

  factory AffiliateMemberModel.fromMap(Map<String, dynamic> map) {
    return AffiliateMemberModel(
      affiliate: map['affiliate'] as String,
      affiliateMember: map['affiliateMember'] as String,
      affiliateMemberNumber: map['affiliateMemberNumber'] as String,
      onboard: map['onboard'] as bool,
      reference: map['reference'] as DocumentReference,
    );
  }

//</editor-fold>
}

class AffiliateModel {
  String? affiliate;
  String? affiliateId;
  String? type;

//<editor-fold desc="Data Methods">

  AffiliateModel({
    this.affiliate,
    this.affiliateId,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'affiliate': affiliate,
      'affiliateId': affiliateId,
      'type': type,
    };
  }

  factory AffiliateModel.fromSnap(DocumentSnapshot snapshot) {
    return AffiliateModel(
      affiliate: snapshot.get("affiliate") as String,
      affiliateId: snapshot.get("affiliateId") as String,
      type: snapshot.get("type") as String,
    );
  }

//</editor-fold>
}
AffiliateModelModel affiliateModelModel = AffiliateModelModel();
class AffiliateModelModel{
  String affiliate = "affiliate";
  String affiliateId = "affiliateId";
  String type = "type";
  String url = "url";
}
