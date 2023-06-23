import 'package:mooweapp/export_files.dart';

class VoiceOrVideoCall{

  VoiceOrVideoCall({required CallType callType, required ChatRoom chatRoom, required DocumentSnapshot member}){
    switch(callType) {

      case CallType.VIDEO_CALL:
        if (permissionController.audioPermissionGranted.value && permissionController.cameraPermissionGranted.value) {
          navController.callStatus.value = CallActionStatus.CALL_START;

          signal.callActionDetailsData = {
            callActionDetailsModel.callerCandidate: [],
            callActionDetailsModel.receiverCandidate: [],
            callActionDetailsModel.chatRoomPath: chatRoom.chatRoomChatsCollection,
            callActionDetailsModel.callActionStatus: EnumToString.convertToString(CallActionStatus.CALL_START),
            callActionDetailsModel.didCallDeclined: false,
            callActionDetailsModel.isCallAnswered: false,
            callActionDetailsModel.didCallerHangup: false,
            callActionDetailsModel.didPhoneRang: false,
            // callActionDetailsModel.chatRoom: chatRoom,
            callActionDetailsModel.callType: EnumToString.convertToString(CallType.VIDEO_CALL),
            callActionDetailsModel.chatType: EnumToString.convertToString(chatRoom.chatType),
            callActionDetailsModel.callFrom: chatServices.callInfo(chatServices.localMember!),
            callActionDetailsModel.callTo: chatServices.callInfo(member),
            callActionDetailsModel.jitsiCallActions: EnumToString.convertToString(JitsiCallActions.PRIVATE_CALL),
            callActionDetailsModel.isAudioMuted: false,
            callActionDetailsModel.isAudioOnly: false,
            callActionDetailsModel.isVideoMuted: false,
            callActionDetailsModel.callActive: true,
            callActionDetailsModel.roomId: chatRoom.reference!.id,
            callActionDetailsModel.subject: "Private call",
            callActionDetailsModel.notifyName: "${chatServices.sender[messageSenderModel.firstName]} ${chatServices.sender[messageSenderModel.lastName]}",
            callActionDetailsModel.callResponds: EnumToString.convertToString(CallResponds.INCOMING_CALL)
          };
          signal.showCallScreen(IncomingCallOrOutGoingCall.OUTGOING_CALL);
        } else {
          if (!permissionController.audioPermissionGranted.value) {
            permissionController.getMicrophonePermission();
          } else if (!permissionController.cameraPermissionGranted.value) {
            permissionController.getCameraPermission();
          }
        }
        break;
      case CallType.VOICE_CALL:
        print("permissionController.audioPermissionGranted.value Voice");
        print(permissionController.audioPermissionGranted.value);
        if (permissionController.audioPermissionGranted.value && permissionController.cameraPermissionGranted.value) {
          navController.callStatus.value = CallActionStatus.CALL_START;

          signal.callActionDetailsData = {
            // callActionDetailsModel.time: Timestamp.now(),
            callActionDetailsModel.callerCandidate: [],
            callActionDetailsModel.receiverCandidate: [],
            callActionDetailsModel.chatRoomPath: chatRoom.chatRoomChatsCollection,
            callActionDetailsModel.chatRoomPath: chatRoom.chatRoomChatsCollection,
            callActionDetailsModel.callActionStatus: EnumToString.convertToString(CallActionStatus.CALL_START),
            callActionDetailsModel.didCallDeclined: false,
            callActionDetailsModel.isCallAnswered: false,
            callActionDetailsModel.didPhoneRang: false,
            callActionDetailsModel.didCallerHangup: false,
            // callActionDetailsModel.chatRoom: chatRoom,
            callActionDetailsModel.callType: EnumToString.convertToString(CallType.VOICE_CALL),
            callActionDetailsModel.chatType: EnumToString.convertToString(chatRoom.chatType),
            callActionDetailsModel.callFrom: chatServices.callInfo(chatServices.localMember!),
            callActionDetailsModel.callTo: chatServices.callInfo(member),
            callActionDetailsModel.jitsiCallActions: EnumToString.convertToString(JitsiCallActions.PRIVATE_CALL),
            callActionDetailsModel.isAudioMuted: false,
            callActionDetailsModel.isAudioOnly: true,
            callActionDetailsModel.isVideoMuted: true,
            callActionDetailsModel.callActive: true,
            callActionDetailsModel.roomId: chatRoom.reference!.id,
            callActionDetailsModel.subject: "Private call",
            callActionDetailsModel.notifyName: "${chatServices.sender[messageSenderModel.firstName]} ${chatServices.sender[messageSenderModel.lastName]}",
            callActionDetailsModel.callResponds: EnumToString.convertToString(CallResponds.INCOMING_CALL)
          };
          signal.showCallScreen(IncomingCallOrOutGoingCall.OUTGOING_CALL);
        } else {
          if (!permissionController.audioPermissionGranted.value) {
            permissionController.getMicrophonePermission();
          } else if (!permissionController.cameraPermissionGranted.value) {
            permissionController.getCameraPermission();
          }
        }
        break;
    }
  }
}
