import 'package:mooweapp/export_files.dart';
class ApiController extends GetxController{
  static ApiController instance = Get.find();

  Rx<ApiKeyModel>  apiKeyModel =  Rx<ApiKeyModel>(ApiKeyModel());
  @override
  void onInit() {
    retrieveApiKeys();
    super.onInit();
  }

  void retrieveApiKeys() async{
    if(box.read("apiKeys") != null) {
      if (kDebugMode) {
        print("retrieveApiKeys  got keys");
      }
      Map<String, dynamic> keys = box.read("apiKeys");
      if (kDebugMode) {
        print("retrieveApiKeys  ${keys}");
      }
      apiKeyModel.value = ApiKeyModel.fromMap(keys);
      paymentsController.apiKeyModel = apiKeyModel.value;
      addPaymentMethodController.apiKeyModel = apiKeyModel.value;
      sandboxPaymentMethodController.apiKeyModel = apiKeyModel.value;

    } else {
      print("retrieveApiKeys  getApiKeys");
      getApiKeys();
    }
  }

  void getApiKeys() async{
    if (kDebugMode) {
      print("getApiKeys");
    }

    var response = await post(Uri.parse("https://us-central1-mooweapp.cloudfunctions.net/getApiKeys"));
    final responseData = jsonDecode(response.body);
    if (kDebugMode) {
      print("ApiController responseData");
    }
    if(responseData["success"]) {
      if (kDebugMode) {
        print(responseData["success"]);
        print(responseData);
      }
      apiKeyModel.value = ApiKeyModel.fromMap(jsonDecode(response.body));
      paymentsController.apiKeyModel = apiKeyModel.value;
      addPaymentMethodController.apiKeyModel = apiKeyModel.value;
      sandboxPaymentMethodController.apiKeyModel = apiKeyModel.value;
      box.write("apiKeys", apiKeyModel.value.toMap());
      if (kDebugMode) {
        // print(apiKeyModel.toMap());
      }

    } else {
      var _apiKeyModel = ApiKeyModel();
      _apiKeyModel.success = false;
      apiKeyModel.value = _apiKeyModel;
      print(apiKeyModel.value.toMap());
    }
    print(response.body);

  }
}