import 'dart:convert';

class TextsSet {
  DateTime date;
  final String first, firstIndex;
  final String second, secondIndex;
  final String psalm, psalmIndex, psalmResponse;
  final String godspel, godspelIndex;

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
      this.godspelIndex);

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
      "godspelIndex": this.godspelIndex
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
        jsonData["godspelIndex"]);
  }
}
