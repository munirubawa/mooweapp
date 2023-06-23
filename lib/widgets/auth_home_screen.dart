import 'package:mooweapp/export_files.dart';
class AuthHomeScreen extends StatefulWidget {
  const AuthHomeScreen({Key? key}) : super(key: key);

  @override
  State<AuthHomeScreen> createState() => _AuthHomeScreenState();
}

class _AuthHomeScreenState extends State<AuthHomeScreen> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final controller = Provider.of<AuthController>(context);
    // contextServices = Provider.of<ContextServices>(context);
    themeData = Theme.of(context);

    // return LoginScreen();
    // chatServices = Provider.of<ChatServices>(context);
    bool isUserLoggedIn = box.read("isUserLoggedIn") ?? false;
    // if (isUserLoggedIn) {
    //   return const MyHomeScreen();
    // }

    // controller.onInit();


    return Obx((){
      switch (authController?.authScreens.value) {
        case AuthScreens.LOGIN_SCREEN:
        // TODO: Handle this case.
          return const LoginScreen();
        case AuthScreens.HOME_SCREEN:
        // TODO: Handle this case.
          navController.pipPage = const MyHomeScreen();
          return const MyHomeScreen();
        case AuthScreens.REGISTER_SCREEN:
        // TODO: Handle this case.
          return const RegisterScreen();
        default:
          return const Center(
            child: Text("Sorry something went wrong"),
          );
      }
    });

  }
}