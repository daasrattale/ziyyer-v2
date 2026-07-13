import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @insight.
  ///
  /// In en, this message translates to:
  /// **'Insight'**
  String get insight;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @userPreferences.
  ///
  /// In en, this message translates to:
  /// **'User preferences'**
  String get userPreferences;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'TOTAL BALANCE'**
  String get totalBalance;

  /// No description provided for @percentFromLastMonth.
  ///
  /// In en, this message translates to:
  /// **'+20% from last month'**
  String get percentFromLastMonth;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'INCOME'**
  String get income;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'PAYMENTS'**
  String get payments;

  /// No description provided for @allocated.
  ///
  /// In en, this message translates to:
  /// **'Allocated'**
  String get allocated;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'TRANSACTIONS'**
  String get transactions;

  /// No description provided for @budgetIncome.
  ///
  /// In en, this message translates to:
  /// **'Budget Income'**
  String get budgetIncome;

  /// No description provided for @budgetPayments.
  ///
  /// In en, this message translates to:
  /// **'Budget Payments'**
  String get budgetPayments;

  /// No description provided for @spendingCategories.
  ///
  /// In en, this message translates to:
  /// **'Spending categories'**
  String get spendingCategories;

  /// No description provided for @spendingCategoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Split your budget into categories like groceries or transport.'**
  String get spendingCategoriesSubtitle;

  /// No description provided for @budgetAmountAndCurrency.
  ///
  /// In en, this message translates to:
  /// **'Your budget amount and currency'**
  String get budgetAmountAndCurrency;

  /// No description provided for @budgetAmountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How much do you plan to spend in total? and in which currency?'**
  String get budgetAmountSubtitle;

  /// No description provided for @recurringPayments.
  ///
  /// In en, this message translates to:
  /// **'Recurring payments'**
  String get recurringPayments;

  /// No description provided for @recurringPaymentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add recurring bills like rent or subscriptions.'**
  String get recurringPaymentsSubtitle;

  /// No description provided for @totalPayments.
  ///
  /// In en, this message translates to:
  /// **'TOTAL PAYMENTS'**
  String get totalPayments;

  /// No description provided for @leftToAllocate.
  ///
  /// In en, this message translates to:
  /// **'LEFT TO ALLOCATE'**
  String get leftToAllocate;

  /// No description provided for @categoriesTotal.
  ///
  /// In en, this message translates to:
  /// **'CATEGORIES TOTAL'**
  String get categoriesTotal;

  /// No description provided for @addAnotherCategory.
  ///
  /// In en, this message translates to:
  /// **'Add another category'**
  String get addAnotherCategory;

  /// No description provided for @addAnotherPayment.
  ///
  /// In en, this message translates to:
  /// **'Add another payment'**
  String get addAnotherPayment;

  /// No description provided for @quickSet.
  ///
  /// In en, this message translates to:
  /// **'QUICK SET'**
  String get quickSet;

  /// No description provided for @egGroceries.
  ///
  /// In en, this message translates to:
  /// **'e.g. Groceries'**
  String get egGroceries;

  /// No description provided for @egNetflix.
  ///
  /// In en, this message translates to:
  /// **'e.g. Netflix'**
  String get egNetflix;

  /// No description provided for @hintAmount.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get hintAmount;

  /// No description provided for @optionalSkipPayments.
  ///
  /// In en, this message translates to:
  /// **'Optional · skip if you have no recurring payments'**
  String get optionalSkipPayments;

  /// No description provided for @optionalAdjustCategories.
  ///
  /// In en, this message translates to:
  /// **'Optional · adjust categories later anytime'**
  String get optionalAdjustCategories;

  /// No description provided for @otherCategoryAutoCreated.
  ///
  /// In en, this message translates to:
  /// **'The \'Other\' category will be automatically created'**
  String get otherCategoryAutoCreated;

  /// No description provided for @budgetAmountError.
  ///
  /// In en, this message translates to:
  /// **'Budget amount must be greater than 0'**
  String get budgetAmountError;

  /// No description provided for @budgetUnallocatedError.
  ///
  /// In en, this message translates to:
  /// **'Budget unallocated must be greater than 0'**
  String get budgetUnallocatedError;

  /// No description provided for @addNewExpense.
  ///
  /// In en, this message translates to:
  /// **'Add a new expense'**
  String get addNewExpense;

  /// No description provided for @addNewExpenseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track a new transaction and assign it to a category.'**
  String get addNewExpenseSubtitle;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'AMOUNT'**
  String get amount;

  /// No description provided for @amountHint.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get amountHint;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Grocery run, Uber ride...'**
  String get descriptionHint;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'CATEGORY'**
  String get category;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @expenseAmountError.
  ///
  /// In en, this message translates to:
  /// **'Expense amount must be greater than 0'**
  String get expenseAmountError;

  /// No description provided for @expenseSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Expense saved successfully'**
  String get expenseSavedSuccess;

  /// No description provided for @transactionUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Transaction updated successfully'**
  String get transactionUpdatedSuccess;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editTransaction;

  /// No description provided for @deleteTransaction.
  ///
  /// In en, this message translates to:
  /// **'Delete transaction?'**
  String get deleteTransaction;

  /// No description provided for @deleteTransactionConfirm.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteTransactionConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @noTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsYet;

  /// No description provided for @noTransactionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your saved expenses will appear here.'**
  String get noTransactionsSubtitle;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @deleteTransactionDesc.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove \"{description}\".'**
  String deleteTransactionDesc(Object description);

  /// No description provided for @thisTransaction.
  ///
  /// In en, this message translates to:
  /// **'this transaction'**
  String get thisTransaction;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get noDescription;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @spendingByCategory.
  ///
  /// In en, this message translates to:
  /// **'Spending by category'**
  String get spendingByCategory;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @insightsScreen.
  ///
  /// In en, this message translates to:
  /// **'Insights Screen'**
  String get insightsScreen;

  /// No description provided for @historyScreen.
  ///
  /// In en, this message translates to:
  /// **'History Screen'**
  String get historyScreen;

  /// No description provided for @transactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionsTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get languageSubtitle;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT METHOD'**
  String get paymentMethod;

  /// No description provided for @applePay.
  ///
  /// In en, this message translates to:
  /// **'Apple Pay'**
  String get applePay;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get creditCard;

  /// No description provided for @debitCard.
  ///
  /// In en, this message translates to:
  /// **'Debit Card'**
  String get debitCard;

  /// No description provided for @bankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get bankTransfer;

  /// No description provided for @scanReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scan Receipt'**
  String get scanReceipt;

  /// No description provided for @scanningReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scanning receipt...'**
  String get scanningReceipt;

  /// No description provided for @receiptScanError.
  ///
  /// In en, this message translates to:
  /// **'Failed to scan receipt'**
  String get receiptScanError;

  /// No description provided for @noTextFound.
  ///
  /// In en, this message translates to:
  /// **'No text found on receipt'**
  String get noTextFound;

  /// No description provided for @receiptScannedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Receipt scanned successfully'**
  String get receiptScannedSuccess;

  /// No description provided for @addExpenseOption.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpenseOption;

  /// No description provided for @scanReceiptOption.
  ///
  /// In en, this message translates to:
  /// **'Scan Receipt'**
  String get scanReceiptOption;

  /// No description provided for @enterManuallyOption.
  ///
  /// In en, this message translates to:
  /// **'Enter Manually'**
  String get enterManuallyOption;

  /// No description provided for @scanReceiptDesc.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of your receipt to auto-fill details'**
  String get scanReceiptDesc;

  /// No description provided for @enterManuallyDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter expense details by hand'**
  String get enterManuallyDesc;

  /// No description provided for @monthlySpending.
  ///
  /// In en, this message translates to:
  /// **'Monthly Spending'**
  String get monthlySpending;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total Spent'**
  String get totalSpent;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @transactionCount.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionCount;

  /// No description provided for @dailySpending.
  ///
  /// In en, this message translates to:
  /// **'Daily Spending'**
  String get dailySpending;

  /// No description provided for @topCategories.
  ///
  /// In en, this message translates to:
  /// **'Top Categories'**
  String get topCategories;

  /// No description provided for @budgetHealth.
  ///
  /// In en, this message translates to:
  /// **'Budget Health'**
  String get budgetHealth;

  /// No description provided for @budgetUsed.
  ///
  /// In en, this message translates to:
  /// **'of budget used'**
  String get budgetUsed;

  /// No description provided for @avgTransaction.
  ///
  /// In en, this message translates to:
  /// **'Avg. Transaction'**
  String get avgTransaction;

  /// No description provided for @largestTransaction.
  ///
  /// In en, this message translates to:
  /// **'Largest Transaction'**
  String get largestTransaction;

  /// No description provided for @mostActiveCategory.
  ///
  /// In en, this message translates to:
  /// **'Most Active'**
  String get mostActiveCategory;

  /// No description provided for @noDataForMonth.
  ///
  /// In en, this message translates to:
  /// **'No data for this month'**
  String get noDataForMonth;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions'**
  String get noTransactions;

  /// No description provided for @ofTotal.
  ///
  /// In en, this message translates to:
  /// **'of total'**
  String get ofTotal;

  /// No description provided for @spendingVelocity.
  ///
  /// In en, this message translates to:
  /// **'Spending Pace'**
  String get spendingVelocity;

  /// No description provided for @dailyAverage.
  ///
  /// In en, this message translates to:
  /// **'Daily Avg'**
  String get dailyAverage;

  /// No description provided for @projectedTotal.
  ///
  /// In en, this message translates to:
  /// **'Projected'**
  String get projectedTotal;

  /// No description provided for @onTrack.
  ///
  /// In en, this message translates to:
  /// **'On Track'**
  String get onTrack;

  /// No description provided for @overPace.
  ///
  /// In en, this message translates to:
  /// **'Over Pace'**
  String get overPace;

  /// No description provided for @underPace.
  ///
  /// In en, this message translates to:
  /// **'Under Pace'**
  String get underPace;

  /// No description provided for @monthComparison.
  ///
  /// In en, this message translates to:
  /// **'Month Comparison'**
  String get monthComparison;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get lastMonth;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @weekendVsWeekday.
  ///
  /// In en, this message translates to:
  /// **'Weekend vs Weekday'**
  String get weekendVsWeekday;

  /// No description provided for @weekend.
  ///
  /// In en, this message translates to:
  /// **'Weekend'**
  String get weekend;

  /// No description provided for @weekday.
  ///
  /// In en, this message translates to:
  /// **'Weekday'**
  String get weekday;

  /// No description provided for @biggestExpense.
  ///
  /// In en, this message translates to:
  /// **'Biggest Expense'**
  String get biggestExpense;

  /// No description provided for @noSpendDays.
  ///
  /// In en, this message translates to:
  /// **'No-Spend Days'**
  String get noSpendDays;

  /// No description provided for @daysTracked.
  ///
  /// In en, this message translates to:
  /// **'days with no spending'**
  String get daysTracked;

  /// No description provided for @lessThanLastMonth.
  ///
  /// In en, this message translates to:
  /// **'less than last month'**
  String get lessThanLastMonth;

  /// No description provided for @moreThanLastMonth.
  ///
  /// In en, this message translates to:
  /// **'more than last month'**
  String get moreThanLastMonth;

  /// No description provided for @sameAsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'same as last month'**
  String get sameAsLastMonth;

  /// No description provided for @projectedBy.
  ///
  /// In en, this message translates to:
  /// **'Projected by'**
  String get projectedBy;

  /// No description provided for @onBudgetPace.
  ///
  /// In en, this message translates to:
  /// **'You\'re on pace'**
  String get onBudgetPace;

  /// No description provided for @overBudgetPace.
  ///
  /// In en, this message translates to:
  /// **'Spending above pace'**
  String get overBudgetPace;

  /// No description provided for @underBudgetPace.
  ///
  /// In en, this message translates to:
  /// **'Great job saving!'**
  String get underBudgetPace;

  /// No description provided for @critical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get critical;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @healthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthy;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @remainingBudget.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remainingBudget;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
