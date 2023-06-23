// import 'package:mooweapp/export_files.dart';
// class BusinessContactServices {
//   Map<String, dynamic>? newChatreciever;
//   var contactsFiltered = <Business>{};
//   var contacts = <Business>{};
//   var queryResultSet = {};
//   var tempSearchStore = <Business>{};
//   // Map<String, dynamic> mooweContacts = {};
//   var mooweBusinesses = <Business>{};
//   var mooweBusinessesFiltered = <Business>{};
//   var mooweTempSearchStore = <Business>{};
//   var mooweQueryResultSet = <Business>{};
//
//   late String _uid;
//   BuildContext? context;
//   late var intValue;
//   Contact? contact;
//   Business? selectedBusiness;
//   Chat? newChat;
//   ChatRoom? chatRoom;
//   // Contract? contract;
//   bool fromDisplayContact = true;
//   List<BuildContext> contextToPop = [];
//   fireStoreSearch(Contact number) {
//     FirebaseFirestore.instance
//         .collection('businesses').where("city", isEqualTo: Placemark.fromMap(chatServices.localUser!.get(localUserModel.address)).locality)
//         .snapshots()
//         .listen((contacs) {
//       if (contacs.docs.isNotEmpty) {
//         for (var docSnap in contacs.docs) {
//           if (docSnap.exists) {
//             Business member = Business.fromMap(docSnap.data());
//             if(!mooweBusinesses.contains(member)) {
//               mooweBusinesses.add(member);
//             }
//           }
//         }
//       }
//     });
//
//   }
//
//
//   Future<String> getAllBusinesses() async {
//     if (kDebugMode) {
//       print("getAllBusinesses");
//     }
// // print(chatServices.localUser!.member!.toMap());
//     FirebaseFirestore.instance
//         .collection('businesses').where("locality", isEqualTo: chatServices.localUser!.get(localUserModel.address).locality).get().then((contacs) {
//       if (contacs.docs.isNotEmpty) {
//         for (var docSnap in contacs.docs) {
//           if (docSnap.exists) {
//             Business member = Business.fromMap(docSnap.data());
//             if (kDebugMode) {
//               print(member.toMap());
//             }
//             if(!mooweBusinesses.contains(member)) {
//               mooweBusinesses.add(member);
//             }
//           }
//         }
//       }
//     });
//
//
//     return Future.value("string");
//   }
//
//   bool streetUpdate = false;
//   String street = "";
//   bool postalCodeUpdate = false;
//   String postalCode = "";
//   bool administrativeAreaUpdate = false;
//   String administrativeArea = "";
//   bool localityUpdate = false;
//   String locality = "";
//
//   requiredUserAddress(BuildContext context, Business business) {
//     final _formKey = GlobalKey<FormBuilderState>();
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: Column(
//           children: [
//             Text("${business.businessName}", style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: Get.width * 0.13
//             ),),
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text("Customer address"),
//             ),
//           ],
//         ),
//         contentPadding: const EdgeInsets.all(0.0),
//         actionsAlignment: MainAxisAlignment.spaceBetween,
//         content: SingleChildScrollView(
//           child: SizedBox(
//             height: Get.width * 0.3,
//             child: FormBuilder(
//               key: _formKey,
//               child: Column(
//                 // overflow: Overflow.visible,
//                 children: <Widget>[
//                   RoundedInputField(
//                     key: UniqueKey(),
//                     data: chatServices.localUser!.get(localUserModel.address)[addressModel.street],
//                     textInputType: TextInputType.text,
//                     hintText: "Address",
//                     onChanged: (value) {
//                       street = value;
//                       streetUpdate = true;
//
//                     },
//                   ),
//                   RoundedInputField(
//                     key: UniqueKey(),
//                     data: chatServices.localUser!.get(localUserModel.address)[addressModel.locality],
//                     textInputType: TextInputType.text,
//                     hintText: "City",
//                     onChanged: (value) {
//                       locality = value;
//                       localityUpdate = true;
//
//                     },
//                   ),
//                   RoundedInputField(
//                     key: UniqueKey(),
//                     data: chatServices.localUser!.get(localUserModel.address)[addressModel.administrativeArea],
//                     textInputType: TextInputType.text,
//                     hintText: "State",
//                     onChanged: (value) {
//                       administrativeArea = value;
//                       administrativeAreaUpdate = true;
//
//                     },
//                   ),
//                   RoundedInputField(
//                     key: UniqueKey(),
//                     data: chatServices.localUser!.get(localUserModel.address)[addressModel.postalCode],
//                     textInputType: TextInputType.number,
//                     hintText: "Zip code",
//                     onChanged: (value) {
//                       postalCode = value;
//                       postalCodeUpdate = true;
//
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//
//         actions: [
//           TextButton(
//             key: UniqueKey(),
//             child: const Text("Cancel"),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           TextButton(
//             key: UniqueKey(),
//             child: const Text("Send Payment"),
//             onPressed: () {
//               businessServices.context = context;
//
//
//               switch (enumServices.businessServiceAction!) {
//
//                 case BusinessServiceAction.CREATE_NEW_BUSINESS_ACCOUNT:
//                 // TODO: Handle this case.
//                   break;
//                 case BusinessServiceAction.
//                 PAY_A_BILL:
//                 // TODO: Handle this case.
//                   Placemark placemark = Placemark(
//                     name: chatServices.localUser!.get(localUserModel.address)[addressModel.name],
//                     street: streetUpdate? street: chatServices.localUser!.get(localUserModel.address)[addressModel.street],
//                     isoCountryCode: chatServices.localUser!.get(localUserModel.address)[addressModel.isoCountryCode],
//                     country: chatServices.localUser!.get(localUserModel.address)[addressModel.country],
//                     postalCode: postalCodeUpdate? postalCode : chatServices.localUser!.get(localUserModel.address)[addressModel.postalCode],
//                     administrativeArea: administrativeAreaUpdate? administrativeArea:  chatServices.localUser!.get(localUserModel.address)[addressModel.administrativeArea],
//                     subAdministrativeArea: chatServices.localUser!.get(localUserModel.address)[addressModel.subAdministrativeArea],
//                     locality: localityUpdate? locality : chatServices.localUser!.get(localUserModel.address)[addressModel.locality],
//                     subLocality: chatServices.localUser!.get(localUserModel.address)[addressModel.subLocality],
//                     thoroughfare: chatServices.localUser!.get(localUserModel.address)[addressModel.thoroughfare],
//                     subThoroughfare: chatServices.localUser!.get(localUserModel.address)[addressModel.subThoroughfare],
//                   );
//                   _formKey.currentState?.save();
//                   if (_formKey.currentState!.validate()) {
//                     businessServices.customerAddress = placemark;
//                     chatServices.localUser!.reference.update({
//                       "address": placemark.toJson()
//                     });
//                     Navigator.of(context).pop();
//                     businessServices.runBusinessServices();
//                   } else {
//                     print("validation failed");
//                   }
//
//                   break;
//               }
//             },
//           ),
//         ],
//       ),
//     ).then((value) => (value) {
//       print("exit value $value");
//     });
//   }
//
// }
