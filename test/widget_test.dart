import 'package:flutter_test/flutter_test.dart';

// Widget and UI tests are in development.
// Service layer tests are located in services_test.dart
//
// For comprehensive testing of business logic and data persistence,
// see test/services_test.dart which includes:
// - AccountService tests
// - TransactionService tests
// - BudgetService tests
// - Integration tests
//
// To run tests:
//   flutter test

int add(int a, int b) => a + b;

void main() {
  group('Math utils', () {
    test('add returns correct sum', () {
      expect(add(2, 3), equals(5));
    });

    test('add handles negative numbers', () {
      expect(add(-1, 1), equals(0));
    });
  });
}
