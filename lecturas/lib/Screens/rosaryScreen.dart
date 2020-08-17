import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lecturas/Model/Rosary.dart';
import 'package:lecturas/Model/Settings.dart';
import 'package:provider/provider.dart';

import '../Util.dart';

class RosaryScreen extends StatelessWidget {
  Settings _settings;
  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);
    var padding = EdgeInsets.all(16);
    var oneTo13 = List<int>.generate(13, (i) => i + 1);
    return Scaffold(
        appBar: AppBar(
          title: title(context),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: ListView(
          children: [
            Padding(
              padding: padding,
              child: MarkdownBody(
                data: _settings.rosary.skeletonSplitted[0],
              ),
            ),
            Column(
                children: _settings.rosary
                    .getTodayMisteries()
                    .misteries
                    .asMap()
                    .entries
                    .map((mEntry) => mEntry.key == 1
                        ? Column(
                            children: oneTo13.map((i) {
                            if (i == 1)
                              return ListTile(
                                title: Text((mEntry.key + 1).toString() +
                                    "º " +
                                    mEntry.value),
                              );
                            else if (i == 2)
                              return CheckboxListTile(
                                title: Text("Padrenuestro..."),
                                value: false,
                                onChanged: (_) async {},
                              );
                            else if (i == 13)
                              return CheckboxListTile(
                                title: Text("Gloria..."),
                                value: false,
                                onChanged: (_) async {},
                              );
                            else
                              return CheckboxListTile(
                                title:
                                    Text((i - 2).toString() + " Avemaria..."),
                                value: false,
                                onChanged: (_) async {},
                              );
                          }).toList())
                        : ListTile(
                            title: Text((mEntry.key + 1).toString() +
                                "º " +
                                mEntry.value),
                          ))
                    .toList()),
            Padding(
              padding: padding,
              child: MarkdownBody(
                data: _settings.rosary.skeletonSplitted[1],
              ),
            ),
            Padding(
              padding: padding,
              child: MarkdownBody(
                data: _settings.rosary.skeletonSplitted[2],
              ),
            ),
          ],
        ));
  }

  Widget title(BuildContext context) {
    var name = _settings.rosary.getTodayTitle();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Misterios " +
              name[0].toUpperCase() +
              name.substring(1).toLowerCase(),
          maxLines: 1,
          style: TextStyle(
            color: (_settings.darkTheme)
                ? Theme.of(context).textTheme.bodyText1.color
                : Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            //fontSize: 24
          ),
        ),
        Text(
          Util.getFullDateSpanish(_settings.currentTime),
          maxLines: 1,
          style: TextStyle(
              color: (_settings.darkTheme)
                  ? Theme.of(context).textTheme.bodyText1.color
                  : Theme.of(context).primaryColor,
              fontStyle: FontStyle.italic,
              fontSize: Theme.of(context).textTheme.bodyText1.fontSize
              //fontSize: 24
              ),
        )
      ],
    );
  }
}
