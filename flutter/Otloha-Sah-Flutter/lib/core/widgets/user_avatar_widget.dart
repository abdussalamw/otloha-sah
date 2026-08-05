import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/utils/constant/constants.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';

/// UserAvatarWidget renders user avatar with gender-specific defaults (Male with Agal/Beard, Female with Hijab)
/// and a distinctive ribbon badge for male teachers ("معلم") and female teachers ("معلمة").
class UserAvatarWidget extends StatelessWidget {
  final User? user;
  final String? gender;
  final bool? isTeacher;
  final String? imageUrl;
  final double radius;

  const UserAvatarWidget({
    super.key,
    this.user,
    this.gender,
    this.isTeacher,
    this.imageUrl,
    this.radius = 26,
  });

  bool get _isFemale {
    final g = (gender ?? user?.gender ?? '').toLowerCase();
    return g == 'female' || g == 'أنثى' || g == 'f' || g == '2';
  }

  bool get _checkIsTeacher {
    return isTeacher ?? user?.isTeacher ?? false;
  }

  String get _defaultAsset {
    return _isFemale ? 'assets/images/avatar_female.png' : 'assets/images/avatar_male.png';
  }

  String get _badgeText {
    return _isFemale ? 'معلمة' : 'معلم';
  }

  @override
  Widget build(BuildContext context) {
    final rawUrl = imageUrl ?? user?.profileImage;
    final hasCustomUrl = rawUrl != null && rawUrl.isNotEmpty && !rawUrl.contains('default');

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Main Avatar Image
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _checkIsTeacher ? const Color(0xFFFFD700) : AppColors.primary,
              width: _checkIsTeacher ? 2.5 : 1.5,
            ),
            boxShadow: _checkIsTeacher
                ? [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withOpacity(0.4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: hasCustomUrl
                ? CachedNetworkImage(
                    imageUrl: rawUrl.startsWith('http') ? rawUrl : '${Constants.baseUrl}$rawUrl',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(_defaultAsset, fit: BoxFit.cover),
                    errorWidget: (context, url, error) => Image.asset(_defaultAsset, fit: BoxFit.cover),
                  )
                : Image.asset(_defaultAsset, fit: BoxFit.cover),
          ),
        ),

        // Teacher Badge / Ribbon
        if (_checkIsTeacher)
          Positioned(
            bottom: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isFemale
                      ? const [Color(0xFF8E2DE2), Color(0xFF4A00E0)]
                      : const [Color(0xFF007AFF), Color(0xFF0040DD)],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  )
                ],
              ),
              child: Text(
                _badgeText,
                style: const TextStyle(
                  fontFamily: 'Beiruti',
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
