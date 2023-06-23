import 'package:mooweapp/export_files.dart';

class ChatRoom {
  String? firstName, lastName, groupName, accountType, currencyCode, chatRoomCardTransactionCollection;
  String? chatRoomCardPath, chatRoomChatsCollection, chatRoomMembersCollection;
  String? imageUrl;
  String? currencySign;
  String? fundBeneficiaries;
  String? currentBeneficiary;
  String? chatRoomPathDocId;
  int? chatRoomDecorumLimit;
  int? messageCount;
  List<dynamic>? admins;
  List<dynamic>? supperAdmin;
  List<dynamic>? members;
  List<dynamic>? groupImages;
  List<dynamic>? deviceTokens;
  TextMessage? message;
  String? manager;
  String? senderName;
  ChatTypes? chatType;
  DocumentReference? reference;
  CreditCard? creditCard;
  String? businessPath;

  factory ChatRoom.fromSnap(DocumentSnapshot snapshot) {
    Map<String, dynamic> mem = snapshot.data() as Map<String, dynamic>;
    return ChatRoom(
      firstName: snapshot.get("firstName") as String,
      lastName: snapshot.get("lastName") as String,
      groupName: snapshot.get("groupName") as String,
      accountType: snapshot.get("accountType") as String,
      currencyCode: snapshot.get("currencyCode") as String,
      currencySign: snapshot.get("currencySign") as String,
      chatRoomCardTransactionCollection: snapshot.get("chatRoomCardTransactionCollection"),
      chatRoomCardPath: snapshot.get("chatRoomCardPath"),
      chatRoomChatsCollection: snapshot.get("chatRoomChatsCollection"),
      chatRoomMembersCollection: snapshot.get("chatRoomMembersCollection"),
      imageUrl: snapshot.get("imageUrl") as String,
      chatRoomPathDocId: snapshot.get("chatRoomPathDocId") as String,
      admins: snapshot.get("admins") as List<dynamic>,
      groupImages: snapshot.get("groupImages") as List<dynamic>,
      supperAdmin: snapshot.get("supperAdmin"),
      members: snapshot.get("members"),
      deviceTokens: snapshot.get("deviceTokens"),
      message: TextMessage.fromMap(snapshot.get("message")),
      fundBeneficiaries: snapshot.get("fundBeneficiaries"),
      currentBeneficiary: snapshot.get("currentBeneficiary"),
      manager: snapshot.get("manager") as String,
      senderName: snapshot.get("senderName") as String,
      messageCount: snapshot.get("messageCount") as int,
      chatRoomDecorumLimit: snapshot.get("chatRoomDecorumLimit") as int,
      chatType: EnumToString.fromString(ChatTypes.values, snapshot.get("chatType")),
      reference: snapshot.reference,
      businessPath: snapshot.get("businessPath") ?? "",
      creditCard: snapshot.get("creditCard") != null ? CreditCard.fromMap(snapshot.get("creditCard")) : CreditCard(),
    );
  }
  factory ChatRoom.fromSnapSetup(DocumentSnapshot snapshot) {
    return ChatRoom(
      firstName: snapshot.get("firstName") as String,
      lastName: snapshot.get("lastName") as String,
      groupName: snapshot.get("groupName") as String,
      accountType: snapshot.get("accountType") as String,
      currencyCode: snapshot.get("currencyCode") as String,
      currencySign: snapshot.get("currencySign") as String,
      chatRoomCardTransactionCollection: "chatRoom/${snapshot.id}/transactions",
      chatRoomCardPath: "chatRoom/${snapshot.id}/card/${snapshot.id}",
      chatRoomChatsCollection: "chatRoom/${snapshot.id}/chats",
      chatRoomMembersCollection: "chatRoom/${snapshot.id}/members",
      fundBeneficiaries: "chatRoom/${snapshot.id}/fundBeneficiaries",
      currentBeneficiary: "",
      imageUrl: snapshot.get("imageUrl") as String,
      chatRoomPathDocId: "chatRoom/${snapshot.id}",
      admins: snapshot.get("admins") as List<dynamic>,
      groupImages: snapshot.get("groupImages") as List<dynamic>,
      supperAdmin: snapshot.get("supperAdmin"),
      members: snapshot.get("members"),
      deviceTokens: snapshot.get("deviceTokens"),
      message: TextMessage.fromMap(snapshot.get("message")),
      manager: snapshot.get("manager") as String,
      senderName: snapshot.get("senderName") as String,
      messageCount: snapshot.get("messageCount") as int,
      chatRoomDecorumLimit: snapshot.get("chatRoomDecorumLimit") as int,
      chatType: EnumToString.fromString(ChatTypes.values, snapshot.get("chatType")),
      reference: snapshot.reference,
      creditCard: snapshot.get("creditCard") != null ? CreditCard.fromMap(snapshot.get("creditCard")) : null,
    );
  }

//<editor-fold desc="Data Methods">

