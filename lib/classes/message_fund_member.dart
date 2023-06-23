
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mooweapp/classes/member_model.dart';
import 'package:mooweapp/classes/transactions.dart';

class MoneyFundMemberMessage {
  DocumentSnapshot? fundReceiver;
  MooweTransactions? transaction;
  List<dynamic>? beneficiaryConfirmations;
  List<dynamic>? beneficiaryConfirmationsDecorum;
}