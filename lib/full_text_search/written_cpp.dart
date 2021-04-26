import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

/// return boolean 0 == false; 1 == true;
typedef fullTextSearchFunc = Int32 Function(
    Pointer<Utf8> searchText, Pointer<Utf8> texts);
typedef FullTextSearch = int Function(
    Pointer<Utf8> searchText, Pointer<Utf8> texts);

class WritenCpp {
  static final WritenCpp _singleton = WritenCpp._internal();
  WritenCpp._internal();

  factory WritenCpp() {
    return _singleton;
  }

  DynamicLibrary initLibrary() {
    final DynamicLibrary library = Platform.isAndroid
        ? DynamicLibrary.open("text_search.so")
        : DynamicLibrary.process();
    return library;
  }

  TextsStore get _textsStore => TextsStore();

  Map<Pointer<Utf8>, Pointer<Utf8>> _checkTextsStore(
      Map<String, String> texts) {
    // TODO: ハッシュで比較
    if (_textsStore.data.length == 0) {
      _textsStore.setTexts(texts);
      return _textsStore.data;
    } else {
      return _textsStore.data;
    }
  }

  Map<String, String> searchText(
      {required String searchText,required Map<String, String> texts}) {
    final nativetexts = _checkTextsStore(texts);
    final nativeSearchText = searchText.toNativeUtf8();

    final library = initLibrary();
    final cppTextSearch = library
        .lookup<NativeFunction<fullTextSearchFunc>>("full_text_search")
        .asFunction<FullTextSearch>();

    final Map<String, String> results = {};

    for (final textMap in nativetexts.entries.toList()) {
      final key = textMap.key;
      final text = textMap.value;

      //Stopwatch stopwatch = Stopwatch();
      //stopwatch.start();
      final hasMatch = cppTextSearch(nativeSearchText, text);
      //stopwatch.stop();
      //print(stopwatch.elapsedMicroseconds);

      if (hasMatch == 1) {
        results.addAll({key.toDartString(): text.toDartString()});
      }
    }
    return results;
  }

  Map<String, String> orSearch(
      {required List<String> searchTexts,required Map<String, String> texts}) {
    final nativetexts = _checkTextsStore(texts);

    final library = initLibrary();
    final cppTextSearch = library
        .lookup<NativeFunction<fullTextSearchFunc>>("full_text_search")
        .asFunction<FullTextSearch>();
    final Map<String, String> results = {};
    for (final searchText in searchTexts) {
      final nativeSearchText = searchText.toNativeUtf8();
      for (final textMap in nativetexts.entries.toList()) {
        final key = textMap.key;
        final text = textMap.value;

        //Stopwatch stopwatch = Stopwatch();
        //stopwatch.start();
        final hasMatch = cppTextSearch(nativeSearchText, text);
        //stopwatch.stop();
        //print(stopwatch.elapsedMicroseconds);

        if (hasMatch == 1) {
          results.addAll({key.toDartString(): text.toDartString()});
        }
      }
    }
    return results;
  }

  static bool _intToBool(int value) => (value == 1) ? true : false;
}

class TextsStore {
  static final TextsStore _singleton = TextsStore._internal();
  TextsStore._internal();

  factory TextsStore() {
    return _singleton;
  }

  Map<Pointer<Utf8>, Pointer<Utf8>> data = {};

  void setTexts(Map<String, String> texts) {
    final resulsts = <Pointer<Utf8>, Pointer<Utf8>>{};
    for (final textMap in texts.entries.toList()) {
      final key = textMap.key;
      final text = textMap.value;
      resulsts.addAll({key.toNativeUtf8(): text.toNativeUtf8()});
    }
    data = resulsts;
  }
}
