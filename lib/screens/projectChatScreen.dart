import 'package:mooweapp/export_files.dart';
class ProjectChatScreen extends StatefulWidget {
  final ChatRoom? chatRoom;
  final UserChatRoom? userChatRoom;
  const ProjectChatScreen({required this.chatRoom, required this.userChatRoom});

  @override
  State<ProjectChatScreen> createState() => _ProjectChatScreenState();
}

class _ProjectChatScreenState extends State<ProjectChatScreen> {

  @override
  void initState() {
    addPaymentMethodController.initializePaymentMethod();
    super.initState();
    ///whatever you want to run on page build
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor:  kPrimaryColor,
          elevation: 0.0,
          leading: IconButton(
            onPressed: (){
              if(navController.callStatus.value == CallActionStatus.CALL_START) {
                navController.pipPage = const MyHomeScreen();
                navController.smallScreen();
              } else {
                Get.back();
              }
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white,),
          ),
          title: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.chatRoom!.firstName}'.capitalize!,
                    overflow: TextOverflow.fade,
                    style: themeData!.textTheme.bodyLarge!.copyWith(color: Colors.white),
                  ),
                  Text("project chat", style: themeData!.textTheme.bodySmall!.copyWith(color: Colors.white),),
                ],
              ),
              Expanded(child: Container()),
              IconButton(
                icon: const Icon(Icons.money, color: Colors.white,),
                tooltip: 'Open project wallet',
                onPressed: () {
                  groupChatController.chatRoom.value = widget.chatRoom!;
                  Get.to(()=> GroupContributionsScreen(
                    chatRoom: widget.chatRoom,
                  ));
                  // showModalBottomSheet(
                  //   context: context,
                  //   builder: (context) => Container(
                  //     color: Colors.white,
                  //     child: ,
                  //   ),
                  // );

                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupContributionsScreen(chatRoom: chatRoom)));
                },
              ),
              IconButton(

                icon: const Icon(Icons.monetization_on_outlined, color: Colors.white),
                tooltip: 'Send money in chat',
                onPressed: () {
                  // Get.to(()=> ChatMoneyKeyPad(
                  //   chatRoom: chatRoom,
                  // ));
                  if(paymentsController.hasePaymentMethod)
                  {
                    enumServices.transactionActionType = TransactionActionType.SEND_CASH_PROJECT_CHAT;

                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        color: Colors.white,
                        child: ChatMoneyKeyPad(
                          chatRoom: widget.chatRoom,

                        ),
                      ),
                    );
                  } else {
                    addPaymentMethodController.addPaymentMethod();
                    // Get.to(()=> const AddPlaidPaymentMethod());
                  }
                },
              ),
            ],
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.black,
            indicatorWeight: 5.0,
            tabs: [
              Tab(text: "Messages"),
              Tab(text: "Members"),
              Tab(text: "Contracts"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/whatsappchatbackground.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: ChatScreen(
                chatRoom: widget.chatRoom, userChatRoom: widget.userChatRoom,
              ),
            ),
            ProjectGroupMembersScreen(
              chatRoom: widget.chatRoom
            ),
            ProjectContractScreen(
              chatRoom: widget.chatRoom,
            ),
          ],
        ),
      ),
    );
  }
}


