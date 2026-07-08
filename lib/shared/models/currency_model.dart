class CurrencyModel {
  final String code;
  final String symbol;
  final String name;

  const CurrencyModel(this.code, this.symbol, this.name);

  @override
  String toString() {
    return 'code=$code symbol=$symbol name=$name';
  }
}
