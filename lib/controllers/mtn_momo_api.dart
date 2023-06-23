import 'package:mooweapp/export_files.dart';
import 'package:http/http.dart' as http;

class CollectionController extends GetxController {
  static CollectionController instance = Get.find();

  var uuid = const Uuid();
  String? uniqueId;
  void newUUId() {
    uniqueId = uuid.v4();
  }

  MTNTokenResponse? tokenResponse;
  String url = 'https://sandbox.momodeveloper.mtn.com';
  String ocpApimSubscriptionKey = "f93aca31121a4fc595c7688207675219";
  // String ocpApimSubscriptionKey = "618aff221d1441dc990b3446767fd0ec";
  String X_Target_Environment = "sandbox";
  String apiUserForCollectXReferenceID = "196e19b1-07aa-4eb7-a47a-e0f40982a755";

  // Future<void> createAPIUser() async {
  //   var headers = {
  //     'X-Reference-Id': '196e19b1-07aa-4eb7-a47a-e0f40982a755',
  //     'Ocp-Apim-Subscription-Key': ocpApimSubscriptionKey,
  //     'Content-Type': 'application/json',
  //   };
  //   var request = Request(
  //     'POST',
  //     Uri.parse('$url/v1_0/apiuser?X-Reference-Id=196e19b1-07aa-4eb7-a47a-e0f40982a755&Ocp-Apim-Subscription-Key=618aff221d1441dc990b3446767fd0ec'),
  //   );
  //   request.body = json.encode(
  //     {"providerCallbackHost": "https://webhook.site/48aa248a-f183-4298-802f-bc26facb7592"},
  //   );
  //   request.headers.addAll(headers);
  //
  //   StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }
  //
  // Future<void> getSandboxUser() async {
  //   var headers = {'Ocp-Apim-Subscription-Key': ocpApimSubscriptionKey};
  //   var request = Request('GET', Uri.parse('$url/v1_0/apiuser/196e19b1-07aa-4eb7-a47a-e0f40982a755'));
  //
  //   request.headers.addAll(headers);
  //
  //   StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     if (kDebugMode) {
  //       print(await response.stream.bytesToString());
  //     }
  //   } else {
  //     if (kDebugMode) {
  //       print(response.reasonPhrase);
  //     }
  //   }
  // }

  // Future<void> getAPIKey() async {
  //   var headers = {'Ocp-Apim-Subscription-Key': ocpApimSubscriptionKey};
  //   var request = Request('POST', Uri.parse('$url/v1_0/apiuser/${apiUserForCollectXReferenceID.trim()}/apikey'));
  //
  //   request.headers.addAll(headers);
  //
  //   StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 201) {
  //     // print(await response.stream.bytesToString());
  //     // print(await response.headers);
  //     await response.stream.toStringStream().forEach((element) {
  //       if (kDebugMode) {
  //         print(element);
  //         print(jsonDecode(element)["apiKey"]);
  //       }
  //       generateAPIToken(userName: apiUserForCollectXReferenceID.trim(), password: jsonDecode(element)['apiKey']);
  //     });
  //   } else {
  //     if (kDebugMode) {
  //       print(response.reasonPhrase);
  //     }
  //   }
  // }
  Future<void> getAPIKey() async {
    final headers = {'Ocp-Apim-Subscription-Key': ocpApimSubscriptionKey};
    final uri = Uri.parse('$url/v1_0/apiuser/$apiUserForCollectXReferenceID/apikey');

    try {
      final response = await http.post(uri, headers: headers);

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        if (kDebugMode) {
          print(responseBody);
          print(responseBody["apiKey"]);
        }
        await generateAPIToken(userName: apiUserForCollectXReferenceID, password: responseBody['apiKey']);
      } else {
        if (kDebugMode) {
          print(response.reasonPhrase);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error making API request: $e');
      }
    }
  }

  // Future<void> generateAPIToken({required String userName, required String password}) async {
  //   String basicAuth = 'Basic ${base64Encode(utf8.encode('$userName:$password'))}';
  //   if (kDebugMode) {
  //     print(basicAuth);
  //   }
  //
  //   var headers = {
  //     'Ocp-Apim-Subscription-Key': ocpApimSubscriptionKey,
  //     'Authorization': basicAuth
  //     // 'Authorization': 'Basic MTk2ZTE5YjEtMDdhYS00ZWI3LWE0N2EtZTBmNDA5ODJhNzU1OmQyODVlZTI5NDdiYzRhMzU5YzYzNDI2MzVkNmNlN2Yx'
  //   };
  //   var request = Request('POST', Uri.parse('$url/collection/token/'));
  //
  //   request.headers.addAll(headers);
  //
  //   StreamedResponse response = await request.send();
  //   if (kDebugMode) {
  //     print("response.statusCode");
  //     print(response.statusCode);
  //   }
  //   if (response.statusCode == 200) {
  //     // print(await response.stream.bytesToString());
  //     await response.stream.toStringStream().forEach((element) {
  //       if (kDebugMode) {
  //         print(element);
  //         print(jsonDecode(element)["access_token"]);
  //       }
  //       tokenResponse = MTNTokenResponse.fromMap(jsonDecode(element));
  //     });
  //   } else {
  //     if (kDebugMode) {
  //       print(response.reasonPhrase);
  //     }
  //   }
  // }


