import 'package:cloud_firestore/cloud_firestore.dart';

class ProfOfWork {
  ProfOfWork({
    this.firstName,
    this.lastName,
    this.uploaderUid,
    this.timeStamp,
    this.images,
  });

  String? firstName;
  String? lastName;
  String? uploaderUid;
  Timestamp? timeStamp;
  List<String>? images;

  factory ProfOfWork.fromMap(Map<String, dynamic> json) => ProfOfWork(
    firstName: json["firstName"],
    lastName: json["lastName"],
    uploaderUid: json["uploaderUid"],
    timeStamp: json["timeStamp"],
    images: List<String>.from(json["images"].map((x) => x)),
  );


  ProfOfWork.fromFirstore(DocumentSnapshot? doc) {

    firstName = doc!.get('firstName');
    lastName = doc.get('lastName');
    uploaderUid = doc.get("uploaderUid");
    timeStamp = doc.get("timeStamp");
    images = List<String>.from(doc.get("timeStamp").map((x) => x));

  }

  Map<String, dynamic> toMap() => {
    "firstName": firstName,
    "lastName": lastName,
    "uploaderUid": uploaderUid,
    "timeStamp": timeStamp,
    "images": List<dynamic>.from(images!.map((x) => x)),
  };
}