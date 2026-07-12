// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get home => 'Inicio';

  @override
  String get history => 'Historial';

  @override
  String get insight => 'Resumen';

  @override
  String get settings => 'Configuración';

  @override
  String get welcomeBack => 'Bienvenido de nuevo';

  @override
  String get totalBalance => 'SALDO TOTAL';

  @override
  String get percentFromLastMonth => '+20% respecto al mes pasado';

  @override
  String get income => 'INGRESOS';

  @override
  String get payments => 'PAGOS';

  @override
  String get allocated => 'Asignado';

  @override
  String get transactions => 'TRANSACCIONES';

  @override
  String get budgetIncome => 'Ingreso presupuestario';

  @override
  String get budgetPayments => 'Pagos presupuestarios';

  @override
  String get spendingCategories => 'Categorías de gastos';

  @override
  String get spendingCategoriesSubtitle =>
      'Divida su presupuesto en categorías como supermercado o transporte.';

  @override
  String get budgetAmountAndCurrency => 'Su monto presupuestario y moneda';

  @override
  String get budgetAmountSubtitle =>
      '¿Cuánto planea gastar en total? ¿y en qué moneda?';

  @override
  String get recurringPayments => 'Pagos recurrentes';

  @override
  String get recurringPaymentsSubtitle =>
      'Agregue facturas recurrentes como alquiler o suscripciones.';

  @override
  String get totalPayments => 'TOTAL DE PAGOS';

  @override
  String get leftToAllocate => 'PENDIENTE DE ASIGNAR';

  @override
  String get categoriesTotal => 'TOTAL DE CATEGORÍAS';

  @override
  String get addAnotherCategory => 'Agregar otra categoría';

  @override
  String get addAnotherPayment => 'Agregar otro pago';

  @override
  String get quickSet => 'CONFIG. RÁPIDA';

  @override
  String get egGroceries => 'ej. Supermercado';

  @override
  String get egNetflix => 'ej. Netflix';

  @override
  String get hintAmount => '0';

  @override
  String get optionalSkipPayments =>
      'Opcional · omita si no tiene pagos recurrentes';

  @override
  String get optionalAdjustCategories =>
      'Opcional · ajuste las categorías más tarde';

  @override
  String get otherCategoryAutoCreated =>
      'La categoría \'Otro\' se creará automáticamente';

  @override
  String get budgetAmountError =>
      'El monto del presupuesto debe ser mayor que 0';

  @override
  String get budgetUnallocatedError =>
      'El presupuesto no asignado debe ser mayor que 0';

  @override
  String get addNewExpense => 'Agregar un nuevo gasto';

  @override
  String get addNewExpenseSubtitle =>
      'Registre una nueva transacción y asíignela a una categoría.';

  @override
  String get amount => 'MONTO';

  @override
  String get amountHint => '0,00';

  @override
  String get descriptionOptional => 'Descripción (opcional)';

  @override
  String get descriptionHint => 'ej. Compra en supermercado, viaje en Uber...';

  @override
  String get category => 'CATEGORÍA';

  @override
  String get date => 'Fecha';

  @override
  String get saving => 'Guardando...';

  @override
  String get save => 'Guardar';

  @override
  String get expenseAmountError => 'El monto del gasto debe ser mayor que 0';

  @override
  String get expenseSavedSuccess => 'Gasto guardado exitosamente';

  @override
  String get transactionUpdatedSuccess =>
      'Transacción actualizada exitosamente';

  @override
  String get editTransaction => 'Editar transacción';

  @override
  String get deleteTransaction => '¿Eliminar transacción?';

  @override
  String get deleteTransactionConfirm => 'Esta acción no se puede deshacer.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get noTransactionsYet => 'Sin transacciones aún';

  @override
  String get noTransactionsSubtitle => 'Sus gastos guardados aparecerán aquí.';

  @override
  String get edit => 'Editar';

  @override
  String deleteTransactionDesc(Object description) {
    return 'Esto eliminará permanentemente \"$description\".';
  }

  @override
  String get thisTransaction => 'esta transacción';

  @override
  String get type => 'Tipo';

  @override
  String get expense => 'Gasto';

  @override
  String get time => 'Hora';

  @override
  String get noDescription => 'Sin descripción';

  @override
  String get other => 'Otro';

  @override
  String get spendingByCategory => 'Gastos por categoría';

  @override
  String get previous => 'Anterior';

  @override
  String get done => 'Listo';

  @override
  String get insightsScreen => 'Pantalla de Resumen';

  @override
  String get historyScreen => 'Pantalla de Historial';

  @override
  String get transactionsTitle => 'Transacciones';

  @override
  String get language => 'Idioma';

  @override
  String get languageSubtitle => 'Elija su idioma preferido';

  @override
  String get english => 'Inglés';

  @override
  String get french => 'Francés';

  @override
  String get spanish => 'Español';

  @override
  String get paymentMethod => 'MÉTODO DE PAGO';

  @override
  String get applePay => 'Apple Pay';

  @override
  String get cash => 'Efectivo';

  @override
  String get creditCard => 'Tarjeta de crédito';

  @override
  String get debitCard => 'Tarjeta de débito';

  @override
  String get bankTransfer => 'Transferencia bancaria';

  @override
  String get scanReceipt => 'Escanear recibo';

  @override
  String get scanningReceipt => 'Escaneando recibo...';

  @override
  String get receiptScanError => 'Error al escanear el recibo';

  @override
  String get noTextFound => 'No se encontró texto en el recibo';

  @override
  String get receiptScannedSuccess => 'Recibo escaneado exitosamente';

  @override
  String get addExpenseOption => 'Agregar gasto';

  @override
  String get scanReceiptOption => 'Escanear recibo';

  @override
  String get enterManuallyOption => 'Ingresar manualmente';

  @override
  String get scanReceiptDesc =>
      'Tome una foto de su recibo para autocompletar los datos';

  @override
  String get enterManuallyDesc => 'Ingrese los detalles del gasto manualmente';
}
