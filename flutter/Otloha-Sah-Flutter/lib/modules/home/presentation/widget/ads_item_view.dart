import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/constant/constants.dart';

class AdsItemView extends StatelessWidget {
  const AdsItemView({
    Key? key,
    required this.image,
    this.action,
  }) : super(key: key);
  final String image;
  final Function()? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: action,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .3,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: '${Constants.baseUrl}$image',
            ),
          ),
        ),
      ),
    );
  }
}
