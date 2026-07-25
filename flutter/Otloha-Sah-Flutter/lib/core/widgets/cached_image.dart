import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/constant/constants.dart';

class CachedImage extends StatefulWidget {
  final String url;
  final double raduis;
  final Widget? errorWidget;

  const CachedImage({
    required this.url,
    required this.raduis,
    this.errorWidget,
  });
  @override
  _CachedImageState createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: widget.raduis,
      backgroundColor: Colors.grey[300],
      child: CachedNetworkImage(
        imageUrl: '${Constants.baseUrl}${widget.url}',
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
          ),
        ),
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) {
          return widget.errorWidget ?? const Icon(Icons.error);
        },
      ),
    );
  }
}
