import 'package:intl/intl.dart';
import 'package:html/parser.dart' as Parser;
import '../model/text_sets.dart';
import 'texts_provider.dart';

class BuigleProvider extends TextsProvider {
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

    return parseFromSection(texts, this);
  }

  static TextsSet parseFromSection(String body, TextsProvider provider) {
    var chunk = body.split("PRIMERA LECTURA")[1];
    var firstParts = chunk
        .split("SALMO RESPONSORIAL")[0]
        .replaceAll("<br>", "\n")
        .trim()
        .split("\n")
        .where((e) => e != "")
        .toList();
    chunk = chunk.split("SALMO RESPONSORIAL")[1];
    var psalmParts = chunk
        .split("Versículo")[0]
        .replaceAll("<br>", "\n")
        .trim()
        .split("\n")
        .where((e) => e != "")
        .toList();
    var godspelParts = chunk
        .split("EVANGELIO")[1]
        .replaceAll("<br>", "\n")
        .trim()
        .split("\n")
        .where((e) => e != "")
        .toList();

    var sTest = psalmParts.join("\n").split("SEGUNDA LECTURA");
    List<String>? secondParts;
    if (sTest.length > 1) {
      secondParts = sTest[1].split("\n").where((e) => e != "").toList();
    }

    return TextsSet(
        from: provider.getProviderNameForDisplay(),
        second: secondParts?.sublist(2).join("\n"),
        secondIndex: secondParts?.elementAt(1).trim(),
        first: firstParts.sublist(2).join("\n"),
        firstIndex: firstParts[1].trim(),
        psalm: psalmParts
            .sublist(2)
            .join("\n")
            .split("SEGUNDA LECTURA")[0]
            .trim()
            .replaceAll("R.", "\n"),
        psalmIndex: "Salmo " + psalmParts[0].trim(),
        psalmResponse: psalmParts[1].replaceAll("R.", "").trim(),
        godspel: godspelParts.sublist(2).join("\n"),
        godspelIndex: godspelParts[1].trim());
  }
}
