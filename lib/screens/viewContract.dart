import 'package:mooweapp/export_files.dart';

class ViewContract extends StatelessWidget {
  // Contract? view_contract;
  ViewContract({
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    int maxLines = 22;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text(
          "Safe Contract",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          PopupMenuButton<ChatSettingOptions>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: (ChatSettingOptions result) {},
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<ChatSettingOptions>>[
                PopupMenuItem<ChatSettingOptions>(
                  value: ChatSettingOptions.SETTING,
                  child: TextButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Dispute",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                    onPressed: () {
                      // paymentsController.getPlaidLinkToken();
                      // Navigator.pop(context);
                      Get.back();
                      contractController.disputeContract();
                      // Get.to(() => const SettingScreen());
                    },
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 33, horizontal: 20),
          child: Obx(() => Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const Text("Status: "),
                        Text(
                            "${contractController.contractData[conModel.status]}"),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text.rich(
                        TextSpan(
                          text: contractController.contractData[
                              conModel.thisContract], // default text style
                          children: [
                            TextSpan(
                              text: contractController
                                      .contractData[conModel.creator]
                                  [conModel.firstName],
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: contractController.contractData
                                  .value[conModel.creator][conModel.lastName],
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: contractController
                                  .contractData.value[conModel.and],
                            ),
                            TextSpan(
                              text: contractController.contractData
                                  .value[conModel.receiver][conModel.firstName],
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: contractController.contractData
                                  .value[conModel.receiver][conModel.lastName],
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Purpose",
                          style: themeData!.textTheme.headline6,
                        ),
                        Text(
                          contractController
                              .contractData.value[conModel.purpose],
                          maxLines: maxLines,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Agreed Amount",
                        ),
                        Row(
                          children: [
                            Text(
                              "${paymentsController.numCurrency(contractController.contractData.value[conModel.contractAmount])} ${contractController.contractData.value[conModel.creator][conModel.currencyCode]}",
                              style: themeData!.textTheme.headline5,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 8),
                    child: Table(
                      children: [
                        const TableRow(children: [
                          Text("Start Date"),
                          Text("End Date"),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(DateFormat.yMMMEd().add_jm().format(
                                contractController
                                    .contractData
                                    .value[conModel.startDateEndDate]
                                        ["startDate"]
                                    .toDate())),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(DateFormat.yMMMEd().add_jm().format(
                                contractController.contractData
                                    .value[conModel.startDateEndDate]["endDate"]
                                    .toDate())),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  // Text(contractController.contractData[conModel.toProtect], maxLines: maxLines,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Table(
                      children: [
                        TableRow(
                          children: [
                            const Text("# days"),
                            Text("${contractController.getNumberOfDay()}"),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text("Days Till"),
                            Text("${contractController.getDaysTill()}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: contractController.contractData[
                          conModel.toProtect], // default text style
                      children: [
                        TextSpan(
                          text:
                              contractController.contractData[conModel.creator]
                                  [conModel.firstName],
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              contractController.contractData[conModel.creator]
                                  [conModel.lastName],
                          style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: contractController.contractData[conModel.and],
                        ),
                        TextSpan(
                          text:
                              contractController.contractData[conModel.receiver]
                                  [conModel.firstName],
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              contractController.contractData[conModel.receiver]
                                  [conModel.lastName],
                          style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  buttonsForContractReceiver(),
                  buttonsForContractCreator(),
                ],
              )),
        ),
      ),
    );
  }

  Widget buttonsForContractReceiver() {
    print("buttonsForContractReceiver");
    if (contractController.contractData[conModel.contractDispute] == false &&
        contractController.contractData[conModel.rejected] == false &&
        contractController.contractData[conModel.cancelContract] == false) {
      if (contractController.contractData[conModel.receiver]
              [conModel.userUID] ==
          chatServices.localMember!.get(memberModel.userUID)) {
        if (contractController.contractData[conModel.contractAccepted] ==
            false) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  Get.defaultDialog(
                      barrierDismissible: false,
                      title: "Reject Contract",
                      content: const Text(
                        "Are you sure you want to Reject this contract?",
                        textAlign: TextAlign.center,
                      ),
                      confirm: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Text(
                              "Go Back",
                              style: themeData!.textTheme.headline6,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              contractController.contractSnap!.reference
                                  .update({
                                conModel.rejected: true,
                                conModel.status: "Rejected",
                              });
                              Get.back();
                            },
                            child: Text(
                              "Accept",
                              style: themeData!.textTheme.headline6,
                            ),
                          ),
                        ],
                      ));
                },
                child: Text(
                  "Reject",
                  style: themeData!.textTheme.headline6,
                ),
              ),
              InkWell(
                onTap: () {
                  Get.defaultDialog(
                      barrierDismissible: false,
                      title: "Accept Contract",
                      content: const Text(
                        "Are you sure you want to accept this contract?",
                        textAlign: TextAlign.center,
                      ),
                      confirm: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Text(
                              "Go Back",
                              style: themeData!.textTheme.headline6,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              contractController.contractSnap!.reference
                                  .update({
                                conModel.contractAccepted: true,
                                conModel.status: "Accepted",
                              });
                              Get.back();
                            },
                            child: Text(
                              "Accept",
                              style: themeData!.textTheme.headline6,
                            ),
                          ),
                        ],
                      ));
                },
                child: Text(
                  "Accept",
                  style: themeData!.textTheme.headline6,
                ),
              ),
            ],
          );
        }
        return Container();
      }
      return Container();
    }
    return Container();
  }

