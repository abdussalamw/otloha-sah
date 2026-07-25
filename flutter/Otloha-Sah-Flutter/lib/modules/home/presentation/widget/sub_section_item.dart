import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class SubSectionItem extends Equatable {
  String? subTitle;
  final String title;
  final String image;
  final String? action;
  final bool isPng;
  final Function(BuildContext)? action2;
  SubSectionItem({
    this.subTitle,
    required this.title,
    required this.image,
    this.action,
    this.action2,
    this.isPng = false,
  });

  @override
  List<Object?> get props => [title, image, subTitle];
}
