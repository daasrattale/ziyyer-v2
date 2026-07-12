import 'package:flutter/material.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/setup_input_section.dart';
import 'package:ziyyer/l10n/app_localizations.dart';

class TransactionDescriptionSection extends StatelessWidget {
  final TextEditingController descriptionController;

  const TransactionDescriptionSection({super.key, required this.descriptionController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(AppLocalizations.of(context)!.descriptionOptional),
        const SizedBox(height: 12),
        Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE7E7E7), width: 1.2),
          ),
          child: Center(
            child: TextField(
              controller: descriptionController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              maxLines: 1,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.descriptionHint,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                isDense: true,
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
                hintStyle: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
