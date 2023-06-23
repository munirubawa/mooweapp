class RequestToPayModel {
  String? amount;
  String? currency;
  String? externalId;
  String? payerMessage;
  String? payeeNote;
  String? status;
  Map<String, dynamic>? payer;

//<editor-fold desc="Data Methods">

  RequestToPayModel({
    this.amount,
    this.currency,
    this.externalId,
    this.payerMessage,
    this.payeeNote,
    this.payer,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'currency': currency,
      'externalId': externalId,
      'payerMessage': payerMessage,
      'payeeNote': payeeNote,
      'payer': payer,
      'status': status,
    };
  }

  factory RequestToPayModel.fromMap(Map<String, dynamic> map) {
    return RequestToPayModel(
      amount: map['amount'] as String,
      currency: map['currency'] as String,
      externalId: map['externalId'] as String,
      payerMessage: map['payerMessage'] as String,
      payeeNote: map['payeeNote'] as String,
      status: map['status'] as String,
      payer: map['payer'] as Map<String, dynamic>,
    );
  }

//</editor-fold>
}