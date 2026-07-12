import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ziyyer/features/receipt_scanner/services/receipt_parser.dart';
import 'package:ziyyer/features/receipt_scanner/services/text_recognition_service.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/shared/utils/toaster.dart';
import 'package:ziyyer/theme.dart';

class ReceiptScannerButton extends StatefulWidget {
  final void Function(ParsedReceipt receipt) onReceiptScanned;

  const ReceiptScannerButton({
    super.key,
    required this.onReceiptScanned,
  });

  @override
  State<ReceiptScannerButton> createState() => _ReceiptScannerButtonState();
}

class _ReceiptScannerButtonState extends State<ReceiptScannerButton> {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  Future<void> _scanReceipt() async {
    if (_isProcessing) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image == null) return;

      setState(() => _isProcessing = true);

      final recognizedText = await TextRecognitionService.recognizeText(image.path);

      if (recognizedText.isEmpty) {
        if (mounted) {
          Toaster.warning(AppLocalizations.of(context)!.noTextFound);
        }
        return;
      }

      final parsed = ReceiptParser.parse(recognizedText);

      if (mounted) {
        widget.onReceiptScanned(parsed);
      }
    } catch (e) {
      if (mounted) {
        Toaster.error(AppLocalizations.of(context)!.receiptScanError);
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _isProcessing ? null : _scanReceipt,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.accent(context).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.accent(context).withValues(alpha: 0.3),
            ),
          ),
          child: _isProcessing
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.accent(context),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.document_scanner_outlined,
                      size: 18,
                      color: AppColors.accent(context),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppLocalizations.of(context)!.scanReceipt,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.accent(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
