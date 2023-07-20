// import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:mooweapp/export_files.dart';
import 'package:shimmer/shimmer.dart';

// import 'package:contacts_service/contacts_service.dart' as contacts;
class DisplayContactRemittance extends StatefulWidget {
  ChatRoom? chatRoom = ChatRoom();
  Color? backgroundColor;

  DisplayContactRemittance({Key? key, this.chatRoom, this.backgroundColor = kPrimaryColor}) : super(key: key);

  @override
  _DisplayContactRemittanceState createState() => _DisplayContactRemittanceState();
}

class _DisplayContactRemittanceState extends State<DisplayContactRemittance> {
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
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            TextButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Remittance",
                    style: themeData!.textTheme.titleMedium!.copyWith(color: Colors.white),
                  )
                ],
              ),
              onPressed: () {
                Get.back();
                enumServices.openContactsScreenOrigin = OpenContactsScreenOrigin.FROM_CHAT_PAGE;
                enumServices.userActionType = UserActionType.CREATE_NEW_GROUP_OR_PROJECT_CHAT;
                enumServices.chatTypes = ChatTypes.GROUP_CHAT;
                // changeScreen(context, DisplayContacts(actionType: "newChat", backgroundColor: white,));
                Get.to(
                  () => const DisplayContacts(
                    backgroundColor: Colors.white,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () async {
              // Navigator.of(context).pop();
              // showSearch<Member>(context: context, delegate: StartNewChat());
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _body(),
          )
        ],
      ),
    );
  }

  Widget _body() {
    if (_permissionDenied) return const Center(child: Text('Permission denied'));
    if (contactServices.localContact.isEmpty) return Center(child: LoadingListPage(count: 10));
    return ListView.builder(
      itemCount: contactServices.localContact.length,
      itemBuilder: (context, i) {
        return ListTile(
          title: listTitle(contactServices.localContact.elementAt(i)),
          subtitle: listSubtitle(contactServices.localContact.elementAt(i)),
          onTap: () {
            Get.to(
                  () => ConfirmContact(
                contact: contactServices.localContact.elementAt(i),
              ),
            );
          },
        );
      },
    );
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
}

class ConfirmContact extends StatelessWidget {
  final Contact contact;
  const ConfirmContact({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          contact.displayName,
          style: themeData!.textTheme.titleMedium!.copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: Get.width * 0.1,
                ),
                SizedBox(
                  height: Get.height * 0.80,
                  // flex: 9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 4,
                        child: Container(
                          // color: Colors.green,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: listTitle(contact),
                            subtitle: listSubtitle(contact),
                            trailing: contactServices.momoLogo(contact),
                          ),
                          // child: Center(
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         Text(
                          //           "${contact.displayName.capitalizeFirst} ",
                          //           maxLines: 1,
                          //           style: themeData!.textTheme.headline6,
                          //         ),
                          //         Text(contactServices.cleanNumber(contact.phones.first))
                          //       ],
                          //     )),
                        ),
                      ),
                      SizedBox(
                        height: Get.width * 0.1,
                      ),
                      SizedBox(
                        height: Get.height * 0.20,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                height: Get.height * 0.3,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),

                                // color: Colors.blueAccent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("SEND",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black45,
                                        )),
                                    // SizedBox(
                                    //   width: Get.width * 0.20,
                                    // ),
                                    Text(
                                      "${paymentsController.numCurrency(transactionService.transactionAmount.value)} ${chatServices.localMember!.get(memberModel.currencyCode)}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.0254,
                            ),
                            Expanded(
                              child: Container(
                                height: Get.height * 0.2,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "RECEIVE",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                        color: Colors.black45,
                                      ),
                                    ),
                                    Obx(
                                          () => Text(
                                        "${paymentsController.numCurrency(exchangeController.moweReceiveRate.value)} ${contactServices.getCurrencyType(contact)}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(
                            () => Text(
                          "Rate: 1: ${chatServices.localMember!.get(memberModel.currencyCode)} = "
                              "${paymentsController.numCurrency(exchangeController.moweExchangeRate.value)} ${contactServices.getCurrencyType(contact)}"
                              " with no fees",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DefaultButton(
                        text: "Send",
                        color: Colors.blue,
                        press: () {
                          // if (exchangeController.exchangeSuccess.value) {
                          //   paymentsController.checkUserPasscode(onTap: () {
                          //     enumServices.sameCurrencyType = SameCurrencyType.CURRENCY_EXCHANGE;
                          //     exchangeController.completeTransaction();
                          //   });
                          // } else {
                          //   showToastMessage(msg: "Sorry Something went wrong");
                          // }
                        },
                      ),
                      Expanded(
                        flex: 10,
                        child: Container(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listTitle(Contact contact) {
    return Text(
      contact.displayName,
      style: themeData!.textTheme.titleLarge,
    );
  }

  Widget listSubtitle(Contact contact) {
    return android_ios_number_display(contact.phones.first);
  }
}
