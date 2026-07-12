import 'package:flutter/services.dart';

class TextRecognitionService {
  static const _channel = MethodChannel('dev.daasrattale.ziyyer/text_recognition');

  static Future<String> recognizeText(String imagePath) async {
    final result = await _channel.invokeMethod<String>(
      'recognizeText',
      {'imagePath': imagePath},
    );
    return result ?? '';
  }
}
