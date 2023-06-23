import 'package:mooweapp/export_files.dart';

class RoutesClass {
  static String home = "/";
  static String mowePay = "/mowePay";
  static String moweMarket = "/moweMarket";
  static String moweSettings = "/moweSettings";

  static String getHomeRoute() => home;
  static String getMowePayRoute() => mowePay;
  static String getMoweMarketRoute() => moweMarket;
  static String getSettingScreen() => moweSettings;


  static List<GetPage> routs = [
    GetPage(
      preventDuplicates: true,
        transition: Transition.zoom,
        name: home,
        page: () {
          return const AuthHomeScreen();
        }),
    GetPage(
      transition: Transition.zoom,
        name: mowePay,
        page: () {
          return const MoowePayHomeScreen();
        }),
    // GetPage(
    //   transition: Transition.zoom,
    //     name: moweMarket,
    //     page: () {
    //       return MarketPlaceHomeScreen();
    //     }),
    GetPage(
        transition: Transition.zoom,
        name: moweSettings,
        page: () {
          return const SettingScreen();
        }),
  ];
}
