import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_shadows.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/modules/quran_hafs/data/quran_hafs_metadata.dart';
import 'package:otloha_sah_flutter/modules/quran/presentation/widget/quranenc_tafseer_widget.dart';

class TafsirBrowserPage extends StatefulWidget {
  final int initialSura;
  final int initialAya;

  const TafsirBrowserPage({
    Key? key,
    this.initialSura = 1,
    this.initialAya = 1,
  }) : super(key: key);

  static const routeName = '/quran/tafsir_browser';

  @override
  State<TafsirBrowserPage> createState() => _TafsirBrowserPageState();
}

class _TafsirBrowserPageState extends State<TafsirBrowserPage> with SingleTickerProviderStateMixin {
  late int _selectedSura;
  late int _selectedAya;
  late TabController _tabController;

  static const List<int> _suraAyahCounts = [
    7, 286, 200, 176, 120, 165, 206, 75, 129, 109,
    123, 111, 43, 52, 99, 128, 111, 110, 98, 135,
    112, 78, 118, 64, 77, 227, 93, 88, 69, 60,
    34, 30, 73, 54, 45, 83, 182, 88, 75, 85,
    54, 53, 89, 59, 37, 35, 38, 29, 18, 45,
    60, 49, 62, 55, 78, 96, 29, 22, 24, 13,
    14, 11, 11, 18, 12, 12, 30, 52, 52, 44,
    28, 28, 20, 56, 40, 31, 50, 40, 46, 42,
    29, 19, 36, 25, 22, 17, 19, 26, 30, 20,
    15, 21, 11, 8, 8, 19, 5, 8, 8, 11,
    11, 8, 3, 9, 5, 4, 7, 3, 6, 3,
    5, 4, 5, 6
  ];

  @override
  void initState() {
    super.initState();
    _selectedSura = widget.initialSura.clamp(1, 114);
    _selectedAya = widget.initialAya.clamp(1, _maxAyasForSura(_selectedSura));
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int _maxAyasForSura(int sura) {
    if (sura >= 1 && sura <= 114) {
      return _suraAyahCounts[sura - 1];
    }
    return 7;
  }

  void _nextAyah() {
    final maxAya = _maxAyasForSura(_selectedSura);
    if (_selectedAya < maxAya) {
      setState(() => _selectedAya++);
    } else if (_selectedSura < 114) {
      setState(() {
        _selectedSura++;
        _selectedAya = 1;
      });
    }
  }

  void _prevAyah() {
    if (_selectedAya > 1) {
      setState(() => _selectedAya--);
    } else if (_selectedSura > 1) {
      setState(() {
        _selectedSura--;
        _selectedAya = _maxAyasForSura(_selectedSura);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(isDark),
            _buildAyahNavigator(isDark),
            _buildTabBar(isDark),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  QuranEncTafseerWidget(
                    sura: _selectedSura,
                    aya: _selectedAya,
                    fallbackTafseer: '',
                    isTranslationMode: false,
                  ),
                  QuranEncTafseerWidget(
                    sura: _selectedSura,
                    aya: _selectedAya,
                    fallbackTafseer: '',
                    isTranslationMode: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        boxShadow: isDark ? AppShadows.softCardDark : AppShadows.softCardLight,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book_rounded, color: Colors.white, size: 24),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'التفسير والترجمات',
                style: AppTypography.h3Medium(color: Colors.white),
              ),
            ],
          ),
          // Sura picker button
          TextButton.icon(
            onPressed: _showSuraPickerDialog,
            style: TextButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.15),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
            ),
            icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.white),
            label: Text(
              QuranHafsMetadata.getSuraName(_selectedSura),
              style: AppTypography.bodyMedium(color: Colors.white).copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyahNavigator(bool isDark) {
    final maxAya = _maxAyasForSura(_selectedSura);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded, size: 28),
            onPressed: (_selectedSura == 114 && _selectedAya == maxAya) ? null : _nextAyah,
            tooltip: 'الآية التالية',
          ),
          InkWell(
            onTap: _showAyahPickerDialog,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  Text(
                    'الآية $_selectedAya من $maxAya',
                    style: AppTypography.bodyMedium(
                      color: AppColors.primary,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down_rounded, size: 20, color: AppColors.primary),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded, size: 28),
            onPressed: (_selectedSura == 1 && _selectedAya == 1) ? null : _prevAyah,
            tooltip: 'الآية السابقة',
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isDark) {
    return Container(
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'التفسير العربي'),
          Tab(text: 'الترجمة الإنجليزية'),
        ],
      ),
    );
  }

  void _showSuraPickerDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final filteredSuras = List.generate(114, (i) => i + 1).where((suraNum) {
              if (searchQuery.isEmpty) return true;
              final name = QuranHafsMetadata.getSuraName(suraNum);
              return name.contains(searchQuery) || suraNum.toString().contains(searchQuery);
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Text('اختر السورة', style: AppTypography.h3Medium()),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'ابحث عن اسم أو رقم السورة...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) {
                      setModalState(() => searchQuery = val.trim());
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredSuras.length,
                      itemBuilder: (ctx, index) {
                        final suraNum = filteredSuras[index];
                        final isSelected = suraNum == _selectedSura;
                        return ListTile(
                          title: Text(
                            'سورة ${QuranHafsMetadata.getSuraName(suraNum)}',
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppColors.primary : null,
                            ),
                          ),
                          leading: CircleAvatar(
                            radius: 14,
                            backgroundColor: isSelected ? AppColors.primary : Colors.grey.shade200,
                            child: Text(
                              '$suraNum',
                              style: TextStyle(
                                fontSize: 11,
                                color: isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          trailing: Text(
                            '${_maxAyasForSura(suraNum)} آية',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                          onTap: () {
                            Navigator.pop(ctx);
                            setState(() {
                              _selectedSura = suraNum;
                              _selectedAya = 1;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAyahPickerDialog() {
    final maxAya = _maxAyasForSura(_selectedSura);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Text('اختر الآية (سورة ${QuranHafsMetadata.getSuraName(_selectedSura)})', style: AppTypography.h3Medium()),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: maxAya,
                  itemBuilder: (ctx, index) {
                    final ayaNum = index + 1;
                    final isSelected = ayaNum == _selectedAya;
                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() => _selectedAya = ayaNum);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$ayaNum',
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
