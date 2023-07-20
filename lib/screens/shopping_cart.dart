// import 'package:mooweapp/export_files.dart';
//
// class ShoppingCartWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0.0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Get.back();
//           },
//         ),
//         title: const Center(
//           child: CustomText(
//             text: "Shopping Cart",
//             size: 24,
//             weight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Get.defaultDialog(
//                 barrierDismissible: false,
//                 title: "Empty Cart",
//                 content: const Text("Are you sure?"),
//                 confirm: SizedBox(
//                   height: permissionController.confirmButtonHeight + 10,
//                   width: permissionController.confirmButtonWidth,
//                   child: Row(
//                     children: [
//                       InkWell(
//                           onTap: () {
//                             Get.back();
//                           },
//                           child: const Padding(
//                             padding: EdgeInsets.all(12.0),
//                             child: Text("Cancel"),
//                           )),
//                       Expanded(child: Container()),
//                       InkWell(
//                           onTap: () {
//                             cartController.cart.clear();
//                             cartController.deleteItemAllCheckOutOrder();
//                             Get.back();
//                           },
//                           child: const Padding(
//                             padding: EdgeInsets.all(12.0),
//                             child: Text("Empty"),
//                           )),
//                     ],
//                   ),
//                 ),
//               );
//             },
//             icon: const Icon(
//               Icons.auto_delete_outlined,
//               color: Colors.black,
//             ),
//           )
//         ],
//       ),
//       body: Stack(
//         children: [
//           ListView(
//             children: [
//               const SizedBox(
//                 height: 10,
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               Obx(() => Column(
//                     children: cartController.cart.value
//                         .map(
//                           (cartItem) => Dismissible(
//                             background: Container(
//                               color: Colors.red,
//                               child: const Icon(
//                                 Icons.delete,
//                                 color: Colors.white,
//                                 size: 45,
//                               ),
//                             ),
//                             direction: DismissDirection.startToEnd,
//                             onDismissed: (direction) {},
//                             confirmDismiss: (derection) {
//                               return Get.defaultDialog(
//                                 barrierDismissible: false,
//                                 title: "Delete Item",
//                                 content: const Text("Are you sure, you want to delete"),
//                               confirm: SizedBox(
//                               height: permissionController.confirmButtonHeight +2,
//                               width: permissionController.confirmButtonWidth,
//                                 child:  Row(
//                                   children: [
//                                     InkWell(
//                                         onTap: () {
//                                           Get.back();
//                                         },
//                                         child: const Padding(
//                                           padding: EdgeInsets.all(12.0),
//                                           child: Text("Cancel"),
//                                         )),
//                                     Expanded(child: Container()),
//                                     InkWell(
//                                       onTap: () {
//                                         cartController.cart.removeWhere(
//                                               (element) => element.id == cartItem.id,
//                                         );
//                                         cartController.deleteItemCheckOutOrder(cartItem);
//                                         Get.back();
//                                       },
//                                       child: const Padding(
//                                         padding: EdgeInsets.all(12.0),
//                                         child: Text("Delete"),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                                 actions: [
//
//                                 ],
//                               );
//                             },
//                             // key: UniqueKey(),
//                             key: ValueKey(cartItem.id),
//                             child: CartItemWidget(
//                               cartItem: cartItem,
//                             ),
//                           ),
//                         )
//                         .toList(),
//                   )),
//             ],
//           ),
//           Positioned(
//             bottom: 30,
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               padding: const EdgeInsets.all(8),
//               child: Obx(
//                 () => CustomButton(
//                     text: "Check out (${paymentsController.numCurrency(cartController.totalCartPrice.value)} ${chatServices.localMember!.get(memberModel.currencyCode).toString()})",
//                     onTap: () async {
//                       addPaymentMethodController.initializePaymentMethod();
//                       if (kDebugMode) {
//                         print("paymentsController.hasePaymentMethod");
//                       }
//                       showModalBottomSheet(
//                         context: context,
//                         builder: (context) => Container(
//                           color: Colors.white,
//                           child: ShippingAddress(),
//                         ),
//                       );
//                       if (kDebugMode) {
//                         print(paymentsController.hasePaymentMethod);
//                       }
//                     }),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ShippingAddress extends StatelessWidget {
//   ShippingAddress({Key? key}) : super(key: key);
//   final AddressController addressController = Get.put(AddressController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Form(
//         child: Stack(children: [
//           ListView(
//             children: [
//               const SizedBox(
//                 height: 10,
//               ),
//               const Center(
//                 child: CustomText(
//                   text: "Shipping Address",
//                   size: 24,
//                   weight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: ListTile(
//                   leading: const Icon(FontAwesomeIcons.searchLocation),
//                   title: (addressController.predictions.isNotEmpty)
//                       ? Text(
//                           "Update Address",
//                           style: themeData!.textTheme.headline6,
//                         )
//                       : Text(
//                           "Add Address",
//                           style: themeData!.textTheme.headline6,
//                         ),
//                   onTap: () {
//                     addressController.selectedAddress = null;
//                     addressController.predictions.clear();
//                     // showModalBottomSheet(
//                     //   context: context,
//                     //   builder: (context) => Container(
//                     //     color: Colors.white,
//                     //     child: SearchAddress(),
//                     //   ),
//                     // );
//                   },
//                 ),
//               ),
//               Obx(
//                 () {
//                   return (addressController.isAddressSelected.value)
//                       ? Padding(
//                     padding: const EdgeInsets.only(left: 30.0, right: 30.0),
//                     child: SizedBox(
//                       height: Get.height * 0.5,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Ship To :"),
//                           Text(
//                             cartController.shippingAddress,
//                             style: themeData!.textTheme.headline6,
//                           ),
//                           (addressController.isAddressSelected.value)
//                               ? Padding(
//                             padding: const EdgeInsets.only(left: 30.0, right: 30.0),
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                     height: Get.height * 0.1,
//                                     child: Container()
//                                 ),
//                                 Table(
//                                   children: [
//                                     TableRow(children: [
//                                       Text(
//                                         "Item Price: ",
//                                         style: themeData!.textTheme.headline6,
//                                       ),
//                                       Text(
//                                         "${(paymentsController.numCurrency(cartController.totalCartPrice.value.ceilToDouble()))} ${chatServices.localMember!.get(memberModel.currencyCode)!}",
//                                         style: themeData!.textTheme.headline6,
//                                       ),
//                                     ]),
//                                     TableRow(children: [
//                                       Text(
//                                         "Shipment Fee: ",
//                                         style: themeData!.textTheme.headline6,
//                                       ),
//                                       Text(
//                                         "${paymentsController.numCurrency(shippingCost(cartController.totalCartPrice.value).ceilToDouble())} ${chatServices.localMember!.get(memberModel.currencySign)!}",
//                                         style: themeData!.textTheme.headline6,
//                                       ),
//                                     ]),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: 25,
//                                 ),
//                                 Table(
//                                   children: [
//                                     TableRow(children: [
//                                       Text(
//                                         "Subtotal: ",
//                                         style: themeData!.textTheme.headline6,
//                                       ),
//                                       Text(
//                                         "${chatServices.localMember!.get(memberModel.currencySign)!}${paymentsController.numCurrency((cartController.totalCartPrice.value + shippingCost(cartController.totalCartPrice.value)).ceilToDouble())}",
//                                         style: themeData!.textTheme.headline6,
//                                       ),
//                                     ]),
//                                   ],
//                                 )
//
//                               ],
//                             ),
//                           )
//                               : Container(),
//                           // Text(
//                           //   addressController.selectedAddress!.structuredFormatting!.secondaryText.toString(),
//                           //   style: themeData!.textTheme.headline6,
//                           // ),
//                           // Text(addressController.selectedAddress!.matchedSubstrings.forEach((element) { }).toString()),
//
//                           // Expanded(child: Text(addressController.selectedAddress!.description.toString()))
//                         ],
//                       ),
//                     ),
//                   )
//                       : SizedBox(
//                     height: Get.height * 0.5,
//                     child: Column(
//                       children: [
//                         formFiled(
//                           initialValue: addressController.address.value,
//                           textCapitalization: TextCapitalization.words,
//                           icon: const Icon(Icons.place, color: Colors.grey),
//                           labelText: "Shipping address",
//                           hintText: "Address",
//                           validateString: "Shipping address required",
//                           onChange: (value) async {
//                             print("$value");
//                             addressController.address.value = value!;
//                             // businessServices.business.value.address = value;
//                           },
//                         ),
//                         formFiled(
//                           initialValue: addressController.city.value,
//                           textCapitalization: TextCapitalization.words,
//                           icon: const Icon(Icons.location_city, color: Colors.grey),
//                           labelText: "City",
//                           hintText: "City",
//                           validateString: "City required",
//                           onChange: (value) async {
//                             print("$value");
//                             addressController.city.value = value!;
//                             // businessServices.business.value.city = value;
//                           },
//                         ),
//                         formFiled(
//                           initialValue: addressController.state.value,
//                           textCapitalization: TextCapitalization.words,
//                           icon: const Icon(Icons.location_city, color: Colors.grey),
//                           labelText: "State",
//                           hintText: "State",
//                           validateString: "State required",
//                           onChange: (value) async {
//                             print("$value");
//                             addressController.state.value = value!;
//                             // businessServices.business.value.state = value;
//                           },
//                         ),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: formFiled(
//                                 initialValue: businessServices.business.value.zip ?? "",
//                                 icon: const Icon(Icons.confirmation_number_outlined, color: Colors.grey),
//                                 labelText: "Zip Code",
//                                 hintText: "Zip Code",
//                                 keyboardType: TextInputType.number,
//                                 validateString: "State required",
//                                 onChange: (value) async {
//                                   print("$value");
//                                   addressController.zip.value = value ?? "";
//                                   // businessServices.business.value.zip = value ?? "";
//                                 },
//                               ),
//                             ),
//                             Expanded(
//                               child: Container(),
//                             ),
//                           ],
//                         ),
//
//                       ],
//                     ),
//                   );
//                 },
//               ),
//
//               Container(
//                   width: MediaQuery.of(context).size.width,
//                   padding: const EdgeInsets.all(8),
//                   child: Obx(
//                     () => CustomButton(
//                         bgColor: addressController.isAddressSelected.value ? kPrimaryColor : Colors.black,
//                         text:
//                             "${addressController.isAddressSelected.value ? 'Pay' : 'Next'} (${chatServices.localMember!.get(memberModel.currencySign)!}${paymentsController.numCurrency((cartController.totalCartPrice.value + shippingCost(cartController.totalCartPrice.value)).ceilToDouble())})",
//                         onTap: () async {
//                           if (cartController.addShippingAddress()) {
//                             cartController.shippingFee = paymentsController.numCurrency(shippingCost(cartController.totalCartPrice.value).ceilToDouble());
//                             if (paymentsController.hasePaymentMethod) {
//                               transactionService.transactionAmount.value = (cartController.totalCartPrice.value + shippingCost(cartController.totalCartPrice.value)).ceilToDouble();
//                               // transactionService.processTransact();
//                               // transactionService.runTransaction();
//                               if(cartController.processCheckOutProcess){
//                                 cartController.processCheckOutProcess = false;
//                                 paymentsController.checkUserPasscode(onTap: () {
//                                   enumServices.transactionActionType = TransactionActionType.CHECK_OUT_PAYMENT;
//                                   transactionService.processTransact();
//                                 });
//                               } else {
//                                 cartController.processCheckOutProcess = true;
//                               }
//
//                             } else {
//                               addPaymentMethodController.addPaymentMethod();
//
//                             }
//                           }
//                           // else {
//                           //   Get.defaultDialog(
//                           //       content: Container(
//                           //         child: Center(
//                           //           child: Text(
//                           //             "Please add shipping address",
//                           //             style: themeData!.textTheme.headline6!,
//                           //           ),
//                           //         ),
//                           //       ));
//                           // }
//                         }),
//                   )),
//             ],
//           )
//         ]),
//       ),
//     );
//   }
//
//   int shippingCost(double amount) {
//     if (amount > 0 && amount <= 50) {
//       return 10;
//     } else if (amount > 50 && amount <= 80) {
//       return 12;
//     } else if (amount > 80 && amount <= 125) {
//       return 14;
//     } else if (amount > 125 && amount <= 150) {
//       return 16;
//     } else if (amount > 150 && amount <= 300) {
//       return 18;
//     } else if (amount > 300) {
//       return 20;
//     } else {
//       return 20;
//     }
//   }
// }
