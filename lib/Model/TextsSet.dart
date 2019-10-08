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
}
