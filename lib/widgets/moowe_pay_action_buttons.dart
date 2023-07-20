import 'package:mooweapp/export_files.dart';

class MoowePayActionButton extends StatelessWidget {
  const MoowePayActionButton({Key? key}) : super(key: key);
  final int timeInSecForIosWeb = 1;
  @override
  Widget build(BuildContext context) {
    runSystemOverlay();
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CustomBtn2(
                  onTap: () async {
                    if (permissionController.cameraPermissionGranted.value) {
                      Get.back();
                      enumServices.cameraScanLocation = CameraScanLocation.CAMERA_FROM_WALLET;

                      Get.to(() => const QRViewExample());
                      //   if (transactionService.transactionAmount > 0 ) {
                      //   } else {
                      //     Get.back();
                      //     showToastMessage(msg: "Type an amount", backgroundColor: Colors.green, timeInSecForIosWeb: timeInSecForIosWeb);
                      // }
                    } else {
                      permissionController.getCameraPermission();
                    }
                  },
                  bgColor: kPrimaryColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.qr_code_scanner,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Scan",
                        style: themeData!.textTheme.headline6!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CustomBtn(
                  text: "Add Cash",
                  onTap: () async {
                    enumServices.transactionActionType = TransactionActionType.CASH_IN_FROM_BANK;
                    paymentsController.checkPaymentMethod();
                    if (await Permission.contacts.status.isGranted) {
                      if (transactionService.transactionAmount > 0) {
                        Get.back();
                        addPaymentMethodController.initializePaymentMethod();
                        // print("after initializing payment method  ${transactionService.transactionAmount}");
                        // print(dbHelper.paymentMethodPath());
                        if (paymentsController.hasePaymentMethod && userPaymentMethod.defaultPaymentMethodId != "") {
                          paymentsController.checkUserPasscode(onTap: () async {
                            paymentsController.payWithExistingPaymentMethod(
                              amount: (transactionService.transactionAmount).toInt().truncate().toString(),
                              currency: chatServices.localMember!.get(memberModel.currencyCode)!,
                            );
                          });
                        } else {
                          addPaymentMethodController.addPaymentMethod();
                        }
                      } else {
                        showToastMessage(msg: "Type an amount", backgroundColor: Colors.green, timeInSecForIosWeb: timeInSecForIosWeb);
                      }
                    } else {
                      await Permission.contacts.request();
                    }
                    runSystemOverlay();
                  },
                  bgColor: kPrimaryColor,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CustomBtn2(
                  onTap: () async {


                    Get.back();
                    transactionService.userBalance().then((value) async {
                      if(transactionService.accountBalance.value < transactionService.transactionAmount.value){
                        await Vibration.hasVibrator().then((value){
                          Vibration.vibrate();
                        });
                      } else {
                        enumServices.userActionType = UserActionType.SEND_CASH_TO_MOMO;
                        Get.to(() =>  const DisplayContacts());
                      }
                    });

                    // Get.to(() =>  DisplayContactRemittance());
                  },
                  bgColor: kPrimaryColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Remit",
                        style: themeData!.textTheme.headline6!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CustomBtn(
                  text: "Cash Out",
                  onTap: () {
                    Get.back();
                    if (transactionService.transactionAmount.value > 0 && transactionService.transactionAmount.value <= transactionService.accountBalance.value) {
                      enumServices.transactionType = TransactionType.CASH_OUT;
                      enumServices.cashOutFrom = CashOutFrom.WALLET_CASH_OUT;

                      Get.to(() => const CashOutScreen());
                    } else {
                      showToastMessage(msg: "Type an amount", backgroundColor: Colors.green, timeInSecForIosWeb: 2);
                    }
                  },
                  bgColor: kPrimaryColor,
                ),
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //
          //
          //     Padding(
          //       padding: const EdgeInsets.all(15.0),
          //       child: CustomBtn(
          //         text: "Pay a Bill",
          //         onTap: () async {
          //           Get.back();
          //           enumServices.businessServiceAction = BusinessServiceAction.PAY_A_BILL;
          //           enumServices.payBillActionLocation = PayBillActionLocation.PAY_A_BILL_FROM_WALLET;
          //
          //           Get.to(() => DisplayBusinessContacts(), binding: BusinessBinding());
          //         },
          //         bgColor: kPrimaryColor,
          //       ),
          //     ),
          //     // Padding(
          //     //   padding: const EdgeInsets.all(15.0),
          //     //   child: CustomBtn(
          //     //     text: "Add Cash",
          //     //     onTap: () async {
          //     //       enumServices.transactionActionType = TransactionActionType.CASH_IN_FROM_BANK;
          //     //       paymentsController.checkPaymentMethod();
          //     //       if (await Permission.contacts.status.isGranted) {
          //     //         if (transactionService.transactionAmount > 0) {
          //     //           Get.back();
          //     //           addPaymentMethodController.initializePaymentMethod();
          //     //           // print("after initializing payment method  ${transactionService.transactionAmount}");
          //     //           // print(dbHelper.paymentMethodPath());
          //     //           if (paymentsController.hasePaymentMethod && userPaymentMethod.defaultPaymentMethodId != "") {
          //     //             paymentsController.checkUserPasscode(onTap: () async {
          //     //               paymentsController.payWithExistingPaymentMethod(
          //     //                 amount: (transactionService.transactionAmount).toInt().truncate().toString(),
          //     //                 currency: chatServices.localMember!.get(memberModel.currencyCode)!,
          //     //               );
          //     //             });
          //     //           } else {
          //     //             addPaymentMethodController.addPaymentMethod();
          //     //           }
          //     //         } else {
          //     //           showToastMessage(msg: "Type an amount", backgroundColor: Colors.green, timeInSecForIosWeb: timeInSecForIosWeb);
          //     //         }
          //     //       } else {
          //     //         await Permission.contacts.request();
          //     //       }
          //     //       runSystemOverlay();
          //     //     },
          //     //     bgColor: kPrimaryColor,
          //     //   ),
          //     // ),
          //   ],
          // ),

          // const Padding(
          //   padding: EdgeInsets.all(15.0),
          //   child: BusinessAccountName(),
          // ),
        ],
      ),
    );
  }
}

