import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mooweapp/classes/chatRoom.dart';
import 'package:mooweapp/classes/credit_card.dart';
import 'package:mooweapp/classes/member_model.dart';
import 'package:mooweapp/enums.dart';


class Chat {
  String? docId;
  Timestamp? time;
  bool? firstTimeMessage ;
  bool? notify ;
  bool? read = true;
  String? notifyName;
  String? displayName;
  ChatTypes? chatType;
  String? text;
  int? count;
  String? deviceToken;
  List<DocumentSnapshot>? chatMembers = [];
  bool isNew = false;
  ChatRoom? chatRoom;
  DocumentReference? reference;
  CreditCard? creditCard;

  Chat({
    this.docId,
    this.time,
    this.firstTimeMessage =  true,
    this.notify =  false,
    this.read =  false,
    this.notifyName = "",
    this.displayName,
    this.chatType,
    this.text = "",
    this.count = 0,
    this.deviceToken = "",
    this.chatMembers ,
     this.isNew =  false,
    this.chatRoom,
    this.reference,
  });



  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'firstTimeMessage': firstTimeMessage,
      'notify': notify,
      'read': read,
      'notifyName': notifyName,
      'displayName': displayName,
      'chatType': EnumToString.convertToString(chatType),
      'text': text,
      'count': count,
      'deviceToken': deviceToken,
      'isNew': isNew,
      'chatRoom': chatRoom!.toMap(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      time: map['time'] as Timestamp,
      firstTimeMessage: map['firstTimeMessage'] as bool,
      notify: map['notify'] as bool,
      read: map['read'] as bool,
      notifyName: map['notifyName'] as String,
      displayName: map['displayName'] as String,
      chatType: EnumToString.fromString(ChatTypes.values, map['chatType']),
      text: map['text'] as String,
      count: map['count'] as int,
      deviceToken: map['deviceToken'] as String,
      // chatMembers: map['chatMembers'] !=null? map['chatMembers'].map((e) => Member.fromMap(e)).toList(): null,
      isNew: map['isNew'] as bool,
      chatRoom: map['chatRoom'] as ChatRoom,
    );
  }
  factory Chat.fromSnap(DocumentSnapshot snapshot) {
    return Chat(
      time: snapshot.get("time") as Timestamp,
      firstTimeMessage: snapshot.get("firstTimeMessage") as bool,
      notify: snapshot.get("notify") as bool,
      read: snapshot.get("read") as bool,
      notifyName: snapshot.get("notifyName") as String,
      displayName: snapshot.get("displayName") as String,
      chatType: EnumToString.fromString(ChatTypes.values, snapshot.get("chatType")),
      text: snapshot.get("text") as String,
      count: snapshot.get("count") as int,
      deviceToken: snapshot.get("deviceToken") as String,
      // chatMembers: snapshot.get("chatMembers") !=null? snapshot.get("chatMembers").map((e) => Member.fromMap(e)) : null ,
      isNew: snapshot.get("isNew") as bool,
      chatRoom: snapshot.get("chatRoom") !=null?  ChatRoom.fromMap(snapshot.get("chatRoom")) : null,
      docId: snapshot.id,
      reference: snapshot.reference,
    );
  }

  Stream<List<DocumentSnapshot>> getChatMembers() {
    print("getChatMembers");

    var recentChats =
    FirebaseFirestore.instance.collection(chatRoom!.chatRoomMembersCollection!).snapshots();
    return recentChats.map((snaps) => snaps.docs.map((snap) => snap).toList());
  }

   getChatMembers2() async {
    print("getChatMembers2");
   await FirebaseFirestore.instance
        .collection(chatRoom!.chatRoomMembersCollection!)
        .snapshots()
        .forEach((mems) => mems.docs.forEach((mem) => chatMembers!.add(mem)
)); }

  Stream<CreditCard> getGroupDefaultCard(String cardPath) {
    var groupDefaultCard = FirebaseFirestore.instance.doc(cardPath).snapshots();

    groupDefaultCard.forEach((data){
    });
    return FirebaseFirestore.instance.doc(cardPath).snapshots().map((data) => CreditCard.fromMap(data.data()!));
  }
  // Future<ChatRoom> getRoomData() {
  //   print("getRoomData");
  //   print(chatRoomPathDocId);
  //   final settings = FirebaseFirestore.instance.doc(chatRoomPathDocId!).get();
  //   return settings.then((snap) => ChatRoom.fromSnap(snap));
  // }
}
