import 'package:mooweapp/export_files.dart';

class PaymentsController extends GetxController {
  static PaymentsController instance = Get.find();
  String collection = "payments";
  String kApiUrl = "https://us-central1-mooweapp.cloudfunctions.net";
  String pubKey = "";
  String url = 'https://us-central1-sneex-cbc6a.cloudfunctions.net/createPaymentIntent';
  // List<PaymentsModel> payments = [];
  Map<String, dynamic>? paymentIntentData;
  String bankName = "Cash In";
  String? _paymentMethodId;
  String? _client_secret;
  String? _amount;

  final String _errorMessage = "";
  // final _stripePayment = FlutterStripePayment();
  // String? _paymentIntentClientSecret;
  // final bool _error = false;
  bool hasePaymentMethod = false;
  ApiKeyModel? apiKeyModel;
  late LegacyLinkConfiguration publicKeyConfiguration;
  late LinkTokenConfiguration linkTokenConfiguration;
  Map<String, dynamic>? plaidData;
  final String _sandbox = "https://sandbox.plaid.com";
  final String _development = "https://development.plaid.com";
  final String _production = "https://production.plaid.com";
  String _everonmentUrl = "";

  @override
  void onReady() {
    _everonmentUrl = _sandbox;
    super.onReady();
    // _stripePayment.setStripeSettings(
    //   "pk_test_51JU8mFAbOs4vYObLsJ55qfDdecQyGG5mGlkmkDSoXVaMCOQy58NXJP4eb0k1YZnozvRZIpxN5cnh5SfMFOojqdA600rnaEqtGl",
    // );
    // _stripePayment.onCancel = () {
    //   print("the payment form was cancelled");
    // };

    // getPlaidLinkToken();
  }

  String numCurrency(double number) {
    final oCcy = NumberFormat("#,##0.##", "en_US");
    return oCcy.format(number);
  }

  // String cartNumCurrency(double number){
  //   final oCcy = NumberFormat("#,##0.##", "en_US");
  //   return oCcy.format(number);
  // }
  Future<void> plaidAuthResponse(String accessToken) async {
    if (kDebugMode) {
      print("plaidAuthResponse");
    }

    var headers = {'Content-Type': 'application/json'};
    var request = Request('POST', Uri.parse('$_everonmentUrl/auth/get'));
    request.body = json.encode({
      "client_id": apiKeyModel!.plaidClientId,
      "secret": apiKeyModel!.plaidSecret,
      "access_token": accessToken,
    });
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    if (kDebugMode) {
      print("getUserAccount StreamedResponse");
    }

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("plaidAuthResponse response");
      }

