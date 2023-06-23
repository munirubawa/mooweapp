import 'package:mooweapp/export_files.dart';
class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> with WidgetsBindingObserver {
  @override
  initState() {
    // Vibration.vibrate(
    //   pattern: [500, 1000, 500, 2000, 500, 3000, 500, 500],
    //   intensities: [128, 255, 64, 255],
    // );
    allBindings.initializeControllersAfterLogin();

    runSystemOverlay();
    enumServices.chatServicesActions = ChatServicesActions.SAVE_DEVICE_TOKEN;
    chatServices.runChatServices();
    enumServices.chatServicesActions = ChatServicesActions.LOCAL_FIREBASE_LISTENERS;
    chatServices.runChatServices();
    contactPermission();
    // AwesomeNotifications().setListeners(onActionReceivedMethod: onActionReceivedMethod).asStream();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void contactPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if(!isAllowed) Future.delayed(const Duration(seconds: 3), ()=>     NotificationController.initializePushPermissions());

  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      enumServices.chatServicesActions = ChatServicesActions.UPDATE_MEMBER_STATUS_ON_LINE;
      chatServices.runChatServices();
      print("app is in resumed");
    } else if (state == AppLifecycleState.inactive) {
      print("app is in inactive");
      enumServices.chatServicesActions = ChatServicesActions.UPDATE_MEMBER_STATUS_OFF_LINE;
      chatServices.runChatServices();
    } else if (state == AppLifecycleState.detached) {
      print("app is in detached");
      enumServices.chatServicesActions = ChatServicesActions.UPDATE_MEMBER_STATUS_OFF_LINE;
      chatServices.runChatServices();
    } else if (state == AppLifecycleState.paused) {
      print("app is in paused");
      enumServices.chatServicesActions = ChatServicesActions.UPDATE_MEMBER_STATUS_OFF_LINE;
      chatServices.runChatServices();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // EnumServices enumServices = Get.find();
    enumServices = enumServices;
    return GestureDetector(
      onTap: () {},
      child: const Scaffold(
          body:  ChatsHomeScreen(),
          // bottomNavigationBar: const HomeNavigationBar() // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }
}
