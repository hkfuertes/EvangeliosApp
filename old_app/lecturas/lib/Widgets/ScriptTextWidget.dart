import 'package:flutter/material.dart';
import 'package:lecturas/Model/ScriptText.dart';
import 'package:lecturas/Model/Settings.dart';
import 'package:provider/provider.dart';

class ScriptTextWidget extends StatelessWidget {
  final ScriptText scriptText;
  final TextStyle _responseStyle = TextStyle(fontWeight: FontWeight.bold);

  RegExp _onlyIndexRegex = RegExp(r'[^ ]* \(.*\)$');

  TextStyle _bodySize, _titleSize;

  ScriptTextWidget({Key key, this.scriptText}) : super(key: key);

  Widget buildScript(BuildContext context, ScriptText text) {
    String response, typeDisplayName;
    if (text.type == ScriptText.SCRIPT_TAG) {
      response = "Palabra de Dios";
      typeDisplayName = "Lectura";
    } else {
      response = "Palabra del Señor";
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
    var settings = Provider.of<Settings>(context);
    var scaleFactor = settings?.scaleFactor ?? 1;
    _bodySize = TextStyle(
        fontSize: Theme.of(context).textTheme.bodyText1.fontSize * scaleFactor);
    _titleSize = TextStyle(
        fontSize: Theme.of(context).textTheme.headline6.fontSize * scaleFactor);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          child: (this.scriptText is Psalm)
              ? buildPsalm(context, this.scriptText as Psalm)
              : buildScript(context, this.scriptText)),
    );
  }
}
