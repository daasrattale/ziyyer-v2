class FinancialCalculations {
  static double calculateInterest(double principal, double rate, int time) {
    return principal * rate * time / 100;
  }

  static double calculateCompoundInterest(double principal, double rate, int time, int n) {
    return principal * (1 + rate / n).pow(n * time) - principal;
  }

  static double calculateBalance(List<double> incomes, List<double> expenses) {
    double totalIncome = incomes.reduce((a, b) => a + b);
    double totalExpense = expenses.reduce((a, b) => a + b);
    return totalIncome - totalExpense;
  }

  // Add more calculation methods
}

extension on double {
  double pow(int exponent) {
    double result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= this;
    }
    return result;
  }
}