  Future<void> generateAPIToken({required String userName, required String password}) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$userName:$password'))}';
    if (kDebugMode) {
      print(basicAuth);
    }

    final headers = {
      'Ocp-Apim-Subscription-Key': ocpApimSubscriptionKey,
      'Authorization': basicAuth
    };
    final uri = Uri.parse('$url/collection/token/');

    try {
      final response = await http.post(uri, headers: headers);

      if (kDebugMode) {
        print("response.statusCode");
        print(response.statusCode);
      }

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (kDebugMode) {
          print(responseBody);
          print(responseBody["access_token"]);
        }
        tokenResponse = MTNTokenResponse.fromMap(responseBody);
      } else {
        if (kDebugMode) {
          print(response.reasonPhrase);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error making API request: $e');
      }
    }
  }


  Future<StreamedResponse> requestToPay({required String amount, required String currency}) async {
    newUUId();
    print(uniqueId);
    var headers = {
      'X-Reference-Id': uniqueId.toString(),
      'X-Target-Environment': X_Target_Environment,
      'Ocp-Apim-Subscription-Key': ocpApimSubscriptionKey,
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${tokenResponse!.access_token}'
    };
    var request = Request('POST', Uri.parse('$url/collection/v1_0/requesttopay'));
    request.body = json.encode({
      "amount": paymentsController.numCurrency(double.parse(amount)),
      "currency": "EUR",
      "externalId": "2525522",
      "payer": {
        "partyIdType": "MSISDN",
        "partyId": userPaymentMethod.defaultPaymentMethodId,
      },
      "payerMessage": "Mowe",
      "payeeNote": ""
    });
    request.headers.addAll(headers);
    StreamedResponse response = await request.send();

    return response;
  }

  Future<void> getAccountBalance() async {
    newUUId();
    if (kDebugMode) {
      print("getAccountBalance");
      print(uniqueId);
    }
    var headers = {
      'X-Target-Environment': X_Target_Environment,
      'Ocp-Apim-Subscription-Key': ocpApimSubscriptionKey,
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${tokenResponse?.access_token}'
    };
    var request = Request('GET', Uri.parse('https://sandbox.momodeveloper.mtn.com/collection/v1_0/account/balance'));
    // var request = Request('GET', Uri.parse('${url.trim()}/collection/v1_0/account/balance'));
    request.headers.addAll(headers);
    StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(await response.stream.bytesToString());
      }
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
        print(response.statusCode);
        print(await response.stream.bytesToString());
      }
    }
  }

  Future<StreamedResponse> checkIsAccountHolderRegistered(String number) async {
    var headers = {'X-Target-Environment': X_Target_Environment, 'Ocp-Apim-Subscription-Key': ocpApimSubscriptionKey, 'Authorization': 'Bearer ${tokenResponse!.access_token.toString().trim()}'};
    if (kDebugMode) {
      print("checkIsAccountHolderRegistered");
      print(number);
    }
    userPaymentMethod.defaultPaymentMethodId = number;
    var request = Request('GET', Uri.parse('$url/collection/v1_0/accountholder/msisdn/$number/active'));
    // var request = Request('GET', Uri.parse('https://sandbox.momodeveloper.mtn.com/collection/v1_0/accountholder/msisdn/$number/active'));

    request.headers.addAll(headers);
    StreamedResponse response = await request.send();

    return response;
  }

  Future<StreamedResponse> checkStatusOfRequestToPay() async {
    var headers = {
      'Ocp-Apim-Subscription-Key': ocpApimSubscriptionKey,
      'X-Target-Environment': X_Target_Environment,
      'Authorization': 'Bearer ${tokenResponse!.access_token}',
    };
    var request = Request('GET', Uri.parse('$url/collection/v1_0/requesttopay/$uniqueId'));

    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    return response;
  }

  // Future<void> accountBalanceCheck() async {
  //   if (kDebugMode) {
  //     print("accountBalanceCheck");
  //   }
  //   var headers = {
  //     'Ocp-Apim-Subscription-Key': ocpApimSubscriptionKey,
  //     'X-Target-Environment': X_Target_Environment,
  //     'Authorization': 'Bearer ${tokenResponse!.access_token}',
  //   };
  //   var request = Request('GET', Uri.parse('https://sandbox.momodeveloper.mtn.com/collection/v1_0/account/balance'));
  //
  //   request.headers.addAll(headers);
  //
  //   StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     if (kDebugMode) {
  //       print("accountBalanceCheck response.statusCode");
  //     }
  //     print(await response.stream.bytesToString());
  //   }
  //   else {
  //     if (kDebugMode) {
  //       print("accountBalanceCheck faile");
  //       print(response.reasonPhrase);
  //
  //     }
  //   }
  // }
}

