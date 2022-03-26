import 'package:lecturas/model/text_sets.dart';

import 'provider.dart';

class MisasNavarraProvider extends Provider {
  @override
  String getProviderNameForDisplay() {
    return "Misas Navarra";
  }

  @override
  String getProviderUrlForDate(DateTime date) {
    return "http://vl23416.dns-privadas.es/misasnavarra/evangelio.php";
  }

  @override
  TextsSet parse(String body) {
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

    return TextsSet(
        from: getProviderNameForDisplay(),
        first: firstParts.sublist(2).join("\n"),
        firstIndex: firstParts[1].trim(),
        psalm: psalmParts.sublist(2).join("\n").replaceAll("R.", "\n"),
        psalmIndex: "Salmo " + psalmParts[0].trim(),
        psalmResponse: psalmParts[1].replaceAll("R.", "").trim(),
        godspel: godspelParts.sublist(2, godspelParts.length - 2).join("\n"),
        godspelIndex: godspelParts[1].trim());
  }
}
