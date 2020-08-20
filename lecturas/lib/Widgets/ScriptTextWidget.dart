import 'package:flutter/material.dart';
import 'package:lecturas/Model/ScriptText.dart';
import 'package:lecturas/Model/Settings.dart';

class ScriptTextWidget extends StatelessWidget {
  final ScriptText scriptText;
  final Settings settings;
  final TextStyle _responseStyle = TextStyle(fontWeight: FontWeight.bold);

  RegExp _onlyIndexRegex = RegExp(r'[^ ]* \(.*\)$');

  TextStyle _bodySize, _titleSize;

  ScriptTextWidget({Key key, this.scriptText, this.settings}) : super(key: key);

  Widget buildScript(BuildContext context, ScriptText text) {
    String response, typeDisplayName;
    if (text.type == ScriptText.SCRIPT_TAG) {
      response = "Palabra del Señor";
      typeDisplayName = "Lectura";
    } else {
      response = "Palabra de Dios";
      typeDisplayName = "Evangelio";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          title: Text(
            typeDisplayName,
            style: _titleSize,
          ),
          subtitle: Opacity(
            opacity: 0.6,
            child: SelectableText(
              text.index,
              style: _bodySize.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        SelectableText(
          text.text.replaceAll("\n", " "),
          style: _bodySize,
        ),
        Container(
          height: 10,
        ),
        SelectableText(
          response,
          style: _bodySize.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildPsalm(BuildContext context, Psalm text) {
    var typeDisplayName = "Salmo";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          title: Text(
            typeDisplayName,
            style: _titleSize,
          ),
          subtitle: Opacity(
            opacity: 0.6,
            child: SelectableText(
              text.index,
              style: _bodySize.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        SelectableText(
          text.response.replaceAll("\n", " "),
          style: _bodySize.copyWith(fontWeight: FontWeight.bold),
        ),
        Container(
          height: 10,
        ),
        SelectableText(text.text, style: _bodySize)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _bodySize = TextStyle(
        fontSize: Theme.of(context).textTheme.bodyText2.fontSize *
            settings.scaleFactor *
            0.95);
    _titleSize = TextStyle(
        fontSize: Theme.of(context).textTheme.headline6.fontSize *
            settings.scaleFactor *
            0.95);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          child: (this.scriptText is Psalm)
              ? buildPsalm(context, this.scriptText as Psalm)
              : buildScript(context, this.scriptText)),
    );
  }
}
