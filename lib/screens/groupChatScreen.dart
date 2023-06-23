import 'package:mooweapp/export_files.dart';

class GroupChatScreen extends StatefulWidget {
  final ChatRoom? chatRoom;
  final UserChatRoom? userChatRoom;
  const GroupChatScreen({required this.chatRoom, required this.userChatRoom});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
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
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
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
          iconTheme: const IconThemeData(color: Colors.black),
          title: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.chatRoom!.firstName}'.capitalize!,
                    overflow: TextOverflow.fade,
                    style: themeData!.textTheme.bodyText1!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  // Text("group chat",
                  //   style: themeData!.textTheme.bodySmall!.copyWith(color: Colors.white),
                  // ),
                ],
              ),
              Expanded(child: Container()),
              IconButton(
                icon: const Icon(
                  Icons.money,
                  color: Colors.white,
                ),
                tooltip: 'See Group Contribution',
                onPressed: () {
                 if(paymentsController.hasePaymentMethod)
                   {
                     showBarModalBottomSheet(
                       elevation: 0.0,
                       context: context,
                       builder: (context) => Container(
                         color: Colors.white,
                         child: GroupContributionsScreen(
                                            chatRoom: widget.chatRoom,
                                          ),
                       ),
                     );
                   } else {
                   addPaymentMethodController.addPaymentMethod();
                  // Get.to(()=> const AddPlaidPaymentMethod());
                  }
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => GroupContributionsScreen(
                  //         chatRoom: chatRoom,
                  //       )
                  //   ),
                  // );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.monetization_on_outlined,
                  color: Colors.white,
                ),
                tooltip: 'Send money in chat',
                onPressed: () {
                  paymentsController.checkPaymentMethod();
                  enumServices.userActionType = UserActionType.SEND_CASH_IN_GROUP_CHAT;
                  enumServices.transactionActionType = TransactionActionType.SEND_CASH_IN_GROUP_CHAT;
                  enumServices.fundingActionType = FundingActionType.TRANSFER_FUNDS_INTO_GROUP;
                  transactionService.chatRoom = widget.chatRoom;
                  // Get.to(()=>  ChatMoneyKeyPad(chatRoom: chatRoom, contract: Contract(),));

                  showBarModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      color: Colors.white,
                      child: ChatMoneyKeyPad(
                        chatRoom: widget.chatRoom,
                        // contract: Contract(),
                      ),
                    ),
                  );
                },
              ),
              // Expanded(
              //     child: IconButton(
              //   icon: const Icon(
              //     Icons.add_call,
              //     color: Colors.white,
              //   ),
              //   onPressed: () {
              //     signalingController.callActionDetails = CallActionDetails(
              //         chatRoomPath: chatRoom!.chatRoomChatsCollection,
              //         didCallDeclined: false,
              //         isCallAnswered: false,
              //         didPhoneRang: false,
              //         didCallerHangup: false,
              //         time: Timestamp.now(),
              //         chatRoom: chatRoom,
              //         callType: CallType.VOICE_CALL,
              //         chatType: chatRoom!.chatType,
              //         callFrom: MemberCallInfo.fromMap(chatServices.localUser!.member!.toMap()),
              //         callTo: MemberCallInfo.fromMap(chatServices.localUser!.member!.toMap()),
              //         jitsiCallActions: JitsiCallActions.PRIVATE_CALL,
              //         isAudioMuted: false,
              //         isAudioOnly: true,
              //         isVideoMuted: true,
              //         callActive: true,
              //         roomId: chatRoom!.reference!.id,
              //         subject: "Private call",
              //         notifyName: "${chatServices.sender.firstName} ${chatServices.sender.lastName}",
              //         callResponds: CallResponds.INCOMING_CALL);
              //     signalingController.showCallScreen(IncomingCallOrOutGoingCall.OUTGOING_CALL);
              //   },
              // )),
            ],
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.black,
            indicatorWeight: 5.0,
            onTap: (int? value ){
              groupChatController.memberDisplayType = GroupMemberDisplayType.DISPLAY_MEMBERS_OF_GROUP;
            },

            tabs: const [
              Tab(
                text: "Message",
              ),
              // Tab( text: "Media"),
              Tab(text: "Members"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChatScreen(
              chatRoom: widget.chatRoom,
              userChatRoom: widget.userChatRoom,
            ),
            GroupMembersScreen(
              chatRoom: widget.chatRoom,
            ),
          ],
        ),
      ),
    );
  }
}
