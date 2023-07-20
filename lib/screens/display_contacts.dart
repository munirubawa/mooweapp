// import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:mooweapp/export_files.dart';
import 'package:shimmer/shimmer.dart';

class DisplayContacts extends StatefulWidget {
  final ChatRoom? chatRoom;
  final Color? backgroundColor;

  const DisplayContacts({Key? key, this.chatRoom, this.backgroundColor = kPrimaryColor}) : super(key: key);

  @override
  State<DisplayContacts> createState() => _DisplayContactsState();
}

class _DisplayContactsState extends State<DisplayContacts> {
  int indexToInsert = 0;
  bool switchToGroup = false;

  DocumentSnapshot? documentSnapshot;
  Contact? _currentContact;

  @override
  void initState() {
    super.initState();
    // _fetchContacts();
    contactServices.selectedContacts.clear();
    // contactServices.localContactFound.clear();

    // FlutterContacts.addListener(() => firebaseUsers());
  }

  @override
  void dispose() {
    enumServices.appBarActions = ContactAppBarActions.CANCEL_SEARCH;
    enumServices.userActionType = UserActionType.USER_ACTION_NOT_SET;
    // TODO: implement dispose
    super.dispose();
  }

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
        title: enumServices.userActionType == UserActionType.SEND_CASH_TO_MOMO
            ? Container()
            : enumServices.appBarActions == ContactAppBarActions.CANCEL_SEARCH
                ? enumServices.userActionType == UserActionType.ADD_NEW_MEMBER_TO_GROUP_OR_PROJECT
                    ? Row(
                        children: [
                          TextButton(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                enumServices.userActionType == UserActionType.CREATE_NEW_GROUP_OR_PROJECT_CHAT || enumServices.userActionType == UserActionType.ADD_NEW_MEMBER_TO_GROUP_OR_PROJECT
                                    ? Text(
                                        "${groupOrProjectMembers.length} Selected",
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                            onPressed: () {
                              Get.back();
                              enumServices.openContactsScreenOrigin = OpenContactsScreenOrigin.FROM_CHAT_PAGE;
                              enumServices.userActionType = UserActionType.CREATE_NEW_GROUP_OR_PROJECT_CHAT;
                              enumServices.chatTypes = ChatTypes.GROUP_CHAT;
                              // changeScreen(context, DisplayContacts(actionType: "newChat", backgroundColor: white,));
                              Get.to(() => const DisplayContacts(
                                    backgroundColor: Colors.white,
                                  ));
                            },
                          ),
                        ],
                      )
                    : const Text("Select a contact")
                : Container(),
        actions: [
          enumServices.appBarActions == ContactAppBarActions.CANCEL_SEARCH
              ? IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    enumServices.appBarActions = ContactAppBarActions.SEARCH;
                    print("contactServices.snapshots ${contactServices.snapshots.length}");
                    setState(() {});
                    // Navigator.of(context).pop();
                    // showSearch<Member>(context: context, delegate: StartNewChat());
                  },
                )
              : IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    enumServices.appBarActions = ContactAppBarActions.CANCEL_SEARCH;
                    setState(() {});
                    // Navigator.of(context).pop();
                    // showSearch<Member>(context: context, delegate: StartNewChat());
                  },
                ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(child: _body()),
          ],
        ),
      ),
      floatingActionButton: enumServices.userActionType == UserActionType.SEND_CASH_TO_MOMO
          ? Container()
          : enumServices.chatTypes != ChatTypes.PRIVATE_CHAT
              ? FloatingActionButton(
                  backgroundColor: kPrimaryColor,
                  child: enumServices.userActionType == UserActionType.ADD_NEW_MEMBER_TO_GROUP_OR_PROJECT ? const Text("Add") : const Text("Start"),
                  onPressed: () {
                    print("object");
                    print(enumServices.userActionType);
                    switch (enumServices.userActionType) {
                      case UserActionType.CREATE_NEW_GROUP_OR_PROJECT_CHAT:
                        Get.back();
                        initialChat.chatType = enumServices.chatTypes;
                        enumServices.appBarActions = ContactAppBarActions.CANCEL_SEARCH;
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
                  },
                )
              : Container(),
    );
  }

  Widget _body() {
    if (contactServices.permissionDenied) return const Center(child: Text('Permission denied'));
    if (contactServices.localContact.isEmpty) return Center(child: LoadingListPage(count: 10));
    return enumServices.userActionType == UserActionType.SEND_CASH_TO_MOMO
        ? ListView.builder(
            itemCount: contactServices.momoSelectedContacts.length,
            itemBuilder: (context, i) {
              return ListTile(
                title: listTitle(contactServices.momoSelectedContacts.elementAt(i)),
                subtitle: listSubtitle(contactServices.momoSelectedContacts.elementAt(i)),
                trailing: contactServices.momoLogo(contactServices.momoSelectedContacts.elementAt(i)),
                onTap: () {
                  if (contactServices.getCurrencyType(contactServices.momoSelectedContacts.elementAt(i)) == "") {
                    showToastMessage(msg: "Sorry: please check back later");
                  } else {
                    exchangeController.exchangeFrom.value = chatServices.localMember!.get(memberModel.currencyCode)!;
                    exchangeController.exchangeTo.value = contactServices.getCurrencyType(contactServices.momoSelectedContacts.elementAt(i));
                    transactionService.localCurrency = chatServices.localMember!.get(memberModel.currencyCode)!;
                    transactionService.remoteCurrency = contactServices.getCurrencyType(contactServices.momoSelectedContacts.elementAt(i));
                    exchangeController.currencyExchangeConverter().then((value) {
                      print(value);
                      Get.to(
                        () => ConfirmContact(
                          contact: contactServices.momoSelectedContacts.elementAt(i),
                        ),
                      );
                    });
                  }
                },
              );
            },
          )
        : enumServices.appBarActions == ContactAppBarActions.SEARCH
            ? ListView.builder(
                itemCount: contactServices.localContactFound.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: listTitle(contactServices.localContactFound.elementAt(i)),
                    subtitle: listSubtitle(contactServices.localContactFound.elementAt(i)),
                    trailing: listTrailing(contactServices.localContactFound.elementAt(i)),
                    onLongPress: onLongPress,
                    onTap: () => logicForNewChat(contactServices.localContactFound.elementAt(i)),
                  );
                })
            : ListView.builder(
                itemCount: contactServices.localContact.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: listTitle(contactServices.localContact.elementAt(i)),
                    subtitle: listSubtitle(contactServices.localContact.elementAt(i)),
                    trailing: listTrailing(contactServices.localContact.elementAt(i)),
                    onLongPress: onLongPress,
                    onTap: () => logicForNewChat(contactServices.localContact.elementAt(i)),
                  );
                },
              );
  }

  void onLongPress() {
    if (enumServices.chatTypes == ChatTypes.PRIVATE_CHAT) {
      enumServices.chatTypes = ChatTypes.GROUP_CHAT;
      enumServices.userActionType = UserActionType.CREATE_NEW_GROUP_OR_PROJECT_CHAT;
    } else {
      enumServices.userActionType = UserActionType.CREATE_NEW_CHAT;
      enumServices.chatTypes = ChatTypes.PRIVATE_CHAT;
    }
    setState(() {});
  }

  Widget listTitle(Contact contact) {
    return Text(
      contact.displayName,
      style: themeData!.textTheme.titleMedium,
    );
  }

  Widget listSubtitle(Contact contact) {
    return android_ios_number_display(contact.phones.first);
  }

  Widget listTrailing(Contact contact) {
    return SizedBox(
      width: 50,
      height: 50,
      child: checkIfContactFound(contact)
          ? Stack(
              alignment: Alignment.center,
              children: [
                // ,
                Positioned.fill(child: getLogo(contact)),
                Visibility(
                  visible: enumServices.userActionType == UserActionType.CREATE_NEW_GROUP_OR_PROJECT_CHAT ? true : false,
                  child: Checkbox(
                    value: checkIfContactIsSelected(contact),
                    onChanged: (bool? val) {
                      //TODO add checked contact to a list or remove it
                      if (val == true) {
                        for (var phone in contact.phones) {
                          print(contact.phones.length);
                          for (var snap in contactServices.snapshots) {
                            if (contactServices.cleanNumber(phone) == snap.get("phone")) {
                              // print(snap.data());
                              var result = groupOrProjectMembers.where(
                                (element) => element.get("phone") == snap.get("phone"),
                              );
                              if (result.isEmpty) {
                                groupOrProjectMembers.add(snap);
                                contactServices.selectedContacts.add(contact);
                              }
                            }
                          }
                        }
                      } else {
                        for (var phone in contact.phones) {
                          contactServices.selectedContacts.removeWhere((element) {
                            bool confirm = false;
                            for (var element in element.phones) {
                              if (contactServices.cleanNumber(phone) == contactServices.cleanNumber(element)) {
                                groupOrProjectMembers.removeWhere((element) => contactServices.cleanNumber(phone) == element.get("phone"));
                                confirm = true;
                              }
                            }
                            return confirm;
                          });
                        }
                        setState(() {});
                      }
                      setState(() {});
                    },
                  ),
                ),
              ],
            )
          : const Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                    child: InkWell(
                  child: Text("Invite"),
                ))
              ],
            ),
    );
  }

  bool checkIfContactFound(Contact contact) {
    bool found_bool = false;
    for (var element in contact.phones) {
      for (var foundContact in contactServices.localContactFound) {
        for (var found in foundContact.phones) {
          if (contactServices.cleanNumber(found) == contactServices.cleanNumber(element)) {
            found_bool = true;
          }
        }
      }
      // var existingItem = contactServices.contactservices.localContactFound.firstWhere((itemToCheck) => itemToCheck.phones == favoriteitem.link, orElse: () => null);
    }
    return found_bool;
  }

  bool checkIfContactIsSelected(Contact contact) {
    bool found_bool = false;
    for (var element in contact.phones) {
      for (var foundContact in contactServices.selectedContacts) {
        for (var found in foundContact.phones) {
          if (contactServices.cleanNumber(found) == contactServices.cleanNumber(element)) {
            found_bool = true;
          }
        }
      }
      // var existingItem = contactServices.contactservices.localContactFound.firstWhere((itemToCheck) => itemToCheck.phones == favoriteitem.link, orElse: () => null);
    }
    return found_bool;
  }

  Widget getLogo(Contact contact) {
    // print(contact.phones);
    bool found_bool = false;
    for (var element in contact.phones) {
      for (var foundContact in contactServices.localContactFound) {
        for (var found in foundContact.phones) {
          if (contactServices.cleanNumber(found) == contactServices.cleanNumber(element)) {
            found_bool = true;
          }
        }
      }
      // var existingItem = _localContactFound.firstWhere((itemToCheck) => itemToCheck.phones == favoriteitem.link, orElse: () => null);
    }

    return found_bool
        ? CircleAvatar(radius: imageRadius, backgroundImage: const AssetImage('assets/ic_launcher_round.png'))
        : InkWell(
            onTap: sharInvite,
            child: const Text("Invite"),
          );
  }

  DocumentSnapshot? selectedContact;

  Chat newChat = Chat(
    firstTimeMessage: true,
    read: false,
    time: Timestamp.now(),
  );

  // final contract = locator.get<Contract>();

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

  void showInViteDialog(String name) {
    Get.defaultDialog(
        barrierDismissible: false,
        title: "Invite to chat",
        content: Text("Invite $name"),
        confirm: SizedBox(
          height: 40,
          width: Get.width,
          child: Row(
            children: [
              InkWell(
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                  child: Text("Cancel"),
                ),
                onTap: () => Get.back(),
              ),
              Expanded(child: Container()),
              InkWell(
                onTap: () {
                  Get.back();
                  sharInvite();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                  child: Text("Invite"),
                ),
              ),
            ],
          ),
        ));
  }

  void logicForNewChat(Contact contact) {
    DocumentSnapshot<Object?>? member = documentSnapshot;
    contactServices.context = context;
    transactionService.context = context;
    contactServices.newChat = initialChat;
    contactServices.chatRoom = widget.chatRoom;
    transactionService.chatRoom = widget.chatRoom;
    print("Usr actions here ${enumServices.userActionType}");
    print("Usr actions here ${enumServices.chatTypes}");

    // contactServices.contract = contract;

    switch (enumServices.userActionType) {
      case UserActionType.CREATE_NEW_CHAT:
        // TODO: Handle this case.
        switch (enumServices.chatTypes!) {
          case ChatTypes.PRIVATE_CHAT:
            initialChat.chatType = enumServices.chatTypes;
            groupOrProjectMembers.clear();
            if (checkIfContactFound(contact)) {
              for (var phone in contact.phones) {
                for (var snap in contactServices.snapshots) {
                  if (contactServices.cleanNumber(phone) == snap.get("phone")) {
                    transactionService.member = snap;
                    remoteMember = snap;
                    member = snap;
                    contactServices.selectedContact = snap;
                  }
                }
              }

              var chat = currentChats.firstWhereOrNull((element) {
                return element.members!.contains(member?.get(memberModel.contactPath)) &&
                    element.chatType == enumServices.chatTypes &&
                    element.members!.contains(chatServices.localMember!.get(memberModel.contactPath));
              });
              var userChatRoomInfo = userChatRoom.firstWhereOrNull((element) {
                return chat != null && chat.chatRoomChatsCollection == element.chatRoom;
              });
              groupOrProjectMembers.add(member!);
              //
              // if (chat == null) {
              //   chatServices.runChatServices();
              // } else {
              //   Get.to(() => PrivateChatScreen(chatRoom: chat, userChatRoom: userChatRoomInfo));
              // }

              if (chat == null) {
                Get.back();
                chatServices.runChatServices();
              } else {
                Get.to(() => PrivateChatScreen(chatRoom: chat, userChatRoom: userChatRoomInfo));
              }
            } else {
              showInViteDialog(contact.displayName);
            }
            break;
          case ChatTypes.GROUP_CHAT:

            // TODO: Handle this case.
            initialChat.chatType = ChatTypes.GROUP_CHAT;
            // CountryInfo? counteryInfo =  await showSearch<CountryInfo>(context: context, delegate: CurrencySearch());
            enumServices.chatServicesActions = ChatServicesActions.CREATE_NEW_GROUP_OR_PROJECT_CHAT;
            // chatServices.context = context;
            print("this is a new group");
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
}

class ShareWithContact extends StatelessWidget {
  final Contact contact;
  const ShareWithContact({Key? key, required this.contact}) : super(key: key);

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
