import 'package:mooweapp/export_files.dart';
// class ContactValuation extends StatelessWidget {
//   Function()? press;
//   Contact contact;
//   final intValue;
//   ContactValuation({Key? key, this.press, required this.contact, this.intValue}) : super(key: key);
//   // var con_serv = locator.get<ContactServices>();
//   // var service = locator.get<FirestoreService>();
//
//   @override
//   Widget build(BuildContext context) {
//     // double imageSize = 3.4;
//     return ListTile(
//       onTap: () {
//         String phone = contact.phones.first.number.toString();
//         // CallsAndMessagesService().sendSms(int.parse(phone.replaceAll(RegExp(r'[^\w\s]+'), '')));
//       },
//       leading: contact.photo != null
//           ? CircleAvatar(
//               radius: imageRadius,
//               backgroundImage: MemoryImage(contact.photo!),
//             )
//           : CircleAvatar(
//               radius: imageRadius,
//               child: Text(contact.displayName.substring(0, 1).toString()),
//             ),
//       title: Text(contact.displayName.toString()),
//       subtitle: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10),
//         child: contact.phones.first.number.isNotEmpty ? Text(contact.phones.first.number) : Container(),
//       ),
//       trailing: Wrap(
//         children: [
//
//           Column(
//             children: [
//               Text(
//                 "${chatServices.localMember!.get(memberModel.currencySign)}100 - ${chatServices.localMember!.get(memberModel.currencySign)}300 ",
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 15.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const Text(
//                 " 2yrs +/-",
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 15.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               )
//             ],
//           ),
//
//         ],
//       ),
//     );
//   }
// }
