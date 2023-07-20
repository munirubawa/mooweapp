// import 'package:mooweapp/export_files.dart';
//
// bool _initialized = false;
// Random random =
//     Random(); // keep this somewhere in a static variable. Just make sure to initialize only once.
//
// class NotificationController extends GetxController {
//   static NotificationController instance = Get.find();
//   static ReceivedAction? initialAction;
//
//   ///  *********************************************
//   ///     INITIALIZATIONS
//   ///  *********************************************
//   ///
//   ///
//   ///
//   @override
//   void onInit() {
//     super.onInit();
//   }
//
//   static Future<void> initializeLocalNotifications() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (kDebugMode) {
//         print('A new onMessageOpenedApp event was published!');
//         print(box.read("background"));
//
//       }
//       if (message.notification == null) return;
//       PushNotifier(message: message, originating: NotificationOriginating.onMessage);
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       if (kDebugMode) {
//         print('A new onMessageOpenedApp event was published!');
//         print(box.read("background"));
//
//       }
//       if (message.notification == null) return;
//       PushNotifier(message: message, originating: NotificationOriginating.onMessageOpenedApp);
//     });
//     await AwesomeNotifications().initialize(
//         null, //'resource://drawable/res_app_icon',//
//         [
//           NotificationChannel(
//             channelKey: 'alerts',
//             channelName: 'Alerts',
//             channelDescription: 'Notification tests as alerts',
//             playSound: true,
//             onlyAlertOnce: true,
//             groupAlertBehavior: GroupAlertBehavior.Children,
//             importance: NotificationImportance.High,
//             defaultPrivacy: NotificationPrivacy.Private,
//             defaultColor: Colors.deepPurple,
//             ledColor: Colors.deepPurple,
//           ),
//           NotificationChannel(
//             enableVibration: true,
//             defaultRingtoneType: DefaultRingtoneType.Ringtone,
//             channelKey: 'call_channel',
//             channelName: 'Calls',
//             channelDescription: 'Calls Notification',
//             playSound: true,
//             onlyAlertOnce: true,
//             groupAlertBehavior: GroupAlertBehavior.Children,
//             importance: NotificationImportance.High,
//             defaultPrivacy: NotificationPrivacy.Private,
//             defaultColor: Colors.deepPurple,
//             ledColor: Colors.deepPurple,
//           ),
//         ],
//         debug: true);
//     _initialized = true;
//     // Get initial notification action is optional
//     // NotificationController.startListeningNotificationEvents();
//
//     initialAction = await AwesomeNotifications()
//         .getInitialNotificationAction(removeFromActionEvents: false);
//     {}
//   }
//
//   static Future<void> onSilentActionHandle(ReceivedAction received) async {
//     if (kDebugMode) {
//       print('On new background action received: ${received.toMap()}');
//     }
//
//     if (!_initialized) {
//       SendPort? uiSendPort =
//           IsolateNameServer.lookupPortByName('background_notification_action');
//       if (uiSendPort != null) {
//         if (kDebugMode) {
//           print(
//               'Background action running on parallel isolate without valid context. Redirecting execution');
//         }
//         uiSendPort.send(received);
//         return;
//       }
//     }
//
//     if (kDebugMode) {
//       print('Background action running on main isolate');
//     }
//     // await _handleBackgroundAction(received);
//   }
//
//   static Future<void> initializePushPermissions() async {
//
//     if(Platform.isIOS) {
//       Get.defaultDialog(
//         title: "Notification",
//         content: const Text("Mowe would like to send you important notifications", textAlign: TextAlign.center,),
//         confirm: SizedBox(
//           height: permissionController.confirmButtonHeight,
//           width: permissionController.confirmButtonWidth,
//           child: Row(
//             children: [
//               InkWell(
//                   onTap: () {
//                     Get.back();
//                   },
//                   child: const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text("Later"),
//                   )),
//               Expanded(child: Container()),
//               InkWell(
//                   onTap: () async {
//                     Get.back();
//                     await FirebaseMessaging.instance.requestPermission(
//                         alert: true,
//                         announcement: false,
//                         badge: true,
//                         carPlay: false,
//                         criticalAlert: false,
//                         provisional: false,
//                         sound: true);
//                   },
//                   child: const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text("Agree"),
//                   )),
//             ],
//           ),
//         ),
//       );
//     }
//
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//
//   }
//
//   ///
//   // @pragma('vm:entry-point')
//   // static Future<void> onActionReceivedMethod(
//   //     ReceivedAction receivedAction) async {
//   //   if (receivedAction.actionType == ActionType.SilentAction ||
//   //       receivedAction.actionType == ActionType.SilentBackgroundAction) {
//   //     // For background actions, you must hold the execution until the end
//   //     print(
//   //         'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
//   //     await executeLongTaskInBackground();
//   //   } else {
//   //     // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
//   //     //     '/notification-page',
//   //     //         (route) =>
//   //     //     (route.settings.name != '/notification-page') || route.isFirst,
//   //     //     arguments: receivedAction);
//   //   }
//   // }
//
//   ///  *********************************************
//   ///     REQUESTING NOTIFICATION PERMISSIONS
//   ///  *********************************************
//   ///
//   static Future<bool> displayNotificationRationale() async {
//     bool userAuthorized = false;
//     BuildContext context = Get.context!;
//     await showDialog(
//         context: context,
//         builder: (BuildContext ctx) {
//           return AlertDialog(
//             title: Text('Get Notified!',
//                 style: Theme.of(context).textTheme.titleLarge),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Image.asset(
//                         'assets/animated-bell.gif',
//                         height: MediaQuery.of(context).size.height * 0.3,
//                         fit: BoxFit.fitWidth,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 const Text('Allow Awesome Notifications to send you beautiful notifications!'),
//               ],
//             ),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.of(ctx).pop();
//                   },
//                   child: Text(
//                     'Deny',
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleLarge
//                         ?.copyWith(color: Colors.red),
//                   )),
//               TextButton(
//                   onPressed: () async {
//                     userAuthorized = true;
//                     Navigator.of(ctx).pop();
//                   },
//                   child: Text(
//                     'Allow',
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleLarge
//                         ?.copyWith(color: Colors.deepPurple),
//                   )),
//             ],
//           );
//         });
//     return userAuthorized &&
//         await AwesomeNotifications().requestPermissionToSendNotifications();
//   }
//
//   ///  *********************************************
//   ///     BACKGROUND TASKS TEST
//   ///  *********************************************
//   static Future<void> executeLongTaskInBackground() async {
//     if (kDebugMode) {
//       print("starting long task");
//     }
//     await Future.delayed(const Duration(seconds: 4));
//     final url = Uri.parse("http://google.com");
//     final re = await get(url);
//     if (kDebugMode) {
//       print(re.body);
//     }
//     if (kDebugMode) {
//       print("long task done");
//     }
//   }
//
//   ///  *********************************************
//   ///     NOTIFICATION CREATION METHODS
//   ///  *********************************************
//   ///
//   static Future<void> createNewNotification() async {
//     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed) isAllowed = await displayNotificationRationale();
//     if (!isAllowed) return;
//
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//           id: -1, // -1 is replaced by a random number
//           channelKey: 'alerts',
//           title: 'Huston! The eagle has landed!',
//           body:
//               "A small step for a man, but a giant leap to Flutter's community!",
//           bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
//           largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
//           wakeUpScreen: true,
//           fullScreenIntent: true,
//           autoDismissible: false,
//           locked: true,
//           displayOnForeground: true,
//           category: NotificationCategory.Call,
//           //'asset://assets/images/balloons-in-sky.jpg',
//           notificationLayout: NotificationLayout.BigPicture,
//           payload: {'notificationId': '1234567890'}),
//       actionButtons: [
//         NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
//         NotificationActionButton(
//           key: 'REPLY',
//           label: 'Reply Message',
//           requireInputText: true,
//           actionType: ActionType.SilentAction,
//           enabled: true,
//         ),
//         NotificationActionButton(
//           enabled: true,
//           key: 'DISMISS',
//           label: 'Dismiss',
//           actionType: ActionType.DismissAction,
//           isDangerousOption: true,
//         )
//       ],
//     );
//   }
//
//   static Future<void> createCallNotification(RemoteMessage message) async {
//     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed) isAllowed = await displayNotificationRationale();
//     if (!isAllowed) return;
//     int min = 13, max = 42;
//     int id2 = random.nextInt(100);
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//           id: id2, // -1 is replaced by a random number
//           channelKey: 'call_channel',
//           title: 'Income call',
//           body:
//               "A small step for a man, but a giant leap to Flutter's community!",
//           bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
//           largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
//           wakeUpScreen: true,
//           fullScreenIntent: true,
//           autoDismissible: false,
//           locked: true,
//           displayOnForeground: true,
//           category: NotificationCategory.Call,
//           //'asset://assets/images/balloons-in-sky.jpg',
//           notificationLayout: NotificationLayout.BigPicture,
//           payload: {'notificationId': message.data["id"]}),
//       actionButtons: [
//         NotificationActionButton(
//           key: 'DISMISS',
//           label: 'Dismiss',
//           actionType: ActionType.DismissAction,
//           enabled: true,
//           isDangerousOption: true,
//           autoDismissible: true,
//         ),
//         NotificationActionButton(
//           autoDismissible: true,
//           key: 'REPLY',
//           label: 'Answer',
//           enabled: true,
//           actionType: ActionType.SilentAction,
//         )
//       ],
//     );
//   }
//
//   static Future<void> scheduleNewNotification() async {
//     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed) isAllowed = await displayNotificationRationale();
//     if (!isAllowed) return;
//
//     await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//             id: -1, // -1 is replaced by a random number
//             channelKey: 'alerts',
//             title: "Huston! The eagle has landed!",
//             body:
//                 "A small step for a man, but a giant leap to Flutter's community!",
//             bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
//             largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
//             //'asset://assets/images/balloons-in-sky.jpg',
//             notificationLayout: NotificationLayout.BigPicture,
//             payload: {
//               'notificationId': '1234567890'
//             }),
//         actionButtons: [
//           NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
//           NotificationActionButton(
//               key: 'DISMISS',
//               label: 'Dismiss',
//               actionType: ActionType.DismissAction,
//               isDangerousOption: true)
//         ],
//         schedule: NotificationCalendar.fromDate(
//             date: DateTime.now().add(const Duration(seconds: 10))));
//   }
//
//   static Future<void> resetBadgeCounter() async {
//     await AwesomeNotifications().resetGlobalBadge();
//   }
//
//   static Future<void> cancelNotifications() async {
//     await AwesomeNotifications().cancelAll();
//   }
//
//   ///  *********************************************
//   ///     NOTIFICATION EVENTS LISTENER
//   ///  *********************************************
//   ///  Notifications events are only delivered after call this method
//   static Future<void> startListeningNotificationEvents() async {
//     print("startListeningNotificationEvents");
//     AwesomeNotifications().setListeners(
//       onActionReceivedMethod: (ReceivedAction receivedAction) async {
//         NotificationController.onActionReceivedMethod(receivedAction);
//         onSilentActionHandle(receivedAction);
//       },
//       onNotificationCreatedMethod:
//           (ReceivedNotification receivedNotification) async {
//         NotificationController.onNotificationCreatedMethod(
//             receivedNotification);
//       },
//       onNotificationDisplayedMethod:
//           (ReceivedNotification receivedNotification) async {
//
//         NotificationController.onNotificationDisplayedMethod(
//             receivedNotification);
//       },
//       onDismissActionReceivedMethod: (ReceivedAction receivedAction) async {
//         onSilentActionHandle(receivedAction);
//         NotificationController.onDismissActionReceivedMethod(receivedAction);
//       },
//     );
//   }
//
//   /// Use this method to detect when a new notification or a schedule is created
//   @pragma("vm:entry-point")
//   static Future<void> onNotificationCreatedMethod(
//       ReceivedNotification receivedNotification) async {
//     // Your code goes here
//   }
//
//   /// Use this method to detect every time that a new notification is displayed
//   @pragma("vm:entry-point")
//   static Future<void> onNotificationDisplayedMethod(
//       ReceivedNotification receivedNotification) async {
//     // Your code goes here
//   }
//
//   /// Use this method to detect if the user dismissed a notification
//   @pragma("vm:entry-point")
//   static Future<void> onDismissActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     // Your code goes here
//   }
//
//   /// Use this method to detect when the user taps on a notification or action button
//   @pragma("vm:entry-point")
//   static Future<void> onActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     // Your code goes here
//
//     // Navigate into pages, avoiding to open the notification details page over another details page already opened
//   }
//
//   ///  *********************************************
//   ///     NOTIFICATION EVENTS
//   ///  *********************************************
// }
