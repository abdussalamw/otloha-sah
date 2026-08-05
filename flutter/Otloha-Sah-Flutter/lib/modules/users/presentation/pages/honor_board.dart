import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/data_source/models/user/base_user.dart';

import '../../../../core/design_system/components/cards/app_card.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/widgets/cached_image.dart';
import '../../../../core/widgets/tool_bar_app.dart';

class HonorBoardPage extends StatefulWidget {
  final String type; // 'student' or 'teacher'

  const HonorBoardPage({super.key, required this.type});

  @override
  State<HonorBoardPage> createState() => _HonorBoardPageState();
}

class _HonorBoardPageState extends State<HonorBoardPage> {
  List<BaseUser> topUsers = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchTopUsers();
  }

  Future<void> fetchTopUsers() async {
    setState(() => loading = true);

    final endpoint = widget.type == 'teacher'
        ? '/api/v2/users-profiles/teachers/'
        : '/api/v2/users-profiles/students/';

    try {
      final response = await ApiBaseHelper().getHTTP(
        endpoint,
        queryParameters: {'page': 1, 'ordering': '-rate'},
        dioTypes: DioTypes.authRequired,
      );

      final results = response?.data['results'] as List;

      setState(() {
        topUsers = results.map((e) => BaseUser.fromMap(e)).toList();
      });
    } catch (e) {
      print('Error fetching ${widget.type}s: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  Widget buildUserTile(BaseUser user, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      onTap: () {
        if (widget.type == 'teacher') {
          Navigator.pushNamed(context, '/teacher/${user.id}');
        } else {
          Navigator.pushNamed(context, '/student/${user.id}');
        }
      },
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: [
          // Rank Badge Badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: index == 0
                  ? Colors.amber.shade700
                  : index == 1
                      ? Colors.grey.shade500
                      : index == 2
                          ? Colors.brown.shade400
                          : AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: index < 3 ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Avatar Image
          CachedImage(
            url: user.image ?? '',
            raduis: 22,
          ),
          const SizedBox(width: AppSpacing.md),

          // Username & Rate
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.username,
                  style: AppTypography.bodyMedium(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                    const SizedBox(width: 2),
                    Text(
                      'التقييم: ${user.rate}',
                      style: AppTypography.bodySmall(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.military_tech_rounded,
            color: index == 0 ? Colors.amber : Colors.grey.shade400,
            size: 24,
          ),
        ],
      ),
    );
  }

  String getPageTitle() {
    return widget.type == 'teacher' ? 'لوحة شرف المعلمين' : 'لوحة شرف الطلاب المميزين';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              ToolBarApp(
                backIcon: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: getPageTitle(),
              ),
              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: topUsers.length,
                        itemBuilder: (context, index) =>
                            buildUserTile(topUsers[index], index),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
