
import 'package:mooweapp/classes/transactions.dart';

class MoneyMessage {
  MooweTransactions? transaction;
  String? transactionStatus;
  bool? isTransactionReleased;
  bool? isTransactionProcessed;
  String? transactionSentFrom;
  String? transactionSentTo;

//<editor-fold desc="Data Methods">

  MoneyMessage({
   required this.transaction,
    required this.transactionStatus,
    required this.isTransactionReleased,
    required this.isTransactionProcessed,
    required this.transactionSentFrom,
    required this.transactionSentTo,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoneyMessage &&
          runtimeType == other.runtimeType &&
          transaction == other.transaction &&
          transactionStatus == other.transactionStatus &&
          isTransactionReleased == other.isTransactionReleased &&
          isTransactionProcessed == other.isTransactionProcessed &&
          transactionSentFrom == other.transactionSentFrom &&
          transactionSentTo == other.transactionSentTo);

  @override
  int get hashCode =>
      transaction.hashCode ^ transactionStatus.hashCode ^
      isTransactionReleased.hashCode ^
      transactionSentFrom.hashCode ^
      isTransactionProcessed.hashCode ^
      transactionSentTo.hashCode;

  @override
  String toString() {
    return 'MoneyMessagePrivate{' ' transaction: $transaction,' ' transactionStatus: $transactionStatus,' ' isTransactionReleased: $isTransactionReleased,' ' isTransactionProcessed: $isTransactionProcessed,' ' transactionSentFrom: $transactionSentFrom,' ' transactionSentTo: $transactionSentTo,' '}';
  }

  MoneyMessage copyWith({
    MooweTransactions? transaction,
    String? transactionStatus,
    bool? isTransactionReleased,
    bool? isTransactionProcessed,
    String? transactionSentFrom,
    String? transactionSentTo,
  }) {
    return MoneyMessage(
      transaction: transaction ?? this.transaction,
      transactionStatus: transactionStatus ?? this.transactionStatus,
      isTransactionReleased: isTransactionReleased ?? this.isTransactionReleased,
      isTransactionProcessed: isTransactionProcessed ?? this.isTransactionProcessed,
      transactionSentFrom: transactionSentFrom ?? this.transactionSentFrom,
      transactionSentTo: transactionSentTo ?? this.transactionSentTo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transaction': transaction!.toMap(),
      'transactionStatus': transactionStatus,
      'isTransactionReleased': isTransactionReleased,
      'isTransactionProcessed': isTransactionProcessed,
      'transactionSentFrom': transactionSentFrom,
      'transactionSentTo': transactionSentTo,
    };
  }

  factory MoneyMessage.fromMap(Map<String, dynamic> map) {
    return MoneyMessage(
      transaction: MooweTransactions.fromJson(map['transaction']),
      transactionStatus: map['transactionStatus'] as String,
      isTransactionReleased: map['isTransactionReleased'] as bool,
      isTransactionProcessed: map['isTransactionProcessed'] as bool,
      transactionSentFrom: map['transactionSentFrom'] as String,
      transactionSentTo: map['transactionSentTo'] as String,
    );
  }

//</editor-fold>
}
MoneyMessageModel moneyMessageModel = MoneyMessageModel();
class MoneyMessageModel{
  String  transaction = "transaction";
  String  transactionStatus = "transactionStatus";
  String  isTransactionReleased = "isTransactionReleased";
  String  isTransactionProcessed = "isTransactionProcessed";
  String  transactionSentFrom = "transactionSentFrom";
  String  transactionSentTo = "transactionSentTo";
}