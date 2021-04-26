class WrittenDart {
  static final WrittenDart _singleton = WrittenDart._internal();
  WrittenDart._internal();

  factory WrittenDart() {
    return _singleton;
  }

  /// https://github.com/gcc-mirror/gcc/blob/16e2427f50c208dfe07d07f18009969502c25dc8/libstdc%2B%2B-v3/include/bits/basic_string.tcc#L1200

  Map<String, String> searchText(
      {required String searchText,required Map<String, String> texts}) {
    final Map<String, String> results = {};
    final reg = RegExp(searchText);

    for (final textMap in texts.entries.toList()) {
      final key = textMap.key;
      final text = textMap.value;
      // final hasMatch = text.contains(searchText); //遅い → regexpが使われている
      final hasMatch = reg.hasMatch(text);

      if (hasMatch) {
        results.addAll({key: text});
      }
    }
    return results;
  }

  Map<String, String> orSearch(
      {required List<String> searchTexts,required Map<String, String> texts}) {
    final Map<String, String> results = {};
    for (final searchText in searchTexts) {
      final reg = RegExp(searchText);

      for (final textMap in texts.entries.toList()) {
        final key = textMap.key;
        final text = textMap.value;
        // final hasMatch = text.contains(searchText); //遅い → regexpが使われている
        final hasMatch = reg.hasMatch(text);

        if (hasMatch) {
          results.addAll({key: text});
        }
      }
    }
    return results;
  }
}
