import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mooweapp/classes/message_sender.dart';
import 'package:mooweapp/enums.dart';
MessagePayloadModel messagePayloadModel = MessagePayloadModel();
class MessagePayloadModel{
  String  reference = "reference";
  String  chatRoomChatsCollection = "chatRoomChatsCollection";
  String  time = "time";
  String  sender = "sender";
  String  messageType = "messageType";
  String  messageGroupType = "messageGroupType";
  String messages = "messages";
}

