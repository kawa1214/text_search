export 'full_text_search/written_cpp.dart';
export 'full_text_search/written_dart.dart';

import 'package:flutter/services.dart';

class TextSearch {
  static final TextSearch _singleton = TextSearch._internal();
  TextSearch._internal();

  factory TextSearch() {
    return _singleton;
  }
  final _channel = const MethodChannel('text_search');

  Future<List<String>> tokenize(String text) async {
    final tokenized = <String>[];
    final List<dynamic> result = await _channel.invokeMethod('handle', text);
    for (final token in result) {
      if (token is String) {
        tokenized.add(token);
      }
    }
    return tokenized;
  }

  Future<Map<String, List<String>>> tokenizedMap(
    Map<String, String> texts,
  ) async {
    final Map<String, List<String>> tokenizedTexts = {};
    final Map<String, List<String>> futures = {};
    for (final textMap in texts.entries.toList()) {
      final key = textMap.key;
      final text = textMap.value;
      final tokenizedText = await tokenize(text);
      tokenizedTexts.addAll({key: tokenizedText});
    }
    return tokenizedTexts;
  }

  Map<String, String> scored(List<String> search, Map<String, List<String>> texts) {
    final Map<String, String>scored = {};
    for (final textMap in texts.entries.toList()) {
      final key = textMap.key;
      final strings = textMap.value;
      final count = search.map((e) => strings.contains(e)).where((e) => e).length;//strings.map((e) => search.contains(e)).length;
      final score = count/search.length;
      scored.addAll({'key': key, 'score': score.toString()});
    }
    return scored;
  }

  Future<Map<String, String>> scoreTextSearch({
    required String searchText,
    required Map<String, String> texts,
  }) async {
    final tokenizedSearchText = await tokenize(searchText);
    final tokenizedTexts = await tokenizedMap(texts);
    final scoreling = scored(tokenizedSearchText, tokenizedTexts);
    print(scoreling);
    final sorted = scoreling.entries.toList().sort((a, b){
      print('test: ${a.key}');
      return a.value.compareTo(b.value);
    });
    
    //final sorted = scoreling.entries.toList().sort((a, b)=> double.parse(a.value).compareTo(double.parse(b.value)));
    return scoreling;
  }

  static Map<String, String> search({
    required String searchText,
    required Map<String, String> texts,
  }) {
    final Map<String, String> results = {};
    final reg = RegExp(searchText);

    for (final textMap in texts.entries.toList()) {
      final key = textMap.key;
      final text = textMap.value;
      final hasMatch = reg.hasMatch(text);

      if (hasMatch) {
        results.addAll({key: text});
      }
    }
    return results;
  }

  static Map<String, String> orSearch({
    required List<String> searchTexts,
    required Map<String, String> texts,
  }) {
    final Map<String, String> results = {};
    for (final searchText in searchTexts) {
      final reg = RegExp(searchText);

      for (final textMap in texts.entries.toList()) {
        final key = textMap.key;
        final text = textMap.value;
        final hasMatch = reg.hasMatch(text);

        if (hasMatch) {
          results.addAll({key: text});
        }
      }
    }
    return results;
  }
}