  ChatRoom({
    this.firstName,
    this.lastName,
    this.groupName,
    this.accountType,
    this.currencyCode,
    this.chatRoomCardTransactionCollection,
    this.chatRoomCardPath,
    this.chatRoomChatsCollection,
    this.chatRoomMembersCollection,
    this.imageUrl,
    this.currencySign,
    this.fundBeneficiaries,
    this.currentBeneficiary,
    this.chatRoomPathDocId,
    this.chatRoomDecorumLimit,
    this.messageCount,
    this.admins,
    this.supperAdmin,
    this.members,
    this.groupImages,
    this.deviceTokens,
    this.message,
    this.manager,
    this.senderName,
    this.chatType,
    this.reference,
    this.creditCard,
    this.businessPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'groupName': groupName,
      'accountType': accountType,
      'currencyCode': currencyCode,
      'chatRoomCardTransactionCollection': chatRoomCardTransactionCollection,
      'chatRoomCardPath': chatRoomCardPath,
      'chatRoomChatsCollection': chatRoomChatsCollection,
      'chatRoomMembersCollection': chatRoomMembersCollection,
      'imageUrl': imageUrl,
      'currencySign': currencySign,
      'fundBeneficiaries': fundBeneficiaries,
      'currentBeneficiary': currentBeneficiary,
      'chatRoomPathDocId': chatRoomPathDocId,
      'chatRoomDecorumLimit': chatRoomDecorumLimit,
      'messageCount': messageCount,
      'admins': admins,
      'supperAdmin': supperAdmin,
      'members': members,
      'groupImages': groupImages,
      'deviceTokens': deviceTokens,
      'message': message!.toMap(),
      'manager': manager,
      'senderName': senderName,
      'chatType': EnumToString.convertToString(chatType),
      'creditCard': creditCard != null?  creditCard!.toMap(): {},
      'businessPath': businessPath,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      groupName: map['groupName'] as String,
      accountType: map['accountType'] as String,
      currencyCode: map['currencyCode'] as String,
      chatRoomCardTransactionCollection: map['chatRoomCardTransactionCollection'] as String,
      chatRoomCardPath: map['chatRoomCardPath'] as String,
      chatRoomChatsCollection: map['chatRoomChatsCollection'] as String,
      chatRoomMembersCollection: map['chatRoomMembersCollection'] as String,
      imageUrl: map['imageUrl'] as String,
      currencySign: map['currencySign'] as String,
      fundBeneficiaries: map['fundBeneficiaries'] as String,
      currentBeneficiary: map['currentBeneficiary'] as String,
      chatRoomPathDocId: map['chatRoomPathDocId'] as String,
      chatRoomDecorumLimit: map['chatRoomDecorumLimit'] as int,
      messageCount: map['messageCount'] as int,
      admins: map['admins'] as List<dynamic>,
      supperAdmin: map['supperAdmin'] as List<dynamic>,
      members: map['members'] as List<dynamic>,
      groupImages: map['groupImages'] as List<dynamic>,
      deviceTokens: map['deviceTokens'] as List<dynamic>,
      message: map['message'] as TextMessage,
      manager: map['manager'] as String,
      senderName: map['senderName'] as String,
      chatType: map['chatType'] as ChatTypes,
      reference: map['reference'] as DocumentReference,
      creditCard: map['creditCard'] as CreditCard,
      businessPath: map['businessPath'] ,
    );
  }

//</editor-fold>
}
