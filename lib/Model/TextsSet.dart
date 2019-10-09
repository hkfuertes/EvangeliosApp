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

  String getFirstMarkDown(){
    return "## "+firstIndex+"\n\n"+first + "\n\n**Palabra de Dios**";
  }

  String getSecondMarkDown(){
        return "## "+secondIndex+"\n\n"+second+"\n\n**Palabra de Dios**";

  }
  String getGodspelMarkDown(){
    return "## "+godspelIndex+"\n\n"+godspel+"\n\n**Palabra del Señor**";
  }
  String getPsalmMarkDown(){
    return "## "+psalmIndex+"\n\n"+
    "**_"+psalmResponse+"_**\n\n"+
    psalm.replaceAll("R/.", "**R/.**");
  }
}
