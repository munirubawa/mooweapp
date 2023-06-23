import 'package:contacts_service/contacts_service.dart';
import 'package:mooweapp/export_files.dart';

class ContactServices extends GetxController {
  static ContactServices instance = Get.find();

  DocumentSnapshot? newChatreciever;
  var contactsFiltered = <Contact>{};
  RxSet<Contact> contacts = RxSet<Contact>();
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
    super.onInit();
  }

  // void listenToContacts() {
  //   // FlutterContacts.addListener(() => getAllContacts());
  // }

  // fireStoreSearch(Contact number) {
  //   for (var num in number.phones) {
  //     // debugPrint(num.normalizedNumber);
  //     // debugPrint(num.number.replaceAll(RegExp('[^A-Za-z0-9+]'), ''));
  //     String numPhone = num.number.replaceAll(RegExp('[^0-9+]'), '');
  //     if (numPhone.toString().length > 10) {
  //       FirebaseFirestore.instance.collection(dbHelper.users()).where("phone", isEqualTo: numPhone).snapshots().listen((QuerySnapshot snapshot) {
  //         if (snapshot.docs.isNotEmpty) {
  //           for (var docSnap in snapshot.docs) {
  //             DocumentSnapshot member = docSnap;
  //             if (auth.currentUser!.uid != docSnap.get(memberModel.userUID)) {
  //               bool containsItem = mooweContacts.any((mem) => mem.get(memberModel.userUID) == member.get(memberModel.userUID));
  //               if (!containsItem) {
  //                 mooweContacts.add(member);
  //               }
  //             }
  //           }
  //         }
  //       });
  //     }
  //   }
  // }



  runContactServices() {
    switch (enumServices.userActionType) {
      case UserActionType.CREATE_NEW_CHAT:
        remoteMember = selectedContact!;
        // Get.to(() => SelectChatType());
        break;
      case UserActionType.SEND_CASH_DIRECT_FROM_MOOWE_PAY:
        Get.back();
        transactionService.directTransMember = selectedContact!;
        transactionService.context = context;
        transactionService.runTransaction();

        break;
      case UserActionType.CREATE_CONTRACT:
        Get.back();
        Get.to(() => CreateContractScreen(
              chatRoom: chatRoom,
            ));
        break;
      case UserActionType.SEND_CASH_IN_PRIVATE_CHAT:
      case UserActionType.SEND_CASH_IN_GROUP_CHAT:
      case UserActionType.SEND_CASH_PROJECT_CHAT:
      case UserActionType.SEND_CASH_TO_MOMO:
      case UserActionType.SEND_CASH_TO_BANK_ACCOUNT:
      case UserActionType.CASH_OUT_TO_BANK_ACCOUNT:
      case UserActionType.ADD_NEW_MEMBER_TO_GROUP_OR_PROJECT:
        Get.back();
        newChatreciever = selectedContact!;

        enumServices.chatServicesActions = ChatServicesActions.ADD_MEMBER_TO_PROJECT_OR_GROUP;
        chatServices.chatRoom = chatRoom;
        chatServices.member = selectedContact;
        chatServices.runChatServices();
        break;
      case UserActionType.PAY_INTO_CONTRACT:
        // TODO: Handle this case.
        break;
      case UserActionType.PROCESS_CONTRACT:
        // TODO: Handle this case.
        break;

      default:
        // getAllContacts();
        break;
    }
  }

  // Future<String> getAllContacts() async {
  //   print("getAllContacts");
  //   PermissionStatus status = await Permission.contacts.status;
  //   switch (status) {
  //     case PermissionStatus.denied:
  //       contactsPermissionGranted = false;
  //       break;
  //     case PermissionStatus.granted:
  //       contactsPermissionGranted = true;
  //       contacts.clear();
  //       await FlutterContacts.getContacts(withProperties: true, withPhoto: true, withThumbnail: true).then((conts) {
  //         for (var cont in conts) {
  //           if (cont.displayName.isNotEmpty && cont.phones.toList().isNotEmpty) {
  //             if (cont.phones.toList().first.number.length > 10) {
  //               if (!contacts.contains(cont)) {
  //                 contacts.add(cont);
  //                 fireStoreSearch(cont);
  //               }
  //             }
  //           }
  //         }
  //       });
  //       break;
  //     case PermissionStatus.restricted:
  //       contactsPermissionGranted = false;
  //       break;
  //     case PermissionStatus.limited:
  //       contactsPermissionGranted = false;
  //       break;
  //     case PermissionStatus.permanentlyDenied:
  //       contactsPermissionGranted = false;
  //       break;
  //   }
  //   return Future.value("string");
  // }
}
