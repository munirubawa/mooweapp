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
                  () => DisplayContacts(
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
      body: _body(),
    );
  }

  Widget _body() {
    if (_permissionDenied) return const Center(child: Text('Permission denied'));
    if (_contacts == null) return Center(child: LoadingListPage(count: 10));
    return ListView.builder(
      itemCount: _contacts!.length,
      itemBuilder: (context, i) {
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
          onTap: () {
            FlutterContacts.getContact(_contacts![i].id, withPhoto: false).then((value) {
              Get.to(
                () => ConfirmContact(
                  contact: value!,
                ),
              );
            });
          },
        );
      },
    );
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
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          contact.displayName,
          style: themeData!.textTheme.titleMedium!.copyWith(color: Colors.white),
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
      body: Center(
        child: Center(
          child: ListView.builder(
            itemCount: contact.phones.length,
            itemBuilder: ((context, index) {
              return ListTile(
                title: Text(contact.phones[index].normalizedNumber.toString()),
                onTap: () {
                  String num = contact.phones[index].normalizedNumber.toString();
                  print(num.length);
                  String code = '';
                  print(code);
                  switch (num.length) {
                    case 12:
                      code = num.substring(0, 2);
                      break;
                    case 13:
                      code = num.substring(0, 4);
                      break;
                  }
                  if (code.isNotEmpty) {
                    for (var element in countryInformation.values) {
                      if (element[countryModelModel.dialingCode] == code) {
                        print(element);
                      }
                    }
                  }
                },
              );
            }), // itemBuilder
          ),
        ),
      ),
    );
  }
}
