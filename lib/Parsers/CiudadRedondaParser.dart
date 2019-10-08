import 'package:evangelios/Model/TextsSet.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart' as Parser;
import 'package:html/dom.dart';

import 'BaseParser.dart';

class CiudadRedondaParser extends BaseParser {
  @override
  Future<TextsSet> parse(String body) async {
    var document = Parser.parse(body);
    List<Element> texts = document.querySelectorAll('div.texto_palabra');
    if (texts.length > 3) {
      //Sunday
      return TextsSet(
          null,
          getText(texts[0]),
          getTextIndex(texts[0]),
          getText(texts[1]),
          getTextIndex(texts[1]),
          getPsalm(texts[2]),
          getPsalmIndex(texts[2]),
          getPsalmResponse(texts[1]),
          getText(texts[3]),
          getTextIndex(texts[3]));
    } else {
      return TextsSet(
          null,
          getText(texts[0]),
          getTextIndex(texts[0]),
          null,
          null,
          getPsalm(texts[1]),
          getPsalmIndex(texts[1]),
          getPsalmResponse(texts[1]),
          getText(texts[2]),
          getTextIndex(texts[2]));
    }
  }

  @override
  String getProviderUrlForDate(DateTime date) {
    var formatter = new DateFormat('yyyy-MM-dd');
    return "https://www.ciudadredonda.org/calendario-lecturas/evangelio-del-dia/?f=" +
        formatter.format(date);
  }

  String getPsalm(Element element) {
    return element.text
        .replaceAll("<br>", "\n")
        .replaceAll(getPsalmIndex(element), "")
        .replaceAll(getPsalmResponse(element), "")
        .replaceAll("R/.", "")
        .trim();
  }

  String getPsalmIndex(Element element) {
    return element
        .querySelector("b")
        .innerHtml
        .replaceAll("<br>\n<br>\nR/.", "");
  }

  String getPsalmResponse(Element element) {
    return element.querySelector("i").text.trim();
  }

  String getText(Element element) {
    return element.innerHtml
        //.replaceAll("\n", "")
        .replaceAll("<br>", "\n")
        .replaceAll(element.querySelector("b").outerHtml, "")
        .replaceAll("<b>Palabra de Dios</b>", "")
        .replaceAll("<b>Palabra del Señor</b>", "")
        .trim();
  }

  String getTextIndex(Element element) {
    return element.querySelector("b").text.replaceAll(":", "");
  }
}
