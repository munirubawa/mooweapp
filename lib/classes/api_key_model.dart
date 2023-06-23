class ApiKeyModel{
  String? plaidClientId;
  String? plaidSecret;
  String? googleMapApiKey;
  String? serverToken;
  bool? success;

  String? mtnCollectionPrimaryKey;
  String? mtnCollectionSecondaryKey;
  String? mtnDisbursementsPrimaryKey;
  String? mtnDisbursementsSecondaryKey;
  String? mtnRemittancePrimaryKey;
  String? mtnRemittanceSecondaryKey;
//<editor-fold desc="Data Methods">

  ApiKeyModel({
    this.plaidClientId,
    this.plaidSecret,
    this.googleMapApiKey,
    this.serverToken,
    this.success,
    this.mtnCollectionPrimaryKey,
    this.mtnCollectionSecondaryKey,
    this.mtnDisbursementsPrimaryKey,
    this.mtnDisbursementsSecondaryKey,
    this.mtnRemittancePrimaryKey,
    this.mtnRemittanceSecondaryKey,
  });

  Map<String, dynamic> toMap() {
    return {
      'plaidClientId': plaidClientId,
      'plaidSecret': plaidSecret,
      'googleMapApiKey': googleMapApiKey,
      'serverToken': serverToken,
      'success': success,
      'mtnCollectionPrimaryKey': mtnCollectionPrimaryKey,
      'mtnCollectionSecondaryKey': mtnCollectionSecondaryKey,
      'mtnDisbursementsPrimaryKey': mtnDisbursementsPrimaryKey,
      'mtnDisbursementsSecondaryKey': mtnDisbursementsSecondaryKey,
      'mtnRemittancePrimaryKey': mtnRemittancePrimaryKey,
      'mtnRemittanceSecondaryKey': mtnRemittanceSecondaryKey,
    };
  }

  factory ApiKeyModel.fromMap(Map<String, dynamic> map) {
    return ApiKeyModel(
      plaidClientId: map['plaidClientId'] as String,
      plaidSecret: map['plaidSecret'] as String,
      googleMapApiKey: map['googleMapApiKey'] as String,
      serverToken: map['serverToken'] as String,
      success: map['success'] as bool,
      mtnCollectionPrimaryKey: map['mtnCollectionPrimaryKey'] as String,
      mtnCollectionSecondaryKey: map['mtnCollectionSecondaryKey'] as String,
      mtnDisbursementsPrimaryKey: map['mtnDisbursementsPrimaryKey'] as String,
      mtnDisbursementsSecondaryKey: map['mtnDisbursementsSecondaryKey'] as String,
      mtnRemittancePrimaryKey: map['mtnRemittancePrimaryKey'] as String,
      mtnRemittanceSecondaryKey: map['mtnRemittanceSecondaryKey'] as String,
    );
  } //</editor-fold>
}