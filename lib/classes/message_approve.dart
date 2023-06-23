

import 'package:mooweapp/classes/message_text.dart';

class ApproveMessage {
  TextMessage? message;

//<editor-fold desc="Data Methods">

  ApproveMessage({
    this.message,
  });

  @override
  bool operator ==(Object other) => identical(this, other) || (other is ApproveMessage && runtimeType == other.runtimeType && message == other.message);

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() {
    return 'ApproveMessage{' ' message: $message,' '}';
  }

  ApproveMessage copyWith({
    TextMessage? message,
  }) {
    return ApproveMessage(
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message!.toMap(),
    };
  }

  factory ApproveMessage.fromMap(Map<String, dynamic> map) {
    return ApproveMessage(
      message: map['message'] as TextMessage,
    );
  }

//</editor-fold>
}