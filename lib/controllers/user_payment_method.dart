import 'package:mooweapp/export_files.dart';
class UserPaymentMethod {
  String? defaultPaymentMethodId;
  String? accessToken;
  List<dynamic>? paymentMethods;
  DocumentReference? reference;
  String? passcode;
  String? customer;
  String? default_source;

  factory UserPaymentMethod.fromSnap(DocumentSnapshot snapshot) {
    return UserPaymentMethod(
      reference: snapshot.reference,
      defaultPaymentMethodId: snapshot.get("defaultPaymentMethodId") as String,
      passcode: snapshot.get("passcode") as String,
      accessToken: snapshot.get("accessToken") as String,
      paymentMethods: snapshot.get("paymentMethods"),
      customer: snapshot.get("customer"),
      default_source: snapshot.get("default_source"),
    );
  }

//<editor-fold desc="Data Methods">

  UserPaymentMethod({
    this.defaultPaymentMethodId,
    this.accessToken,
    this.paymentMethods,
    this.reference,
    this.passcode,
    this.customer,
    this.default_source,
  });

  UserPaymentMethod copyWith({
    String? defaultPaymentMethodId,
    String? accessToken,
    List<dynamic>? paymentMethods,
    DocumentReference? reference,
    String? passcode,
    String? customer,
    String? default_source,
  }) {
    return UserPaymentMethod(
      defaultPaymentMethodId: defaultPaymentMethodId ?? this.defaultPaymentMethodId,
      accessToken: accessToken ?? this.accessToken,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      reference: reference ?? this.reference,
      passcode: passcode ?? this.passcode,
      customer: customer ?? this.customer,
      default_source: default_source ?? this.default_source,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'defaultPaymentMethodId': defaultPaymentMethodId,
      'accessToken': accessToken,
      'paymentMethods': paymentMethods,
      'passcode': passcode,
      'customer': customer,
      'default_source': default_source,
    };
  }

  factory UserPaymentMethod.fromMap(Map<String, dynamic> map) {
    return UserPaymentMethod(
      defaultPaymentMethodId: map['defaultPaymentMethodId'] as String,
      accessToken: map['accessToken'] as String,
      paymentMethods: map['paymentMethods'] as List<dynamic>,
      reference: map['reference'] as DocumentReference,
      passcode: map['passcode'] as String,
      customer: map['customer'] as String,
      default_source: map['default_source'] as String,
    );
  }

//</editor-fold>
}