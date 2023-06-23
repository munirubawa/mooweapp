import 'package:mooweapp/export_files.dart';

class BusinessAccountScreen extends StatelessWidget {
  final ChatRoom chatRoom;
  const BusinessAccountScreen({
    Key? key, required this.chatRoom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: kPrimaryColor,
          elevation: 0.0,
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
          bottom: const TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            indicatorWeight: 6.0,
            tabs: [
              Tab(text: "Team chat"),
              Tab(text: "Team"),
              Tab(text: "Dashboard"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() => showOption()),
            // ChatScreen(chatRoom: chatRoom, userChatRoom: UserChatRoom(chatRoom: '', isNew: false, time: Timestamp.now(), reference: null)),
            BusinessGroupMembersScreen(chatRoom: acceptPaymentsController.chatRoom.value),
            BusinessTransactionScreen(),
          ],
        ),
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

class BusinessQRCode extends StatelessWidget {
  const BusinessQRCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

