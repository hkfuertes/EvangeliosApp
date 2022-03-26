import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lecturas/constants.dart';

class PsalmWidget extends StatelessWidget {
  final String title;
  final String? quote;
  final String repeat;
  final List<String> texts;
  final bool asExpandableTile;
  const PsalmWidget(
      {Key? key,
      required this.texts,
      required this.repeat,
      this.asExpandableTile = false,
      required this.title,
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
                    textScaleFactor: 0.8,
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w100),
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
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                e.trim() + " R.",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w100),
                              ),
                              const SizedBox(
                                height: 8,
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
                  textScaleFactor: 1.25,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (quote != null)
                  Text(
                    quote!,
                    textScaleFactor: 0.8,
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w100),
                  ),
                const SizedBox(
                  height: 8,
                ),
                ...texts
                    .map((e) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "V. " + repeat.trim(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                            Text(
                              e.trim() + " R.",
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
