
import 'dart:async';

import 'package:flutter/services.dart';
export 'full_text_search/written_cpp.dart';
export 'full_text_search/written_dart.dart';
class TextSearch {
  static const MethodChannel _channel =
      const MethodChannel('text_search');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
