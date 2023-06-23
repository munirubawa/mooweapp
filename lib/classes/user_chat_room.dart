

import 'package:cloud_firestore/cloud_firestore.dart';

class UserChatRoom{
  String chatRoom;
  bool isNew;
  Timestamp time;
  DocumentReference? reference;

//<editor-fold desc="Data Methods">

  UserChatRoom({
    required this.chatRoom,
    required this.isNew,
    required this.time,
     this.reference,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserChatRoom &&
          runtimeType == other.runtimeType &&
          chatRoom == other.chatRoom &&
          isNew == other.isNew &&
          time == other.time &&
          reference == other.reference);

  @override
  int get hashCode => chatRoom.hashCode ^ isNew.hashCode ^ time.hashCode ^ reference.hashCode;

  @override
  String toString() {
    return 'UserChatRoom{' ' chatRoom: $chatRoom,' ' isNew: $isNew,' ' time: $time,' ' reference: $reference,' '}';
  }

  UserChatRoom copyWith({
    String? chatRoom,
    bool? isNew,
    Timestamp? time,
    DocumentReference? reference,
  }) {
    return UserChatRoom(
      chatRoom: chatRoom ?? this.chatRoom,
      isNew: isNew ?? this.isNew,
      time: time ?? this.time,
      reference: reference ?? this.reference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatRoom': chatRoom,
      'isNew': isNew,
      'time': time,
    };
  }

  factory UserChatRoom.fromMap(Map<String, dynamic> map) {
    return UserChatRoom(
      chatRoom: map['chatRoom'] as String,
      isNew: map['isNew'] as bool,
      time: map['time'] as Timestamp,
      reference: map['reference'] as DocumentReference,
    );
  }
  factory UserChatRoom.fromSnap(DocumentSnapshot snapshot) {
    return UserChatRoom(
      chatRoom: snapshot.get("chatRoom") as String,
      isNew: snapshot.get("isNew") as bool,
      time: snapshot.get("time") as Timestamp,
      reference: snapshot.reference,
    );
  }


//</editor-fold>
}