import 'package:flutter/material.dart';
import '../design_system/components/loading/app_loading_indicator.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLoadingIndicator();
  }
}
