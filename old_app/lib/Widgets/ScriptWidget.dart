import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ScriptWidget extends StatelessWidget {
  final String text, textIndex;
  final String endPhrase;
  final double zoomFactor;
  ScriptWidget(this.text, this.textIndex, this.endPhrase,
      {this.zoomFactor = 100});

  @override
  Widget build(BuildContext context) {
    double defaultSizeNormal = Theme.of(context).textTheme.body1.fontSize;
    double defaultSizeTitle = Theme.of(context).textTheme.title.fontSize;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SelectableText(
            textIndex,
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(fontSize: defaultSizeTitle * (zoomFactor / 100)),
          ),
          Container(
            height: 10,
          ),
          SelectableText(text,
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(fontSize: defaultSizeNormal * (zoomFactor / 100))),
          Container(
            height: 10,
          ),
          SelectableText(endPhrase,
              style: Theme.of(context).textTheme.body1.copyWith(
                  fontSize: defaultSizeNormal * (zoomFactor / 100),
                  fontWeight: FontWeight.bold))
        ]);
  }
}
