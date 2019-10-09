import 'dart:collection';

import 'package:evangelios/Model/TextsSet.dart';
import 'package:evangelios/Parsers/BuigleProvider.dart';
import 'package:evangelios/Parsers/CiudadRedondaProvider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

abstract class Provider {
  static List<String> registeredProviders = ["CiudadRedonda", "Buigle"];

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

  static Provider getInstance(String provider){
    if (registeredProviders.contains(provider)){
      switch(provider){
        case "CiudadRedonda": return CiudadRedondaProvider();
        case "Buigle": return BuigleProvider();
      }
    }
    return null;
  }

}
