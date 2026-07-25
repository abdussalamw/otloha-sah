class Settings {
  final String name;
  String? subTitle;
  final String image;
  final String? actionTo;
  final int? selected;

  Settings({
    required this.name,
    required this.image,
    this.subTitle,
    this.actionTo,
    this.selected,
  });
}
