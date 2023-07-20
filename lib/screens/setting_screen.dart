import 'package:mooweapp/export_files.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool fingerPrint = false;
  bool beATaxiDriver = false;
  Map<String, dynamic>? paymentIntentData;
  double imageRadius = Get.width * 0.15;
  @override
  void initState() {
    // TODO: implement initState
    runSystemOverlay();
    StripeService.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(chatServices.localUser!.get(localUserModel.countryModel));
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text("Settings", style: themeData!.textTheme.headline6),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: imageRadius,
                      child: storage.checkImage(chatServices.localMember!.get(memberModel.imageUrl))
                          ? CircleAvatar(
                              radius: imageRadius,
                              child: Container(
                                decoration: BoxDecoration(
                                    // color: Colors.orange,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(image: storage.getImage(chatServices.localMember!.get(memberModel.imageUrl)), fit: BoxFit.cover)),
                              ),
                            )
                          : CircleAvatar(
                              radius: imageRadius,
                              child: Icon(
                                Icons.person,
                                size: Get.width * 0.1,
                              ),
                            ),
                    ),
                    Text("${chatServices.localMember!.get(memberModel.firstName)} ${chatServices.localMember!.get(memberModel.lastName)}",
                    style: themeData!.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 17),),
                  ],
                ),
              ),
              Expanded(
                flex: 12,
                child: SettingsList(
                  contentPadding: const EdgeInsets.symmetric(vertical: 22),
                  sections: [
                    SettingsSection(
                      title: 'Chat Service',
                      subtitle: Text("Settings", style: themeData!.textTheme.headline6),
                      tiles: [
                        SettingsTile(
                          title: 'Add Payment Method',
                          leading: paymentMethodIcon(),
                          onPressed: (BuildContext context) async {
                            print(chatServices.localMember!.get(memberModel.currencyCode));
                            addPaymentMethodController.addPaymentMethod();
                          },
                          // trailing: Text("1.85%"),
                        ),
                      ],
                    ),
                    SettingsSection(
                      titleWidget: Column(
                        children: const [
                          Text('Wallet information')
                        ],
                      ),
                      // subtitle: const Text("Settings"),
                      tiles: [
                        // SettingsTile(
                        //   title: 'Country',
                        //   subtitle: '${chatServices.localUser!.get(localUserModel.countryModel)[countryModelModel.currencyCode]}',
                        //   leading: const Icon(Icons.location_city),
                        //   onPressed: (BuildContext context) {},
                        // ),
                        SettingsTile(
                          title: 'Phone',
                          subtitle: '${chatServices.localUser!.get(memberModel.phone)}',
                          leading: const Icon(Icons.location_city),
                          onPressed: (BuildContext context) {},
                        ),
                        SettingsTile(
                          title: 'Currency',
                          subtitle: '${chatServices.localMember!.get(localUserModel.currencyCode) ?? ""} (${chatServices.localUser!.get(localUserModel.countryModel)[countryModelModel.currencyCode]})',
                          leading: const Icon(Icons.money),
                          onPressed: (BuildContext context) {},
                        ),
                      ],
                    ),
                    // SettingsSection(
                    //   titleWidget: Column(
                    //     children: const [
                    //       Text("Accept Payment For Your Business")
                    //     ],
                    //   ),
                    //   // subtitle: const Text("Registrations"),
                    //   tiles: [
                    //     SettingsTile(
                    //       title: 'Accept Payment',
                    //       subtitle: 'Sign Up',
                    //       leading: const Icon(FontAwesomeIcons.moneyBill),
                    //       onPressed: (BuildContext context) {
                    //         enumServices.userBusinessType = UserBusinessType.ACCEPT_PAYMENT_SERVICE;
                    //         businessServices.business.value.userBusinessType = UserBusinessType.ACCEPT_PAYMENT_SERVICE;
                    //         Get.to(() => const RegisterBusiness());
                    //       },
                    //       trailing: const Text("1.85%"),
                    //     ),
                    //   ],
                    // ),
                    // SettingsSection(
                    //   // title: "Sell on Mowe Market Place",
                    //   titleWidget: Column(
                    //     children: const [
                    //       Text('Reach millions of customers on Mowe market place world wide')
                    //     ],
                    //   ),
                    //   // subtitle: const Text("Registrations"),
                    //   tiles: [
                    //     SettingsTile(
                    //       title: 'Registrations',
                    //       subtitle: 'Sign Up',
                    //       leading: const Icon(FontAwesomeIcons.store),
                    //       onPressed: (BuildContext context) {
                    //         enumServices.userBusinessType = UserBusinessType.MERCHANT_STORE;
                    //         businessServices.business.value.userBusinessType = UserBusinessType.MERCHANT_STORE;
                    //         Get.to(() => const RegisterBusiness());
                    //       },
                    //       trailing: const Text("1.85%"),
                    //     ),
                    //   ],
                    // ),
                    SettingsSection(
                      title: "App Settings",
                      tiles: [
                        SettingsTile(
                          title: 'Language',
                          subtitle: 'English',
                          leading: const Icon(Icons.language),
                          onPressed: (BuildContext context) {},
                        ),
                        // SettingsTile.switchTile(
                        //   title: 'Use fingerprint',
                        //   leading: const Icon(Icons.fingerprint),
                        //   switchValue: fingerPrint,
                        //   onToggle: (bool value) {
                        //     setState(() {
                        //       fingerPrint = !fingerPrint;
                        //     });
                        //   },
                        // ),
                        SettingsTile(
                          title: 'Log Out',
                          leading: const Icon(FontAwesomeIcons.key),
                          onPressed: (context) {
                            Get.back();
                            authController!.signOut();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeNavigationBar(tabIndex: 2, backgroudColor: Colors.white,),
    );
  }

  Widget paymentMethodIcon() {
    switch (chatServices.localMember!.get(memberModel.currencyCode)!) {
      case "GHS":
        return const Icon(FontAwesomeIcons.sortNumericDown);
      case "USD":
        return const Icon(FontAwesomeIcons.creditCard);
      default:
        return const Icon(FontAwesomeIcons.creditCard);
    }
  }
}