      Map<String, dynamic> authResponseData = jsonDecode(await response.stream.bytesToString());
      debugPrint(authResponseData.toString());
      // paymentsController.userPaymentMethod.defaultPaymentMethodId = accessToken;
      // paymentsController.setUpUserPasscode();
      // plaidIdentityResponse(accessToken);
      transferAuthCreate(authResponseData: authResponseData, accessToken: accessToken);
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
  }

  void transferAuthCreate({required Map<String, dynamic> authResponseData, required String accessToken}) async {
    if (kDebugMode) {
      print("transferAuthCreate");
    }

    var headers = {'Content-Type': 'application/json'};
    var request = Request('POST', Uri.parse('$_everonmentUrl/transfer/authorization/create'));
    request.body = json.encode({
      "client_id": apiKeyModel!.plaidClientId,
      "secret": apiKeyModel!.plaidSecret,
      "access_token": accessToken,
      "account_id": authResponseData["accounts"][0]["account_id"],
      "network": "ach",
      "amount": "12.35",
      "type": "credit",
      "ach_class": "ppd",
      "user": {"legal_name": "Muniru Bawa"},
    });
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    if (kDebugMode) {
      print("transferAuthCreate StreamedResponse");
    }

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("transferAuthCreate response");
      }

      Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      debugPrint(data.toString());
      // paymentsController.userPaymentMethod.defaultPaymentMethodId = accessToken;
      // paymentsController.setUpUserPasscode();
      // plaidIdentityResponse(accessToken);
      // processorStripeBankAccountToken(accountId: data["accounts"][0]["account_id"], accessToken: accessToken);
    } else {
      Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      debugPrint(data.toString());
      if (kDebugMode) {
        print(response.reasonPhrase);
        print(response.statusCode);
      }
    }
  }

  Future<void> plaidIdentityResponse(String accessToken) async {
    print("plaidIdentityResponse");

    var headers = {'Content-Type': 'application/json'};
    var request = Request('POST', Uri.parse('$_everonmentUrl/identity/get'));
    request.body = json.encode({
      "client_id": apiKeyModel!.plaidClientId,
      "secret": apiKeyModel!.plaidSecret,
      "access_token": accessToken,
    });
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    print("plaidIdentityResponse StreamedResponse");

    if (response.statusCode == 200) {
      print("plaidIdentityResponse response");

      Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      debugPrint(data.toString());
      return Future(() => null);
      // processorStripeBankAccountToken(accountId: data["accounts"][0]["account_id"], accessToken: accessToken);
    } else {
      print(response.reasonPhrase);
      return Future(() => null);
    }
  }

  Future<void> getUserAccount(String accessToken) async {
    print("getUserAccount");

    var headers = {'Content-Type': 'application/json'};
    var request = Request('POST', Uri.parse('$_everonmentUrl/item/get'));
    request.body = json.encode({
      "client_id": apiKeyModel!.plaidClientId,
      "secret": apiKeyModel!.plaidSecret,
      "access_token": accessToken,
    });
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    print("getUserAccount StreamedResponse");

    if (response.statusCode == 200) {
      print("getUserAccount response");

      Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      debugPrint(data.toString());
    } else {
      print(response.reasonPhrase);
    }
  }

  void setStripeAsProcessor(String publicToken) async {
    print("getStripeBankAccountToken");

    var headers = {'Content-Type': 'application/json'};
    var request = Request('POST', Uri.parse('$_everonmentUrl/processor/stripe/bank_account_token/create'));
    request.body = json.encode({
      "client_id": apiKeyModel!.plaidClientId,
      "secret": apiKeyModel!.plaidSecret,
      "public_token": publicToken,
    });
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    if (kDebugMode) {
      print("getStripeBankAccountToken StreamedResponse");
    }

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("getStripeBankAccountToken response");
      }

      Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      debugPrint(data.toString());
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
  }

  Future<Map<String, dynamic>> accountBalance(String accessToken) async {
    print("accountBalance");
    await plaidAuthResponse(accessToken);
    var headers = {'Content-Type': 'application/json'};
    var request = Request('POST', Uri.parse('$_everonmentUrl/accounts/balance/get'));
    request.body = json.encode({
      "client_id": apiKeyModel!.plaidClientId,
      "secret": apiKeyModel!.plaidSecret,
      "access_token": accessToken,
    });
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    if (kDebugMode) {
      print("accountBalance StreamedResponse");
    }

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("accountBalance response");
      }

      Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      // debugPrint(data.toString());
      return data;
    } else {
      Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      debugPrint(data.toString());
      return data;
    }
  }

  void checkUserPasscode({required void Function()? onTap}) {
    showBarModalBottomSheet(
      context: Get.context!,
      builder: (context) => Container(
        color: Colors.white,
        child: RawKeyboardListener(
          autofocus: true,
          focusNode: FocusNode(),
          child: Column(
            children: [
              SizedBox(
                height: Get.height * .01,
              ),
              Text(
                "Enter Passcode",
                style: themeData!.textTheme.headline4,
              ),
              SizedBox(
                height: Get.height * .15,
              ),
              Pinput(
                autofocus: true,
                obscureText: true,
                obscuringCharacter: "*",
                pinContentAlignment: Alignment.center,
                focusNode: FocusNode(),
                onCompleted: (pin) => print(pin),
                validator: (s) {
                  // return s == '2222' ? null : 'Pin is incorrect';
                  if (s == userPaymentMethod.passcode) {
                    Get.back();

                    if (onTap == null) {
                    } else {
                      onTap();
                    }

                    return null;
                  } else {
                    return 'Pin is incorrect';
                  }
                },
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  RxString firstPasscode = RxString("");
  RxString secondPasscode = RxString("");
  void setUpUserPasscode() {
    showBarModalBottomSheet(
      context: Get.context!,
      builder: (context) => Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: Get.height * .1,
            ),
            Obx(
              () => firstPasscode.value == "" ? Text("Create A Passcode ", style: themeData!.textTheme.headline4) : Text("Enter Passcode Again", style: themeData!.textTheme.headline4),
            ),
            Obx(
              () => secondPasscode.value.length == 4
                  ? firstPasscode.value != secondPasscode.value
                      ? Text(
                          "Passcode do not match",
                          style: themeData!.textTheme.bodyLarge!.copyWith(color: Colors.red),
                        )
                      : Container()
                  : Container(),
            ),
            SizedBox(
              height: Get.height * .15,
            ),
            Pinput(
              // obscureText: true,
              autofocus: true,
              obscuringCharacter: "*",
              pinContentAlignment: Alignment.center,
              onChanged: (value) {
                if (firstPasscode.value != "") secondPasscode.value = value;
              },
              onCompleted: (pin) {
                if (kDebugMode) {
                  print("onCompleted");
                  print(pin);
                }
              },
              validator: (s) {
                // return s == '2222' ? null : 'Pin is incorrect';
                if (firstPasscode.value != "") {
                  secondPasscode.value = s.toString();
                }
                if (firstPasscode.value == "") {
                  firstPasscode.value = s.toString();
                  Get.back();
                  setUpUserPasscode();
                } else if (s.toString() == firstPasscode.value) {
                  Get.back();
                  userPaymentMethod.passcode = s.toString();
                  savePaymentMethodToStripe();
                }
                // onTap!();

                return null;
              },
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
            ),
          ],
        ),
      ),
    );
  }

  void savePaymentMethodToStripe() async {
    switch (enumServices.currencyTypes) {
      case CurrencyTypes.USD:
        Map<String, dynamic> body = {
          "email": auth.currentUser!.email,
          "userId": auth.currentUser!.uid,
          "token": userPaymentMethod.defaultPaymentMethodId,
          "currency": chatServices.localMember!.get(memberModel.currencyCode),
        };
        print("paymentIntent");

        var response = await post(Uri.parse("https://us-central1-mooweapp.cloudfunctions.net/savePaymentMethod"), body: body, headers: StripeService.headers);
        final responseData = jsonDecode(response.body);
        print("savePaymentMethodToStripe responseData");
        print(responseData);
        if (responseData!["success"]) {
          userPaymentMethod.customer = responseData!["customer"]["id"];
          userPaymentMethod.default_source = responseData!["customer"]["default_source"];
          FirebaseFirestore.instance.doc(dbHelper.paymentMethodPath()).set(userPaymentMethod.toMap()).whenComplete(() => checkPaymentMethod);
          successDialog();
        } else {
          errorDialog();
        }
        break;
      case CurrencyTypes.GHS:
        userPaymentMethod.accessToken = "";
        userPaymentMethod.customer = "";
        userPaymentMethod.default_source = "";
        FirebaseFirestore.instance.doc(dbHelper.paymentMethodPath()).set(userPaymentMethod.toMap()).whenComplete(() => checkPaymentMethod);

        break;
    }
  }

  void successDialog() {
    Get.defaultDialog(
      barrierDismissible: false,
      content: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
                child: Text(
              "Payment Method Saved successfully",
              style: themeData!.textTheme.headline6,
            )),
          ],
        ),
      ),
      confirm: SizedBox(
        height: Get.height * 0.05,
        child: CustomBtn2(
          bgColor: kPrimaryColor,
          child: Text(
            "Okay",
            style: themeData!.textTheme.bodyText1,
          ),
          onTap: () {
            Get.back();
          },
        ),
      ),
    );
  }

  void errorDialog() {
    Get.defaultDialog(
      barrierDismissible: false,
      content: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
                child: Text(
              "Something went wrong, Try again!",
              style: themeData!.textTheme.bodyText1!.copyWith(color: Colors.white),
            )),
          ],
        ),
      ),
      confirm: SizedBox(
        height: Get.height * 0.05,
        child: CustomBtn2(
          bgColor: kPrimaryColor,
          child: Text(
            "Okay",
            style: themeData!.textTheme.headline6!.copyWith(color: Colors.white),
          ),
          onTap: () {
            Get.back();
          },
        ),
      ),
    );
  }

  void passcodeDialogSuccess() {
    Get.defaultDialog(
        barrierDismissible: false,
        content: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                  child: Center(
                      child: Text(
                "Passcode setup was successfully",
                style: themeData!.textTheme.headline6,
              )))
            ],
          ),
        ),
        confirm: SizedBox(
          height: Get.height * 0.05,
          child: CustomBtn2(
            bgColor: kPrimaryColor,
            child: Text(
              "Okay",
              style: themeData!.textTheme.bodyLarge!.copyWith(color: Colors.white),
            ),
            onTap: () {
              Get.back();
            },
          ),
        ));
  }

  Future<Map<String, dynamic>?> chargeSourceWithStripeToken(String amount, String currency) async {
    debugPrint("chargeSourceWithStripeToken");
    Map<String, dynamic> body = {
      "token": userPaymentMethod.defaultPaymentMethodId,
      "email": auth.currentUser!.email,
      "amount": "${amount}00",
      "currency": currency.toLowerCase(),
      "customer": userPaymentMethod.customer,
      "source": userPaymentMethod.default_source,
    };
    var response = await post(Uri.parse("https://us-central1-mooweapp.cloudfunctions.net/chargeSource"), body: body, headers: StripeService.headers);
    final responseData = jsonDecode(response.body);
    debugPrint("chargeSourceWithStripeToken responseData");

    paymentIntentData = responseData;
    if (kDebugMode) {
      print(paymentIntentData);
    }
    return responseData;
  }

  void _addCardToAccount() {
    print("_addCardToAccount");
    // print(paymentMethodId);
    if (enumServices.transactionActionType == TransactionActionType.CASH_IN_FROM_BANK) {
      transactionService.processTransact();
    }
    savePaymentMethodToStripe();

    // checkPaymentMethod();
  }

  void checkPaymentMethod() {
    if (chatServices.localMember != null && !hasePaymentMethod) {
      enumServices.currencyTypes = EnumToString.fromString(CurrencyTypes.values, chatServices.localMember!.get(memberModel.currencyCode)!)!;
      // enumServices.currencyTypes = EnumToString.fromString(CurrencyTypes.values, "GHS")!;
      FirebaseFirestore.instance.doc(dbHelper.paymentMethodPath()).get().then((event) {
        hasePaymentMethod = event.exists;
        print("hasePaymentMethod ${event.exists}");
        if (event.exists) {
          hasePaymentMethod = true;
          userPaymentMethod = UserPaymentMethod.fromSnap(event);
        } else {
          hasePaymentMethod = false;
        }
      });
    }
  }

  void payWithExistingPaymentMethod({required String amount, required String currency}) async {
    Get.defaultDialog(
        barrierDismissible: false,
        content: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: const [
              CircularProgressIndicator(),
              Expanded(
                  child: Center(
                      child: Text(
                "Please Wait",
              )))
            ],
          ),
        ));

    switch (enumServices.currencyTypes) {
      case CurrencyTypes.USD:
        Map<String, dynamic>? checkBalance = await accountBalance(userPaymentMethod.accessToken.toString());
        debugPrint("checkBalance[accounts]");
        // debugPrint(checkBalance.runtimeType.toString());
        // debugPrint(checkBalance.toString());
        // debugPrint(checkBalance["accounts"].toString());
        // debugPrint(checkBalance["accounts"][0]["balances"]["available"].toString());
        if (checkBalance["error_code"] == "ITEM_LOGIN_REQUIRED") {
          PlaidLink.open(configuration: addPaymentMethodController.linkTokenConfiguration);
        }
        double available = double.parse(checkBalance["accounts"][0]["balances"]["available"].toString());

        print(available);
        print("Check available funds");
        print(amount);
        if (available >= double.parse(amount)) {
          // bankName = checkBalance["accounts"][0]["bank_name"];
          Map<String, dynamic>? chargeUser = await chargeSourceWithStripeToken(amount, currency);
          bankName = chargeUser!["charge"]["source"]["bank_name"];
          Get.back();
          print(chargeUser);
          if (chargeUser["success"] == true) {
            transactionLogic();
          } else {
            Get.defaultDialog(
                content: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Center(
                    child: Text(
                      "Transaction Unsuccessful",
                      style: themeData!.textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ));
          }
        } else {
          Get.back();
          Get.defaultDialog(
              content: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Center(
                  child: Text(
                    "Insufficient funds",
                    style: themeData!.textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          ));
        }

        break;
      case CurrencyTypes.GHS:
        StreamedResponse response = await momoController.requestToPay( amount: amount, currency: currency);

        if (response.statusCode == 202) {
          Future.delayed(const Duration(seconds: 10), () async {
            StreamedResponse status = await momoController.checkStatusOfRequestToPay();
            if (status.statusCode == 200) {
              var result = await status.stream.bytesToString();
              Map<String, dynamic> valueResult = jsonDecode(result);
              if (valueResult["status"] == "SUCCESSFUL") {
                Get.back();

                // transactionLogic();

                transactionService.processTransact();
                print(valueResult);
              }
            } else {}
          });
        } else {
          if (kDebugMode) {
            print(response.reasonPhrase);
          }
        }
        break;
      case CurrencyTypes.NGN:
        // TODO: Handle this case.
        break;
      case CurrencyTypes.GBP:
        // TODO: Handle this case.
        break;
    }
  }

  void transactionLogic() {
    switch (enumServices.transactionActionType) {
      case TransactionActionType.SEND_CASH_DIRECT_FROM_MOOWE_PAY:
        break;
      case TransactionActionType.SEND_CASH_IN_PRIVATE_CHAT:
        enumServices.transactionActionType = TransactionActionType.CASH_IN_FROM_BANK;
        transactionService.processTransact();
        transactionService.transactionAmount.value = transactionService.transactionAmountCopy;

        enumServices.transactionActionType = TransactionActionType.SEND_CASH_IN_PRIVATE_CHAT;
        transactionService.processTransact();
        break;
      case TransactionActionType.SEND_CASH_IN_GROUP_CHAT:
        enumServices.transactionActionType = TransactionActionType.CASH_IN_FROM_BANK;
        transactionService.processTransact();
        transactionService.transactionAmount.value = transactionService.transactionAmountCopy;

        enumServices.transactionActionType = TransactionActionType.SEND_CASH_IN_GROUP_CHAT;
        transactionService.processTransact();
        break;
      case TransactionActionType.CASH_IN_FROM_BANK:
        transactionService.processTransact();

        break;
      case TransactionActionType.SEND_CASH_PROJECT_CHAT:
        enumServices.transactionActionType = TransactionActionType.CASH_IN_FROM_BANK;
        transactionService.processTransact();
        transactionService.transactionAmount.value = transactionService.transactionAmountCopy;

        enumServices.transactionActionType = TransactionActionType.SEND_CASH_PROJECT_CHAT;
        transactionService.processTransact();
        break;
      case TransactionActionType.SEND_CASH_TO_MOMO:
      case TransactionActionType.SEND_CASH_TO_BANK_ACCOUNT:
      case TransactionActionType.CASH_OUT_TO_BANK_ACCOUNT:
      case TransactionActionType.PAY_INTO_CONTRACT:
      case TransactionActionType.PROCESS_CONTRACT:
      case TransactionActionType.SEND_CONVERTED_CURRENCY:
      case TransactionActionType.SEND_CASH_WITH_PROJECT_SCAN_CAMERA:
      case TransactionActionType.OFFLINE_TRANSACTION:
      case TransactionActionType.SCAN_QR_CODE_FROM_MOOWE_PAY:
      case TransactionActionType.PROCESS_CHAT_GROUP_FUNDING:
      case TransactionActionType.BILL_PAY:
      case TransactionActionType.REQUEST_PAYMENT:
      case TransactionActionType.TRANSFER_CASH_TO_BANK:
      case TransactionActionType.EXCHANGE_IN_PRIVATE_CHAT:
      case TransactionActionType.EXCHANGE_IN_GROUP_CHAT_OR_PROJECT_CHAT:
      case TransactionActionType.EXCHANGE_GROUP_FUNDING:
      case TransactionActionType.EXCHANGE_FROM_MOOWE_PAY:
      case TransactionActionType.PROCESS_REQUEST_PAYMENT:
      case TransactionActionType.DECLINE_PAYMENT_REQUEST:
      case TransactionActionType.FUND_A_MEMBER:
      case TransactionActionType.MOOWE_RIDE_CHARGE:
      default:
        break;
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }

  // _addToCollection({String? paymentStatus, String? paymentId}) {
  //   String id = const Uuid().v1();
  //   firebaseFirestore.collection(collection).doc(id).set({
  //     "id": id,
  //     "clientId": userController.userModel!.value.get(memberModel.userUID),
  //     "status": paymentStatus,
  //     "paymentId": paymentId,
  //     "cart": userController.userModel!.value.get(memberModel.cart),
  //     "amount": cartController.totalCartPrice.value.toStringAsFixed(2),
  //     "createdAt": DateTime.now().microsecondsSinceEpoch,
  //   });
  // }

  // getPaymentHistory() {
  //   showLoading();
  //   payments.clear();
  //   firebaseFirestore.collection(collection).where("clientId", isEqualTo: userController.userModel!.value.get(memberModel.userUID)).get().then((snapshot) {
  //     for (var doc in snapshot.docs) {
  //       PaymentsModel payment = PaymentsModel.fromMap(doc.data());
  //       payments.add(payment);
  //     }
  //
  //     // logger.i("length ${payments.length}");
  //     dismissLoadingWidget();
  //     // Get.to(() => PaymentsScreen());
  //   });
  // }
}

final defaultPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
  decoration: BoxDecoration(
    border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
    borderRadius: BorderRadius.circular(20),
  ),
);
final focusedPinTheme = defaultPinTheme.copyDecorationWith(
  border: Border.all(color: kPrimaryColor),
  borderRadius: BorderRadius.circular(8),
);

final submittedPinTheme = defaultPinTheme.copyWith(
  decoration: defaultPinTheme.decoration!.copyWith(
    color: const Color.fromRGBO(234, 239, 243, 1),
  ),
);
