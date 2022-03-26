abstract class ScriptText {
  static const SCRIPT_TAG = "lectura";
  static const GODSPELL_TAG = "evangelio";
  static const PSALM_TAG = "salmo";

  final String index;
  final String text;
  final String type;

  ScriptText(this.index, this.text, this.type);
}

class Script extends ScriptText {
  Script(String index, String text) : super(index, text, ScriptText.SCRIPT_TAG);
}

class Godspel extends ScriptText {
  Godspel(String index, String text)
      : super(index, text, ScriptText.GODSPELL_TAG);
}

class Psalm extends ScriptText {
  final String response;
  Psalm(String index, String text, this.response)
      : super(index, text, ScriptText.PSALM_TAG);
}
