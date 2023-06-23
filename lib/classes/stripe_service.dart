import 'package:mooweapp/export_files.dart';
class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret =
      'sk_test_51JU8mFAbOs4vYObLYFRs7G9gVmEXxoq9RUDKLatkgS44FtsEHnJoA880t30VtU1I4NfgQD5dPfiAL2Ir3GWdT8GC00aGQZrN0Y';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  String? _paymentMethodId;
  final String _errorMessage = "";
  // FlutterStripePayment stripePayment = FlutterStripePayment();
  final _isNativePayAvailable = false;

  static init() {

  }


  static Future<Map<String, dynamic>?> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {'amount': amount, 'currency': currency, 'payment_method_types[]': 'card'};
      var response =
          await post(Uri.parse(StripeService.paymentApiUrl), body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }

}
