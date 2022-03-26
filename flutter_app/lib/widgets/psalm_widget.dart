import 'package:flutter/widgets.dart';
import 'package:lecturas/constants.dart';

class PsalmWidget extends StatelessWidget {
  final String? title;
  final String? quote;
  final String repeat;
  final List<String> texts;
  const PsalmWidget(
      {Key? key,
      required this.texts,
      required this.repeat,
      this.title,
      this.quote})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title!.toUpperCase(),
              textScaleFactor: 1.25,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          if (quote != null)
            Text(
              quote!,
              textScaleFactor: 0.8,
              style: const TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.w100),
            ),
          const SizedBox(
            height: 8,
          ),
          ...texts
              .map((e) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
