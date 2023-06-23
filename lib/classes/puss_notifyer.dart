import 'package:mooweapp/export_files.dart';

class PushNotifier{
  RemoteMessage message;
  NotificationOriginating originating;
  PushNotifier({required this.message, required this.originating}){
    NotificationDataType? dataType = EnumToString.fromString(NotificationDataType.values, message.data["type"]);
    switch (dataType) {
      case NotificationDataType.STORE_PAYMENT:
        transactionService.setPaymentToEmpty();
        break;
      case NotificationDataType.MONEY_DATA:

        break;
      case NotificationDataType.CALL_DATA:
        if (kDebugMode) {
          debugPrint("message.data.toString()");
          // debugPrint(message.data.toString());
          print('Got a message whilst in the foreground!');
          // print('Message data: ${message.data}');
          print("onMessageFirebaseMessagingMessage");
          print("message.data[]");
          // print(message.data["notificationDocPath"]);
        }
        print("call Data notification");
        switch (originating) {

          case NotificationOriginating.onMessage:
            // TODO: Handle this case.
            break;
          case NotificationOriginating.onMessageOpenedApp:
            // TODO: Handle this case.
            break;
          case NotificationOriginating.background:
            NotificationController.createCallNotification(message);

            break;
        }
        CallSignalingController callScreenController = Get.put(CallSignalingController());
        callScreenController.incomingCallPath = message.data["notificationDocPath"];
        callScreenController.showCallScreen(IncomingCallOrOutGoingCall.INCOMING_CALL);
        debugPrint("call Data notification showNotificaton");
        // flutterLocalNotificationsPlugin.cancel(message.data['id'].toInt());
        // flutterLocalNotificationsPlugin.cancelAll();

        break;
      case NotificationDataType.CHAT_DATA:
      // TODO: Handle this case.
        debugPrint("call Data notification CHAT_DATA");
        print('Message data: ${message.data}');

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
        // Driver driver = Driver.fromSnap(driverSnapshot!);
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
  }
}