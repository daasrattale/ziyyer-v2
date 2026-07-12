class ParsedReceipt {
  final double? amount;
  final DateTime? date;
  final String? description;
  final String? paymentMethod;
  final String? status;

  const ParsedReceipt({
    this.amount,
    this.date,
    this.description,
    this.paymentMethod,
    this.status,
  });
}

class ReceiptParser {
  static final _totalPatterns = [
    RegExp(r'(?:^|\b)TOTAL\b.*?(\d+[.,]\d{2})', caseSensitive: false),
    RegExp(r'(?:^|\b)GRAND\s+TOTAL\b.*?(\d+[.,]\d{2})', caseSensitive: false),
    RegExp(r'(?:^|\b)AMOUNT\s+DUE\b.*?(\d+[.,]\d{2})', caseSensitive: false),
    RegExp(r'(?:^|\b)BALANCE\s+DUE\b.*?(\d+[.,]\d{2})', caseSensitive: false),
    RegExp(r'(\d+[.,]\d{2}).*?(?:^|\b)TOTAL\b', caseSensitive: false),
  ];

  static final _amountPatterns = [
    RegExp(r'[\$€£¥]\s*(\d+[.,]\d{2})'),
    RegExp(r'(\d+[.,]\d{2})\s*[\$€£¥]'),
  ];

  static final _datePatterns = [
    RegExp(r'(\d{1,2})[/\-.](\d{1,2})[/\-.](\d{2,4})'),
    RegExp(r'(\d{4})[/\-.](\d{1,2})[/\-.](\d{1,2})'),
    RegExp(r'(\d{1,2})\s+(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\s+(\d{2,4})', caseSensitive: false),
    RegExp(r'(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\s+(\d{1,2}),?\s+(\d{2,4})', caseSensitive: false),
  ];

  static final _timePatterns = [
    RegExp(r'(\d{1,2}:\d{2}(?::\d{2})?)\s*(AM|PM|am|pm)?', caseSensitive: false),
    RegExp(r'(\d{1,2})\s*(AM|PM|am|pm)', caseSensitive: false),
  ];

  static final _phonePatterns = [
    RegExp(r'[\(]?\d{3}[)\.\-\s]?\d{3}[\.\-\s]?\d{4}'),
    RegExp(r'\+\d{1,3}[\s.\-]?\d{1,4}[\s.\-]?\d{2,4}[\s.\-]?\d{2,4}'),
  ];

  static final _addressPatterns = [
    RegExp(r'\d{1,5}\s+[\w\s]+(?:St|Street|Ave|Avenue|Blvd|Boulevard|Dr|Drive|Rd|Road|Ln|Lane|Ct|Court|Pl|Place|Way|Cir|Circle)\.?', caseSensitive: false),
    RegExp(r'[\w\s]+,\s*[A-Z]{2}\s+\d{5}(?:-\d{4})?'),
  ];

  static final _skipWords = [
    'total', 'amount', 'subtotal', 'sub total', 'tax', 'vat', 'hst', 'gst',
    'change', 'cash', 'card', 'credit', 'debit', 'visa', 'mastercard',
    'receipt', 'invoice', 'transaction', 'auth', 'approval', 'reference',
    'terminal', 'batch', 'order', 'check', 'tip', 'discount', 'savings',
    'member', 'loyalty', 'points', 'rewards', 'phone', 'tel', 'fax',
    'website', 'www', 'email', 'thank', 'welcome', 'return', 'policy',
    'item', 'qty', 'quantity', 'price', 'unit', 'description',
    'paid', 'balance', 'due', 'tender', 'payment', 'status',
  ];

  static final _paymentMethodMap = {
    'cash': 'cash',
    'credit': 'credit_card',
    'credit card': 'credit_card',
    'visa': 'credit_card',
    'mastercard': 'credit_card',
    'amex': 'credit_card',
    'debit': 'debit_card',
    'debit card': 'debit_card',
    'apple pay': 'apple_pay',
    'applepay': 'apple_pay',
    'google pay': 'other',
    'gpay': 'other',
    'bank transfer': 'bank_transfer',
    'wire': 'bank_transfer',
    'check': 'other',
    'cheque': 'other',
  };

  static ParsedReceipt parse(String text) {
    final lines = text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();

    final amount = _extractTotal(text) ?? _extractAmount(text);
    final dateRaw = _extractDate(text, lines);
    final time = _extractTime(text);
    final date = _mergeTimeIntoDate(dateRaw, time);
    final paymentMethod = _extractPaymentMethod(lines);
    final status = _extractStatus(lines);
    final businessName = _extractBusinessName(lines);
    final address = _extractAddress(lines);
    final phone = _extractPhone(lines);
    final description = _buildDescription(
      businessName: businessName,
      date: date,
      time: time,
      address: address,
      phone: phone,
    );

    return ParsedReceipt(
      amount: amount,
      date: date,
      description: description,
      paymentMethod: paymentMethod,
      status: status,
    );
  }

