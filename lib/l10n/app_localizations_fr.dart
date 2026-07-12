// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get home => 'Accueil';

  @override
  String get history => 'Historique';

  @override
  String get insight => 'Aperçu';

  @override
  String get settings => 'Paramètres';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get totalBalance => 'SOLDE TOTAL';

  @override
  String get percentFromLastMonth => '+20% par rapport au mois dernier';

  @override
  String get income => 'REVENUS';

  @override
  String get payments => 'PAIEMENTS';

  @override
  String get allocated => 'Alloué';

  @override
  String get transactions => 'TRANSACTIONS';

  @override
  String get budgetIncome => 'Revenu budgétaire';

  @override
  String get budgetPayments => 'Paiements budgétaires';

  @override
  String get spendingCategories => 'Catégories de dépenses';

  @override
  String get spendingCategoriesSubtitle =>
      'Répartissez votre budget en catégories comme courses ou transport.';

  @override
  String get budgetAmountAndCurrency => 'Votre montant budgétaire et devise';

  @override
  String get budgetAmountSubtitle =>
      'Combien prévoyez-vous de dépenser au total ? et dans quelle devise ?';

  @override
  String get recurringPayments => 'Paiements récurrents';

  @override
  String get recurringPaymentsSubtitle =>
      'Ajoutez des factures récurrentes comme le loyer ou les abonnements.';

  @override
  String get totalPayments => 'TOTAL DES PAIEMENTS';

  @override
  String get leftToAllocate => 'RESTE À ALLUER';

  @override
  String get categoriesTotal => 'TOTAL DES CATÉGORIES';

  @override
  String get addAnotherCategory => 'Ajouter une catégorie';

  @override
  String get addAnotherPayment => 'Ajouter un paiement';

  @override
  String get quickSet => 'CONFIG. RAPIDE';

  @override
  String get egGroceries => 'ex. Courses';

  @override
  String get egNetflix => 'ex. Netflix';

  @override
  String get hintAmount => '0';

  @override
  String get optionalSkipPayments =>
      'Facultatif · ignorez si vous n\'avez pas de paiements récurrents';

  @override
  String get optionalAdjustCategories =>
      'Facultatif · ajustez les catégories plus tard';

  @override
  String get otherCategoryAutoCreated =>
      'La catégorie \'Autre\' sera créée automatiquement';

  @override
  String get budgetAmountError =>
      'Le montant du budget doit être supérieur à 0';

  @override
  String get budgetUnallocatedError =>
      'Le budget non alloué doit être supérieur à 0';

  @override
  String get addNewExpense => 'Ajouter une nouvelle dépense';

  @override
  String get addNewExpenseSubtitle =>
      'Enregistrez une nouvelle transaction et assignez-la à une catégorie.';

  @override
  String get amount => 'MONTANT';

  @override
  String get amountHint => '0,00';

  @override
  String get descriptionOptional => 'Description (facultatif)';

  @override
  String get descriptionHint => 'ex. Course au supermarché, trajet Uber...';

  @override
  String get category => 'CATÉGORIE';

  @override
  String get date => 'Date';

  @override
  String get saving => 'Enregistrement...';

  @override
  String get save => 'Enregistrer';

  @override
  String get expenseAmountError =>
      'Le montant de la dépense doit être supérieur à 0';

  @override
  String get expenseSavedSuccess => 'Dépense enregistrée avec succès';

  @override
  String get transactionUpdatedSuccess => 'Transaction mise à jour avec succès';

  @override
  String get editTransaction => 'Modifier la transaction';

  @override
  String get deleteTransaction => 'Supprimer la transaction ?';

  @override
  String get deleteTransactionConfirm => 'Cette action est irréversible.';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get noTransactionsYet => 'Aucune transaction';

  @override
  String get noTransactionsSubtitle =>
      'Vos dépenses enregistrées apparaîtront ici.';

  @override
  String get edit => 'Modifier';

  @override
  String deleteTransactionDesc(Object description) {
    return 'Cela supprimera définitivement « $description ».';
  }

  @override
  String get thisTransaction => 'cette transaction';

  @override
  String get type => 'Type';

  @override
  String get expense => 'Dépense';

  @override
  String get time => 'Heure';

  @override
  String get noDescription => 'Pas de description';

  @override
  String get other => 'Autre';

  @override
  String get spendingByCategory => 'Dépenses par catégorie';

  @override
  String get previous => 'Précédent';

  @override
  String get done => 'Terminé';

  @override
  String get insightsScreen => 'Écran Aperçus';

  @override
  String get historyScreen => 'Écran Historique';

  @override
  String get transactionsTitle => 'Transactions';

  @override
  String get language => 'Langue';

  @override
  String get languageSubtitle => 'Choisissez votre langue préférée';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get spanish => 'Espagnol';

  @override
  String get paymentMethod => 'MODE DE PAIEMENT';

  @override
  String get applePay => 'Apple Pay';

  @override
  String get cash => 'Espèces';

  @override
  String get creditCard => 'Carte de crédit';

  @override
  String get debitCard => 'Carte de débit';

  @override
  String get bankTransfer => 'Virement bancaire';

  @override
  String get scanReceipt => 'Scanner le reçu';

  @override
  String get scanningReceipt => 'Scan du reçu en cours...';

  @override
  String get receiptScanError => 'Échec du scan du reçu';

  @override
  String get noTextFound => 'Aucun texte trouvé sur le reçu';

  @override
  String get receiptScannedSuccess => 'Reçu scanné avec succès';

  @override
  String get addExpenseOption => 'Ajouter une dépense';

  @override
  String get scanReceiptOption => 'Scanner le reçu';

  @override
  String get enterManuallyOption => 'Saisie manuelle';

  @override
  String get scanReceiptDesc =>
      'Prenez une photo de votre reçu pour remplir automatiquement';

  @override
  String get enterManuallyDesc =>
      'Saisissez les détails de la dépense manuellement';
}
