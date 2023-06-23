import 'package:mooweapp/export_files.dart';

class SandboxPaymentMethodController extends GetxController {
  static SandboxPaymentMethodController instance = Get.find();

  bool hasePaymentMethod = false;
  UserPaymentMethod userPaymentMethod = UserPaymentMethod();
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
      // print(data);
      plaidData = data;
      openPlaid();
    } else {
      Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      print("getPlaidLinkToken");
      print("response.reasonPhrase");
      print(response.reasonPhrase);
      print(data);
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
    print("onSuccess sandbox: $publicToken, metadata: ${metadata.description()}");
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



  void plaidAuthResponse(String accessToken) async {
    print("plaidAuthResponse sandbox");

    var headers = {'Content-Type': 'application/json'};
    var request = Request('POST', Uri.parse('$_everonmentUrl/auth/get'));
    request.body = json.encode({
      "client_id": apiKeyModel!.plaidClientId,
      "secret": apiKeyModel!.plaidSecret,
      "access_token": accessToken,
    });
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    print("getUserAccount sandbox StreamedResponse");

    if (response.statusCode == 200) {
      print("plaidAuthResponse sandbox response");

      Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      debugPrint(data["item"].toString());
      transferAuthCreate(authResponseData: data, accessToken: userPaymentMethod.defaultPaymentMethodId.toString());
      // debugPrint(data.toString());
      // sandboxPublicTokenCreateRequest(institutionId: data["item"]["institution_id"]);
      // plaidIdentityResponse(accessToken);
      // processorStripeBankAccountToken(accountId: data["accounts"][0]["account_id"], accessToken: accessToken);
    } else {
      print(response.reasonPhrase);
    }
  }

  void sandboxPublicTokenCreateRequest() async {
    print("sandboxPublicTokenCreateRequest");
// https://plaid.com/docs/sandbox/institutions/
// https://plaid.com/docs/auth/coverage/testing/#testing-same-day-micro-deposits
    // https://plaid.com/docs/sandbox/
    var headers = {'Content-Type': 'application/json'};
    var request = Request('POST', Uri.parse('$_everonmentUrl/sandbox/public_token/create'));
    request.body = json.encode({
      "client_id": apiKeyModel!.plaidClientId,
      "secret": apiKeyModel!.plaidSecret,
      "institution_id": "ins_109508",
      "initial_products": ["transfer"]
    });
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    print("sandboxPublicTokenCreateRequest StreamedResponse");

    if (response.statusCode == 200) {
      print("sandboxPublicTokenCreateRequest response");

      Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      debugPrint(data.toString());
      // debugPrint(data.toString());
      getPlaidAccessToken(data["public_token"].toString());
      // plaidIdentityResponse(accessToken);
      // processorStripeBankAccountToken(accountId: data["accounts"][0]["account_id"], accessToken: accessToken);
    } else {
      Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      debugPrint(data.toString());
      print(response.reasonPhrase);
    }
  }

  void getPlaidAccessToken(String publicToken) async {
    print("getPlaidAccessToken sandbox");

    var headers = {'Content-Type': 'application/json'};
    var request = Request('POST', Uri.parse('$_everonmentUrl/item/public_token/exchange'));
    request.body = json.encode({
      "client_id": apiKeyModel!.plaidClientId,
      "secret": apiKeyModel!.plaidSecret,
      "public_token": publicToken,
    });
    request.headers.addAll(headers);
    StreamedResponse response = await request.send();
    print("getPlaidAccessToken sandbox StreamedResponse");

    if (response.statusCode == 200) {
      print("getPlaidAccessToken sandbox response");

      Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      print(data);
      // paymentsController.userPaymentMethod.defaultPaymentMethodId = data["access_token"];
      // paymentsController.setUpUserPasscode();
      // plaidAuthResponse(data["access_token"]);
    } else {
      Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      print(data);
      print(response.reasonPhrase);
    }
  }

  void transferAuthCreate({required Map<String, dynamic> authResponseData, required String accessToken}) async{
    print("transferAuthCreate");

    var headers = {
      'Content-Type': 'application/json'
    };
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
    print("transferAuthCreate StreamedResponse");

    if (response.statusCode == 200) {
      print("transferAuthCreate response");

      Map<String, dynamic> data =  jsonDecode(await response.stream.bytesToString());
      debugPrint(data.toString());

      // plaidIdentityResponse(accessToken);
      // processorStripeBankAccountToken(accountId: data["accounts"][0]["account_id"], accessToken: accessToken);
    }
    else {
      Map<String, dynamic> data =  jsonDecode(await response.stream.bytesToString());
      debugPrint(data.toString());
      print(response.reasonPhrase);
      print(response.statusCode);
    }
  }
}
