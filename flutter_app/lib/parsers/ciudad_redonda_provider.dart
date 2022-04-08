import 'package:intl/intl.dart';
import 'package:html/parser.dart' as Parser;
import 'package:html/dom.dart';
import 'package:lecturas/parsers/parsers_string_extensions.dart';

import '../model/text_sets.dart';
import 'texts_provider.dart';

class CiudadRedondaProvider extends TextsProvider {
  @override
  TextsSet parse(String body) {
    var elements = Parser.parse(body).querySelectorAll("div.texto_palabra");
    if (elements.length <= 3) {
      return TextsSet(
          first: elements[0].text.cleanHtml().split("\n").sublist(1).join("\n"),
          firstIndex: elements[0].text.cleanHtml().split("\n")[0],
          psalm: elements[1]
              .text
              .cleanHtml(removeDouble: false)
              .split("\n")
              .sublist(2)
              .join("\n")
              .replaceAll("R/.", "\n")
              .replaceAll("R.", "\n")
              .replaceAll("V/.", "")
              .replaceAll("V.", "")
              .trimEachLine(),
          psalmIndex:
              elements[1].text.cleanHtml(removeDouble: false).split("\n")[0],
          psalmResponse: elements[1]
              .text
              .cleanHtml(removeDouble: false)
              .split("\n")[1]
              .replaceAll("R/.", "")
              .replaceAll("R.", "")
              .replaceAll("V/.", "")
              .replaceAll("V.", "")
              .trim(),
          godspel:
              elements[2].text.cleanHtml().split("\n").sublist(1).join("\n"),
          godspelIndex: elements[2].text.cleanHtml().split("\n")[0],
          from: getProviderNameForDisplay());
    } else {
      return TextsSet(
          first: elements[0].text.cleanHtml().split("\n").sublist(1).join("\n"),
          firstIndex: elements[0].text.cleanHtml().split("\n")[0],
          psalm: elements[1]
              .text
              .cleanHtml()
              .split("\n")
              .sublist(2)
              .join("\n")
              .replaceAll("R/.", "\n")
              .replaceAll("R.", "\n")
              .replaceAll("V/.", "")
              .replaceAll("V.", "")
              .trimEachLine(),
          psalmIndex: elements[1].text.cleanHtml().split("\n")[0],
          psalmResponse: elements[1]
              .text
              .cleanHtml()
              .split("\n")[1]
              .replaceAll("R/.", "")
              .replaceAll("R.", "")
              .trim(),
          second:
              elements[2].text.cleanHtml().split("\n").sublist(1).join("\n"),
          secondIndex: elements[2].text.cleanHtml().split("\n")[0],
          godspel:
              elements[3].text.cleanHtml().split("\n").sublist(1).join("\n"),
          godspelIndex: elements[3].text.cleanHtml().split("\n")[0],
          from: getProviderNameForDisplay());
    }
  }

  @override
  String getProviderUrlForDate(DateTime date) {
    var formatter = DateFormat('yyyy-MM-dd');
    return "https://www.ciudadredonda.org/calendario-lecturas/evangelio-del-dia/?f=" +
        formatter.format(date);
  }

  @override
  String getProviderNameForDisplay() {
    return "Ciudad Redonda";
  }
}
