class StripeTransactionResponse {
  String message;
  bool success;
  String client_secret;
  String paymentMethodId;
  StripeTransactionResponse({required this.message, required this.success, required this.client_secret, required this
      .paymentMethodId});
}