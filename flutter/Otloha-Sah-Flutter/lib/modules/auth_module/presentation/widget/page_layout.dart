import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';

class PageAuthLayout extends StatelessWidget {
  const PageAuthLayout({
    Key? key,
    required this.pageComponents,
  }) : super(key: key);
  
  final Widget pageComponents;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: pageComponents,
          ),
        ),
      ),
    );
  }
}
