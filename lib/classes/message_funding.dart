import 'package:mooweapp/classes/message_text.dart';

class FundingMessage {
  TextMessage? message;

//<editor-fold desc="Data Methods">

  FundingMessage({
    this.message,
  });

  @override
  bool operator ==(Object other) => identical(this, other) || (other is FundingMessage && runtimeType == other.runtimeType && message == other.message);

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() {
    return 'FundingCompleteMessage{' ' message: $message,' '}';
  }

  FundingMessage copyWith({
    TextMessage? message,
  }) {
    return FundingMessage(
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message!.toMap(),
    };
  }

  factory FundingMessage.fromMap(Map<String, dynamic> map) {
    return FundingMessage(
      message: TextMessage.fromMap(map['message']),
    );
  }

//</editor-fold>
}
