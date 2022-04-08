extension ParsersStringExtensions on String {
  String replaceBreakLines() {
    return replaceAll(r'/\<br ?\/\>/', "/n");
  }

  String removeDoubleBreakLines({bool removeDouble = true}) {
    return removeDouble ? replaceAll("\n\n", "\n") : this;
  }

  String removeEmptyLines() {
    return split("\n").where((element) => element.trim().isNotEmpty).join("\n");
  }

  String removeWords() {
    return replaceAll("Palabra del Señor", "")
        .replaceAll("Palabra de Dios", "");
  }

  String removeLastLine() {
    var lines = split("\n");
    return lines.sublist(0, lines.length - 1).join("\n");
  }

  String trimEachLine() {
    return split("\n").map((e) => e.trim()).join("\n");
  }

  String cleanHtml({bool removeDouble = true}) {
    return replaceBreakLines()
        .removeDoubleBreakLines(removeDouble: removeDouble)
        .removeWords()
        .removeEmptyLines()
        .trimEachLine()
        .trim();
  }
}