// class CollectionController extends GetxController {
//   static CollectionController instance = Get.find();
//   static CollectionController getCollectionController() {
//     return CollectionController.instance;
//   }
// }
class DisbursementController extends GetxController {
  static DisbursementController instance = Get.find();
  String apiUserForDisbursementsXReferenceID = "d1d0cc71-9219-4077-b067-e7e5ea316050";
  MTNTokenResponse? tokenResponse;

  Future<void> getAPIKey() async {
    var headers = {
      'Ocp-Apim-Subscription-Key': apiController.apiKeyModel.value.mtnDisbursementsPrimaryKey!,
    };
    var request = Request(
      'POST',
      Uri.parse(
        '${momoController.url}/v1_0/apiuser/$apiUserForDisbursementsXReferenceID/apikey',
      ),
    );

    request.headers.addAll(headers);

    StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      // print(await response.stream.bytesToString());
      // print(await response.headers);
      await response.stream.toStringStream().forEach((element) {
        if (kDebugMode) {
          print(element);
          print(jsonDecode(element)["apiKey"]);
        }
        generateAPIToken(userName: apiUserForDisbursementsXReferenceID, password: jsonDecode(element)['apiKey']);
      });
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
  }

  Future<void> generateAPIToken({required String userName, required String password}) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$userName:$password'))}';
    if (kDebugMode) {
      print(basicAuth);
    }

    var headers = {'Ocp-Apim-Subscription-Key': apiController.apiKeyModel.value.mtnDisbursementsPrimaryKey!, 'Authorization': basicAuth};
    // 'Authorization': 'Basic MTk2ZTE5YjEtMDdhYS00ZWI3LWE0N2EtZTBmNDA5ODJhNzU1OmQyODVlZTI5NDdiYzRhMzU5YzYzNDI2MzVkNmNlN2Yx'
    var request = Request('POST', Uri.parse('${momoController.url}/disbursement/token/'));

    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    if (kDebugMode) {
      print("response.statusCode");
      print(response.statusCode);
    }
    if (response.statusCode == 200) {
      await response.stream.toStringStream().forEach((element) {
        if (kDebugMode) {
          print(element);
          print(jsonDecode(element)["access_token"]);
        }
        tokenResponse = MTNTokenResponse.fromMap(jsonDecode(element));
      });
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
  }
}

class RemittanceController extends GetxController {
  static RemittanceController instance = Get.find();
  String apiUserForRemittanceXReferenceID = "c02b5065-fb2a-4db4-983c-9f458006e5ed";

  MTNTokenResponse? tokenResponse;
  Future<void> getAPIKey() async {
    var headers = {'Ocp-Apim-Subscription-Key': apiController.apiKeyModel.value.mtnRemittancePrimaryKey!};
    var request = Request('POST', Uri.parse('${momoController.url}/v1_0/apiuser/$apiUserForRemittanceXReferenceID/apikey'));
    request.headers.addAll(headers);
    StreamedResponse response = await request.send();
    print("getAPIKey");
    if (response.statusCode == 201) {
      await response.stream.toStringStream().forEach((element) {
        if (kDebugMode) {
          print("getAPIKey element");
          print(element);
          print(jsonDecode(element)["apiKey"]);
        }
        generateAPIToken(userName: apiUserForRemittanceXReferenceID, password: jsonDecode(element)['apiKey']);
      });
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
  }

  Future<void> generateAPIToken({required String userName, required String password}) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$userName:$password'))}';
    if (kDebugMode) {
      print(basicAuth);
    }
    var headers = {'Ocp-Apim-Subscription-Key': apiController.apiKeyModel.value.mtnRemittancePrimaryKey!, 'Authorization': basicAuth};
    // 'Authorization': 'Basic MTk2ZTE5YjEtMDdhYS00ZWI3LWE0N2EtZTBmNDA5ODJhNzU1OmQyODVlZTI5NDdiYzRhMzU5YzYzNDI2MzVkNmNlN2Yx'
    var request = Request('POST', Uri.parse('${momoController.url}/remittance/token/'));
    request.headers.addAll(headers);
    StreamedResponse response = await request.send();
    if (kDebugMode) {
      print("response.statusCode");
      print(response.statusCode);
    }
    if (response.statusCode == 200) {
      await response.stream.toStringStream().forEach((element) {
        if (kDebugMode) {
          print(element);
          print(jsonDecode(element)["access_token"]);
        }
        tokenResponse = MTNTokenResponse.fromMap(jsonDecode(element));
      });
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
  }
}
