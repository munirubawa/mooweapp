import 'package:cloud_firestore/cloud_firestore.dart';

class TextMessage {
  Timestamp? time;
  String? text;
  bool? read;
  String? senderID;

//<editor-fold desc="Data Methods">

  TextMessage({
    required this.time,
    required this.text,
    required this.read,
    required this.senderID,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TextMessage &&
          runtimeType == other.runtimeType &&
          time == other.time &&
          text == other.text &&
          senderID == other.senderID &&
          read == other.read
      );

  @override
  int get hashCode => time.hashCode ^ text.hashCode ^ read.hashCode ^ senderID.hashCode;

  @override
  String toString() {
    return 'TextMessage{' ' time: $time,' ' text: $text,' ' read: $read,' ' senderID: $senderID,' '}';
  }

  TextMessage copyWith({
    Timestamp? time,
    String? text,
    bool? read,
    String? senderID,
  }) {
    return TextMessage(
      time: time ?? this.time,
      text: text ?? this.text,
      read: read ?? this.read,
      senderID: senderID ?? this.senderID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'text': text,
      'read': read,
      'senderID': senderID,
    };
  }

  factory TextMessage.fromMap(Map<String, dynamic> map) {
    return TextMessage(
      time: map['time'] as Timestamp,
      senderID: map['senderID'],
      text: map['text'] as String,
      read: map['read'] as bool,
    );
  }

//</editor-fold>
}

class TextMessageModel {
  String? time = "time";
  String? text = "text";
  String? read = "read";
  String? senderID = "senderID";
}