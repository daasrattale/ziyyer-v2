import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/features/receipt_scanner/services/pending_receipt_service.dart';
import 'package:ziyyer/features/receipt_scanner/services/receipt_parser.dart';
import 'package:ziyyer/features/receipt_scanner/services/text_recognition_service.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/shared/utils/toaster.dart';
import 'package:ziyyer/theme.dart';

class AddExpenseOptionsSheet extends StatelessWidget {
  final VoidCallback onManually;
  final VoidCallback onScanned;

  const AddExpenseOptionsSheet({super.key, required this.onManually, required this.onScanned});

  static Future<void> show(BuildContext context, {required VoidCallback onManually, required VoidCallback onScanned}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => AddExpenseOptionsSheet(onManually: onManually, onScanned: onScanned),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(color: AppColors.background(context), borderRadius: BorderRadius.circular(24)),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.divider(context), borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.addExpenseOption,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _OptionTile(
                icon: Icons.document_scanner_outlined,
                title: AppLocalizations.of(context)!.scanReceiptOption,
                subtitle: AppLocalizations.of(context)!.scanReceiptDesc,
                onTap: () => _scanReceipt(context),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _OptionTile(
                icon: Icons.edit_outlined,
                title: AppLocalizations.of(context)!.enterManuallyOption,
                subtitle: AppLocalizations.of(context)!.enterManuallyDesc,
                onTap: () {
                  Navigator.pop(context);
                  onManually();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scanReceipt(BuildContext context) async {
    Navigator.pop(context);

    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);

    if (image == null || !context.mounted) return;
    await _processImage(context, image.path);
  }

  Future<void> _processImage(BuildContext context, String imagePath) async {
    try {
      final text = await TextRecognitionService.recognizeText(imagePath);

      if (text.isEmpty) {
        if (context.mounted) {
          Toaster.warning(AppLocalizations.of(context)!.noTextFound);
        }
        return;
      }

      final parsed = ReceiptParser.parse(text);
      PendingReceiptService.set(parsed);
      onScanned();
    } catch (e) {
      if (context.mounted) {
        Toaster.error(AppLocalizations.of(context)!.receiptScanError);
      }
    }
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius - 4),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.accent(context).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                ),
                child: Icon(icon, color: AppColors.accent(context), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary(context))),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.textHint(context)),
            ],
          ),
        ),
      ),
    );
  }
}
