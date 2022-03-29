import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lecturas/constants.dart';

class PsalmWidget extends StatelessWidget {
  final String title;
  final String? quote;
  final String repeat;
  final List<String> texts;
  final bool asExpandableTile;
  final double textScale;
  const PsalmWidget(
      {Key? key,
      required this.texts,
      required this.repeat,
      this.asExpandableTile = false,
      required this.title,
      this.textScale = 1,
      this.quote})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (asExpandableTile)
        ? ExpansionTile(
            textColor: Colors.white,
            iconColor: Colors.white,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            childrenPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            title: Text(title),
            subtitle: (quote != null)
                ? Text(
                    quote!,
                    textScaleFactor: 0.8 * textScale,
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w200),
                  )
                : null,
            children: texts
                .map((e) => Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "V. " + repeat.trim(),
                                textScaleFactor: textScale,
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8 * textScale,
                              ),
                              Text(
                                e.trim() + " R.",
                                textScaleFactor: textScale,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w200),
                              ),
                              SizedBox(
                                height: 8 * textScale,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))
                .toList(),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
                SizedBox(
                  height: (8 * textScale),
                ),
                ...texts
                    .map((e) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0 * textScale),
                              child: Text(
                                "V. " + repeat.trim(),
                                textScaleFactor: textScale,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                            Text(
                              e.trim() + " R.",
                              textScaleFactor: textScale,
                            ),
                          ],
                        ))
                    .toList()
              ],
            ),
          );
  }

  static PsalmWidget makeDummy() => const PsalmWidget(
        texts: [Constants.lorem, Constants.lorem],
        repeat: "El señor es mi pastor",
        title: "Salmo",
        quote: "Col. 1-25",
      );
}
