import 'package:intl/intl.dart';
import 'package:html/parser.dart' as Parser;
import 'package:lecturas/parsers/misas_navarra_provider.dart';

import '../model/text_sets.dart';
import 'provider.dart';

class BuigleProvider extends Provider {
  RegExp firstRegex =
      RegExp(r'PRIMERA LECTURA.*SALMO', multiLine: true, dotAll: true);
  RegExp secondRegex =
      RegExp(r"SEGUNDA LECTURA.*Aleluya", multiLine: true, dotAll: true);
  RegExp psalmRegex =
      RegExp(r"SALMO RESPONSORIAL.*Aleluya", multiLine: true, dotAll: true);
  RegExp psalmSundayRegex =
      RegExp(r"SALMO RESPONSORIAL.*SEGUNDA", multiLine: true, dotAll: true);
  RegExp godspellRegex =
      RegExp(r"EVANGELIO.*Palabra del Señor", multiLine: true, dotAll: true);

  @override
  String getProviderNameForDisplay() {
    return "Buigle";
  }

  @override
  String getProviderUrlForDate(DateTime date) {
    DateFormat _formatter = DateFormat("yyyyMMdd");
    return "https://www.buigle.net/detalle_modulo.php?s=1&sec=7&fecha=" +
        _formatter.format(date);
  }

  @override
  TextsSet parse(String body) {
    var document = Parser.parse(body);
    String texts = document
        .querySelectorAll('table.texto2 tbody tr td div')[1]
        .querySelectorAll('div')[0]
        .innerHtml
        .replaceAll("\n", "");

    var misanavarra = MisasNavarraProvider();
    return misanavarra.parse(texts);
  }

  String getGodspelIndex(String chunk) {
    return godspellRegex.stringMatch(chunk)?.split("<br>")[2] ?? "N/A";
  }

  String getGodspel(String chunk) {
    var parts = godspellRegex.stringMatch(chunk)?.split("<br>");
    return parts
            ?.sublist(3, parts.length - 1)
            .join("\n")
            .replaceAll(String.fromCharCode(0x93), "")
            .replaceAll(String.fromCharCode(0x94), "")
            .trim() ??
        "N/A";
  }

  String getFirstIndex(String chunk) {
    return firstRegex.stringMatch(chunk)?.split("<br>")[2] ?? "N/A";
  }

  String getFirst(String chunk) {
    var parts = firstRegex.stringMatch(chunk)?.split("<br>") ?? [];
    return parts.sublist(3, parts.length - 3).join("\n").trim();
  }

  String? getSecondIndex(String chunk) {
    var match = secondRegex.stringMatch(chunk);
    if (match == null) return null;
    return match.split("<br>")[2];
  }

  String? getSecond(String chunk) {
    var match = secondRegex.stringMatch(chunk);
    if (match == null) return null;

    var parts = match.split("<br>");
    return parts.sublist(3, parts.length - 4).join("\n").trim();
  }

  String getPsalm(String chunk, bool sunday) {
    var parts = !sunday
        ? psalmRegex.stringMatch(chunk)?.split("<br>")
        : psalmSundayRegex.stringMatch(chunk)?.split("<br>");
    return parts
            ?.sublist(2, parts.length - 2)
            .join("\n")
            .replaceAll(" R.", " R/.\n")
            .trim() ??
        "N/A";
  }

  String getPsalmIndex(String chunk) {
    return psalmRegex
            .stringMatch(chunk)
            ?.split("<br>")[0]
            .trim()
            .replaceAll("SALMO RESPONSORIAL", "Sal") ??
        "N/A";
  }

  String getPsalmResponse(String chunk) {
    return psalmRegex
            .stringMatch(chunk)
            ?.split("<br>")[1]
            .trim()
            .replaceAll("R.", "R/.") ??
        "N/A";
  }
}
