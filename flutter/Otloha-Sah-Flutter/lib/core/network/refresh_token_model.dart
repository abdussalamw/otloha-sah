class RefreshTokenModel {
  RefreshTokenModel({
    required this.access,
    required this.refresh,
  });

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenModel(
      access: json['access'] ?? '',
      refresh: json['refresh'] ?? '',
    );
  }
  String access;
  String refresh;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access'] = access;
    map['refresh'] = refresh;

    return map;
  }
}
