// import 'dart:ui';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mooweapp/classes/country_model.dart';
// import 'package:mooweapp/classes/country_model.dart';
// import 'package:mooweapp/classes/local_user.dart';
// import 'package:mooweapp/classes/local_user.dart';
// import 'package:mooweapp/classes/transactions.dart';
// import 'package:mooweapp/global.dart';
import 'package:mooweapp/export_files.dart';

import 'country_model.dart';
enum CardBrand { visa, mastercard }
class CreditCard {
   String? firstName, lastName, securityCode, number, currencyCode, userDocId, accountType, cardDocId;
   String? cardTransactionPath;
   String? imageUrl, currencySign;
   String? brand;
   String? nameOnCard;
   double? amount;
   List<dynamic>? colors;
   bool? isDefault;
   bool? isCardActivated;
   List<dynamic>? leanAmount;
   double? cardBalance;


  CreditCard({
    this.firstName,
    this.lastName,
    this.securityCode,
    this.number,
    this.currencyCode,
    this.currencySign,
    this.userDocId,
    this.accountType,
    this.cardDocId,
    this.cardTransactionPath,
    this.imageUrl,
    this.brand,
    this.nameOnCard,
    this.amount,
    this.colors,
    this.isDefault,
    this.isCardActivated,
    this.leanAmount = const [],
    this.cardBalance = 0.0,
  });

//  C@override
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is CreditCard &&
              runtimeType == other.runtimeType &&
              firstName == other.firstName &&
              lastName == other.lastName &&
              securityCode == other.securityCode &&
              number == other.number &&
              currencyCode == other.currencyCode &&
              currencySign == other.currencySign &&
              userDocId == other.userDocId &&
              accountType == other.accountType &&
              cardDocId == other.cardDocId &&
              cardTransactionPath == other.cardTransactionPath &&
              imageUrl == other.imageUrl &&
              brand == other.brand &&
              nameOnCard == other.nameOnCard &&
              amount == other.amount &&
              colors == other.colors &&
              isDefault == other.isDefault &&
              isCardActivated == other.isCardActivated &&
              leanAmount == other.leanAmount &&
              cardBalance == other.cardBalance
          );


  @override
  int get hashCode =>
      firstName.hashCode ^
      lastName.hashCode ^
      securityCode.hashCode ^
      number.hashCode ^
      currencyCode.hashCode ^
      currencySign.hashCode ^
      userDocId.hashCode ^
      accountType.hashCode ^
      cardDocId.hashCode ^
      cardTransactionPath.hashCode ^
      imageUrl.hashCode ^
      brand.hashCode ^
      nameOnCard.hashCode ^
      amount.hashCode ^
      colors.hashCode ^
      isDefault.hashCode ^
      isCardActivated.hashCode ^
      leanAmount.hashCode ^
      cardBalance.hashCode;


  @override
  String toString() {
    return 'CreditCard{' ' firstName: $firstName,' ' lastName: $lastName,' ' securityCode: $securityCode,' ' number: $number,' ' currencyCode: $currencyCode,' ' currencySign: $currencySign,' ' userDocId: $userDocId,' ' accountType: $accountType,' +
        ' cardDocId: $cardDocId,' +
        ' cardTransactionPath: $cardTransactionPath,' +
        ' imageUrl: $imageUrl,' +
        ' brand: $brand,' +
        ' nameOnCard: $nameOnCard,' +
        ' amount: $amount,' +
        ' colors: $colors,' +
        ' isDefault: $isDefault,' +
        ' isCardActivated: $isCardActivated,' +
        ' leanAmount: $leanAmount,' +
        ' cardBalance: $cardBalance,' +
        '}';
  }


  CreditCard copyWith({
    String? firstName,
    String? lastName,
    String? securityCode,
    String? number,
    String? currencyCode,
    String? currencySign,
    String? userDocId,
    String? accountType,
    String? cardDocId,
    String? cardTransactionPath,
    String? imageUrl,
    String? brand,
    String? nameOnCard,
    double? amount,
    List<dynamic>? colors,
    bool? isDefault,
    bool? isCardActivated,
    List<MooweTransactions>? transactions,
    List<dynamic>? leanAmount,
    double? cardBalance,
  }) {
    return CreditCard(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      securityCode: securityCode ?? this.securityCode,
      number: number ?? this.number,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySign: currencySign ?? this.currencySign,
      userDocId: userDocId ?? this.userDocId,
      accountType: accountType ?? this.accountType,
      cardDocId: cardDocId ?? this.cardDocId,
      cardTransactionPath: cardTransactionPath ?? this.cardTransactionPath,
      imageUrl: imageUrl ?? this.imageUrl,
      brand: brand ?? this.brand,
      nameOnCard: nameOnCard ?? this.nameOnCard,
      amount: amount ?? this.amount,
      colors: colors ?? this.colors,
      isDefault: isDefault ?? this.isDefault,
      isCardActivated: isCardActivated ?? this.isCardActivated,
      leanAmount: leanAmount ?? this.leanAmount,
      cardBalance: cardBalance ?? this.cardBalance,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'securityCode': securityCode,
      'number': number,
      'currencyCode': currencyCode,
      'currencySign': currencySign,
      'userDocId': userDocId,
      'accountType': accountType,
      'cardDocId': cardDocId,
      'cardTransactionPath': cardTransactionPath,
      'imageUrl': imageUrl,
      'brand': brand,
      'nameOnCard': nameOnCard,
      'amount': amount,
      'colors': colors,
      'isDefault': isDefault,
      'isCardActivated': isCardActivated,
      'leanAmount': leanAmount,
      'cardBalance': cardBalance,
    };
  }

  factory CreditCard.fromMap(Map<String, dynamic> map) {
    return CreditCard(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      securityCode: map['securityCode'] as String,
      number: map['number'] as String,
      currencyCode: map['currencyCode'] as String,
      currencySign: map['currencySign'] as String,
      userDocId: map['userDocId'] as String,
      accountType: map['accountType'] as String,
      cardDocId: map['cardDocId'] as String,
      cardTransactionPath: map['cardTransactionPath'] as String,
      imageUrl: map['imageUrl'] as String,
      brand: map['brand'] as String,
      nameOnCard: map['nameOnCard'] as String,
      amount: double.parse(map['amount'].toString()),
      colors: map['colors'] as List<dynamic>,
      isDefault: map['isDefault'] as bool,
      isCardActivated: map['isCardActivated'] as bool,
      leanAmount: map['leanAmount'] as List<dynamic>,
      cardBalance: double.parse( map['cardBalance'].toString()) ,
    );
  }

  factory CreditCard.fromSnap(DocumentSnapshot snapshot) {
    return CreditCard(
      firstName: snapshot.get("firstName") as String,
      lastName: snapshot.get("lastName") as String,
      securityCode: snapshot.get("securityCode") as String,
      number: snapshot.get("number") as String,
      currencyCode: snapshot.get("currencyCode") as String,
      currencySign: snapshot.get("currencySign") as String,
      userDocId: snapshot.get("userDocId") as String,
      cardTransactionPath: snapshot.get("cardTransactionPath") as String,
      accountType: snapshot.get("accountType") as String,
      cardDocId: snapshot.get("cardDocId") as String,
      imageUrl: snapshot.get("imageUrl") as String,
      brand: snapshot.get("brand") as String,
      nameOnCard: snapshot.get("nameOnCard") as String,
      amount: snapshot.get("amount"),
      colors: snapshot.get("colors") as List<dynamic>,
      isDefault: snapshot.get("isDefault") as bool,
      isCardActivated: snapshot.get("isCardActivated") as bool,
      leanAmount: snapshot.get("leanAmount") as List<dynamic>,
      cardBalance: snapshot.get("cardBalance") as double,
    );
  }

  Map<String, dynamic> toQrMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "cardDocId": cardDocId,
      "imageUrl": imageUrl,
      "currencyCode": currencyCode,
      "accountType": accountType,
      "transactionType": 'initialTransaction',
    };
  }

  balance({bool leanOverride = true}) async  {
     double totalBalance = 0.0;
    return totalBalance;
  }
}



