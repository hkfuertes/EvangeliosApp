import 'dart:convert';

import 'ScriptText.dart';

class TextsSet {
  DateTime date;
  final String first, firstIndex;
  final String second, secondIndex;
  final String psalm, psalmIndex, psalmResponse;
  final String godspel, godspelIndex;
  final String provider;

  TextsSet(
      this.date,
      this.first,
      this.firstIndex,
      this.second,
      this.secondIndex,
      this.psalm,
      this.psalmIndex,
      this.psalmResponse,
      this.godspel,
      this.godspelIndex,
      this.provider);

  List<ScriptText> getTextsAsObjects() {
    if (this.secondIndex != null)
      return [
        Script(this.firstIndex, this.first),
        Psalm(this.psalmIndex, this.psalm, this.psalmResponse),
        Script(this.secondIndex, this.second),
        Godspel(this.godspelIndex, this.godspel),
      ];
    else
      return [
        Script(this.firstIndex, this.first),
        Psalm(this.psalmIndex, this.psalm, this.psalmResponse),
        Godspel(this.godspelIndex, this.godspel),
      ];
  }

  void setDate(DateTime date) {
    this.date = date;
  }

  String getFirstMarkDown() {
    return "## " + firstIndex + "\n" + first + "\n\n**Palabra de Dios**";
  }

  String getSecondMarkDown() {
    return "## " + secondIndex + "\n\n" + second + "\n\n**Palabra de Dios**";
  }

  String getGodspelMarkDown() {
    return "## " +
        godspelIndex +
        "\n\n" +
        godspel +
        "\n\n**Palabra del Señor**";
  }

  String getPsalmMarkDown() {
    return "## " +
        psalmIndex +
        "\n\n" +
        "**_" +
        psalmResponse +
        "_**\n\n" +
        psalm.replaceAll("R/.", "**R/.**");
  }

  String toJson() {
    return jsonEncode({
      "date": this.date.toIso8601String(),
      "first": this.first,
      "firstIndex": this.firstIndex,
      "second": this.second,
      "secondIndex": this.secondIndex,
      "psalm": this.psalm,
      "psalmIndex": this.psalmIndex,
      "psalmResponse": this.psalmResponse,
      "godspel": this.godspel,
      "godspelIndex": this.godspelIndex,
      "provider": this.provider
    });
  }

  static TextsSet fromJson(String jsonString) {
    var jsonData = jsonDecode(jsonString);
    return TextsSet(
        DateTime.parse(jsonData["date"]),
        jsonData["first"],
        jsonData["firstIndex"],
        jsonData["second"],
        jsonData["secondIndex"],
        jsonData["psalm"],
        jsonData["psalmIndex"],
        jsonData["psalmResponse"],
        jsonData["godspel"],
        jsonData["godspelIndex"],
        jsonData["provider"]);
  }
}
