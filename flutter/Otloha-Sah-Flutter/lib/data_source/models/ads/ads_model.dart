class AdsModel {
  final String title;
  final String? url;
  final String image;

  AdsModel({
    required this.title,
    this.url,
    required this.image,
  });

  factory AdsModel.fromJson(Map<String, dynamic> json) {
    return AdsModel(
      title: json['title'],
      url: json['url'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      'image': image,
    };
  }
}
