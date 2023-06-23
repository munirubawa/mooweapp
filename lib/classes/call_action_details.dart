import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mooweapp/classes/chatRoom.dart';
import 'package:mooweapp/classes/member_call_info.dart';
import 'package:mooweapp/enums.dart';

// class CallActionDetails {
//   DocumentSnapshot callFrom;
//   DocumentSnapshot callTo;
//   ChatRoom? chatRoom;
//   JitsiCallActions jitsiCallActions;
//   CallActionStatus? callActionStatus;
//   bool isAudioMuted;
//   bool isAudioOnly;
//   bool isVideoMuted;
//   bool isCallAnswered;
//   bool callActive;
//   bool didPhoneRang;
//   bool didCallerHangup;
//   bool didCallDeclined;
//   String roomId;
//   String subject;
//   CallType? callType;
//   String? notifyName;
//   String? chatRoomPath;
//   ChatTypes? chatType;
//   Timestamp? time;
//   DocumentReference? reference;
//   CallResponds? callResponds;
//   Map<String, dynamic>? offerSdp;
//   Map<String, dynamic>? answerSdp;
//   String? receiverCandidate;
//   String? callerCandidate;
// //<editor-fold desc="Data Methods">
//
//   CallActionDetails({
//     this.reference,
//     this.chatRoom,
//     this.offerSdp,
//     this.answerSdp,
//     this.receiverCandidate,
//     this.callerCandidate,
//     this.callActionStatus,
//     required this.callType,
//     required this.chatRoomPath,
//     required this.chatType,
//     required this.callFrom,
//     required this.callTo,
//     required this.jitsiCallActions,
//     required this.isAudioMuted,
//     required this.isAudioOnly,
//     required this.isVideoMuted,
//     required this.isCallAnswered,
//     required this.callActive,
//     required this.didPhoneRang,
//     required this.didCallerHangup,
//     required this.didCallDeclined,
//     required this.roomId,
//     required this.subject,
//     required this.notifyName,
//     required this.time,
//     required this.callResponds,
//   });
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is CallActionDetails &&
//           runtimeType == other.runtimeType &&
//           chatRoom == other.chatRoom &&
//           offerSdp == other.offerSdp &&
//           answerSdp == other.answerSdp &&
//           receiverCandidate == other.receiverCandidate &&
//           callerCandidate == other.callerCandidate &&
//           callType == other.callType &&
//           chatRoomPath == other.chatRoomPath &&
//           chatType == other.chatType &&
//           callFrom == other.callFrom &&
//           callTo == other.callTo &&
//           jitsiCallActions == other.jitsiCallActions &&
//           isAudioMuted == other.isAudioMuted &&
//           isAudioOnly == other.isAudioOnly &&
//           isVideoMuted == other.isVideoMuted &&
//           isCallAnswered == other.isCallAnswered &&
//           callActive == other.callActive &&
//           didPhoneRang == other.didPhoneRang &&
//           didCallerHangup == other.didCallerHangup &&
//           didCallDeclined == other.didCallDeclined &&
//           roomId == other.roomId &&
//           notifyName == other.notifyName &&
//           time == other.time &&
//           subject == other.subject);
//
//   @override
//   int get hashCode =>
//       chatRoom.hashCode ^
//       callType.hashCode ^
//       offerSdp.hashCode ^
//       answerSdp.hashCode ^
//       receiverCandidate.hashCode ^
//       callerCandidate.hashCode ^
//       chatRoomPath.hashCode ^
//       chatType.hashCode ^
//       callFrom.hashCode ^
//       callTo.hashCode ^
//       jitsiCallActions.hashCode ^
//       isAudioMuted.hashCode ^
//       isAudioOnly.hashCode ^
//       isVideoMuted.hashCode ^
//       isCallAnswered.hashCode ^
//       callActive.hashCode ^
//       didPhoneRang.hashCode ^
//       didCallerHangup.hashCode ^
//       didCallDeclined.hashCode ^
//       roomId.hashCode ^
//       notifyName.hashCode ^
//       time.hashCode ^
//       subject.hashCode;
//
//   @override
//   String toString() {
//     return 'CallActionDetails{'
//             ' chatRoom: $chatRoom,'
//             ' callType: $callType,'
//             ' chatRoomPath: $chatRoomPath,'
//             ' chatType: $chatType,'
//             ' offerSdp: $offerSdp,'
//             ' answerSdp: $answerSdp,'
//             ' receiverCandidate: $receiverCandidate,'
//             ' callerCandidate: $callerCandidate,' +
//         ' callFrom: $callFrom,' +
//         ' callTo: $callTo,' +
//         ' jitsiCallActions: $jitsiCallActions,' +
//         ' callActionStatus: $callActionStatus,' +
//         ' isAudioMuted: $isAudioMuted,' +
//         ' isAudioOnly: $isAudioOnly,' +
//         ' isVideoMuted: $isVideoMuted,' +
//         ' isCallAnswered: $isCallAnswered,' +
//         ' callActive: $callActive,' +
//         ' didPhoneRang: $didPhoneRang,' +
//         ' didCallerHangup: $didCallerHangup,' +
//         ' didCallDeclined: $didCallDeclined,' +
//         ' roomId: $roomId,' +
//         ' subject: $subject,' +
//         ' notifyName: $notifyName,' +
//         ' time: $time,' +
//         ' time: $callResponds,' +
//         '}';
//   }
//
//   CallActionDetails copyWith({
//     ChatRoom? chatRoom,
//     CallType? callType,
//     ChatTypes? chatType,
//     MemberCallInfo? callFrom,
//     MemberCallInfo? callTo,
//     JitsiCallActions? jitsiCallActions,
//     CallActionStatus? callActionStatus,
//     bool? isAudioMuted,
//     bool? isAudioOnly,
//     bool? isVideoMuted,
//     bool? isCallAnswered,
//     bool? callActive,
//     bool? didPhoneRang,
//     bool? didCallerHangup,
//     bool? didCallDeclined,
//     String? roomId,
//     String? chatRoomPath,
//     String? subject,
//     Map<String, dynamic>? offerSdp,
//     Map<String, dynamic>? answerSdp,
//     String? receiverCandidate,
//     String? callerCandidate,
//     Timestamp? time,
//     String? notifyName,
//     CallResponds? callResponds,
//   }) {
//     return CallActionDetails(
//       chatRoom: chatRoom ?? this.chatRoom,
//       callType: callType ?? this.callType,
//       chatRoomPath: chatRoomPath ?? this.chatRoomPath,
//       chatType: chatType ?? this.chatType,
//       callFrom: callFrom ?? this.callFrom,
//       callTo: callTo ?? this.callTo,
//       jitsiCallActions: jitsiCallActions ?? this.jitsiCallActions,
//       callActionStatus: callActionStatus ?? this.callActionStatus,
//       isAudioMuted: isAudioMuted ?? this.isAudioMuted,
//       isAudioOnly: isAudioOnly ?? this.isAudioOnly,
//       isVideoMuted: isVideoMuted ?? this.isVideoMuted,
//       isCallAnswered: isCallAnswered ?? this.isCallAnswered,
//       callActive: callActive ?? this.callActive,
//       didPhoneRang: didPhoneRang ?? this.didPhoneRang,
//       didCallerHangup: didCallerHangup ?? this.didCallerHangup,
//       didCallDeclined: didCallDeclined ?? this.didCallDeclined,
//       roomId: roomId ?? this.roomId,
//       subject: subject ?? this.subject,
//       offerSdp: offerSdp ?? this.offerSdp,
//       answerSdp: answerSdp ?? this.answerSdp,
//       receiverCandidate: receiverCandidate ?? this.receiverCandidate,
//       callerCandidate: callerCandidate ?? this.callerCandidate,
//       notifyName: notifyName ?? this.notifyName,
//       callResponds: callResponds ?? this.callResponds,
//       time: time ?? this.time,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'callFrom': callFrom.data() as Map<String, dynamic>,
//       'callTo': callTo.data() as Map<String, dynamic>,
//       'callType': EnumToString.convertToString(callType),
//       'chatType': EnumToString.convertToString(chatType),
//       'jitsiCallActions': EnumToString.convertToString(jitsiCallActions),
//       'callActionStatus': EnumToString.convertToString(callActionStatus),
//       'callResponds': EnumToString.convertToString(callResponds),
//       'isAudioMuted': isAudioMuted,
//       'isAudioOnly': isAudioOnly,
//       'isVideoMuted': isVideoMuted,
//       'isCallAnswered': isCallAnswered,
//       'callActive': callActive,
//       'didPhoneRang': didPhoneRang,
//       'didCallerHangup': didCallerHangup,
//       'didCallDeclined': didCallDeclined,
//       'roomId': roomId,
//       'chatRoomPath': chatRoomPath,
//       'subject': subject,
//       'offerSdp': offerSdp,
//       'answerSdp': answerSdp,
//       'receiverCandidate': receiverCandidate,
//       'callerCandidate': callerCandidate,
//       'notifyName': notifyName,
//       'time': time,
//     };
//   }
//
//   factory CallActionDetails.fromSnap(DocumentSnapshot snapshot) {
//     return CallActionDetails(
//       reference: snapshot.reference,
//       callFrom: MemberCallInfo.fromMap(snapshot.get("callFrom")),
//       callTo: MemberCallInfo.fromMap(snapshot.get("callTo")),
//       callType: EnumToString.fromString(CallType.values, snapshot.get("callType")),
//       chatType: EnumToString.fromString(ChatTypes.values, snapshot.get("chatType")),
//       callResponds: EnumToString.fromString(CallResponds.values, snapshot.get("callResponds")),
//       jitsiCallActions: EnumToString.fromString(JitsiCallActions.values, snapshot.get("jitsiCallActions"))!,
//       callActionStatus: EnumToString.fromString(CallActionStatus.values, snapshot.get("callActionStatus"))!,
//       isAudioMuted: snapshot.get("isAudioMuted") as bool,
//       isAudioOnly: snapshot.get("isAudioOnly") as bool,
//       isVideoMuted: snapshot.get("isVideoMuted") as bool,
//       isCallAnswered: snapshot.get("isCallAnswered") as bool,
//       callActive: snapshot.get("callActive") as bool,
//       didPhoneRang: snapshot.get("didPhoneRang") as bool,
//       didCallerHangup: snapshot.get("didCallerHangup") as bool,
//       didCallDeclined: snapshot.get("didCallDeclined") as bool,
//       roomId: snapshot.get("roomId") as String,
//       chatRoomPath: snapshot.get("chatRoomPath") as String,
//       subject: snapshot.get("subject") as String,
//       offerSdp: snapshot.get("offerSdp"),
//       answerSdp: snapshot.get("answerSdp"),
//       receiverCandidate: snapshot.get("receiverCandidate"),
//       callerCandidate: snapshot.get("callerCandidate"),
//       notifyName: snapshot.get("notifyName") as String,
//       time: snapshot.get("time"),
//     );
//   }
// //</editor-fold>
// }
CallActionDetailsModel callActionDetailsModel = CallActionDetailsModel();
class CallActionDetailsModel {
  // String sdpAndType = "sdpAndType";
  String callerCandidate = "callerCandidate";
  String receiverCandidate = "receiverCandidate";
  String callFrom = "callFrom";
  String callTo = "callTo";
  String chatRoom = "chatRoom";
  String jitsiCallActions = "jitsiCallActions";
  String callActionStatus = "callActionStatus";
  String isAudioMuted = "isAudioMuted";
  String isAudioOnly = "isAudioOnly";
  String isVideoMuted = "isVideoMuted";
  String isCallAnswered = "isCallAnswered";
  String callActive = "callActive";
  String didPhoneRang = "didPhoneRang";
  String didCallerHangup = "didCallerHangup";
  String didCallDeclined = "didCallDeclined";
  String roomId = "roomId";
  String subject = "subject";
  String callType = "callType";
  String notifyName = "notifyName";
  String chatRoomPath = "chatRoomPath";
  String chatType = "chatType";
  String time = "time";
  String reference = "reference";
  String callResponds = "callResponds";
  // String offerSdp = "offerSdp";
  // String answerSdp = "answerSdp";
}