  Widget buttonsForContractCreator() {
    if (kDebugMode) {
      print("buttonsForContractCreator");
    }
    if (kDebugMode) {
      print(contractController.contractData.value[conModel.contractAccepted]);
    }
    if (contractController.contractData.value[conModel.contractDispute] ==
            false &&
        contractController.contractData.value[conModel.rejected] == false &&
        contractController.contractData.value[conModel.cancelContract] ==
            false) {
      if (contractController.contractData.value[conModel.creator]
              [conModel.userUID] ==
          chatServices.localMember!.get(memberModel.userUID)) {
        if (!contractController.contractData.value[conModel.contractAccepted]) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // InkWell(
              //   onTap: () {},
              //   child: Text(
              //     "Reject",
              //     style: themeData!.textTheme.headline6,
              //   ),
              // ),
              InkWell(
                onTap: () {
                  contractController.contractSnap!.reference.update({
                    conModel.cancelContract: true,
                    conModel.status: "Contract canceled",
                  });
                },
                child: Text(
                  "Cancel",
                  style: themeData!.textTheme.headline6,
                ),
              ),
            ],
          );
        }
        if (contractController.contractData.value[conModel.contractAccepted] ==
                true &&
            contractController.contractData.value[conModel.releasePayment] ==
                false) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  Get.defaultDialog(
                      barrierDismissible: false,
                      title: "Payment",
                      content: const Text(
                        "Are you sure you want to release payment?",
                        textAlign: TextAlign.center,
                      ),
                      confirm: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                                paymentsController.checkUserPasscode(onTap: () {
                                  enumServices.transactionActionType =
                                      TransactionActionType
                                          .RELEASE_CONTRACT_PAYMENT;
                                  transactionService.processTransact();
                                  contractController.contractSnap!.reference
                                      .update({
                                    conModel.releasePayment: true,
                                    conModel.status: "Payment released",
                                  });
                                });
                              },
                              child: const Text("Release"),
                            ),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: const Text("Cancel"),
                            )
                          ],
                        ),
                      ));
                },
                child: Text(
                  "Release Payment",
                  style: themeData!.textTheme.headline6,
                ),
              ),
            ],
          );
        }

        return Container();
      }
      return Container();
    }
    return Container();
  }
}
