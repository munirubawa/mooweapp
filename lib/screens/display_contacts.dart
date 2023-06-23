// import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:mooweapp/export_files.dart';
import 'package:shimmer/shimmer.dart';

// import 'package:contacts_service/contacts_service.dart' as contacts;
class DisplayContacts extends StatefulWidget {
  ChatRoom? chatRoom = ChatRoom();
  Color? backgroundColor;

  DisplayContacts({Key? key, this.chatRoom, this.backgroundColor = kPrimaryColor}) : super(key: key);

  @override
  State<DisplayContacts> createState() => _DisplayContactsState();
}

class _DisplayContactsState extends State<DisplayContacts> {
  List<Contact>? _contacts;
  List<Contact>? _contactsEditing;
  bool _permissionDenied = false;
  List<String> contactData = [];
  List<String> userIndex = [];
  int indexToInsert = 0;
  bool switchToGroup = false;
  @override
  void initState() {
    super.initState();
    _fetchContacts();
    contactData.clear();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();

      setState(() {
        _contacts = contacts.cast<Contact>();
      });

      // print("_fetchContacts ${_contacts!.length}");
    }
  }

  Widget _body() {
    if (_permissionDenied) return const Center(child: Text('Permission denied'));
    if (_contacts == null) return Center(child: LoadingListPage(count: 10));
    return ListView.builder(
      itemCount: _contacts!.length,
      itemBuilder: (context, i) {
        DocumentSnapshot? documentSnapshot;
        return ListTile(
          title: Text(
            _contacts![i].displayName,
            style: themeData!.textTheme.titleMedium,
          ),
          subtitle: FutureBuilder<Contact?>(
            future: FlutterContacts.getContact(_contacts![i].id), // async work
            builder: (BuildContext context, AsyncSnapshot<Contact?> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Container();
                default:
                  if (snapshot.hasError) {
                    return Container();
                  } else {
                    // return Text(contact?.phones.first.number??"");
                    if (snapshot.hasData) {
                      final Contact contact = snapshot.data!;

                      if (contact.phones.isNotEmpty) {
                        return Text(
                          contact.phones.first.normalizedNumber,
                          style: themeData!.textTheme.subtitle1,
                        );
                      } else {
                        return Container();
                      }

                      // return Text('Phone number: ${contact?.phones.first?? contact?.phones.first.normalizedNumber}');
                    } else {
                      return const Text('No phone numbers');
                    }
                  }
              }
            },
          ),
          trailing: switchToGroup
              ? userIndex.contains(_contacts![i].id)
                  ? Checkbox(
                      value: contactData.contains(_contacts![i].id),
                      onChanged: (bool? val) {
                        setState(() {
                          if (contactData.contains(_contacts![i].id)) {
                            contactData.remove(_contacts![i].id);
                          } else {
                            contactData.add(_contacts![i].id);
                          }
                        });
                      },
                    )
                  : const SizedBox(height: 15)
              : SizedBox(
                  width: 50,
                  height: 50,
                  child: FutureBuilder<Contact?>(
                    future: FlutterContacts.getContact(_contacts![i].id), // async work
                    builder: (BuildContext context, AsyncSnapshot<Contact?> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Container();
                        default:
                          if (snapshot.hasError) {
                            return const Text("none");
                          } else {
                            // return Text(contact?.phones.first.number??"");
                            if (snapshot.hasData) {
                              final Contact contact = snapshot.data!;
                              if (contact.phones.isNotEmpty) {
                                return FutureBuilder<QuerySnapshot>(
                                  future: FirebaseFirestore.instance.collection(dbHelper.users()).where("phone", isEqualTo: contact.phones.first.normalizedNumber).get(), // async work
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return Container();
                                      default:
                                        if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        } else {
                                          // bool? found =   snapshot.data?.docs.isNotEmpty;
                                          if (!snapshot.hasData) {
                                            return InkWell(
                                              onTap: () {
                                                print("well 1");
                                              },
                                              child: const Text("Invite 1"),
                                            );
                                          } else {
                                            if (snapshot.data!.docs.isNotEmpty) {
                                              userIndex.add(_contacts![i].id);
                                              documentSnapshot = snapshot.data!.docs.first;
                                              return CircleAvatar(radius: imageRadius, backgroundImage: const AssetImage('assets/ic_launcher_round.png'));
                                            } else {
                                              return InkWell(
                                                onTap: sharInvite,
                                                child: const Text("Invite 2"),
                                              );
                                            }
                                          }
                                        }
                                    }
                                  },
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                            // return Text('Phone number: ${contact?.phones.first?? contact?.phones.first.normalizedNumber}');
                          }
                      }
                    },
                  ),
                ),
          onLongPress: () {
            switchToGroup = !switchToGroup;
            if (enumServices.chatTypes == ChatTypes.PRIVATE_CHAT) {
              enumServices.chatTypes = ChatTypes.GROUP_CHAT;
            } else {
              enumServices.chatTypes = ChatTypes.PRIVATE_CHAT;
            }
            contactData.clear();
            setState(() {});
          },
          onTap: () {
            print(enumServices.chatTypes);
            print(userIndex.contains(_contacts![i].id));

            if (enumServices.chatTypes == ChatTypes.PRIVATE_CHAT) {
              DocumentSnapshot<Object?>? member = documentSnapshot;
              contactServices.context = context;
              transactionService.context = context;
              contactServices.selectedContact = member;
              contactServices.newChat = initialChat;
              contactServices.chatRoom = widget.chatRoom;
              transactionService.chatRoom = widget.chatRoom;

              // contactServices.contract = contract;
              transactionService.member = member;
              remoteMember = member;
              switch (enumServices.userActionType) {
                case UserActionType.CREATE_NEW_CHAT:
                  // TODO: Handle this case.
                  // Navigator.of(context).pop();
                  switch (enumServices.chatTypes!) {
                    case ChatTypes.PRIVATE_CHAT:
                      // TODO: Handle this case.
                      // chatServices.runChatServices();
                      if (userIndex.contains(_contacts![i].id)) {
                        print(documentSnapshot?.data());

                        var chat = currentChats.firstWhereOrNull((element) {
                          return element.members!.contains(member?.get(memberModel.contactPath)) &&
                              element.chatType == enumServices.chatTypes &&
                              element.members!.contains(chatServices.localMember!.get(memberModel.contactPath));
                        });
                        var userChatRoomInfo = userChatRoom.firstWhereOrNull((element) {
                          return chat != null && chat.chatRoomChatsCollection == element.chatRoom;
                        });
                        groupOrProjectMembers.add(member!);

                        if (chat == null) {
                          chatServices.runChatServices();
                        } else {
                          Get.to(() => PrivateChatScreen(chatRoom: chat, userChatRoom: userChatRoomInfo));
                        }
                      } else {
                        Get.defaultDialog(
                          title: "destruct",
                          content: const Text("there is nothing to do"),
                        );
                      }
                      break;
                    case ChatTypes.GROUP_CHAT:

                      // TODO: Handle this case.
                      initialChat.chatType = ChatTypes.GROUP_CHAT;
                      // CountryInfo? counteryInfo =  await showSearch<CountryInfo>(context: context, delegate: CurrencySearch());
                      enumServices.chatServicesActions = ChatServicesActions.CREATE_NEW_GROUP_OR_PROJECT_CHAT;
                      // chatServices.context = context;

                      // Get.to(()=> SelectCurrency( actionType: actionsType));
                      groupNamePushNavigator(context);
                      break;
                    case ChatTypes.PROJECT_CHAT:
                      // TODO: Handle this case.
                      initialChat.chatType = ChatTypes.PROJECT_CHAT;
                      enumServices.chatServicesActions = ChatServicesActions.CREATE_NEW_GROUP_OR_PROJECT_CHAT;
                      // chatServices.context = context;
                      // CountryInfo? counteryInfo =  await showSearch<CountryInfo>(context: context, delegate: CurrencySearch());
                      // Get.to(()=>  SelectCurrency());
                      groupNamePushNavigator(context);
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
                  break;
                case UserActionType.SEND_CASH_DIRECT_FROM_MOOWE_PAY:
                  // TODO: Handle this case.
                  Navigator.of(context).pop();
                  transactionService.runTransaction();
                  break;
                case UserActionType.CREATE_CONTRACT:
                  // TODO: Handle this case.
                  break;
                case UserActionType.SEND_CASH_IN_PRIVATE_CHAT:
                  // TODO: Handle this case.
                  transactionService.runTransaction();
                  break;
                case UserActionType.SEND_CASH_IN_GROUP_CHAT:
                  // TODO: Handle this case.
                  transactionService.runTransaction();

                  break;
                case UserActionType.SEND_CASH_PROJECT_CHAT:
                  // TODO: Handle this case.
                  transactionService.runTransaction();

                  break;
                case UserActionType.SEND_CASH_TO_MOMO:
                  // TODO: Handle this case.
                  // GetCurrencyByNumber getCurrencyByNumber = GetCurrencyByNumber(transactionService.member!.phone!);
                  // if (getCurrencyByNumber.getCurrency() != "unknown") {
                  //   Navigator.of(context).pop();
                  //   changeScreen(
                  //       context,
                  //       MomoHomeScreen(
                  //         contactCurrency: getCurrencyByNumber.getCurrency(),
                  //         userCurrency: chatServices.localUser!.currency,
                  //         member: transactionService.member,
                  //       ));
                  // } else {
                  //   unKnownCurrency(context);
                  // }

                  break;
                case UserActionType.SEND_CASH_TO_BANK_ACCOUNT:
                  // TODO: Handle this case.
                  transactionService.runTransaction();

                  break;
                case UserActionType.CASH_OUT_TO_BANK_ACCOUNT:
                  // TODO: Handle this case.
                  transactionService.runTransaction();
                  break;
                case UserActionType.ADD_NEW_MEMBER_TO_GROUP_OR_PROJECT:
                  // TODO: Handle this case.
                  Get.back();
                  chatServices.member = documentSnapshot;
                  chatServices.runChatServices();
                  break;
                case UserActionType.PAY_INTO_CONTRACT:
                  // TODO: Handle this case.
                  transactionService.runTransaction();

                  break;
                case UserActionType.PROCESS_CONTRACT:
                  // TODO: Handle this case.
                  transactionService.runTransaction();

                  break;
                case UserActionType.BILL_PAY:
                  // TODO: Handle this case.
                  break;
                case UserActionType.REQUEST_PAYMENT:
                  // TODO: Handle this case.
                  transactionService.runTransaction();

                  break;
                case UserActionType.TRANSFER_CASH_TO_BANK:
                  // TODO: Handle this case.
                  break;
                case UserActionType.ADD_MEMBER_TO_BUSINESS_ACCOUNT:
                  // TODO: Handle this case.
                  Navigator.of(context).pop();
                  chatServices.runChatServices();
                  break;
                case UserActionType.CREATE_NEW_GROUP_OR_PROJECT_CHAT:
                  // TODO: Handle this case.
                  break;
                case UserActionType.USER_ACTION_NOT_SET:
                  // TODO: Handle this case.
                  break;
              }
            }
          },
        );
      },
    );
  }

  DocumentSnapshot? selectedContact;

  Chat newChat = Chat(
    firstTimeMessage: true,
    read: false,
    time: Timestamp.now(),
  );

  // final contract = locator.get<Contract>();
  @override
  Widget build(BuildContext context) {
    // newChatAction = actionType;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: enumServices.userActionType != UserActionType.ADD_NEW_MEMBER_TO_GROUP_OR_PROJECT
            ? Row(
                children: [
                  TextButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text(
                        //   "Group",
                        //   style: TextStyle(
                        //     color: Colors.black,
                        //   ),
                        // )
                      ],
                    ),
                    onPressed: () {
                      Get.back();
                      enumServices.openContactsScreenOrigin = OpenContactsScreenOrigin.FROM_CHAT_PAGE;
                      enumServices.userActionType = UserActionType.CREATE_NEW_GROUP_OR_PROJECT_CHAT;
                      enumServices.chatTypes = ChatTypes.GROUP_CHAT;
                      // changeScreen(context, DisplayContacts(actionType: "newChat", backgroundColor: white,));
                      Get.to(() => DisplayContacts(
                            backgroundColor: Colors.white,
                          ));
                    },
                  ),
                ],
              )
            : const Text("Select a contact"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () async {
              // Navigator.of(context).pop();
              // showSearch<Member>(context: context, delegate: StartNewChat());
            },
          )
        ],
      ),
      body: _body(),
      // body: Container(
      //   height: Get.height,
      //   width: Get.width,
      //   color: Theme.of(context).primaryColor,
      //   child: Column(
      //     children: [
      //       Expanded(
      //         child: ListView.builder(
      //             shrinkWrap: true,
      //             itemCount: contactServices.mooweContacts.length,
      //             itemBuilder: (context, index) {
      //               // ContactBody(member: ,);
      //               return ContactBody(
      //                   member: contactServices.mooweContacts.elementAt(index),
      //                   press: () {
      //                     DocumentSnapshot member = contactServices.mooweContacts.elementAt(index);
      //                     contactServices.context = context;
      //                     transactionService.context = context;
      //                     contactServices.selectedContact = member;
      //                     contactServices.newChat = initialChat;
      //                     contactServices.chatRoom = widget.chatRoom;
      //                     transactionService.chatRoom = widget.chatRoom;
      //
      //                     // contactServices.contract = contract;
      //                     transactionService.member = member;
      //                     remoteMember = member;
      //                     switch (enumServices.userActionType) {
      //                       case UserActionType.CREATE_NEW_CHAT:
      //                         // TODO: Handle this case.
      //                         Navigator.of(context).pop();
      //                         // Get.to(()=>  SelectChatType());
      //                         switch (enumServices.chatTypes!) {
      //                           case ChatTypes.PRIVATE_CHAT:
      //                             // TODO: Handle this case.
      //                             // chatServices.runChatServices();
      //                             var chat = currentChats.firstWhereOrNull((element) {
      //                               return element.members!.contains(member.get(memberModel.contactPath)) &&
      //                                   element.chatType == enumServices.chatTypes &&
      //                                   element.members!.contains(chatServices.localMember!.get(memberModel.contactPath));
      //                             });
      //                             var userChatRoomInfo = userChatRoom.firstWhereOrNull((element) {
      //                               return chat != null && chat.chatRoomChatsCollection == element.chatRoom;
      //                             });
      //                             groupOrProjectMembers.add(member);
      //
      //                             if (chat == null) {
      //                               chatServices.runChatServices();
      //                             } else {
      //                               Get.to(() => PrivateChatScreen(chatRoom: chat, userChatRoom: userChatRoomInfo));
      //                             }
      //
      //                             break;
      //                           case ChatTypes.GROUP_CHAT:
      //
      //                             // TODO: Handle this case.
      //                             initialChat.chatType = ChatTypes.GROUP_CHAT;
      //                             // CountryInfo? counteryInfo =  await showSearch<CountryInfo>(context: context, delegate: CurrencySearch());
      //                             enumServices.chatServicesActions = ChatServicesActions.CREATE_NEW_GROUP_OR_PROJECT_CHAT;
      //                             // chatServices.context = context;
      //
      //                             // Get.to(()=> SelectCurrency( actionType: actionsType));
      //                             groupNamePushNavigator(context);
      //                             break;
      //                           case ChatTypes.PROJECT_CHAT:
      //                             // TODO: Handle this case.
      //                             initialChat.chatType = ChatTypes.PROJECT_CHAT;
      //                             enumServices.chatServicesActions = ChatServicesActions.CREATE_NEW_GROUP_OR_PROJECT_CHAT;
      //                             // chatServices.context = context;
      //                             // CountryInfo? counteryInfo =  await showSearch<CountryInfo>(context: context, delegate: CurrencySearch());
      //                             // Get.to(()=>  SelectCurrency());
      //                             groupNamePushNavigator(context);
      //                             break;
      //                           case ChatTypes.FUND_RAISE:
      //                             // TODO: Handle this case.
      //                             break;
      //                           case ChatTypes.SUSU:
      //                             // TODO: Handle this case.
      //                             break;
      //                           case ChatTypes.BUSINESS_CHAT:
      //                             // TODO: Handle this case.
      //                             break;
      //                           case ChatTypes.STORE_CHAT:
      //                             // TODO: Handle this case.
      //                             break;
      //                         }
      //                         break;
      //                       case UserActionType.SEND_CASH_DIRECT_FROM_MOOWE_PAY:
      //                         // TODO: Handle this case.
      //                         Navigator.of(context).pop();
      //                         transactionService.runTransaction();
      //                         break;
      //                       case UserActionType.CREATE_CONTRACT:
      //                         // TODO: Handle this case.
      //                         break;
      //                       case UserActionType.SEND_CASH_IN_PRIVATE_CHAT:
      //                         // TODO: Handle this case.
      //                         transactionService.runTransaction();
      //                         break;
      //                       case UserActionType.SEND_CASH_IN_GROUP_CHAT:
      //                         // TODO: Handle this case.
      //                         transactionService.runTransaction();
      //
      //                         break;
      //                       case UserActionType.SEND_CASH_PROJECT_CHAT:
      //                         // TODO: Handle this case.
      //                         transactionService.runTransaction();
      //
      //                         break;
      //                       case UserActionType.SEND_CASH_TO_MOMO:
      //                         // TODO: Handle this case.
      //                         // GetCurrencyByNumber getCurrencyByNumber = GetCurrencyByNumber(transactionService.member!.phone!);
      //                         // if (getCurrencyByNumber.getCurrency() != "unknown") {
      //                         //   Navigator.of(context).pop();
      //                         //   changeScreen(
      //                         //       context,
      //                         //       MomoHomeScreen(
      //                         //         contactCurrency: getCurrencyByNumber.getCurrency(),
      //                         //         userCurrency: chatServices.localUser!.currency,
      //                         //         member: transactionService.member,
      //                         //       ));
      //                         // } else {
      //                         //   unKnownCurrency(context);
      //                         // }
      //
      //                         break;
      //                       case UserActionType.SEND_CASH_TO_BANK_ACCOUNT:
      //                         // TODO: Handle this case.
      //                         transactionService.runTransaction();
      //
      //                         break;
      //                       case UserActionType.CASH_OUT_TO_BANK_ACCOUNT:
      //                         // TODO: Handle this case.
      //                         transactionService.runTransaction();
      //                         break;
      //                       case UserActionType.ADD_NEW_MEMBER_TO_GROUP_OR_PROJECT:
      //                         // TODO: Handle this case.
      //                         Get.back();
      //                         chatServices.member = contactServices.mooweContacts.elementAt(index);
      //                         chatServices.runChatServices();
      //                         break;
      //                       case UserActionType.PAY_INTO_CONTRACT:
      //                         // TODO: Handle this case.
      //                         transactionService.runTransaction();
      //
      //                         break;
      //                       case UserActionType.PROCESS_CONTRACT:
      //                         // TODO: Handle this case.
      //                         transactionService.runTransaction();
      //
      //                         break;
      //                       case UserActionType.BILL_PAY:
      //                         // TODO: Handle this case.
      //                         break;
      //                       case UserActionType.REQUEST_PAYMENT:
      //                         // TODO: Handle this case.
      //                         transactionService.runTransaction();
      //
      //                         break;
      //                       case UserActionType.TRANSFER_CASH_TO_BANK:
      //                         // TODO: Handle this case.
      //                         break;
      //                       case UserActionType.ADD_MEMBER_TO_BUSINESS_ACCOUNT:
      //                         // TODO: Handle this case.
      //                         Navigator.of(context).pop();
      //                         chatServices.runChatServices();
      //                         break;
      //                       case UserActionType.CREATE_NEW_GROUP_OR_PROJECT_CHAT:
      //                         // TODO: Handle this case.
      //                         break;
      //                       case UserActionType.USER_ACTION_NOT_SET:
      //                         // TODO: Handle this case.
      //                         break;
      //                     }
      //                   });
      //               // return
      //             }),
      //       )
      //     ],
      //   ),
      // ),
      floatingActionButton: enumServices.chatTypes != ChatTypes.PRIVATE_CHAT
          ? FloatingActionButton(
              backgroundColor: kPrimaryColor,
              child: enumServices.userActionType == UserActionType.ADD_NEW_MEMBER_TO_GROUP_OR_PROJECT ? const Text("Add") : const Text("Start"),
              onPressed: () {
                if (groupOrProjectMembers.isNotEmpty) {
                  switch (enumServices.userActionType) {
                    case UserActionType.CREATE_NEW_GROUP_OR_PROJECT_CHAT:
                      Get.back();
                      initialChat.chatType = enumServices.chatTypes;
                      enumServices.chatServicesActions = ChatServicesActions.CREATE_NEW_GROUP_OR_PROJECT_CHAT;
                      groupNamePushNavigator(context);
                      break;
                    case UserActionType.ADD_NEW_MEMBER_TO_GROUP_OR_PROJECT:
                      Get.back();
                      enumServices.chatServicesActions = ChatServicesActions.ADD_MEMBER_TO_PROJECT_OR_GROUP;
                      chatServices.runChatServices();
                      break;
                    case UserActionType.CREATE_NEW_CHAT:
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

                    case UserActionType.PAY_INTO_CONTRACT:
                      // TODO: Handle this case.
                      break;
                    case UserActionType.PROCESS_CONTRACT:
                      // TODO: Handle this case.
                      break;
                    case UserActionType.BILL_PAY:
                      // TODO: Handle this case.
                      break;
                    case UserActionType.REQUEST_PAYMENT:
                      // TODO: Handle this case.
                      break;
                    case UserActionType.TRANSFER_CASH_TO_BANK:
                      // TODO: Handle this case.
                      break;
                    case UserActionType.ADD_MEMBER_TO_BUSINESS_ACCOUNT:
                      // TODO: Handle this case.
                      break;
                    case UserActionType.USER_ACTION_NOT_SET:
                      // TODO: Handle this case.
                      break;
                  }
                }
              },
            )
          : Container(),
    );
  }

  void sharInvite() {
    Share.share(
      "I want to share this app with you, it's a chat platform with \n 1) peer-to-peer payment \n 2) cross border remittance \n 3) group chat with group wallet for group "
      "contributions, \n "
      "4) market place to buy and sell anything "
      "and "
      "5) affiliate program that can make you "
      "hundreds of dollars a month, while using it, check it out.\n Click on the link and enter your "
      "phone number, you get a pin, enter that pin and download they app, it's a great app. https://mowe.app/?ap=${chatServices.localMember!.get(memberModel.affiliateId)} \n",
    );
  }

  void chatCreations() {
    if (enumServices.chatTypes == ChatTypes.PRIVATE_CHAT) {}
  }

  Widget floatingButton() {
    switch (enumServices.chatTypes!) {
      case ChatTypes.BUSINESS_CHAT:
        // TODO: Handle this case.
        return FloatingActionButton(
          child: const Text("Add"),
          onPressed: () {},
        );
      case ChatTypes.STORE_CHAT:
        return FloatingActionButton(
          child: const Text("Add"),
          onPressed: () {},
        );

      case ChatTypes.PRIVATE_CHAT:
        return FloatingActionButton(
          child: const Text("Start"),
          onPressed: () {},
        );
      case ChatTypes.GROUP_CHAT:
        return FloatingActionButton(
          child: const Text("Add"),
          onPressed: () {},
        );
      case ChatTypes.PROJECT_CHAT:
        return FloatingActionButton(
          child: const Text("Add"),
          onPressed: () {},
        );

      case ChatTypes.FUND_RAISE:
        return FloatingActionButton(
          child: const Text("Add"),
          onPressed: () {},
        );

      case ChatTypes.SUSU:
        return FloatingActionButton(
          child: const Text("Add"),
          onPressed: () {},
        );
    }
  }
}

class ShareWithContact extends StatelessWidget {
  Contact contact;
  ShareWithContact({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        String phone = contact.phones.first.number.toString();
        // CallsAndMessagesService().sendSms(int.parse(phone.replaceAll(RegExp(r'[^\w\s]+'),'')));
      },
      leading: contact.photo != null
          ? CircleAvatar(
              radius: Get.width * 0.2,
              backgroundImage: MemoryImage(contact.photo!),
            )
          : CircleAvatar(
              radius: Get.width * 0.2,
              child: Text(contact.displayName.substring(0, 1).toString()),
            ),
      title: Text(contact.displayName.toString()),
      subtitle: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: contact.phones.first.number.isNotEmpty ? Text(contact.phones.first.number) : Container(),
      ),
      trailing: const Icon(FontAwesomeIcons.shareAlt),
    );
  }
}
