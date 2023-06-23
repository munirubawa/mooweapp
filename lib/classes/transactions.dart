import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mooweapp/enums.dart';

class MooweTransactions {
  late  String? firstName;
  late  String?  lastName;
  late  String? currencyCode;
  late  String? currencySign;
  late  String? imageUrl;
  late double? value;
  late double? credit;
  late double? debit;
  late  String? timeStamp;
  TransactionType? type;




//<editor-fold desc="Data Methods">

  MooweTransactions({
   required this.firstName,
    required this.lastName,
    required this.currencyCode,
    required this.currencySign,
    required this.imageUrl,
    required this.value,
    required this.credit,
    required this.debit,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'currencyCode': currencyCode,
      'currencySign': currencySign,
      'imageUrl': imageUrl,
      'value': value,
      'credit': credit,
      'debit': debit,
      'timeStamp': timeStamp,
    };
  }

  factory MooweTransactions.fromJson(Map<String, dynamic> map) {
    return MooweTransactions(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      currencyCode: map['currencyCode'] as String,
      currencySign: map['currencySign'] as String,
      imageUrl: map['imageUrl'] as String,
      value: map['value'] as double,
      credit: map['credit'] as double,
      debit: map['debit'] as double,
      timeStamp: map['timeStamp'] as String,
    );
  }

//</editor-fold>
}

MooweTransactionModel mooweTransactionModel = MooweTransactionModel();
class MooweTransactionModel{
    String firstName = "firstName";
    String  lastName = "lastName";
    String currencyCode = "currencyCode";
    String currencySign = "currencySign";
    String imageUrl = "imageUrl";
   String value = "value";
   String credit = "credit";
   String debit = "debit";
    String timeStamp = "timeStamp";
}

class TransactionPayload{
  late  TransactionType? transactionType;
  late  TransactionPayloadType? payloadType;
  late String? cardTransactionCollectionPath;
  String? contactPath;
  String? note;
  late Timestamp? time;
  late Map<String, dynamic> data;
  DocumentReference? reference;

  // late MooweTransactions? transactions;
  // late MooweTransactions? fromTransaction;
  // late MooweTransactions? toTransaction;
  // late String? requestToContactPath;
  // late String? requestFromContactPath;
  // bool? isCurrencyExchange;



//<editor-fold desc="Data Methods">

  TransactionPayload({
    this.reference ,
    this.contactPath = "",
    this.note = "",
    required this.transactionType,
    required this.payloadType,
    required this.cardTransactionCollectionPath,
    required this.time,
    required this.data,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionPayload &&
          runtimeType == other.runtimeType &&
          transactionType == other.transactionType &&
          payloadType == other.payloadType &&
          cardTransactionCollectionPath == other.cardTransactionCollectionPath &&
          contactPath == other.contactPath &&
          note == other.note &&
          time == other.time &&
          data == other.data);

  @override
  int get hashCode => transactionType.hashCode ^
  payloadType.hashCode ^
  cardTransactionCollectionPath.hashCode ^
  contactPath.hashCode ^
  time.hashCode ^
  data.hashCode;

  @override
  String toString() {
    return 'TransactionPayload{' ' transactionType: $transactionType,' ' payloadType: $payloadType,' ' cardTransactionCollectionPath: $cardTransactionCollectionPath,' ' contactPath: $contactPath,' ' note: $note,' ' time: $time,' ' data: $data,' '}';
  }

  TransactionPayload copyWith({
    TransactionType? transactionType,
    TransactionPayloadType? payloadType,
    String? cardTransactionCollectionPath,
    String? requestPersonCardTransactionCollectionPath,
    String? note,
    Timestamp? time,
    Map<String, dynamic>? data,
  }) {
    return TransactionPayload(
      transactionType: transactionType ?? this.transactionType,
      payloadType: payloadType ?? this.payloadType,
      cardTransactionCollectionPath: cardTransactionCollectionPath ?? this.cardTransactionCollectionPath,
      contactPath: contactPath ?? contactPath,
      note: note ?? this.note,
      time: time ?? this.time,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionType': EnumToString.convertToString(transactionType),
      'payloadType': EnumToString.convertToString(payloadType),
      'cardTransactionCollectionPath': cardTransactionCollectionPath,
      'contactPath': contactPath,
      'note': note,
      'time': time,
      'data': data,
    };
  }

  factory TransactionPayload.fromMap(Map<String, dynamic> map) {
    return TransactionPayload(
      transactionType: EnumToString.fromString(TransactionType.values, map['transactionType']) ,
      payloadType: EnumToString.fromString(TransactionPayloadType.values, map['payloadType']),
      cardTransactionCollectionPath: map['cardTransactionCollectionPath'] as String,
      contactPath: map['contactPath'] as String,
      note: map['note'] as String,
      time: map['time'],
      data: map['data'] as Map<String, dynamic>,
    );
  }
  factory TransactionPayload.fromSnap(DocumentSnapshot snapshot) {
    return TransactionPayload(
      reference: snapshot.reference,
      transactionType: EnumToString.fromString(TransactionType.values, snapshot.get("transactionType")) ,
      payloadType: EnumToString.fromString(TransactionPayloadType.values, snapshot.get("payloadType")),
      cardTransactionCollectionPath: snapshot.get("cardTransactionCollectionPath") as String,
      contactPath: snapshot.get("contactPath") as String,
      note: snapshot.get("note") as String,
      time: snapshot.get("time"),
      data: snapshot.get("data") as Map<String, dynamic>,
    );
  }

 Future<DocumentReference> sendPayload(TransactionPayload payload) async {
   return await FirebaseFirestore.instance.collection(payload.cardTransactionCollectionPath!).add(
      payload.toMap()
      ,
    );
  }
//</editor-fold>
}

