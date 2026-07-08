import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/setup_input_section.dart';

class TransactionDescriptionSection extends StatelessWidget {
  final TextEditingController descriptionController;

  const TransactionDescriptionSection({super.key, required this.descriptionController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Description'),
        const SizedBox(height: 12),
        SetupFieldContainer(
          child: SizedBox(
            height: 120,
            child: TextField(
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.top,
              minLines: null,
              maxLines: null,
              expands: true,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500, height: 1.3),
              decoration: buildSetupInputDecoration(
                hintText: 'What was this expense for?',
                icon: AppIcons.description,
                context: context,
              ).copyWith(alignLabelWithHint: true, contentPadding: const EdgeInsets.only(top: 16)),
            ),
          ),
        ),
      ],
    );
  }
}
