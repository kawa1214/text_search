class WrittenDart {
  static final WrittenDart _singleton = WrittenDart._internal();
  WrittenDart._internal();

  factory WrittenDart() {
    return _singleton;
  }

  Map<String, String> searchText({String searchText, Map<String, String> texts}) {
    final Map<String, String> results = {};
    final reg = RegExp(searchText);

    for (final textMap in texts.entries.toList()) {
      final key = textMap.key;
      final text = textMap.value;
      // final hasMatch = text.contains(searchText); //遅い
      final hasMatch = reg.hasMatch(text);
      
      if (hasMatch) {
        results.addAll({key: text});
      }
    }
    return results;
  }
}
