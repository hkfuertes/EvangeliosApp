import 'package:evangelios/Model/TextsSet.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

abstract class Provider {
  RegExp stripHtmlTagsRegex = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true
    );

  String getProviderUrlForDate(DateTime date);
  String getProviderNameForDisplay();
  TextsSet parse(String body);

  Future<TextsSet> get (DateTime date) async{
    var response = await http.get(getProviderUrlForDate(date));
    TextsSet texts = parse(response.body);
    texts.setDate(date);
    return texts;
  }

}
