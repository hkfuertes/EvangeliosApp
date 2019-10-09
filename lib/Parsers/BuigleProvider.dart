import 'package:evangelios/Model/TextsSet.dart';
import 'package:intl/intl.dart';
import 'package:evangelios/Model/TextsSet.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart' as Parser;
import 'package:html/dom.dart';

import 'Provider.dart';

class BuigleProvider extends Provider {
  RegExp firstRegex =
      new RegExp(r'PRIMERA LECTURA.*SALMO', multiLine: true, dotAll: true);
  RegExp secondRegex = new RegExp(r"SEGUNDA LECTURA.*Aleluya",
      multiLine: true, dotAll: true);
  RegExp psalmRegex =
      new RegExp(r"SALMO RESPONSORIAL.*Aleluya", multiLine: true, dotAll: true);
  RegExp psalmSundayRegex =
      new RegExp(r"SALMO RESPONSORIAL.*SEGUNDA", multiLine: true, dotAll: true);
  RegExp godspellRegex = new RegExp(r"EVANGELIO.*Palabra del Señor",
      multiLine: true, dotAll: true);

  @override
  String getProviderNameForDisplay() {
    return "www.buigle.net";
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
    var first = this.getFirst(texts);
    var firstIndex = this.getFirstIndex(texts);

    var second = this.getSecond(texts);
    var secondIndex = this.getSecondIndex(texts);

    var psalm = this.getPsalm(texts, second != null);
    var psalmIndex = this.getPsalmIndex(texts);
    var psalmResponse = this.getPsalmResponse(texts);

    var godspel = this.getGodspell(texts);
    var godspelIndex = this.getGodspellIndex(texts);
    return TextsSet(null, first, firstIndex, second, secondIndex, psalm,
        psalmIndex, psalmResponse, godspel, godspelIndex);
  }

  String getGodspellIndex(String chunk) {
    return this.godspellRegex.stringMatch(chunk).split("<br>")[2];
  }

  String getGodspell(String chunk) {
    var parts = this.godspellRegex.stringMatch(chunk).split("<br>");
    return parts.sublist(3, parts.length - 1).join("\n").trim();
  }

  String getFirstIndex(String chunk) {
    return this.firstRegex.stringMatch(chunk).split("<br>")[2];
  }

  String getFirst(String chunk) {
    var parts = this.firstRegex.stringMatch(chunk).split("<br>");
    return parts.sublist(3, parts.length - 3).join("\n").trim();
  }

  String getSecondIndex(String chunk) {
    var match = this.secondRegex.stringMatch(chunk);
    if (match == null) return null;
    return match.split("<br>")[2];
  }

  String getSecond(String chunk) {
    var match = this.secondRegex.stringMatch(chunk);
    if (match == null) return null;

    var parts = match.split("<br>");
    return parts.sublist(3, parts.length - 4).join("\n").trim();
  }

  String getPsalm(String chunk, bool sunday) {
    var parts = !sunday
        ? this.psalmRegex.stringMatch(chunk).split("<br>")
        : this.psalmSundayRegex.stringMatch(chunk).split("<br>");
    return parts
        .sublist(2, parts.length - 2)
        .join("\n")
        .replaceAll(" R.", " R/.\n")
        .trim();
  }

  String getPsalmIndex(String chunk) {
    return this
        .psalmRegex
        .stringMatch(chunk)
        .split("<br>")[0]
        .trim()
        .replaceAll("SALMO RESPONSORIAL", "Sal");
  }

  String getPsalmResponse(String chunk) {
    return this
        .psalmRegex
        .stringMatch(chunk)
        .split("<br>")[1]
        .trim()
        .replaceAll("R.", "R/.");
  }
}
