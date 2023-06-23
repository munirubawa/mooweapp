import 'package:mooweapp/classes/message_text.dart';

class DisapproveMessage {
  TextMessage? message;

//<editor-fold desc="Data Methods">

  DisapproveMessage({
    this.message,
  });

  @override
  bool operator ==(Object other) => identical(this, other) || (other is DisapproveMessage && runtimeType == other.runtimeType && message == other.message);

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() {
    return 'DisapproveMessage{' ' message: $message,' '}';
  }

  DisapproveMessage copyWith({
    TextMessage? message,
  }) {
    return DisapproveMessage(
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message!.toMap(),
    };
  }

  factory DisapproveMessage.fromMap(Map<String, dynamic> map) {
    return DisapproveMessage(
      message: map['message'] as TextMessage,
    );
  }

//</editor-fold>
}