

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mooweapp/classes/credit_card.dart';
import 'package:mooweapp/enums.dart';

class Business{
  String? firstName, lastName, phone,businessName, address, businessPhone, city, state,zip;
  String? cardTransactionPath, businessPath, currencyCode, currencySign;
  CreditCard? creditCard;
  DocumentSnapshot? snapshot;
  bool? requireCustomerAddress;
  List<dynamic>? admins;
  List<dynamic>? supperAdmin;
  List<dynamic>? members;
  List<dynamic>? deviceTokens;
  List<dynamic>? userBusinessPath;
  String? manager;
  Timestamp? time;
  String? search;
  dynamic position;
   String? country;
   String? locality;
   String? imageUrl;
  UserBusinessType? userBusinessType;


  factory Business.fromSnap(DocumentSnapshot snapshot) {
    Map<String, dynamic> busi = snapshot.data() as Map<String, dynamic>;

    return Business(
      firstName: snapshot.get("firstName") as String,
      lastName: snapshot.get("lastName") as String,
      search: snapshot.get("search") as String,
      phone: snapshot.get("phone") as String,
      businessName: snapshot.get("businessName") as String,
      address: snapshot.get("address") as String,
      businessPhone: snapshot.get("businessPhone") as String,
      city: snapshot.get("city") as String,
      state: snapshot.get("state") as String,
      zip: snapshot.get("zip") as String,
      cardTransactionPath: snapshot.get("cardTransactionPath") as String,
      businessPath: snapshot.get("businessPath") as String,
      currencyCode: snapshot.get("currencyCode") as String,
      currencySign: snapshot.get("currencySign") as String,
      creditCard: CreditCard.fromMap(snapshot.get("creditCard")),
      snapshot: snapshot,
      requireCustomerAddress: snapshot.get("requireCustomerAddress") as bool,
      admins: snapshot.get("admins") as List<dynamic>,
      supperAdmin: snapshot.get("supperAdmin") as List<dynamic>,
      members: snapshot.get("members") as List<dynamic>,
      deviceTokens: snapshot.get("deviceTokens") as List<dynamic>,
      userBusinessPath: snapshot.get("userBusinessPath") as List<dynamic>,
      userBusinessType:  EnumToString.fromString(UserBusinessType.values,  snapshot.get("userBusinessType")),
      manager: snapshot.get("manager") as String,
      time: snapshot.get("time") as Timestamp,
      country: snapshot.get("country") as String,
      position: snapshot.get("position"),
      imageUrl: busi.containsKey("imageUrl")? snapshot.get("imageUrl") : null,
      locality: snapshot.get("locality") as String,
    );
  }

//<editor-fold desc="Data Methods">

  Business({
    this.firstName,
    this.lastName,
    this.phone,
    this.businessName,
    this.address,
    this.businessPhone,
    this.city,
    this.state,
    this.zip,
    this.cardTransactionPath,
    this.businessPath,
    this.currencyCode,
    this.currencySign,
    this.creditCard,
    this.snapshot,
    this.requireCustomerAddress,
    this.admins,
    this.supperAdmin,
    this.members,
    this.deviceTokens,
    this.userBusinessPath,
    this.manager,
    this.time,
    this.search,
    this.position,
    this.country,
    this.locality,
    this.imageUrl,
    this.userBusinessType,
  });



  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'search': search,
      'phone': phone,
      'businessName': businessName,
      'address': address,
      'businessPhone': businessPhone,
      'city': city,
      'state': state,
      'zip': zip,
      'cardTransactionPath': cardTransactionPath,
      'businessPath': businessPath,
      'currencyCode': currencyCode,
      'currencySign': currencySign,
      'creditCard': creditCard!.toMap(),
      'requireCustomerAddress': requireCustomerAddress,
      'admins': admins,
      'supperAdmin': supperAdmin,
      'members': members,
      'deviceTokens': deviceTokens,
      'userBusinessPath': userBusinessPath,
      'position': position,
      'userBusinessType': EnumToString.convertToString(userBusinessType),
      'manager': manager,
      'time': time,
      'country': country,
      'imageUrl': imageUrl,
      'locality': locality,
    };
  }

  factory Business.fromMap(Map<String, dynamic> map) {
    return Business(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      phone: map['phone'] as String,
      businessName: map['businessName'] as String,
      address: map['address'] as String,
      businessPhone: map['businessPhone'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      zip: map['zip'] as String,
      cardTransactionPath: map['cardTransactionPath'] as String,
      businessPath: map['businessPath'] as String,
      currencyCode: map['currencyCode'] as String,
      currencySign: map['currencySign'] as String,
      creditCard: map['creditCard'] as CreditCard,
      requireCustomerAddress: map['requireCustomerAddress'] as bool,
      admins: map['admins'] as List<dynamic>,
      supperAdmin: map['supperAdmin'] as List<dynamic>,
      members: map['members'] as List<dynamic>,
      deviceTokens: map['deviceTokens'] as List<dynamic>,
      userBusinessPath: map['userBusinessPath'] as List<dynamic>,
      manager: map['manager'] as String,
      time: map['time'] as Timestamp,
      search: map['search'] as String,
      position: map['position'] as dynamic,
      country: map['country'] as String,
      locality: map['locality'] as String,
      imageUrl: map['imageUrl'] as String,
      userBusinessType: map['userBusinessType'] as UserBusinessType,
    );
  }

//</editor-fold>
}

class UserBusiness{
  String businessAccountPath;
  Timestamp time;
  UserBusinessType? userBusinessType;
  DocumentReference? reference;

//<editor-fold desc="Data Methods">

  UserBusiness({
    required this.businessAccountPath,
    required this.time,
    required this.userBusinessType,
    reference,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserBusiness &&
          runtimeType == other.runtimeType &&
          businessAccountPath == other.businessAccountPath &&
          time == other.time &&
          userBusinessType == other.userBusinessType &&
          reference == other.reference);

  @override
  int get hashCode => businessAccountPath.hashCode ^ time.hashCode ^ userBusinessType.hashCode ^ reference.hashCode;

  @override
  String toString() {
    return 'UserBusiness{' ' businessAccountPath: $businessAccountPath,' ' time: $time,' ' userBusinessType: $userBusinessType,' '}';
  }

  UserBusiness copyWith({
    String? businessAccountPath,
    Timestamp? time,
    UserBusinessType? userBusinessType,
    DocumentReference? reference,
  }) {
    return UserBusiness(
      businessAccountPath: this.businessAccountPath,
      time: this.time,
      userBusinessType: userBusinessType ?? userBusinessType,
      reference: reference ?? reference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'businessAccountPath': businessAccountPath,
      'time': time,
      'userBusinessType': EnumToString.convertToString(userBusinessType),
    };
  }

  factory UserBusiness.fromMap(Map<String, dynamic> map) {
    return UserBusiness(
      businessAccountPath: map['businessAccountPath'] as String,
      time: map['time'] as Timestamp,
      userBusinessType: EnumToString.fromString(UserBusinessType.values, map['userBusinessType'] ),
    );
  }
  factory UserBusiness.fromSnap(DocumentSnapshot snapshot) {
    return UserBusiness(
      businessAccountPath: snapshot.get("businessAccountPath") as String,
      time: snapshot.get("time") as Timestamp,
      userBusinessType: EnumToString.fromString(UserBusinessType.values, snapshot.get("userBusinessType") ),
    );
  }
//</editor-fold>
}