requestNote(BuildContext context) {
  // print("pushNavigator");
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text("Note (Optional)"),
      contentPadding: const EdgeInsets.all(0.0),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      content: SizedBox(
        height: Get.height * 0.15,
        child: Column(
          // overflow: Overflow.visible,
          children: <Widget>[
            RoundedInputField(
              key: UniqueKey(),
              data: "",
              textInputType: TextInputType.text,
              hintText: "Request Note",
              onChanged: (value) {
                transactionService.requestNote = value;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          key: UniqueKey(),
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          key: UniqueKey(),
          child: const Text("Send Request"),
          onPressed: () {
            switch (enumServices.transactionType!) {
              case TransactionType.REQUEST_PAYMENT:
                // TODO: Handle this case.
                Navigator.of(context).pop();

                enumServices.transactionActionType = TransactionActionType.REQUEST_PAYMENT;
                enumServices.userActionType = UserActionType.REQUEST_PAYMENT;
                Get.to(() => DisplayContacts(backgroundColor: kPrimaryColor));
                break;
              case TransactionType.REQUEST_PAID:
                // TODO: Handle this case.
                break;
              case TransactionType.BILL_PAY:
                // TODO: Handle this case.
                break;
              case TransactionType.CASH_OUT:
                // TODO: Handle this case.
                break;
              case TransactionType.EXPENSE:
                // TODO: Handle this case.
                break;
              case TransactionType.INCOME:
                // TODO: Handle this case.
                break;
              case TransactionType.CONTRIBUTION:
                // TODO: Handle this case.
                break;
              case TransactionType.FUNDING:
                // TODO: Handle this case.
                break;
              case TransactionType.DECLINE_PAYMENT_REQUEST:
                // TODO: Handle this case.
                break;
            }
          },
        ),
      ],
    ),
  ).then((value) => (value) {
        print("exit value $value");
      });
}

// class BusinessAccountName extends StatelessWidget {
//   const BusinessAccountName({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<UserBusiness>>(
//       key: UniqueKey(),
//       stream: FirebaseFirestore.instance
//           .collection(chatServices.businessAccounts)
//           .orderBy("time", descending: true)
//           .snapshots()
//           .map((event) => event.docs.map((e) => UserBusiness.fromSnap(e)).toList()),
//       builder: (context, AsyncSnapshot<List<UserBusiness>> snapshot) {
//         Widget children;
//
//         if (snapshot.hasData) {
//           print(snapshot.data!.length);
//           children = ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (BuildContext context, int index) {
//
//               return StreamBuilder<Business>(
//                 stream: FirebaseFirestore.instance.doc(snapshot.data![index].businessAccountPath).snapshots().map((event) => Business.fromSnap(event)),
//                 builder: (context, AsyncSnapshot<Business> busSnapshot) {
//                   if (busSnapshot.connectionState == ConnectionState.waiting) {
//                     return Container();
//                   }
//                   if (busSnapshot.data == null) {
//                     return Container();
//                   } else {
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: CustomBtn(
//                         text: "${busSnapshot.data!.businessName}",
//                         onTap: () async {
//                         switch(busSnapshot.data!.userBusinessType!) {
//
//                           case UserBusinessType.MERCHANT_STORE:
//                             // TODO: Handle this case.
//                             Navigator.of(context).pop();
//
//                             Get.to(()=> StoreHomeScreen());
//                             break;
//                           case UserBusinessType.ACCEPT_PAYMENT_SERVICE:
//                             Get.back();
//                             // Get.to(()=> const BusinessAccountScreen(), binding: BusinessAcceptPaymentBinding());
//                             break;
//                         }
//
//                         },
//                         bgColor: kPrimaryColor,
//                       ),
//                     );
//                   }
//                 },
//               );
//             },
//             shrinkWrap: true,
//           );
//         } else if (snapshot.hasError) {
//           children = Padding(
//             padding: const EdgeInsets.only(top: 16),
//             child: Text('Error: ${snapshot.error}'),
//           );
//         } else {
//           children = Container();
//         }
//         return children;
//       },
//     );
//   }
// }
