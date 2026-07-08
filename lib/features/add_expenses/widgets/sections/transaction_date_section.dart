import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/setup_input_section.dart';
import 'package:ziyyer/shared/extensions/datetime_extensions.dart';

class TransactionDateSection extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const TransactionDateSection({super.key, required this.selectedDate, required this.onDateChanged});

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Date'),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _pickDate(context),
          child: SetupFieldContainer(
            child: SizedBox(
              height: 60,
              child: Row(
                children: [
                  Icon(AppIcons.calendar, color: theme.colorScheme.primary, size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedDate.prettyDate(),
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
