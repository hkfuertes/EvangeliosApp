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
    return MarkdownBody(
      data: text,
      styleSheet: MarkdownStyleSheet(
          p: Theme.of(context).textTheme.body1.copyWith(
              fontSize: defaultSizeNormal * (zoomFactor / 100)),
          strong: Theme.of(context).textTheme.body1.copyWith(
              fontSize: defaultSizeNormal * (zoomFactor / 100),
              fontWeight: FontWeight.bold),
          h2: Theme.of(context).textTheme.title.copyWith(
              fontSize: defaultSizeTitle * (zoomFactor / 100))),
    );
  }
}
