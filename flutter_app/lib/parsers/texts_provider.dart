import 'package:http/http.dart' as http;
import 'dart:async';

import '../model/text_sets.dart';

abstract class TextsProvider {
  RegExp stripHtmlTagsRegex =
      RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  String getProviderUrlForDate(DateTime date);
  String getProviderNameForDisplay();
  TextsSet parse(String body);

  Future<TextsSet> get(DateTime date) async {
    var response = await http.get(Uri.parse(getProviderUrlForDate(date)));
    TextsSet texts = parse(response.body
        .replaceAll("Palabra de Dios.", "")
        .replaceAll("Palabra del Señor.", ""));
    texts.setDate(date);
    return texts;
  }

  @override
  bool operator ==(other) {
    if (other is! TextsProvider && other is! String) return false;
    if (other is TextsProvider) {
      return other.getProviderNameForDisplay() == getProviderNameForDisplay();
    }
    if (other is String) return other == getProviderNameForDisplay();
    return false;
  }

  String getUrlForDisplay() {
    var url = getProviderUrlForDate(DateTime.now());
    var https = url.contains("https");
    url = url.replaceAll("https://", "");
    url = url.replaceAll("http://", "");
    return ((https) ? "https://" : "http://") + url.split("/")[0];
  }
}
