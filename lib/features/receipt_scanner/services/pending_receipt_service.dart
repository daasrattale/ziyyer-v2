import 'package:flutter/foundation.dart';
import 'package:ziyyer/features/receipt_scanner/services/receipt_parser.dart';

class PendingReceiptService {
  static ParsedReceipt? _pendingReceipt;
  static final ValueNotifier<bool> _hasReceipt = ValueNotifier(false);

  static ValueNotifier<bool> get hasReceipt => _hasReceipt;

  static void set(ParsedReceipt receipt) {
    _pendingReceipt = receipt;
    _hasReceipt.value = true;
  }

  static ParsedReceipt? consume() {
    final receipt = _pendingReceipt;
    _pendingReceipt = null;
    _hasReceipt.value = false;
    return receipt;
  }

  static bool get hasPending => _pendingReceipt != null;
}
