import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mooweapp/classes/member_model.dart';
import 'package:mooweapp/classes/message_text.dart';

class ApproveDisapproveMessage {
  DocumentSnapshot? fundReceiver;
  double? fundingAmount;
  List<dynamic>? approvedIds;
  List<dynamic>? disapprovedIds;
  TextMessage? message;

//<editor-fold desc="Data Methods">

  ApproveDisapproveMessage({
    this.fundReceiver,
    this.fundingAmount,
    this.approvedIds,
    this.disapprovedIds,
    this.message,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApproveDisapproveMessage &&
          runtimeType == other.runtimeType &&
          fundReceiver == other.fundReceiver &&
          fundingAmount == other.fundingAmount &&
          approvedIds == other.approvedIds &&
          disapprovedIds == other.disapprovedIds &&
          message == other.message);

  @override
  int get hashCode => fundReceiver.hashCode ^ fundingAmount.hashCode ^ approvedIds.hashCode ^ disapprovedIds.hashCode ^ message.hashCode;

  @override
  String toString() {
    return 'ApproveDisapproveMessage{' ' fundReceiver: $fundReceiver,' ' fundingAmount: $fundingAmount,' ' approvedIds: $approvedIds,' ' disapprovedIds: $disapprovedIds,' ' message: $message,' '}';
  }

  ApproveDisapproveMessage copyWith({
    DocumentSnapshot? fundReceiver,
    double? fundingAmount,
    List<dynamic>? approvedIds,
    List<dynamic>? disapprovedIds,
    TextMessage? message,
  }) {
    return ApproveDisapproveMessage(
      fundReceiver: fundReceiver ?? this.fundReceiver,
      fundingAmount: fundingAmount ?? this.fundingAmount,
      approvedIds: approvedIds ?? this.approvedIds,
      disapprovedIds: disapprovedIds ?? this.disapprovedIds,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fundReceiver': fundReceiver!.data() as Map<String, dynamic> ,
      'fundingAmount': fundingAmount,
      'approvedIds': approvedIds,
      'disapprovedIds': disapprovedIds,
      'message': message!.toMap(),
    };
  }

  factory ApproveDisapproveMessage.fromMap(Map<String, dynamic> map) {
    return ApproveDisapproveMessage(
      fundReceiver: map['fundReceiver'],
      fundingAmount: map['fundingAmount'] as double,
      approvedIds: map['approvedIds'] as List<dynamic>,
      disapprovedIds: map['disapprovedIds'] as List<dynamic>,
      message:  TextMessage.fromMap(map['message']),
    );
  }

//</editor-fold>
}
ApproveDisapproveMessageModel approveDisapproveMessageModel = ApproveDisapproveMessageModel();
class ApproveDisapproveMessageModel{
  String fundReceiver = "fundReceiver";
  String fundingAmount = "fundingAmount";
  String approvedIds = "approvedIds";
  String disapprovedIds = "disapprovedIds";
  String message = "message";
}