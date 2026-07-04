import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/shared/models/currency_model.dart';

class CurrencySelectorSection extends StatefulWidget {
  final CurrencyModel currency;
  final Function(CurrencyModel currency) onCurrencyUpdated;

  const CurrencySelectorSection({super.key, required this.currency, required this.onCurrencyUpdated});

  @override
  State<CurrencySelectorSection> createState() => _CurrencySelectorSectionState();
}

class _CurrencySelectorSectionState extends State<CurrencySelectorSection> {
  late CurrencyModel currency;

  @override
  void initState() {
    currency = widget.currency;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openCurrencyBottomSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currency.code, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(width: 6),
            Icon(Icons.keyboard_arrow_down_rounded, size: 22),
          ],
        ),
      ),
    );
  }

  Future<void> _openCurrencyBottomSheet() async {
    final selected = await showModalBottomSheet<CurrencyModel>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Center(
          // keeps the sheet floating & centered, similar to your mock
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: _CurrencyBottomSheet(currentCurrency: currency, supportedCurrencies: AppConstants.supportedCurrencies),
          ),
        );
      },
    );

    if (selected != null) {
      widget.onCurrencyUpdated.call(selected);
    }
  }
}

class _CurrencyBottomSheet extends StatelessWidget {
  final CurrencyModel currentCurrency;
  final List<CurrencyModel> supportedCurrencies;

  const _CurrencyBottomSheet({required this.currentCurrency, required this.supportedCurrencies});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(blurRadius: 24, spreadRadius: 4, color: Colors.black.withValues(alpha: 0.08))],
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final entry = supportedCurrencies[index];
            final code = entry.code;
            final symbol = entry.symbol;
            final name = entry.name;
            final isSelected = code == currentCurrency.code;

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                child: Text(
                  symbol.length > 1 ? symbol.substring(0, 1) : symbol,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor),
                ),
              ),
              title: Text(code, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(name, style: const TextStyle(color: Color(0xFF9E9E9E))),
              trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
              onTap: () => Navigator.of(context).pop(CurrencyModel(code, symbol, name)),
            );
          },
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemCount: supportedCurrencies.length,
        ),
      ),
    );
  }
}
