import 'package:http/http.dart' as http;
import 'dart:async';

import '../model/text_sets.dart';

abstract class Provider {
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
}

class Providers {
  static const int CiudadRedonda = 0x01;
  static const int Buigle = 0x02;
}
