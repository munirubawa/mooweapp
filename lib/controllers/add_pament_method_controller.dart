import 'package:mooweapp/export_files.dart';

class AddPaymentMethodController extends GetxController {
  static AddPaymentMethodController instance = Get.find();

  bool hasePaymentMethod = false;
  // UserPaymentMethod userPaymentMethod = UserPaymentMethod();
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
  }

  void getPlaidLinkToken() async {
    print("confirmations");

    var headers = {'Content-Type': 'application/json'};
    var request = Request('POST', Uri.parse('$_everonmentUrl/link/token/create'));
    request.body = json.encode({
      "client_id": apiKeyModel!.plaidClientId,
      "secret": apiKeyModel!.plaidSecret,
      "client_name": "Mowe Inc.",
      "country_codes": ["US"],
      "language": "en",
      "user": {"client_user_id": auth.currentUser!.uid},
      "products": ["auth", "identity"]
    });
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      if (kDebugMode) {
        print(data);
      }
      plaidData = data;
      openPlaid();
    } else {
      Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
  }

  void openPlaid() {
    linkTokenConfiguration = LinkTokenConfiguration(
      token: plaidData!["link_token"],
    );
    PlaidLink.onSuccess(_onSuccessCallback);
    PlaidLink.onEvent(_onEventCallback);
    PlaidLink.onExit(_onExitCallback);
  }

  void _onSuccessCallback(String publicToken, LinkSuccessMetadata metadata) {
    print("onSuccess: $publicToken, metadata: ${metadata.description()}");
    getPlaidAccessToken(publicToken);
  }

  void _onEventCallback(String event, LinkEventMetadata metadata) {
    print("onEvent: $event, metadata: ${metadata.description()}");
  }

  void _onExitCallback(LinkError? error, LinkExitMetadata metadata) {
    print("onExit metadata: ${metadata.description()}");

    if (error != null) {
      print("onExit error: ${error.description()}");
    }
  }

  void initializePaymentMethod() {
    print("initializePaymentMethod");
    print( enumServices.currencyTypes);
    // enumServices.currencyTypes = CurrencyTypes.GHS;
    switch (enumServices.currencyTypes) {
      case CurrencyTypes.USD:
        getPlaidLinkToken();
        break;
      case CurrencyTypes.NGN:
      case CurrencyTypes.GHS:
        momoController.newUUId();
        // print(momoController.uniqueId);
        if (momoController.tokenResponse != null && momoController.tokenResponse!.isTokenStillValid()) {
          print(momoController.tokenResponse!.toMap());
          print(momoController.tokenResponse!.isTokenStillValid());

          // momoController.requestToPay(amount: transactionService.transactionAmount.value.toString(), currency: enumServices.currencyTypes.toString());
        } else {
          momoController.getAPIKey().then((value) => null);
        }
        break;

      case CurrencyTypes.GBP:
        // TODO: Handle this case.
        break;
    }
  }

  RxString momoNumber = RxString("");
  void addPaymentMethod() {
    switch (enumServices.currencyTypes) {
      case CurrencyTypes.NGN:
      // TODO: Handle this case.
        break;
      case CurrencyTypes.USD:
        Get.back();
        PlaidLink.open(configuration: addPaymentMethodController.linkTokenConfiguration);
        break;
      case CurrencyTypes.GHS:
        Get.back();
        Get.defaultDialog(
          title: "Add Payment Method",
          barrierDismissible: false,
          content: Column(
            children: [
              formFiled(
                // initialValue: businessServices.business.value.state?? "",
                keyboardType: TextInputType.number,
                icon: const Icon(Icons.location_city, color: Colors.grey),
                labelText: "MOMO number",
                hintText: "Mobile money number",
                validateString: "State required",
                onChange: (value) async {
                  print("$value");
                  momoNumber.value = value ?? "";
                  userPaymentMethod.defaultPaymentMethodId = value;
                },
              ),
            ],
          ),
          confirm: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text("Cancel"),
                  ),
                  onTap: () {
                    Get.back();
                  }),
              InkWell(
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Verify"),
                ),
                onTap: () async {
                  if (momoNumber.value.length >= 10) {
                    if (userPaymentMethod.defaultPaymentMethodId != null && userPaymentMethod.defaultPaymentMethodId!.length >= 10) {
                      StreamedResponse response = await momoController.checkIsAccountHolderRegistered(userPaymentMethod.defaultPaymentMethodId!);

                      if (response.statusCode == 200) {
                        var result = await response.stream.bytesToString();
                        Map<String, dynamic> valueResult = jsonDecode(result);
                        print("valueResult");
                        if (kDebugMode) {
                          print(valueResult);
                        }
                        if (valueResult["result"]) {
                          Get.back();
                          momoNumber.value = "";
                          paymentsController.setUpUserPasscode();
                        } else {
                          Get.defaultDialog(content: const Text("Payment method not valid"));
                        }
                      } else {
                        if (kDebugMode) {
                          print("webad");
                          print(response.reasonPhrase);
                          print(response.statusCode);
                          print(response.headers);
                          print(response.request?.headers);
                          print(await response.stream.bytesToString());
                        }
                      }
                    } else {
                      Get.defaultDialog(
                          barrierDismissible: false,
                          title: "Payment Method",
                          content: const Center(
                            child: Text("Please Check the number"),
                          ),
                          confirm: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: InkWell(
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Okay"),
                                ),
                                onTap: () {
                                  Get.back();
                                },
                              ),
                            ),
                          ));
                    }
                  }

                  // setUpUserPasscode();
                },
              ),
              // ElevatedButton(
              //   child: const Text("Start Chat"),
              //   onPressed:
              // }, )
            ],
          ),
        );
        break;

      case CurrencyTypes.GBP:
        // TODO: Handle this case.
        break;
    }
  }

  void getPlaidAccessToken(String publicToken) async {
    if (kDebugMode) {
      print("getPlaidAccessToken");
    }

    var headers = {'Content-Type': 'application/json'};
    var request = Request('POST', Uri.parse('$_everonmentUrl/item/public_token/exchange'));
    request.body = json.encode({
      "client_id": apiKeyModel!.plaidClientId,
      "secret": apiKeyModel!.plaidSecret,
      "public_token": publicToken,
    });
    request.headers.addAll(headers);
    StreamedResponse response = await request.send();
    if (kDebugMode) {
      print("getPlaidAccessToken StreamedResponse");
    }

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("getPlaidAccessToken response");
      }

      Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      if (kDebugMode) {
        print(data);
      }
      plaidAuthResponse(data["access_token"]);
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
  }

  void plaidAuthResponse(String accessToken) async {
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

      Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      debugPrint(data.toString());
      userPaymentMethod.accessToken = accessToken;
      // plaidIdentityResponse(accessToken);
      processorStripeBankAccountToken(accountId: data["accounts"][0]["account_id"], accessToken: accessToken);
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
  }

  void processorStripeBankAccountToken({required String accountId, required String accessToken}) async {
    if (kDebugMode) {
      print("processorStripeBankAccountToken");
    }

    var headers = {
      'Content-Type': 'application/'
          'json'
    };
    var request = Request('POST', Uri.parse('$_everonmentUrl/processor/stripe/bank_account_token/create'));
    request.body = json.encode({
      "client_id": apiKeyModel!.plaidClientId,
      "secret": apiKeyModel!.plaidSecret,
      "access_token": accessToken,
      "account_id": accountId,
    });
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    if (kDebugMode) {
      print("processorStripeBankAccountToken StreamedResponse");
    }

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("processorStripeBankAccountToken response");
      }

      Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      debugPrint(data.toString());

      userPaymentMethod.defaultPaymentMethodId = data["stripe_bank_account_token"];
      paymentsController.setUpUserPasscode();
    } else {
      if (kDebugMode) {
        print("processorStripeBankAccountToken error response");
      }

      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
  }
}
