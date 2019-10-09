import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ScriptWidget extends StatelessWidget {
  ScriptWidget(this.text, {this.zoomFactor = 100});
  final String text;
  final double zoomFactor;

  @override
  Widget build(BuildContext context) {
    double defaultSizeNormal = Theme.of(context).textTheme.body1.fontSize;
    double defaultSizeTitle = Theme.of(context).textTheme.title.fontSize;
    Color textColorDark = Colors.black;
    //Color textColorDark = Theme.of(context).primaryColorDark;
    Color textColor = Colors.black;
    //Color textColor = Theme.of(context).primaryColor;
    return MarkdownBody(
      data: text,
      styleSheet: MarkdownStyleSheet(
          p: Theme.of(context).textTheme.body1.copyWith(
              fontSize: defaultSizeNormal * (zoomFactor / 100),
              color: textColor),
          strong: Theme.of(context).textTheme.body1.copyWith(
              fontSize: defaultSizeNormal * (zoomFactor / 100),
              fontWeight: FontWeight.bold,
              color: textColor),
          h2: Theme.of(context).textTheme.title.copyWith(
              fontSize: defaultSizeTitle * (zoomFactor / 100),
              color: textColorDark)),
    );
  }
}
