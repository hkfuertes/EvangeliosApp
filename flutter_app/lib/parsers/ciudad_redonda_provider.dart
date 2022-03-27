import 'package:intl/intl.dart';
import 'package:html/parser.dart' as Parser;
import 'package:html/dom.dart';

import '../model/text_sets.dart';
import 'texts_provider.dart';

class CiudadRedondaProvider extends TextsProvider {
  @override
  TextsSet parse(String body) {
    var document = Parser.parse(body);
    List<Element> texts = document.querySelectorAll('div.texto_palabra');
    if (texts.length > 3) {
      //Sunday
      return TextsSet(
          from: getProviderNameForDisplay(),
          first: getText(texts[0]),
          firstIndex: getTextIndex(texts[0]),
          second: getText(texts[2]),
          secondIndex: getTextIndex(texts[2]),
          psalm: getPsalm(texts[1]),
          psalmIndex: getPsalmIndex(texts[1]),
          psalmResponse: getPsalmResponse(texts[1]),
          godspel: getText(texts[3]),
          godspelIndex: getTextIndex(texts[3]));
    } else {
      return TextsSet(
          from: getProviderNameForDisplay(),
          first: getText(texts[0]),
          firstIndex: getTextIndex(texts[0]),
          psalm: getPsalm(texts[1]),
          psalmIndex: getPsalmIndex(texts[1]),
          psalmResponse: getPsalmResponse(texts[1]),
          godspel: getText(texts[2]),
          godspelIndex: getTextIndex(texts[2]));
    }
  }

  @override
  String getProviderUrlForDate(DateTime date) {
    var formatter = DateFormat('yyyy-MM-dd');
    return "https://www.ciudadredonda.org/calendario-lecturas/evangelio-del-dia/?f=" +
        formatter.format(date);
  }

  String getPsalm(Element element) {
    return element.text
        .replaceAll("<br>", "\n")
        //.replaceAll("\n\n", "\n")
        .replaceAll(getPsalmIndex(element), "")
        .replaceAll(getPsalmResponse(element), "")
        .replaceAll("R/.", "")
        .replaceAll("V/. ", "")
        .trim();
  }

  String getPsalmIndex(Element element) {
    return element
            .querySelector("b")
            ?.innerHtml
            .replaceAll("<br>\n<br>\nR/.", "") ??
        "N/A";
  }

  String getPsalmResponse(Element element) {
    var el = element.querySelector("i");
    if (el != null) {
      return el.text.trim();
    } else {
      return "N/A";
    }
  }

  String getText(Element element) {
    return element.innerHtml
        //.replaceAll("\n", "")
        .replaceAll("</b>.<br>", "</b><br>")
        .replaceAll("<br>", "\n")
        .replaceAll("\n\n", "\n")
        .replaceAll(element.querySelector("b")?.outerHtml ?? "", "")
        .replaceAll("<b>Palabra de Dios</b>", "")
        .replaceAll("<b>Palabra del Señor</b>", "")
        .replaceAll(super.stripHtmlTagsRegex, "")
        .trim();
  }

  String getTextIndex(Element element) {
    return element.querySelector("b")?.text.replaceAll(":", "") ?? "N/A";
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  @override
  String getProviderNameForDisplay() {
    return "Ciudad Redonda";
  }
}
