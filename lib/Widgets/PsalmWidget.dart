import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PsalmWidget extends StatelessWidget {
  final String psalm, psalmResponse, psalmIndex;
  final double zoomFactor;
  PsalmWidget(this.psalm, this.psalmResponse, this.psalmIndex,
      {this.zoomFactor = 100});

  @override
  Widget build(BuildContext context) {
    double defaultSizeNormal = Theme.of(context).textTheme.body1.fontSize;
    double defaultSizeTitle = Theme.of(context).textTheme.title.fontSize;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            psalmIndex,
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(fontSize: defaultSizeTitle * (zoomFactor / 100)),
          ),
          Container(
            height: 10,
          ),
          Text(psalmResponse,
              style: Theme.of(context).textTheme.body1.copyWith(
                  fontSize: defaultSizeNormal * (zoomFactor / 100),
                  fontWeight: FontWeight.bold)),
          Container(
            height: 10,
          ),
          Text(psalm,
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(fontSize: defaultSizeNormal * (zoomFactor / 100)))
        ]);
  }
}
