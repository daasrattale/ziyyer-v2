import 'package:flutter/material.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/setup_input_section.dart';
import 'package:ziyyer/shared/models/category_model.dart';

class TransactionCategorySection extends StatelessWidget {
  final List<CategoryModel> categories;
  final int? selectedCategoryId;
  final ValueChanged<int?> onCategoryChanged;

  const TransactionCategorySection({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSelectedValue = categories.any((c) => c.id == selectedCategoryId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Category'),
        const SizedBox(height: 12),
        SetupFieldContainer(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: hasSelectedValue ? selectedCategoryId : 0,
              isExpanded: true,
              borderRadius: BorderRadius.circular(20),
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: theme.colorScheme.onSurfaceVariant),
              hint: Row(
                children: [
                  Icon(Icons.category_outlined, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(
                    'Select category',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              items: categories
                  .map(
                    (category) => DropdownMenuItem<int>(
                      value: category.id,
                      child: Row(
                        children: [
                          Icon(Icons.label_outline_rounded, size: 20, color: theme.colorScheme.primary),
                          const SizedBox(width: 12),
                          Text(category.name, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onCategoryChanged,
            ),
          ),
        ),
      ],
    );
  }
}
