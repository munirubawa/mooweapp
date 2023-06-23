import 'package:mooweapp/export_files.dart';
groupNamePushNavigator(BuildContext _context){
  // print("pushNavigator");
  Get.defaultDialog(
    barrierDismissible: false,
    titleStyle: themeData!.textTheme.headline5,
    title: '${chatTypeName()} Chat Name',
    content: RoundedInputField(
      key: UniqueKey(),
      data:  initialChat.displayName?? "",
      textInputType: TextInputType.text,
      hintText: "Chat Name",
      onChanged: (value) {
        // initialChat.notifyName = value;
        initialChat.displayName = value;
      },
    ),
    confirm: SizedBox(
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          CustomBtn2(text: "Cancel", bgColor: kPrimaryColor, onTap: (){
            Get.back();
          }),
          CustomBtn2(text: "Start Chat",  bgColor: kPrimaryColor, onTap: (){
            // countryServices.context = context;
            // countryServices.fromDisplayCurrency = false;
            switch(enumServices.userActionType) {
              case UserActionType.CREATE_NEW_CHAT:
              case UserActionType.CREATE_NEW_GROUP_OR_PROJECT_CHAT:
              // TODO: Handle this case.

                if(initialChat.displayName != null  &&  initialChat.displayName!.isNotEmpty)
                {
                  Get.back();
                  enumServices.chatServicesActions = ChatServicesActions.CREATE_NEW_GROUP_OR_PROJECT_CHAT;

                  var chat =  currentChats.firstWhereOrNull((element){
                    return element.groupName == initialChat.displayName;
                  });
                  var userChatRoomInfo = userChatRoom.firstWhereOrNull((element) {
                    return chat != null && chat
                        .chatRoomChatsCollection == element.chatRoom;});
                  if(chat == null) {
                    chatServices.runChatServices();
                  } else {
                   switch(enumServices.chatTypes!){
                     case ChatTypes.PRIVATE_CHAT:
                       // TODO: Handle this case.
                       break;
                     case ChatTypes.GROUP_CHAT:
                       Get.to(()=>  GroupChatScreen(chatRoom: chat, userChatRoom: userChatRoomInfo));
                       break;
                     case ChatTypes.PROJECT_CHAT:
                       Get.to(()=>  ProjectChatScreen(chatRoom: chat, userChatRoom: userChatRoomInfo));
                       break;
                     case ChatTypes.FUND_RAISE:
                       // TODO: Handle this case.
                       break;
                     case ChatTypes.SUSU:
                       // TODO: Handle this case.
                       break;
                     case ChatTypes.BUSINESS_CHAT:
                       // TODO: Handle this case.
                       break;
                     case ChatTypes.STORE_CHAT:
                       // TODO: Handle this case.
                       break;
                   }
                  }
                } else {
                  showToastMessage(msg: "Group Name required!", timeInSecForIosWeb: 3, backgroundColor: Colors.red);
                }

                break;
              case UserActionType.SEND_CASH_DIRECT_FROM_MOOWE_PAY:
              // TODO: Handle this case.
                break;
              case UserActionType.CREATE_CONTRACT:
              // TODO: Handle this case.
                break;
              case UserActionType.SEND_CASH_IN_PRIVATE_CHAT:
              // TODO: Handle this case.
                break;
              case UserActionType.SEND_CASH_IN_GROUP_CHAT:
              // TODO: Handle this case.
                break;
              case UserActionType.SEND_CASH_PROJECT_CHAT:
              // TODO: Handle this case.
                break;
              case UserActionType.SEND_CASH_TO_MOMO:
              // TODO: Handle this case.
                break;
              case UserActionType.SEND_CASH_TO_BANK_ACCOUNT:
              // TODO: Handle this case.
                break;
              case UserActionType.CASH_OUT_TO_BANK_ACCOUNT:
              // TODO: Handle this case.
                break;
              case UserActionType.ADD_NEW_MEMBER_TO_GROUP_OR_PROJECT:
              // TODO: Handle this case.
                break;
              case UserActionType.PAY_INTO_CONTRACT:
              // TODO: Handle this case.
                break;
              case UserActionType.PROCESS_CONTRACT:
              // TODO: Handle this case.
                break;

              default:

                break;
            }},),
          // ElevatedButton(
          //   child: const Text("Start Chat"),
          //   onPressed:
          // }, )
        ],
      ),
    )
  );
}
String chatTypeName(){
  switch(initialChat.chatType!) {

    case ChatTypes.PRIVATE_CHAT:
      return "Private";
    case ChatTypes.GROUP_CHAT:
      return "Group";
    case ChatTypes.PROJECT_CHAT:
      return "Project";
    case ChatTypes.FUND_RAISE:
      return "Fund raise";
    case ChatTypes.SUSU:
      return "Susu";
    case ChatTypes.BUSINESS_CHAT:
      return "Business";
    case ChatTypes.STORE_CHAT:
      return "Store";
  }
}
