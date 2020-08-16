import '../Model/TextsSet.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart' as Parser;
import 'package:html/dom.dart';

import 'TextsProvider.dart';
import 'package:http/http.dart' as http;

class CiudadRedondaProvider extends TextsProvider {
  @override
  TextsSet parse(String body) {
    var document = Parser.parse(body);
    List<Element> texts = document.querySelectorAll('div.texto_palabra');
    if (texts.length > 3) {
      //Sunday
      return TextsSet(
          null,
          getText(texts[0]),
          getTextIndex(texts[0]),
          getText(texts[2]),
          getTextIndex(texts[2]),
          getPsalm(texts[1]),
          getPsalmIndex(texts[1]),
          getPsalmResponse(texts[1]),
          getText(texts[3]),
          getTextIndex(texts[3]),
          getProviderNameForDisplay());
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
          getTextIndex(texts[2]),
          getProviderNameForDisplay());
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
        //.replaceAll("R/.", "")
        //.replaceAll("V/. ", "")
        .trim();
  }

  String getPsalmIndex(Element element) {
    return element
        .querySelector("b")
        .innerHtml
        .replaceAll("<br>\n<br>\nR/.", "");
  }

  String getPsalmResponse(Element element) {
    return "R/. " + element.querySelector("i").text.trim();
  }

  String getText(Element element) {
    return element.innerHtml
        //.replaceAll("\n", "")
        .replaceAll("</b>.<br>", "</b><br>")
        .replaceAll("<br>", "\n")
        .replaceAll(element.querySelector("b").outerHtml, "")
        .replaceAll("<b>Palabra de Dios</b>", "")
        .replaceAll("<b>Palabra del Señor</b>", "")
        .replaceAll(super.stripHtmlTagsRegex, "")
        .trim();
  }

  String getTextIndex(Element element) {
    return element.querySelector("b").text.replaceAll(":", "");
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  @override
  String getProviderNameForDisplay() {
    return "www.ciudadredonda.org";
  }

  @override
  Future<String> getExtraUrl() async {
    String startingUrl =
        "https://www.ciudadredonda.org/calendario-lecturas/evangelio-del-dia/comentario-homilia/hoy";
    //return startingUrl;

    var response = await http.get(startingUrl);
    var document = Parser.parse(response.body);
    var body = document.querySelectorAll('article div.body-txt')[0].outerHtml;
    body = body.replaceAll(RegExp(r'<p>\n<img.*></p>'), "");
    body = body.replaceAll(RegExp(r'<p>\n&nbsp;</p>'), "");
    body = body.replaceAll("&nbsp;", "");
    body = body.replaceAll("<u>", "");
    body = body.replaceAll("</u>", "");
    body = body.replaceAll("§", "");
/*
    body = body.replaceAll(
        "<blockquote>", '<blockquote style="border-left: none;"');
  body = body.replaceAll("</blockquote>", '');
    body = _removeAllHtmlTags(body);
    //body = body.replaceAll("\n\n", "\n");
    body = body.trim();


    var blockquote =
        "<style>blockquote *:before{content:''!important;}</style>";*/
    return body;
    //return "https://www.ciudadredonda.org" + document.querySelectorAll('div.print-icons a')[1].attributes["href"];
  }

  String _removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  @override
  bool hasExtras(DateTime date) {
    return date.difference(DateTime.now()).inDays == 0 &&
        date.day == DateTime.now().day;
  }
}
