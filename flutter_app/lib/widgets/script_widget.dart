import 'package:flutter/widgets.dart';
import 'package:lecturas/constants.dart';

class ScriptWidget extends StatelessWidget {
  final String? title;
  final String? quote;
  final String text;
  const ScriptWidget({Key? key, required this.text, this.title, this.quote})
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
          Text(text.replaceAll("“", '"').replaceAll("”", '"'))
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
