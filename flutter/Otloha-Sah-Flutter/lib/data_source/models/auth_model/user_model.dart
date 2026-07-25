class UserModelAuth {
  String? accessToken;
  String? refreshToken;
  UserModelAuth({this.accessToken, this.refreshToken});

  UserModelAuth.fromJson(Map<String, dynamic> json) {
    accessToken = json['access'];
    refreshToken = json['refresh'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access'] = accessToken;
    data['refresh'] = refreshToken;

    return data;
  }
}
