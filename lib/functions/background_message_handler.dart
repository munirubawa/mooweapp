import 'package:mooweapp/export_files.dart';
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Get.put(SignalingController());
  // await Isolate.spawn(stopBackgroundRinging, receivePort.sendPort);
  // callScreenController.callListener(IncomingCallOrOutGoingCall.INCOMING_CALL) ;
  NotificationDataType? dataType = EnumToString.fromString(NotificationDataType.values, message.data["type"]);
  switch (dataType) {
    case NotificationDataType.MONEY_DATA:
      break;
    case NotificationDataType.CALL_DATA:
      if (kDebugMode) {
        debugPrint("message.data.toString()");
        debugPrint(message.data.toString());
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
        print("onMessageFirebaseMessagingMessage");
      }
      print("call Data notification");
      // SignalingController callScreenController = SignalingController.instance;
      // // SignalingController callScreenController = Get.put(SignalingController());
      // callScreenController.incomingCallPath = message.data["notificationDocPath"];
      // callScreenController.showCallScreen(IncomingCallOrOutGoingCall.INCOMING_CALL);

      break;
    case NotificationDataType.CHAT_DATA:
    // TODO: Handle this case.
      debugPrint("call Data notification CHAT_DATA");
      // localNotifications.showNotification(message);
      // if (room.message!.senderID != auth.currentUser!.uid) {
      //   FlutterRingtonePlayer.playNotification();
      // }
      break;
    case NotificationDataType.DRIVER_AT_LOCATION_DATA:
    // TODO: Handle this case.
      break;
    case NotificationDataType.REQUEST_ACCEPTED_DATA:
    // TODO: Handle this case.
      break;
    case NotificationDataType.RIDE_REQUEST_DATA:
    // TODO: Handle this case∏∏
      enumServices.notificationDataType = NotificationDataType.RIDE_REQUEST_DATA;
      break;
    case NotificationDataType.REQUEST_PAYMENT:
    // TODO: Handle this case.
      break;
    case NotificationDataType.BUSINESS_ADMIN_ADD_MEMBER:
    // TODO: Handle this case.
      break;
    default:
      break;
  }
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
  }
}