List<CreditCard> listCars = [];
// var service = locator.get<FirestoreService>();
List<CreditCard> availableCards = [
  CreditCard(
    firstName: "",
    lastName: "",
    securityCode: "4260 553",
    number: "1234 5678 9101 1123",
    brand: "${CardBrand.visa}",
    amount: 0.0,
    imageUrl: chatServices.localUser!.get(localUserModel.imageUrl) ?? "",
    accountType: "",
    isCardActivated: false,
    currencyCode: '${selectedCountryInfo[countryModelModel.currencyCode]}',
    nameOnCard: initialChat.displayName.toString(),
    colors: [
      const Color(0xFF000000).toString(),
      const Color(0XFF000000).toString(),
    ],
    isDefault: false,
    userDocId: '',
  ),
  CreditCard(
    firstName: "",
    lastName: "",
    securityCode: "4260 553",
    number: "1234 5678 9101 1123",
    brand: "${CardBrand.visa}",
    amount: 0.0,
    imageUrl: chatServices.localUser!.get(localUserModel.imageUrl) ?? "",
    accountType: "",
    isCardActivated: false,
    currencyCode: '${selectedCountryInfo[countryModelModel.currencyCode]}',
    nameOnCard: initialChat.displayName.toString(),
    colors: [
      const Color(0xFF0000FF).toString(),
      const Color(0XFF377CFF).toString(),
    ],
    isDefault: false,
    userDocId: '',
  ),
  CreditCard(
    firstName: "",
    lastName: "",
    securityCode: "4260 553",
    number: "1234 5678 9101 1123",
    brand: "${CardBrand.mastercard}",
    amount: 0.0,
    imageUrl: chatServices.localUser!.get(localUserModel.imageUrl) ?? "",
    accountType: "",
    currencyCode: '${selectedCountryInfo[countryModelModel.currencyCode]}',
    nameOnCard: initialChat.displayName.toString(),
    isCardActivated: false,
    colors: [
      const Color(0xFFFFA351).toString(),
      const Color(0xFFF83D34).toString(),
    ],
    isDefault: false,
    userDocId: '',
  ),
  CreditCard(
    firstName: "",
    lastName: "",
    securityCode: "4260 553",
    number: "1234 5678 9101 1123",
    brand: "${CardBrand.mastercard}",
    amount: 0.0,
    accountType: "",
    imageUrl: chatServices.localUser!.get(localUserModel.imageUrl) ?? "",
    isCardActivated: false,
    currencyCode: '${selectedCountryInfo[countryModelModel.currencyCode]}',
    nameOnCard: initialChat.displayName.toString(),
    colors: [
      const Color(0xFF990099).toString(),
      const Color(0xFF660066).toString(),
    ],
    isDefault: false,
    userDocId: '',
  ),
  // CreditCard(
  //   firstName: "",
  //   lastName: "",
  //   securityCode: "4260 553",
  //   number: "1234 5678 9101 1123",
  //   brand: "${CardBrand.visa}",
  //   isCardActivated: false,
  //   amount: 0.0,
  //   imageUrl: localUser.imageUrl ?? "",
  //   accountType: "",
  //   currency: '${selectedCountryInfo.currencyCode}',
  //   nameOnCard: initialChat.groupName.toString(),
  //   colors: [
  //     Color(0xFF0000FF).toString(),
  //     Color(0XFF377CFF).toString(),
  //   ],
  //   isDefault: false,
  //   userDocId: '',
  // ),
  // CreditCard(
  //   firstName: "",
  //   lastName: "",
  //   securityCode: "4260 553",
  //   number: "1234 5678 9101 1123",
  //   brand: "${CardBrand.mastercard}",
  //   amount: 0.0,
  //   isCardActivated: false,
  //   imageUrl: localUser.imageUrl ?? "",
  //   accountType: "",
  //   currency: '${selectedCountryInfo.currencyCode}',
  //   nameOnCard: initialChat.groupName.toString(),
  //   colors: [
  //     Color(0xFFFFA351).toString(),
  //     Color(0xFFF83D34).toString(),
  //   ],
  //   isDefault: false,
  //   userDocId: '',
  // ),
  // CreditCard(
  //   firstName: "",
  //   lastName: "",
  //   securityCode: "4260 553",
  //   number: "1234 5678 9101 1123",
  //   brand: "${CardBrand.visa}",
  //   amount: 0.0,
  //   imageUrl: localUser.imageUrl ?? "",
  //   isCardActivated: false,
  //   accountType: "",
  //   currency: '${selectedCountryInfo.currencyCode}',
  //   nameOnCard: initialChat.groupName.toString(),
  //   colors: [
  //     Color(0xFFFFA351).toString(),
  //     Color(0xFFF83D34).toString(),
  //   ],
  //   isDefault: false,
  //   userDocId: '',
  // ),
];
