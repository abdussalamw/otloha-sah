import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/data_source/remote/quranenc_service.dart';

class QuranEncDownloadDialog extends StatefulWidget {
  final TafseerEdition edition;
  final VoidCallback? onDownloadCompleted;

  const QuranEncDownloadDialog({
    super.key,
    required this.edition,
    this.onDownloadCompleted,
  });

  static Future<void> show(BuildContext context, TafseerEdition edition, {VoidCallback? onCompleted}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => QuranEncDownloadDialog(
        edition: edition,
        onDownloadCompleted: onCompleted,
      ),
    );
  }

  @override
  State<QuranEncDownloadDialog> createState() => _QuranEncDownloadDialogState();
}

class _QuranEncDownloadDialogState extends State<QuranEncDownloadDialog> {
  bool _isDownloading = false;
  bool _isComplete = false;
  double _progress = 0.0;
  double _downloadedMb = 0.0;
  String _currentSura = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  void _checkStatus() async {
    final status = await QuranEncService.instance.getDownloadStatus(widget.edition.key);
    if (mounted) {
      setState(() {
        _isComplete = status['isComplete'] == true;
        _progress = (status['progress'] as double?) ?? 0.0;
        _downloadedMb = (status['downloadedMb'] as double?) ?? 0.0;
      });
    }
  }

  void _startDownload() {
    setState(() {
      _isDownloading = true;
      _errorMessage = null;
    });

    QuranEncService.instance.downloadFullQuran(
      editionKey: widget.edition.key,
      onProgress: (progress, downloadedMb, totalMb, currentSuraName) {
        if (mounted) {
          setState(() {
            _progress = progress;
            _downloadedMb = downloadedMb;
            _currentSura = currentSuraName;
          });
        }
      },
      onComplete: () {
        if (mounted) {
          setState(() {
            _isDownloading = false;
            _isComplete = true;
            _progress = 1.0;
          });
          widget.onDownloadCompleted?.call();
        }
      },
      onError: (err) {
        if (mounted) {
          setState(() {
            _isDownloading = false;
            _errorMessage = err;
          });
        }
      },
    );
  }

  void _deleteDownload() async {
    await QuranEncService.instance.deleteEdition(widget.edition.key);
    if (mounted) {
      setState(() {
        _isComplete = false;
        _progress = 0.0;
        _downloadedMb = 0.0;
      });
      widget.onDownloadCompleted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      title: Row(
        children: [
          Icon(Icons.download_for_offline_rounded, color: AppColors.primary, size: 28),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              widget.edition.name,
              style: AppTypography.h3Small(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.edition.author,
            style: AppTypography.caption(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: AppRadius.radiusMd,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الحجم التقريبي للتنزيل:',
                  style: AppTypography.bodySmall(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  '${widget.edition.estimatedSizeMb.toStringAsFixed(1)} ميجابايت',
                  style: AppTypography.bodySmall(color: AppColors.primary).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (_isComplete)
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: AppRadius.radiusMd,
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.green, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'التفسير منزل بالكامل وجاهز للقراءة أوفلاين',
                      style: AppTypography.bodySmall(color: Colors.green).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (_isDownloading) ...[
            ClipRRect(
              borderRadius: AppRadius.radiusFull,
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 10,
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(_progress * 100).toInt()}% (${_downloadedMb.toStringAsFixed(1)} / ${widget.edition.estimatedSizeMb.toStringAsFixed(1)} MB)',
                  style: AppTypography.caption(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                Text(
                  'سورة $_currentSura',
                  style: AppTypography.caption(color: AppColors.primary).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
          if (_errorMessage != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              _errorMessage!,
              style: AppTypography.caption(color: Colors.red),
            ),
          ],
        ],
      ),
      actions: [
        if (_isDownloading)
          TextButton(
            onPressed: () {
              QuranEncService.instance.cancelDownload();
            },
            child: const Text('إلغاء التنزيل', style: TextStyle(color: Colors.red)),
          )
        else ...[
          if (_isComplete)
            TextButton.icon(
              icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
              label: const Text('حذف المحتوى المحلي', style: TextStyle(color: Colors.red)),
              onPressed: _deleteDownload,
            )
          else
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
              ),
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text('بدء التنزيل الآن'),
              onPressed: _startDownload,
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ],
    );
  }
}
