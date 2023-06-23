import 'package:mooweapp/export_files.dart';

class StoreHomeScreen extends StatefulWidget {
  const StoreHomeScreen({super.key});

  // final Business business;
  // const StoreHomeScreen({Key? key, required this.business}) : super(key: key);

  @override
  _StoreHomeScreenState createState() => _StoreHomeScreenState();
}

class _StoreHomeScreenState extends State<StoreHomeScreen> with SingleTickerProviderStateMixin {
  var scaffoldState = GlobalKey<ScaffoldState>();
  TabController? tabController;
  int selectedIndex = 0;

  void onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = index;
    });
  }

  @override
  void initState() {

    Get.put(StoreController());
    Get.put(AddProductController());
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      key: scaffoldState,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
            // HomeTabPage().creat;
          },
        ),
        title: Obx(
              () => Text(
            (acceptPaymentsController.business.value.businessName?? "").capitalize!,
            overflow: TextOverflow.fade,
            style: themeData!.textTheme.headline6!.copyWith(color: Colors.white,),
          ),
        ),
        actions: [
          Obx(() => showOptionSwitch())
        ],
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children:  [
          Obx(() => showOption()),
          const StoreDashboard(),
          const StoreCreateProduct(),
          StoreTransactionsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner_outlined),
            label: "Earning",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.space_dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "Products",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: "Payments",
          ),
        ],
        unselectedItemColor: Colors.black54,
        selectedItemColor: kPrimaryColor,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }

  Widget showOptionSwitch(){
    switch(acceptPaymentsController.qrCodOrChat.value) {
      case StoreShowQRCodOrChat.SHOW_STORE_CHAT:
        return IconButton(onPressed: (){
          acceptPaymentsController.qrCodOrChat.value = StoreShowQRCodOrChat.SHOW_STORE_QRCODE;
        }, icon: const Icon(Icons.qr_code),);
      case StoreShowQRCodOrChat.SHOW_STORE_QRCODE:
        return IconButton(onPressed: (){
          acceptPaymentsController.qrCodOrChat.value = StoreShowQRCodOrChat.SHOW_STORE_CHAT;
        }, icon: const Icon(Icons.chat),);

    }
  }
  Widget showOption(){
    switch(acceptPaymentsController.qrCodOrChat.value) {
      case StoreShowQRCodOrChat.SHOW_STORE_CHAT:
        return ChatScreen(chatRoom: acceptPaymentsController.chatRoom.value, userChatRoom: UserChatRoom(chatRoom: "", isNew: false, time: Timestamp.now(), ));
      case StoreShowQRCodOrChat.SHOW_STORE_QRCODE:
        return const StoreQRCode();
    }
  }
}
