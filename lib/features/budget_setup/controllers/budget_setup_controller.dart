import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/shared/models/currency_model.dart';
import 'package:ziyyer/shared/services/budget_service.dart';
import 'package:ziyyer/shared/services/service_locator.dart';
import 'package:ziyyer/shared/utils/amount_formatter.dart';

class BudgetSetupController {
  BudgetSetupController._();

  static final BudgetSetupController instance = BudgetSetupController._();

  final BudgetService _budgetService = ServiceLocator.budgetService;

  double get defaultBudgetAmount => 2500.0;
  CurrencyModel get defaultCurrency => AppConstants.supportedCurrencies.first;
  List<CurrencyModel> get supportedCurrencies => AppConstants.supportedCurrencies;

  Future<void> createBudget({required double definedAmount, CurrencyModel currency = AppConstants.defaultCurrency}) async {
    await _budgetService.createBudget(definedAmount: definedAmount, currency: currency.code);
  }

  String format(double amount, {CurrencyModel currency = AppConstants.defaultCurrency}) {
    return AmountFormatter.formatCurrency(amount, currency: currency, decimalDigits: 0);
  }
}
