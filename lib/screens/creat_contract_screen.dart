import 'package:mooweapp/export_files.dart';

class CreateContractScreen extends StatefulWidget {
  ChatRoom? chatRoom;
  CreateContractScreen({Key? key, this.chatRoom}) : super(key: key);

  @override
  _CreateContractScreenState createState() => _CreateContractScreenState();
}

class _CreateContractScreenState extends State<CreateContractScreen> {
  @override
  Widget build(BuildContext context) {
    contractController.setupInfo();
    return Localizations(
      locale: const Locale('en', 'US'),
      delegates: const <LocalizationsDelegate<dynamic>>[
        DefaultWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Get.back();
              transactionService.transactionAmount.value = 0.0;
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: const Text(
            "Create Safe Contract",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 33, horizontal: 33),
            child: Column(
              children: <Widget>[
                Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: '${contractController.contract["thisContract"]}',
                        style: themeData!.textTheme.bodyText1,
                        children: <TextSpan>[
                          TextSpan(
                            text: "${contractController.creatorFirstName.value} ${contractController.creatorLastName.value}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: '${contractController.contract["and"]} ',
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                          TextSpan(
                            text: "${contractController.receiverFirstName.value} ${contractController.receiverLastName.value}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: RawKeyboardListener(
                    focusNode: FocusNode(),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          controller: authController!.controllerLastName,
                          onChanged: (value) {
                            contractController.contract["purpose"] = value;
                          },
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (v) {
                            if (v.toString().trim().isNotEmpty) {
                              return null;
                            } else {
                              return 'Please enter a valid name';
                            }
                          },
                          style: themeData!.textTheme.bodyLarge!.copyWith(color: kPrimaryColor),
                          maxLines: 5,
                          // controller: authProvider.email,
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: kPrimaryColor),
                            border: InputBorder.none,
                            labelStyle: TextStyle(color: kPrimaryColor),
                            labelText: "Type a Reason for this contract.....",
                            hintText: "For the Purpose of.....",
                            helperText: 'Reason for entering this agreement',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.greenAccent,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Obx(
                                          () => Row(
                                            children: [
                                              Text(
                                                contractController.contract[conModel.creator][conModel.currencyCode] + " ",
                                                style: themeData!.textTheme.headline3,
                                              ),
                                              Text(
                                                paymentsController.numCurrency(transactionService.transactionAmount.value),
                                                style: themeData!.textTheme.headline3,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.monetization_on_outlined),
                            onPressed: () async {
                              Get.to(() => Scaffold(
                                    backgroundColor: kPrimaryColor,
                                    appBar: AppBar(
                                      backgroundColor: kPrimaryColor,
                                      iconTheme: const IconThemeData(color: Colors.black),
                                      elevation: 0.0,
                                      title: Text(
                                        "Agreed amount",
                                        style: themeData!.textTheme.headline6!.copyWith(color: Colors.white),
                                      ),
                                    ),
                                    body: Column(
                                      children: [
                                        Expanded(
                                            flex: 6,
                                            child: Column(
                                              children: [
                                                NumberDisplay(),
                                              ],
                                            )),
                                        Expanded(
                                            flex: 8,
                                            child: Column(
                                              children: [
                                                KeyPadDisplay(),
                                              ],
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                CustomBtn(
                                                    text: "Next",
                                                    onTap: () {
                                                      Get.back();
                                                    }),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ));
                            },
                          ),
                        ],
                      ),
                      const Text("Agreed amount")
                    ],
                  ),
                ),
                FormBuilderDateRangePicker(
                  name: 'start_to_end_date',
                  firstDate: DateTime(1970),
                  lastDate: DateTime(2030),
                  format: DateFormat('yyyy-MM-dd'),
                  // onChanged: _onChanged,
                  onChanged: (DateTimeRange? rang) async {
                    if (rang != null) {
                      print(rang.start);
                      print(rang.end);
                      contractController.contract[conModel.startDateEndDate] = {
                        "startDate": rang.start,
                        "endDate": rang.end,
                      };
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Start dat - Finish date',
                    helperText: 'How long to complete this task',
                    hintText: 'Start dat - Finish date',
                  ),
                  validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  // height: SizeConfig.heightMultiplier * 15,
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: '${contractController.contract[conModel.toProtect]}',
                          style: themeData!.textTheme.bodyLarge,
                          children: <TextSpan>[
                            TextSpan(
                              text: "${contractController.contract[conModel.creator][conModel.firstName]} ${contractController.contract[conModel.creator][conModel.lastName]}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text: '${contractController.contract[conModel.and]}',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            TextSpan(
                              text: "${contractController.contract[conModel.receiver][conModel.firstName]} ${contractController.contract[conModel.receiver][conModel.lastName]}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FormBuilderCheckbox(
                  name: conModel.acceptTerms,
                  initialValue: false,
                  onChanged: (value) {
                    contractController.contract[conModel.acceptTerms] = value;
                    runSystemOverlay();
                  },
                  title: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'I have read and agree to the ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Terms and Conditions',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  validator: FormBuilderValidators.equal(
                    context,
                    errorText: 'You must accept terms and conditions to continue',
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                MaterialButton(
                  onPressed: () {
                    if (contractController.contract[conModel.purpose] != null && contractController.contract[conModel.purpose] != "") {
                      if (transactionService.transactionAmount.value > 0) {
                        if (contractController.contract[conModel.startDateEndDate] != null) {
                          if (contractController.contract[conModel.acceptTerms] != null && contractController.contract[conModel.acceptTerms] == true) {
                            enumServices.transactionActionType = TransactionActionType.PROCESS_CONTRACT;
                            contractController.contract[conModel.receiverId] = contractController.contract[conModel.receiver]["userUID"];
                            contractController.contract[conModel.creatorId] = contractController.contract[conModel.creator]["userUID"];
                            contractController.contract[conModel.contractAmount] = transactionService.transactionAmount.value;
                            print(contractController.contract);
                            transactionService.runTransaction();
                          }
                        } else {
                          showToastMessage(msg: "Start and End date is required", backgroundColor: Colors.green, timeInSecForIosWeb: 5);
                        }
                      } else {
                        showToastMessage(msg: "Agreed amount is required", backgroundColor: Colors.green, timeInSecForIosWeb: 5);
                      }
                    } else {
                      showToastMessage(msg: "Purpose of contract is required", backgroundColor: Colors.green, timeInSecForIosWeb: 5);
                    }
                  },
                  child: Text(
                    'Create Contract',
                    style: TextStyle(
                      fontSize: Get.width * 0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
