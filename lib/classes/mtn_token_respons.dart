class MTNTokenResponse {
  String? access_token;
  String? token_type;
  int? expires_in;
  DateTime? expireTime;

//<editor-fold desc="Data Methods">

  MTNTokenResponse({
    this.access_token,
    this.token_type,
    this.expires_in,
    this.expireTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'access_token': access_token,
      'token_type': token_type,
      'expires_in': expires_in,
      'expireTime': expireTime,
    };
  }

  factory MTNTokenResponse.fromMap(Map<String, dynamic> map) {
    return MTNTokenResponse(
      access_token: map['access_token'] as String,
      token_type: map['token_type'] as String,
      expires_in: map['expires_in'] as int,
      expireTime: DateTime.now().add(Duration(milliseconds: map['expires_in'])),
    );
  }

  bool isTokenStillValid() {
    if (expireTime == null) return false;
    return DateTime.now().isAfter(expireTime!);
  }

//</editor-fold>
}