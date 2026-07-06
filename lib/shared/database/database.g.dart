// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BudgetTableTable extends BudgetTable
    with TableInfo<$BudgetTableTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _definedAmountMeta =
      const VerificationMeta('definedAmount');
  @override
  late final GeneratedColumn<double> definedAmount = GeneratedColumn<double>(
      'defined_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _realAmountMeta =
      const VerificationMeta('realAmount');
  @override
  late final GeneratedColumn<double> realAmount = GeneratedColumn<double>(
      'real_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, definedAmount, realAmount, currency, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_table';
  @override
  VerificationContext validateIntegrity(Insertable<Budget> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('defined_amount')) {
      context.handle(
          _definedAmountMeta,
          definedAmount.isAcceptableOrUnknown(
              data['defined_amount']!, _definedAmountMeta));
    } else if (isInserting) {
      context.missing(_definedAmountMeta);
    }
    if (data.containsKey('real_amount')) {
      context.handle(
          _realAmountMeta,
          realAmount.isAcceptableOrUnknown(
              data['real_amount']!, _realAmountMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      definedAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}defined_amount'])!,
      realAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}real_amount'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BudgetTableTable createAlias(String alias) {
    return $BudgetTableTable(attachedDatabase, alias);
  }
}

class Budget extends DataClass implements Insertable<Budget> {
  final int id;
  final double definedAmount;
  final double realAmount;
  final String currency;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Budget(
      {required this.id,
      required this.definedAmount,
      required this.realAmount,
      required this.currency,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['defined_amount'] = Variable<double>(definedAmount);
    map['real_amount'] = Variable<double>(realAmount);
    map['currency'] = Variable<String>(currency);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BudgetTableCompanion toCompanion(bool nullToAbsent) {
    return BudgetTableCompanion(
      id: Value(id),
      definedAmount: Value(definedAmount),
      realAmount: Value(realAmount),
      currency: Value(currency),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Budget.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<int>(json['id']),
      definedAmount: serializer.fromJson<double>(json['definedAmount']),
      realAmount: serializer.fromJson<double>(json['realAmount']),
      currency: serializer.fromJson<String>(json['currency']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'definedAmount': serializer.toJson<double>(definedAmount),
      'realAmount': serializer.toJson<double>(realAmount),
      'currency': serializer.toJson<String>(currency),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Budget copyWith(
          {int? id,
          double? definedAmount,
          double? realAmount,
          String? currency,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Budget(
        id: id ?? this.id,
        definedAmount: definedAmount ?? this.definedAmount,
        realAmount: realAmount ?? this.realAmount,
        currency: currency ?? this.currency,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('id: $id, ')
          ..write('definedAmount: $definedAmount, ')
          ..write('realAmount: $realAmount, ')
          ..write('currency: $currency, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, definedAmount, realAmount, currency, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.id == this.id &&
          other.definedAmount == this.definedAmount &&
          other.realAmount == this.realAmount &&
          other.currency == this.currency &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BudgetTableCompanion extends UpdateCompanion<Budget> {
  final Value<int> id;
  final Value<double> definedAmount;
  final Value<double> realAmount;
  final Value<String> currency;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const BudgetTableCompanion({
    this.id = const Value.absent(),
    this.definedAmount = const Value.absent(),
    this.realAmount = const Value.absent(),
    this.currency = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BudgetTableCompanion.insert({
    this.id = const Value.absent(),
    required double definedAmount,
    this.realAmount = const Value.absent(),
    required String currency,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : definedAmount = Value(definedAmount),
        currency = Value(currency),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Budget> custom({
    Expression<int>? id,
    Expression<double>? definedAmount,
    Expression<double>? realAmount,
    Expression<String>? currency,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (definedAmount != null) 'defined_amount': definedAmount,
      if (realAmount != null) 'real_amount': realAmount,
      if (currency != null) 'currency': currency,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BudgetTableCompanion copyWith(
      {Value<int>? id,
      Value<double>? definedAmount,
      Value<double>? realAmount,
      Value<String>? currency,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return BudgetTableCompanion(
      id: id ?? this.id,
      definedAmount: definedAmount ?? this.definedAmount,
      realAmount: realAmount ?? this.realAmount,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (definedAmount.present) {
      map['defined_amount'] = Variable<double>(definedAmount.value);
    }
    if (realAmount.present) {
      map['real_amount'] = Variable<double>(realAmount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetTableCompanion(')
          ..write('id: $id, ')
          ..write('definedAmount: $definedAmount, ')
          ..write('realAmount: $realAmount, ')
          ..write('currency: $currency, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CategoryTableTable extends CategoryTable
    with TableInfo<$CategoryTableTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _budgetIdMeta =
      const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<int> budgetId = GeneratedColumn<int>(
      'budget_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES budget_table (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _definedAmountMeta =
      const VerificationMeta('definedAmount');
  @override
  late final GeneratedColumn<double> definedAmount = GeneratedColumn<double>(
      'defined_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _realAmountMeta =
      const VerificationMeta('realAmount');
  @override
  late final GeneratedColumn<double> realAmount = GeneratedColumn<double>(
      'real_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, budgetId, name, definedAmount, realAmount, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_table';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('budget_id')) {
      context.handle(_budgetIdMeta,
          budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta));
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('defined_amount')) {
      context.handle(
          _definedAmountMeta,
          definedAmount.isAcceptableOrUnknown(
              data['defined_amount']!, _definedAmountMeta));
    } else if (isInserting) {
      context.missing(_definedAmountMeta);
    }
    if (data.containsKey('real_amount')) {
      context.handle(
          _realAmountMeta,
          realAmount.isAcceptableOrUnknown(
              data['real_amount']!, _realAmountMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      budgetId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}budget_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      definedAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}defined_amount'])!,
      realAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}real_amount'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CategoryTableTable createAlias(String alias) {
    return $CategoryTableTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final int budgetId;
  final String name;
  final double definedAmount;
  final double realAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Category(
      {required this.id,
      required this.budgetId,
      required this.name,
      required this.definedAmount,
      required this.realAmount,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['budget_id'] = Variable<int>(budgetId);
    map['name'] = Variable<String>(name);
    map['defined_amount'] = Variable<double>(definedAmount);
    map['real_amount'] = Variable<double>(realAmount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoryTableCompanion toCompanion(bool nullToAbsent) {
    return CategoryTableCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      name: Value(name),
      definedAmount: Value(definedAmount),
      realAmount: Value(realAmount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      budgetId: serializer.fromJson<int>(json['budgetId']),
      name: serializer.fromJson<String>(json['name']),
      definedAmount: serializer.fromJson<double>(json['definedAmount']),
      realAmount: serializer.fromJson<double>(json['realAmount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'budgetId': serializer.toJson<int>(budgetId),
      'name': serializer.toJson<String>(name),
      'definedAmount': serializer.toJson<double>(definedAmount),
      'realAmount': serializer.toJson<double>(realAmount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Category copyWith(
          {int? id,
          int? budgetId,
          String? name,
          double? definedAmount,
          double? realAmount,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Category(
        id: id ?? this.id,
        budgetId: budgetId ?? this.budgetId,
        name: name ?? this.name,
        definedAmount: definedAmount ?? this.definedAmount,
        realAmount: realAmount ?? this.realAmount,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('definedAmount: $definedAmount, ')
          ..write('realAmount: $realAmount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, budgetId, name, definedAmount, realAmount, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.name == this.name &&
          other.definedAmount == this.definedAmount &&
          other.realAmount == this.realAmount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoryTableCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<int> budgetId;
  final Value<String> name;
  final Value<double> definedAmount;
  final Value<double> realAmount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CategoryTableCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.name = const Value.absent(),
    this.definedAmount = const Value.absent(),
    this.realAmount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CategoryTableCompanion.insert({
    this.id = const Value.absent(),
    required int budgetId,
    required String name,
    required double definedAmount,
    this.realAmount = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : budgetId = Value(budgetId),
        name = Value(name),
        definedAmount = Value(definedAmount),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<int>? budgetId,
    Expression<String>? name,
    Expression<double>? definedAmount,
    Expression<double>? realAmount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (name != null) 'name': name,
      if (definedAmount != null) 'defined_amount': definedAmount,
      if (realAmount != null) 'real_amount': realAmount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CategoryTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? budgetId,
      Value<String>? name,
      Value<double>? definedAmount,
      Value<double>? realAmount,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return CategoryTableCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      name: name ?? this.name,
      definedAmount: definedAmount ?? this.definedAmount,
      realAmount: realAmount ?? this.realAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<int>(budgetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (definedAmount.present) {
      map['defined_amount'] = Variable<double>(definedAmount.value);
    }
    if (realAmount.present) {
      map['real_amount'] = Variable<double>(realAmount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTableCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('definedAmount: $definedAmount, ')
          ..write('realAmount: $realAmount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TransactionTableTable extends TransactionTable
    with TableInfo<$TransactionTableTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES category_table (id) ON DELETE CASCADE'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, categoryId, amount, date, description, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_table';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TransactionTableTable createAlias(String alias) {
    return $TransactionTableTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final int categoryId;
  final double amount;
  final DateTime date;
  final String? description;
  final DateTime createdAt;
  const Transaction(
      {required this.id,
      required this.categoryId,
      required this.amount,
      required this.date,
      this.description,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionTableCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      amount: Value(amount),
      date: Value(date),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Transaction copyWith(
          {int? id,
          int? categoryId,
          double? amount,
          DateTime? date,
          Value<String?> description = const Value.absent(),
          DateTime? createdAt}) =>
      Transaction(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        description: description.present ? description.value : this.description,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, categoryId, amount, date, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class TransactionTableCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  const TransactionTableCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TransactionTableCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required double amount,
    required DateTime date,
    this.description = const Value.absent(),
    required DateTime createdAt,
  })  : categoryId = Value(categoryId),
        amount = Value(amount),
        date = Value(date),
        createdAt = Value(createdAt);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransactionTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? categoryId,
      Value<double>? amount,
      Value<DateTime>? date,
      Value<String?>? description,
      Value<DateTime>? createdAt}) {
    return TransactionTableCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTableCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PaymentTableTable extends PaymentTable
    with TableInfo<$PaymentTableTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _budgetIdMeta =
      const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<int> budgetId = GeneratedColumn<int>(
      'budget_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES budget_table (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, budgetId, name, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_table';
  @override
  VerificationContext validateIntegrity(Insertable<Payment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('budget_id')) {
      context.handle(_budgetIdMeta,
          budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta));
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      budgetId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}budget_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
    );
  }

  @override
  $PaymentTableTable createAlias(String alias) {
    return $PaymentTableTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final int id;
  final int budgetId;
  final String name;
  final double amount;
  const Payment(
      {required this.id,
      required this.budgetId,
      required this.name,
      required this.amount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['budget_id'] = Variable<int>(budgetId);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    return map;
  }

  PaymentTableCompanion toCompanion(bool nullToAbsent) {
    return PaymentTableCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      name: Value(name),
      amount: Value(amount),
    );
  }

  factory Payment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<int>(json['id']),
      budgetId: serializer.fromJson<int>(json['budgetId']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'budgetId': serializer.toJson<int>(budgetId),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
    };
  }

  Payment copyWith({int? id, int? budgetId, String? name, double? amount}) =>
      Payment(
        id: id ?? this.id,
        budgetId: budgetId ?? this.budgetId,
        name: name ?? this.name,
        amount: amount ?? this.amount,
      );
  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, budgetId, name, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.name == this.name &&
          other.amount == this.amount);
}

class PaymentTableCompanion extends UpdateCompanion<Payment> {
  final Value<int> id;
  final Value<int> budgetId;
  final Value<String> name;
  final Value<double> amount;
  const PaymentTableCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
  });
  PaymentTableCompanion.insert({
    this.id = const Value.absent(),
    required int budgetId,
    required String name,
    required double amount,
  })  : budgetId = Value(budgetId),
        name = Value(name),
        amount = Value(amount);
  static Insertable<Payment> custom({
    Expression<int>? id,
    Expression<int>? budgetId,
    Expression<String>? name,
    Expression<double>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
    });
  }

  PaymentTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? budgetId,
      Value<String>? name,
      Value<double>? amount}) {
    return PaymentTableCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<int>(budgetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentTableCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabaseManager get managers => _$AppDatabaseManager(this);
  late final $BudgetTableTable budgetTable = $BudgetTableTable(this);
  late final $CategoryTableTable categoryTable = $CategoryTableTable(this);
  late final $TransactionTableTable transactionTable =
      $TransactionTableTable(this);
  late final $PaymentTableTable paymentTable = $PaymentTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [budgetTable, categoryTable, transactionTable, paymentTable];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('category_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('transaction_table', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$BudgetTableTableInsertCompanionBuilder = BudgetTableCompanion
    Function({
  Value<int> id,
  required double definedAmount,
  Value<double> realAmount,
  required String currency,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$BudgetTableTableUpdateCompanionBuilder = BudgetTableCompanion
    Function({
  Value<int> id,
  Value<double> definedAmount,
  Value<double> realAmount,
  Value<String> currency,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$BudgetTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetTableTable,
    Budget,
    $$BudgetTableTableFilterComposer,
    $$BudgetTableTableOrderingComposer,
    $$BudgetTableTableProcessedTableManager,
    $$BudgetTableTableInsertCompanionBuilder,
    $$BudgetTableTableUpdateCompanionBuilder> {
  $$BudgetTableTableTableManager(_$AppDatabase db, $BudgetTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BudgetTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BudgetTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$BudgetTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<double> definedAmount = const Value.absent(),
            Value<double> realAmount = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              BudgetTableCompanion(
            id: id,
            definedAmount: definedAmount,
            realAmount: realAmount,
            currency: currency,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required double definedAmount,
            Value<double> realAmount = const Value.absent(),
            required String currency,
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              BudgetTableCompanion.insert(
            id: id,
            definedAmount: definedAmount,
            realAmount: realAmount,
            currency: currency,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
        ));
}

class $$BudgetTableTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $BudgetTableTable,
    Budget,
    $$BudgetTableTableFilterComposer,
    $$BudgetTableTableOrderingComposer,
    $$BudgetTableTableProcessedTableManager,
    $$BudgetTableTableInsertCompanionBuilder,
    $$BudgetTableTableUpdateCompanionBuilder> {
  $$BudgetTableTableProcessedTableManager(super.$state);
}

class $$BudgetTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $BudgetTableTable> {
  $$BudgetTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get definedAmount => $state.composableBuilder(
      column: $state.table.definedAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get realAmount => $state.composableBuilder(
      column: $state.table.realAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter categoryTableRefs(
      ComposableFilter Function($$CategoryTableTableFilterComposer f) f) {
    final $$CategoryTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.categoryTable,
        getReferencedColumn: (t) => t.budgetId,
        builder: (joinBuilder, parentComposers) =>
            $$CategoryTableTableFilterComposer(ComposerState($state.db,
                $state.db.categoryTable, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter paymentTableRefs(
      ComposableFilter Function($$PaymentTableTableFilterComposer f) f) {
    final $$PaymentTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.paymentTable,
        getReferencedColumn: (t) => t.budgetId,
        builder: (joinBuilder, parentComposers) =>
            $$PaymentTableTableFilterComposer(ComposerState($state.db,
                $state.db.paymentTable, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$BudgetTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $BudgetTableTable> {
  $$BudgetTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get definedAmount => $state.composableBuilder(
      column: $state.table.definedAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get realAmount => $state.composableBuilder(
      column: $state.table.realAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$CategoryTableTableInsertCompanionBuilder = CategoryTableCompanion
    Function({
  Value<int> id,
  required int budgetId,
  required String name,
  required double definedAmount,
  Value<double> realAmount,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$CategoryTableTableUpdateCompanionBuilder = CategoryTableCompanion
    Function({
  Value<int> id,
  Value<int> budgetId,
  Value<String> name,
  Value<double> definedAmount,
  Value<double> realAmount,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$CategoryTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoryTableTable,
    Category,
    $$CategoryTableTableFilterComposer,
    $$CategoryTableTableOrderingComposer,
    $$CategoryTableTableProcessedTableManager,
    $$CategoryTableTableInsertCompanionBuilder,
    $$CategoryTableTableUpdateCompanionBuilder> {
  $$CategoryTableTableTableManager(_$AppDatabase db, $CategoryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CategoryTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CategoryTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$CategoryTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> budgetId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> definedAmount = const Value.absent(),
            Value<double> realAmount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CategoryTableCompanion(
            id: id,
            budgetId: budgetId,
            name: name,
            definedAmount: definedAmount,
            realAmount: realAmount,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int budgetId,
            required String name,
            required double definedAmount,
            Value<double> realAmount = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              CategoryTableCompanion.insert(
            id: id,
            budgetId: budgetId,
            name: name,
            definedAmount: definedAmount,
            realAmount: realAmount,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
        ));
}

class $$CategoryTableTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $CategoryTableTable,
    Category,
    $$CategoryTableTableFilterComposer,
    $$CategoryTableTableOrderingComposer,
    $$CategoryTableTableProcessedTableManager,
    $$CategoryTableTableInsertCompanionBuilder,
    $$CategoryTableTableUpdateCompanionBuilder> {
  $$CategoryTableTableProcessedTableManager(super.$state);
}

class $$CategoryTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CategoryTableTable> {
  $$CategoryTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get definedAmount => $state.composableBuilder(
      column: $state.table.definedAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get realAmount => $state.composableBuilder(
      column: $state.table.realAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$BudgetTableTableFilterComposer get budgetId {
    final $$BudgetTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.budgetId,
        referencedTable: $state.db.budgetTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$BudgetTableTableFilterComposer(ComposerState($state.db,
                $state.db.budgetTable, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter transactionTableRefs(
      ComposableFilter Function($$TransactionTableTableFilterComposer f) f) {
    final $$TransactionTableTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.transactionTable,
            getReferencedColumn: (t) => t.categoryId,
            builder: (joinBuilder, parentComposers) =>
                $$TransactionTableTableFilterComposer(ComposerState($state.db,
                    $state.db.transactionTable, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$CategoryTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CategoryTableTable> {
  $$CategoryTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get definedAmount => $state.composableBuilder(
      column: $state.table.definedAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get realAmount => $state.composableBuilder(
      column: $state.table.realAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$BudgetTableTableOrderingComposer get budgetId {
    final $$BudgetTableTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.budgetId,
        referencedTable: $state.db.budgetTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$BudgetTableTableOrderingComposer(ComposerState($state.db,
                $state.db.budgetTable, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$TransactionTableTableInsertCompanionBuilder
    = TransactionTableCompanion Function({
  Value<int> id,
  required int categoryId,
  required double amount,
  required DateTime date,
  Value<String?> description,
  required DateTime createdAt,
});
typedef $$TransactionTableTableUpdateCompanionBuilder
    = TransactionTableCompanion Function({
  Value<int> id,
  Value<int> categoryId,
  Value<double> amount,
  Value<DateTime> date,
  Value<String?> description,
  Value<DateTime> createdAt,
});

class $$TransactionTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionTableTable,
    Transaction,
    $$TransactionTableTableFilterComposer,
    $$TransactionTableTableOrderingComposer,
    $$TransactionTableTableProcessedTableManager,
    $$TransactionTableTableInsertCompanionBuilder,
    $$TransactionTableTableUpdateCompanionBuilder> {
  $$TransactionTableTableTableManager(
      _$AppDatabase db, $TransactionTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TransactionTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TransactionTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$TransactionTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TransactionTableCompanion(
            id: id,
            categoryId: categoryId,
            amount: amount,
            date: date,
            description: description,
            createdAt: createdAt,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int categoryId,
            required double amount,
            required DateTime date,
            Value<String?> description = const Value.absent(),
            required DateTime createdAt,
          }) =>
              TransactionTableCompanion.insert(
            id: id,
            categoryId: categoryId,
            amount: amount,
            date: date,
            description: description,
            createdAt: createdAt,
          ),
        ));
}

class $$TransactionTableTableProcessedTableManager
    extends ProcessedTableManager<
        _$AppDatabase,
        $TransactionTableTable,
        Transaction,
        $$TransactionTableTableFilterComposer,
        $$TransactionTableTableOrderingComposer,
        $$TransactionTableTableProcessedTableManager,
        $$TransactionTableTableInsertCompanionBuilder,
        $$TransactionTableTableUpdateCompanionBuilder> {
  $$TransactionTableTableProcessedTableManager(super.$state);
}

class $$TransactionTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TransactionTableTable> {
  $$TransactionTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$CategoryTableTableFilterComposer get categoryId {
    final $$CategoryTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $state.db.categoryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CategoryTableTableFilterComposer(ComposerState($state.db,
                $state.db.categoryTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$TransactionTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TransactionTableTable> {
  $$TransactionTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$CategoryTableTableOrderingComposer get categoryId {
    final $$CategoryTableTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.categoryId,
            referencedTable: $state.db.categoryTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$CategoryTableTableOrderingComposer(ComposerState($state.db,
                    $state.db.categoryTable, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$PaymentTableTableInsertCompanionBuilder = PaymentTableCompanion
    Function({
  Value<int> id,
  required int budgetId,
  required String name,
  required double amount,
});
typedef $$PaymentTableTableUpdateCompanionBuilder = PaymentTableCompanion
    Function({
  Value<int> id,
  Value<int> budgetId,
  Value<String> name,
  Value<double> amount,
});

class $$PaymentTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentTableTable,
    Payment,
    $$PaymentTableTableFilterComposer,
    $$PaymentTableTableOrderingComposer,
    $$PaymentTableTableProcessedTableManager,
    $$PaymentTableTableInsertCompanionBuilder,
    $$PaymentTableTableUpdateCompanionBuilder> {
  $$PaymentTableTableTableManager(_$AppDatabase db, $PaymentTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PaymentTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PaymentTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$PaymentTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> budgetId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> amount = const Value.absent(),
          }) =>
              PaymentTableCompanion(
            id: id,
            budgetId: budgetId,
            name: name,
            amount: amount,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int budgetId,
            required String name,
            required double amount,
          }) =>
              PaymentTableCompanion.insert(
            id: id,
            budgetId: budgetId,
            name: name,
            amount: amount,
          ),
        ));
}

class $$PaymentTableTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $PaymentTableTable,
    Payment,
    $$PaymentTableTableFilterComposer,
    $$PaymentTableTableOrderingComposer,
    $$PaymentTableTableProcessedTableManager,
    $$PaymentTableTableInsertCompanionBuilder,
    $$PaymentTableTableUpdateCompanionBuilder> {
  $$PaymentTableTableProcessedTableManager(super.$state);
}

class $$PaymentTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PaymentTableTable> {
  $$PaymentTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$BudgetTableTableFilterComposer get budgetId {
    final $$BudgetTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.budgetId,
        referencedTable: $state.db.budgetTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$BudgetTableTableFilterComposer(ComposerState($state.db,
                $state.db.budgetTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$PaymentTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PaymentTableTable> {
  $$PaymentTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$BudgetTableTableOrderingComposer get budgetId {
    final $$BudgetTableTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.budgetId,
        referencedTable: $state.db.budgetTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$BudgetTableTableOrderingComposer(ComposerState($state.db,
                $state.db.budgetTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class _$AppDatabaseManager {
  final _$AppDatabase _db;
  _$AppDatabaseManager(this._db);
  $$BudgetTableTableTableManager get budgetTable =>
      $$BudgetTableTableTableManager(_db, _db.budgetTable);
  $$CategoryTableTableTableManager get categoryTable =>
      $$CategoryTableTableTableManager(_db, _db.categoryTable);
  $$TransactionTableTableTableManager get transactionTable =>
      $$TransactionTableTableTableManager(_db, _db.transactionTable);
  $$PaymentTableTableTableManager get paymentTable =>
      $$PaymentTableTableTableManager(_db, _db.paymentTable);
}
