import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lecturas/constants.dart';

class ScriptWidget extends StatelessWidget {
  final String title;
  final String? quote;
  final String text;
  final bool asExpandableTile;
  final double textScale;
  const ScriptWidget(
      {Key? key,
      required this.text,
      required this.title,
      this.quote,
      this.textScale = 1,
      this.asExpandableTile = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (asExpandableTile)
        ? ExpansionTile(
            textColor: Colors.white,
            iconColor: Colors.white,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            childrenPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            title: Text(
              title,
              textScaleFactor: textScale,
            ),
            subtitle: (quote != null)
                ? Text(
                    quote!,
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 0.8 * textScale,
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w100),
                  )
                : null,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      text.replaceAll(".\n", ".\n\n"),
                      textScaleFactor: textScale,
                      style: const TextStyle(fontWeight: FontWeight.w100),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              )
            ],
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  textScaleFactor: 1.25 * textScale,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (quote != null)
                  Text(
                    quote!,
                    textScaleFactor: 0.8 * textScale,
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w200),
                  ),
                const SizedBox(
                  height: 8,
                ),
                Text(text.replaceAll("“", '"').replaceAll("”", '"'),
                    textScaleFactor: textScale)
              ],
            ),
          );
  }

  static List<ScriptWidget> makeDummy({count = 3}) => List.generate(
      count,
      (index) => ScriptWidget(
            text: Constants.lorem,
            title: "${index + 1}º Lectura",
            quote: "Col. 1-25",
          ));
}