  static double? _extractTotal(String text) {
    final lines = text.split('\n');

    for (final line in lines) {
      final lower = line.toLowerCase().trim();
      final isTotalLine = RegExp(r'(?:^|\b)total\b').hasMatch(lower) &&
          !lower.contains('subtotal') &&
          !lower.contains('sub total');
      if (!isTotalLine) continue;

      for (final pattern in _amountPatterns) {
        final match = pattern.firstMatch(line);
        if (match != null) {
          final valueStr = match.group(1);
          if (valueStr != null) {
            final normalized = valueStr.replaceAll(',', '.');
            final value = double.tryParse(normalized);
            if (value != null && value > 0 && value < 1000000) {
              return value;
            }
          }
        }
      }
    }

    for (final pattern in _totalPatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final valueStr = match.group(1);
        if (valueStr != null) {
          final normalized = valueStr.replaceAll(',', '.');
          final value = double.tryParse(normalized);
          if (value != null && value > 0 && value < 1000000) {
            return value;
          }
        }
      }
    }

    return null;
  }

  static double? _extractAmount(String text) {
    final lines = text.split('\n');

    for (final line in lines.reversed) {
      final lower = line.toLowerCase();
      if (lower.contains('total') || lower.contains('amount due') || lower.contains('balance')) {
        for (final pattern in _amountPatterns) {
          final match = pattern.firstMatch(line);
          if (match != null) {
            final valueStr = match.group(1);
            if (valueStr != null) {
              final normalized = valueStr.replaceAll(',', '.');
              final value = double.tryParse(normalized);
              if (value != null && value > 0 && value < 1000000) {
                return value;
              }
            }
          }
        }
      }
    }

    for (final pattern in _amountPatterns) {
      final matches = pattern.allMatches(text);
      double? largest;
      for (final match in matches) {
        final valueStr = match.group(1);
        if (valueStr != null) {
          final normalized = valueStr.replaceAll(',', '.');
          final value = double.tryParse(normalized);
          if (value != null && value > 0 && value < 1000000) {
            if (largest == null || value > largest) {
              largest = value;
            }
          }
        }
      }
      if (largest != null) return largest;
    }
    return null;
  }

  static DateTime? _extractDate(String text, List<String> lines) {
    for (final line in lines) {
      final lower = line.toLowerCase();
      if (lower.startsWith('date') || lower.contains('date:')) {
        for (final pattern in _datePatterns) {
          final match = pattern.firstMatch(line);
          if (match != null) {
            try {
              final groups = match.groups([1, 2, 3]);
              return _parseDateFromGroups(pattern, groups);
            } catch (_) {
              continue;
            }
          }
        }
      }
    }

    for (final pattern in _datePatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        try {
          final groups = match.groups([1, 2, 3]);
          return _parseDateFromGroups(pattern, groups);
        } catch (_) {
          continue;
        }
      }
    }
    return null;
  }

  static DateTime? _parseDateFromGroups(RegExp pattern, List<String?> groups) {
    if (pattern == _datePatterns[0] || pattern == _datePatterns[1]) {
      return _parseNumericDate(groups[0]!, groups[1]!, groups[2]!);
    }
    if (pattern == _datePatterns[2]) {
      return _parseMonthFirstDate(groups[0]!, groups[1]!, groups[2]!);
    }
    if (pattern == _datePatterns[3]) {
      return _parseMonthFirstDate(groups[1]!, groups[0]!, groups[2]!);
    }
    return null;
  }

  static DateTime? _parseNumericDate(String first, String second, String third) {
    final a = int.tryParse(first);
    final b = int.tryParse(second);
    final c = int.tryParse(third);
    if (a == null || b == null || c == null) return null;

    if (c > 31) {
      return DateTime(c, a, b);
    } else if (a > 31) {
      return DateTime(a, b, c);
    } else {
      final year = c < 100 ? 2000 + c : c;
      return DateTime(year, a, b);
    }
  }

  static DateTime? _parseMonthFirstDate(String monthStr, String dayStr, String yearStr) {
    final months = {
      'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
      'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
    };
    final monthKey = monthStr.substring(0, 3).toLowerCase();
    final month = months[monthKey];
    final day = int.tryParse(dayStr);
    final year = int.tryParse(yearStr);
    if (month == null || day == null || year == null) return null;

    return DateTime(year < 100 ? 2000 + year : year, month, day);
  }

  static String? _extractTime(String text) {
    for (final pattern in _timePatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final time = match.group(1);
        final period = match.group(2);
        if (time != null) {
          if (period != null) {
            return '$time $period'.toUpperCase();
          }
          return time;
        }
      }
    }
    return null;
  }

  static DateTime? _mergeTimeIntoDate(DateTime? date, String? timeStr) {
    if (date == null || timeStr == null) return date;

    final hour = _parseHour(timeStr);
    final minute = _parseMinute(timeStr) ?? 0;
    if (hour == null) return date;

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  static int? _parseHour(String timeStr) {
    final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(timeStr);
    if (match == null) return null;

    var hour = int.tryParse(match.group(1)!);
    if (hour == null) return null;

    final isPM = timeStr.toUpperCase().contains('PM');
    final isAM = timeStr.toUpperCase().contains('AM');

    if (isPM && hour < 12) {
      hour += 12;
    } else if (isAM && hour == 12) {
      hour = 0;
    }

    return hour;
  }

  static int? _parseMinute(String timeStr) {
    final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(timeStr);
    if (match == null) return null;
    return int.tryParse(match.group(2)!);
  }

  static String? _extractPaymentMethod(List<String> lines) {
    for (final line in lines) {
      final lower = line.toLowerCase().trim();

      if (lower.startsWith('payment') || lower.startsWith('tender') || lower.startsWith('method') || lower.startsWith('paid by')) {
        final cleaned = line.replaceAll(RegExp(r'^(payment|tender|method|paid\s*by)\s*[:\-\s]*', caseSensitive: false), '').trim().toLowerCase();

        for (final entry in _paymentMethodMap.entries) {
          if (cleaned.contains(entry.key)) {
            return entry.value;
          }
        }

        if (cleaned.isNotEmpty) {
          return 'other';
        }
      }
    }

    for (final line in lines) {
      final lower = line.toLowerCase().trim();
      for (final entry in _paymentMethodMap.entries) {
        if (lower == entry.key) {
          return entry.value;
        }
      }
    }

    return null;
  }

  static String? _extractStatus(List<String> lines) {
    for (final line in lines) {
      final lower = line.toLowerCase().trim();

      if (lower.startsWith('status') || lower.startsWith('result') || lower.startsWith('approval')) {
        final cleaned = line.replaceAll(RegExp(r'^(status|result|approval)\s*[:\-\s]*', caseSensitive: false), '').trim();
        if (cleaned.isNotEmpty) {
          return cleaned.toUpperCase();
        }
      }
    }
    return null;
  }

  static String? _extractBusinessName(List<String> lines) {
    for (final line in lines.take(6)) {
      final lower = line.toLowerCase();

      final isSkipLine = _skipWords.any((w) => lower.startsWith(w)) ||
          _isDateLine(line) ||
          _isTimeLine(line) ||
          _isAddressLine(line) ||
          _isPhoneNumber(line) ||
          RegExp(r'^\d+$').hasMatch(line) ||
          RegExp(r'^[\$€£¥\d.,\s]+$').hasMatch(line);

      if (!isSkipLine && line.length >= 2 && line.length <= 40) {
        return line.trim();
      }
    }
    return lines.isNotEmpty ? lines.first.trim() : null;
  }

  static String? _extractAddress(List<String> lines) {
    for (final line in lines) {
      if (_isAddressLine(line)) {
        return line.trim();
      }
    }
    return null;
  }

  static bool _isAddressLine(String line) {
    for (final pattern in _addressPatterns) {
      if (pattern.hasMatch(line)) return true;
    }
    return false;
  }

  static bool _isDateLine(String line) {
    for (final pattern in _datePatterns) {
      if (pattern.hasMatch(line)) return true;
    }
    return false;
  }

  static bool _isTimeLine(String line) {
    for (final pattern in _timePatterns) {
      if (pattern.hasMatch(line)) return true;
    }
    return false;
  }

  static String? _extractPhone(List<String> lines) {
    final allText = lines.join(' ');
    for (final pattern in _phonePatterns) {
      final match = pattern.firstMatch(allText);
      if (match != null) {
        final phone = match.group(0)?.trim();
        if (phone != null && phone.length >= 10) {
          return phone;
        }
      }
    }
    return null;
  }

  static bool _isPhoneNumber(String line) {
    for (final pattern in _phonePatterns) {
      if (pattern.hasMatch(line)) return true;
    }
    return false;
  }

  static String? _buildDescription({
    String? businessName,
    DateTime? date,
    String? time,
    String? address,
    String? phone,
  }) {
    final parts = <String>[];

    if (businessName != null && businessName.isNotEmpty) {
      parts.add(businessName);
    }

    if (date != null) {
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      if (time != null) {
        parts.add('$dateStr $time');
      } else {
        parts.add(dateStr);
      }
    } else if (time != null) {
      parts.add(time);
    }

    final locationParts = <String>[];
    if (address != null && address.isNotEmpty) {
      locationParts.add(address);
    }
    if (phone != null && phone.isNotEmpty) {
      locationParts.add(phone);
    }
    if (locationParts.isNotEmpty) {
      parts.add(locationParts.join(', '));
    }

    return parts.isEmpty ? null : parts.join(' - ');
  }
}
