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
