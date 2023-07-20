// import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:mooweapp/export_files.dart';

class ContactServices extends GetxController {
  static ContactServices instance = Get.find();

  DocumentSnapshot? newChatreciever;
  var contactsFiltered = <Contact>{};
  RxSet<Contact> _lcontacts = RxSet<Contact>();
  var queryResultSet = {};
  var tempSearchStore = <Contact>{};
  // Map<String, dynamic> mooweContacts = {};
  RxSet<DocumentSnapshot> mooweContacts = RxSet<DocumentSnapshot>();
  RxSet<DocumentSnapshot> mooweContactsFiltered = RxSet<DocumentSnapshot>();
  RxSet<DocumentSnapshot> mooweTempSearchStore = RxSet<DocumentSnapshot>();
  RxSet<DocumentSnapshot> mooweQueryResultSet = RxSet<DocumentSnapshot>();

  late String _uid;
  BuildContext? context;
  late var intValue;
  Contact? contact;
  DocumentSnapshot? selectedContact;
  Chat? newChat;
  ChatRoom? chatRoom;
  // Contract? contract;
  bool fromDisplayContact = true;
  bool contactsPermissionGranted = false;

  // List<BuildContext> contextToPop = [];

  @override
  void onInit() {
    // checkPermission();
    // _fetchContacts();
    // FlutterContacts.addListener((){
    //   contactServices.localContact.clear();
    //   contactServices.fetchContacts("contacService init");
    // });
    print(ghanaCodes());
    super.onInit();
  }

  List<Contact> contacts = [];
  final Set<Contact> localContact = {};
  final Set<Contact> localContactFound ={};
  final Set<Contact> selectedContacts = {};
  final Set<Contact> momoSelectedContacts = {};
  List<QueryDocumentSnapshot> snapshots = [];
  bool permissionDenied = false;

  String cleanNumber(Phone phone) {
    return Platform.isIOS ? phone.number.toString().replaceAll(RegExp('[^+0-9]'), '') : phone.normalizedNumber.toString().replaceAll(RegExp('[^+0-9]'), '');
  }

  Future fetchContacts(String callingFrom) async {
    if (contactServices.localContact.isEmpty) {
      print("callingFrom $callingFrom");
      print("runing local contacts");

      if (!await FlutterContacts.requestPermission(readonly: true)) {
        permissionDenied = true;
      } else {
        final contacts = await FlutterContacts.getContacts();

        contactServices.contacts = contacts.cast<Contact>();
        firebaseUsers();
      }
    } else {}
  }

  void firebaseUsers() {

    for (var element in contactServices.contacts) {
      FlutterContacts.getContact(element.id).then((Contact? contact) {
        if (contact?.phones != null && contact!.phones.isNotEmpty && cleanNumber(contact.phones.first).length > 10) {
          momoPassThrough(contact);
          for (var phone in contact.phones) {
            final newContact = Contact()
              ..name.first = contact.name.first
              ..name.last = contact.name.last
              ..displayName = contact.displayName
              ..phones = [Phone(cleanNumber(phone))];

            // print(Platform.isIOS ? phone.number.toString().replaceAll(RegExp('[^+0-9]'), '') : phone.normalizedNumber);
            if (chatServices.localMember!.get("phone") != cleanNumber(phone)) {
              contactServices.localContact.add(newContact);

              FirebaseFirestore.instance.collection(dbHelper.users()).where("phone", isEqualTo: cleanNumber(phone)).get().then((QuerySnapshot? value) {
                if (value!.docs.isNotEmpty) {
                  contactServices.localContactFound.add(newContact);
                  contactServices.snapshots.add(value.docs.first);
                }
              });
            }
          }
        }
      });
    }
  }

  void momoPassThrough(Contact contact) {
    ghanaCodes().forEach((element) {
      if (cleanNumber(contact.phones.first).contains(element)) {
        for (var phone in contact.phones) {
          final newContact = Contact()
            ..name.first = contact.name.first
            ..name.last = contact.name.last
            ..displayName = contact.displayName
            ..phones = [Phone(cleanNumber(phone))];
          momoSelectedContacts.add(newContact);
        }
      }
    });
  }

  Widget momoLogo(Contact contact) {
    return logoName(contact) == ""
        ? SizedBox(
            height: 30,
            width: 30,
            child: Container(),
          )
        : Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(logoName(contact)), fit: BoxFit.contain),
              color: Colors.white,
              shape: BoxShape.rectangle,
            ),
          );
    // ): CircleAvatar(radius: imageRadius, backgroundImage: AssetImage(logoName(contact)));
  }

  String logoName(Contact contact) {
    String logo = "";
    cleanList(ghanaGlobacom).forEach((code) {
      if (cleanNumber(contact.phones.first).contains(code)) {
        logo = "assets/momo/glo.png";
      }
    });
    cleanList(ghanaMtn).forEach((code) {
      if (cleanNumber(contact.phones.first).contains(code)) {
        logo = "assets/momo/mtn.png";
      }
    });
    cleanList(ghanaAirtelTigo).forEach((code) {
      if (cleanNumber(contact.phones.first).contains(code)) {
        logo = "assets/momo/tigo.png";
      }
    });
    cleanList(ghanaExpresso).forEach((code) {
      if (cleanNumber(contact.phones.first).contains(code)) {
        logo = "assets/momo/espress.png";
      }
    });
    cleanList(ghanaVodafone).forEach((code) {
      if (cleanNumber(contact.phones.first).contains(code)) {
        logo = "assets/momo/vodafone.jpeg";
      }
    });
    return logo;
  }

  String getCurrencyType(Contact contact){
    String cur = "";
    ghanaCodes().forEach((element) {
      if(cleanNumber(contact.phones.first).contains(element)){
        cur = "GHS";
      }
    });
    return cur;
  }




  List<String> ghanaCodes() {
    return cleanList(ghanaGlobacom) + cleanList(ghanaMtn) + cleanList(ghanaAirtelTigo) + cleanList(ghanaExpresso) + cleanList(ghanaVodafone);
  }

  List<String> cleanList(List<String> list) {
    return list.map((e) => "+233${e.substring(1)}").toList();
  }

  List<String> ghanaGlobacom = [
    "023",
  ];
  List<String> ghanaMtn = [
    "024",
    "024",
    "025",
    "053",
    "054",
    "055",
    "059",
  ];
  List<String> ghanaAirtelTigo = [
    "027",
    "057",
    "026",
    "056",
  ];
  List<String> ghanaExpresso = [
    "028",
  ];
  List<String> ghanaVodafone = [
    "020",
    "050",
  ];
}
