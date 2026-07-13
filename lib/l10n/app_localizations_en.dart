// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get history => 'History';

  @override
  String get insight => 'Insight';

  @override
  String get settings => 'Settings';

  @override
  String get userPreferences => 'User preferences';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get totalBalance => 'TOTAL BALANCE';

  @override
  String get percentFromLastMonth => '+20% from last month';

  @override
  String get income => 'INCOME';

  @override
  String get payments => 'PAYMENTS';

  @override
  String get allocated => 'Allocated';

  @override
  String get transactions => 'TRANSACTIONS';

  @override
  String get budgetIncome => 'Budget Income';

  @override
  String get budgetPayments => 'Budget Payments';

  @override
  String get spendingCategories => 'Spending categories';

  @override
  String get spendingCategoriesSubtitle =>
      'Split your budget into categories like groceries or transport.';

  @override
  String get budgetAmountAndCurrency => 'Your budget amount and currency';

  @override
  String get budgetAmountSubtitle =>
      'How much do you plan to spend in total? and in which currency?';

  @override
  String get recurringPayments => 'Recurring payments';

  @override
  String get recurringPaymentsSubtitle =>
      'Add recurring bills like rent or subscriptions.';

  @override
  String get totalPayments => 'TOTAL PAYMENTS';

  @override
  String get leftToAllocate => 'LEFT TO ALLOCATE';

  @override
  String get categoriesTotal => 'CATEGORIES TOTAL';

  @override
  String get addAnotherCategory => 'Add another category';

  @override
  String get addAnotherPayment => 'Add another payment';

  @override
  String get quickSet => 'QUICK SET';

  @override
  String get egGroceries => 'e.g. Groceries';

  @override
  String get egNetflix => 'e.g. Netflix';

  @override
  String get hintAmount => '0';

  @override
  String get optionalSkipPayments =>
      'Optional · skip if you have no recurring payments';

  @override
  String get optionalAdjustCategories =>
      'Optional · adjust categories later anytime';

  @override
  String get otherCategoryAutoCreated =>
      'The \'Other\' category will be automatically created';

  @override
  String get budgetAmountError => 'Budget amount must be greater than 0';

  @override
  String get budgetUnallocatedError =>
      'Budget unallocated must be greater than 0';

  @override
  String get addNewExpense => 'Add a new expense';

  @override
  String get addNewExpenseSubtitle =>
      'Track a new transaction and assign it to a category.';

  @override
  String get amount => 'AMOUNT';

  @override
  String get amountHint => '0.00';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get descriptionHint => 'e.g. Grocery run, Uber ride...';

  @override
  String get category => 'CATEGORY';

  @override
  String get date => 'Date';

  @override
  String get saving => 'Saving...';

  @override
  String get save => 'Save';

  @override
  String get expenseAmountError => 'Expense amount must be greater than 0';

  @override
  String get expenseSavedSuccess => 'Expense saved successfully';

  @override
  String get transactionUpdatedSuccess => 'Transaction updated successfully';

  @override
  String get editTransaction => 'Edit Transaction';

  @override
  String get deleteTransaction => 'Delete transaction?';

  @override
  String get deleteTransactionConfirm => 'This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get noTransactionsYet => 'No transactions yet';

  @override
  String get noTransactionsSubtitle => 'Your saved expenses will appear here.';

  @override
  String get edit => 'Edit';

  @override
  String deleteTransactionDesc(Object description) {
    return 'This will permanently remove \"$description\".';
  }

  @override
  String get thisTransaction => 'this transaction';

  @override
  String get type => 'Type';

  @override
  String get expense => 'Expense';

  @override
  String get time => 'Time';

  @override
  String get noDescription => 'No description';

  @override
  String get other => 'Other';

  @override
  String get spendingByCategory => 'Spending by category';

  @override
  String get previous => 'Previous';

  @override
  String get done => 'Done';

  @override
  String get insightsScreen => 'Insights Screen';

  @override
  String get historyScreen => 'History Screen';

  @override
  String get transactionsTitle => 'Transactions';

  @override
  String get language => 'Language';

  @override
  String get languageSubtitle => 'Choose your preferred language';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get spanish => 'Spanish';

  @override
  String get paymentMethod => 'PAYMENT METHOD';

  @override
  String get applePay => 'Apple Pay';

  @override
  String get cash => 'Cash';

  @override
  String get creditCard => 'Credit Card';

  @override
  String get debitCard => 'Debit Card';

  @override
  String get bankTransfer => 'Bank Transfer';

  @override
  String get scanReceipt => 'Scan Receipt';

  @override
  String get scanningReceipt => 'Scanning receipt...';

  @override
  String get receiptScanError => 'Failed to scan receipt';

  @override
  String get noTextFound => 'No text found on receipt';

  @override
  String get receiptScannedSuccess => 'Receipt scanned successfully';

  @override
  String get addExpenseOption => 'Add Expense';

  @override
  String get scanReceiptOption => 'Scan Receipt';

  @override
  String get enterManuallyOption => 'Enter Manually';

  @override
  String get scanReceiptDesc =>
      'Take a photo of your receipt to auto-fill details';

  @override
  String get enterManuallyDesc => 'Enter expense details by hand';

  @override
  String get monthlySpending => 'Monthly Spending';

  @override
  String get totalSpent => 'Total Spent';

  @override
  String get remaining => 'Remaining';

  @override
  String get transactionCount => 'Transactions';

  @override
  String get dailySpending => 'Daily Spending';

  @override
  String get topCategories => 'Top Categories';

  @override
  String get budgetHealth => 'Budget Health';

  @override
  String get budgetUsed => 'of budget used';

  @override
  String get avgTransaction => 'Avg. Transaction';

  @override
  String get largestTransaction => 'Largest Transaction';

  @override
  String get mostActiveCategory => 'Most Active';

  @override
  String get noDataForMonth => 'No data for this month';

  @override
  String get noTransactions => 'No transactions';

  @override
  String get ofTotal => 'of total';

  @override
  String get spendingVelocity => 'Spending Pace';

  @override
  String get dailyAverage => 'Daily Avg';

  @override
  String get projectedTotal => 'Projected';

  @override
  String get onTrack => 'On Track';

  @override
  String get overPace => 'Over Pace';

  @override
  String get underPace => 'Under Pace';

  @override
  String get monthComparison => 'Month Comparison';

  @override
  String get thisMonth => 'This Month';

  @override
  String get lastMonth => 'Last Month';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get weekendVsWeekday => 'Weekend vs Weekday';

  @override
  String get weekend => 'Weekend';

  @override
  String get weekday => 'Weekday';

  @override
  String get biggestExpense => 'Biggest Expense';

  @override
  String get noSpendDays => 'No-Spend Days';

  @override
  String get daysTracked => 'days with no spending';

  @override
  String get lessThanLastMonth => 'less than last month';

  @override
  String get moreThanLastMonth => 'more than last month';

  @override
  String get sameAsLastMonth => 'same as last month';

  @override
  String get projectedBy => 'Projected by';

  @override
  String get onBudgetPace => 'You\'re on pace';

  @override
  String get overBudgetPace => 'Spending above pace';

  @override
  String get underBudgetPace => 'Great job saving!';

  @override
  String get critical => 'Critical';

  @override
  String get warning => 'Warning';

  @override
  String get healthy => 'Healthy';

  @override
  String get spent => 'Spent';

  @override
  String get remainingBudget => 'Remaining';
}
