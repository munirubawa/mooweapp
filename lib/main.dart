import 'package:mooweapp/export_files.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final box = GetStorage();
  box.write("background", "background value");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  PushNotifier(message: message, originating: NotificationOriginating.background);
}

const kWebRecaptchaSiteKey = '6LfMHR0gAAAAACGXLYemUZXZEA6uw62Qrluuuuez';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) {
    FirebaseAppCheck.instance.activate(androidProvider: AndroidProvider.debug, webRecaptchaSiteKey: kWebRecaptchaSiteKey).then((value) {
      // NotificationController.initializeLocalNotifications().then((value) {
      //
      // });
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      getApplicationDocumentsDirectory().then((Directory value) {
        appDocDir = value;
        GetStorage.init().then((value) {
          Get.put(AllBindings());
          authController = Get.put(AuthController());
          runApp(const MyApp());
        });
      });
    });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.rightToLeftWithFade,
      title: 'Login',
      // initialBinding: ControllerBindings(),
      initialRoute: RoutesClass.getHomeRoute(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white,
          textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
          // fontFamily: "Montserrat",
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: COLOR_DARK_BLUE)),
      getPages: RoutesClass.routs,
      onInit: () {},
    );
  }
}
