import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:mooweapp/export_files.dart';

enum ChatSettingOptions {
  SETTING,
  ADD_PAYMENT_METHOD,
}

class ChatsHomeScreen extends StatefulWidget {
  const ChatsHomeScreen({Key? key}) : super(key: key);

  @override
  _ChatsHomeScreenState createState() => _ChatsHomeScreenState();
}

class _ChatsHomeScreenState extends State<ChatsHomeScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    checkPermissionGranted();
    super.initState();
  }
  void checkPermissionGranted() async{
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      contactServices.fetchContacts("ChatHomeScree");

    }
  }

  Future<void> _askPermissions(String routeName) async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Get.to(() => const DisplayContacts(
            backgroundColor: Colors.white,
          ));
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted && permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar = SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        navController.popTabUpdate();
        return Future(() => true);
      },
      child: Scaffold(
        key: UniqueKey(),
        backgroundColor: Colors.transparent,
        body: DefaultTabController(
          length: 1,
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: kPrimaryColor,
                  // expandedHeight: SizeConfig.screenHeight! * .22,
                  title: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Mowe",
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            textStyle: Theme.of(context).textTheme.headline4,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                  actions: [
                    PopupMenuButton<ChatSettingOptions>(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      onSelected: (ChatSettingOptions result) {
                        switch (result) {
                          case ChatSettingOptions.SETTING:
                            Get.to(() => const SettingScreen());
                            break;
                          case ChatSettingOptions.ADD_PAYMENT_METHOD:
                            addPaymentMethodController.addPaymentMethod();
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        addPaymentMethodController.initializePaymentMethod();
                        return <PopupMenuEntry<ChatSettingOptions>>[
                          const PopupMenuItem<ChatSettingOptions>(
                            value: ChatSettingOptions.SETTING,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Setting",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const PopupMenuItem<ChatSettingOptions>(
                            value: ChatSettingOptions.ADD_PAYMENT_METHOD,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Add Payment Method",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
                  ],
                  flexibleSpace: const Padding(
                    padding: EdgeInsets.only(left: 20.0, bottom: 30, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [],
                          ),
                        )
                      ],
                    ),
                  ),
                  floating: true,
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: [
                UserChatRoomWidget(),
                // CallHistory(),
                // UserSafeContracts(),
                // UserContracts(),
              ],
            ),
          ),
        ),
        floatingActionButton: SizedBox(
          // color: Colors.red,
          height: Get.height * .10,
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: "${DateTime.now().microsecond}",
                foregroundColor: Colors.white,
                backgroundColor: kPrimaryColor,
                onPressed: () async {
                  enumServices.openContactsScreenOrigin = OpenContactsScreenOrigin.FROM_CHAT_PAGE;
                  enumServices.userActionType = UserActionType.CREATE_NEW_CHAT;
                  enumServices.chatTypes = ChatTypes.PRIVATE_CHAT;

                  initialChat.chatType = ChatTypes.PRIVATE_CHAT;
                  enumServices.chatServicesActions = ChatServicesActions.CREATE_NEW_PRIVATE_CHAT;
                  chatServices.context = context;
                  // contactServices.listenToContacts();
                  // changeScreen(context, DisplayContacts(actionType: "newChat", backgroundColor: white,));

                  _askPermissions("null");

                  // if (permissionController.contactsPermissionGranted.value) {
                  //
                  // } else {
                  //   permissionController.getContactPermission();
                  // }
                },
                child: const Icon(
                  Icons.add,
                ),
//                onPressed: widget.startNewConversation,
              ),
            ],
          ),
        ),
        bottomNavigationBar: HomeNavigationBar(
          tabIndex: 0,
          backgroudColor: Colors.white,
        ),
      ),
    );
    // return SingleChildScrollView(
    //   child: Padding(
    //     padding: EdgeInsets.all(8),
    //     child: Center(
    //       child: Column(
    //         children: <Widget>[
    //           Text("testing"),
    //
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
