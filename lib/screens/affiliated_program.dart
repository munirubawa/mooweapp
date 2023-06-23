// import 'package:mooweapp/export_files.dart';
//
// // import 'package:mooweapp/size_config.dart';
// class AffiliatedProgram extends StatelessWidget {
//   const AffiliatedProgram({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // newChatAction = actionType;
//     TextStyle textStyle = themeData!.textTheme.headline6!.copyWith(color: Colors.black);
//     var f = NumberFormat(
//       "#,##0.00",
//       "en_US",
//     );
//
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: <Widget>[
//           SliverAppBar(
//             iconTheme: const IconThemeData(
//               color: Colors.black, //change your color here
//             ),
//             backgroundColor: Colors.white,
//             pinned: false,
//             snap: true,
//             floating: true,
//             expandedHeight: Get.height * 0.33,
//             title: Text('Affiliate', style: textStyle),
//             actions: [
//               // ElevatedButton(onPressed: (){}, child: Text("Affiliats"))
//               chatServices.localMember!.get(memberModel.affiliateActive)
//                   ? IconButton(
//                       onPressed: () {
//                         showBarModalBottomSheet(
//                           context: context,
//                           builder: (context) => Container(
//                             color: Colors.white,
//                             child: const AffiliateQRCode(),
//                           ),
//                         );
//                       },
//                       icon: const Icon(Icons.qr_code_scanner))
//                   : Container(),
//               IconButton(
//                   onPressed: () {
//                     Get.to(() => AffiliateMember());
//                   },
//                   icon: const Icon(Icons.person)),
//               chatServices.localMember!.get(memberModel.affiliateActive)
//                   ? IconButton(
//                       onPressed: () {
//                         Share.share(
//                           "I want to share this app with you, it's a chat platform with \n 1) peer-to-peer payment \n 2) cross border remittance \n 3) group chat with group wallet for group "
//                           "contributions, \n "
//                           "4) market place to buy and sell anything "
//                           "and "
//                           "5) affiliate program that can make you "
//                           "hundreds of dollars a month, while using it, check it out.\n Click on the link and enter your "
//                           "phone number, you get a pin, enter that pin and download they app, it's a great app. https://mowe.app/?ap=${chatServices.localMember!.get(memberModel.affiliateId)} \n",
//                         );
//                       },
//                       icon: const Icon(Icons.share))
//                   : Container(),
//             ],
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text(
//                 "${chatServices.localMember!.get(memberModel.currencySign)}${paymentsController.numCurrency((300 * contactServices.contacts.length).truncate().toDouble())}",
//                 style: textStyle.copyWith(fontSize: Get.height * .050, color: Colors.black),
//               ),
//               // background: FlutterLogo(),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: SizedBox(
//               height: Get.height * 0.10,
//               child: Column(
//                 children: [
//                   const Expanded(
//                       child: Center(
//                     child: Text('Two year potential earnings'),
//                   )),
//                   Expanded(
//                       child: Padding(
//                     padding: const EdgeInsets.only(right: 30.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [Text('${contactServices.contacts.length} contacts')],
//                     ),
//                   )),
//                 ],
//               ),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (BuildContext context, int index) {
//                 Contact contact = contactServices.contacts.elementAt(index);
//                 final intValue = contact.phones.first.number.isNotEmpty ? int.parse(contact.phones.first.number.replaceAll(RegExp('[^0-9]'), '')) : "";
//                 return Container(
//                   color: index.isOdd ? Colors.white : Colors.black12,
//                   height: 100.0,
//                   child: Center(
//                     child: ContactValuation(contact: contact, intValue: intValue, press: () {}),
//                   ),
//                 );
//               },
//               childCount: contactServices.contacts.length,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
