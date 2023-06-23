
import 'package:mooweapp/classes/message_text.dart';

class FundingCompleteMessage {
  TextMessage? message;

//<editor-fold desc="Data Methods">

  FundingCompleteMessage({
    this.message,
  });

  @override
  bool operator ==(Object other) => identical(this, other) || (other is FundingCompleteMessage && runtimeType == other.runtimeType && message == other.message);

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() {
    return 'FundingCompleteMessage{' ' message: $message,' '}';
  }

  FundingCompleteMessage copyWith({
    TextMessage? message,
  }) {
    return FundingCompleteMessage(
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message!.toMap(),
    };
  }

  factory FundingCompleteMessage.fromMap(Map<String, dynamic> map) {
    return FundingCompleteMessage(
      message: map['message'] as TextMessage,
    );
  }

//</editor-fold>
}
