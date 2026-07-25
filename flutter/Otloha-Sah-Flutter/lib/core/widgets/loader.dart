import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

showLoader(BuildContext context) {
  Loader.show(
    context,
    isSafeAreaOverlay: false,
    isBottomBarOverlay: true,
    overlayFromBottom: 80,
    overlayColor: Colors.black26,
    progressIndicator: const CircularProgressIndicator(),
    themeData: Theme.of(context).copyWith(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.blue.shade100,
      ),
    ),
  );
}

hideLoader() {
  Loader.hide();
}
