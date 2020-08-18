import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
    var padding = 8.0;
    var oneTo13 = List<int>.generate(13, (i) => i + 1);
    var name = _settings.rosary.getTodayTitle();
    return Scaffold(
        appBar: AppBar(
          title: title(context),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            !_settings.rosary.isPlaying()
                ? IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () async {
                      _settings.rosary.playing[Rosary.CURRENT_MISTERY] = 0;
                      _settings.rosary.playing[Rosary.CURRENT_COUNT] = 0;
                      _settings.update();
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () async {
                      _settings.rosary.restartPlayer();
                      _settings.update();
                    },
                  )
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Html(
                data: _settings.rosary.skeletonSplitted[0].replaceAll(
                    Rosary.MISTERIES_NAME_TOKEN,
                    name[0].toUpperCase() + name.substring(1).toLowerCase()),
              ),
            ),
            Column(
                children: _settings.rosary
                    .getTodayMisteries()
                    .misteries
                    .asMap()
                    .entries
                    .map((mEntry) => mEntry.key ==
                            _settings.rosary.playing[Rosary.CURRENT_MISTERY]
                        ? Column(
                            children: oneTo13.map((i) {
                            if (i == 1)
                              return ListTile(
                                title: Text(
                                  (mEntry.key + 1).toString() +
                                      "º " +
                                      mEntry.value,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            else if (i == 2)
                              return CheckboxListTile(
                                dense: true,
                                title: Text("Padrenuestro"),
                                subtitle: Text(
                                  "Padre nuestro que estas en los cielos...",
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                                value: _settings
                                        .rosary.playing[Rosary.CURRENT_COUNT] >
                                    0,
                                onChanged: (ourFather) async {
                                  if (_settings.rosary
                                              .playing[Rosary.CURRENT_COUNT] ==
                                          0 &&
                                      ourFather) {
                                    _settings.rosary.nextMistery();
                                    _settings.update();
                                  }
                                  if (_settings.rosary
                                              .playing[Rosary.CURRENT_COUNT] ==
                                          1 &&
                                      !ourFather) {
                                    _settings.rosary.previousMistery();
                                    _settings.update();
                                  }
                                },
                              );
                            else if (i == 13)
                              return CheckboxListTile(
                                dense: true,
                                title: Text("Gloria"),
                                subtitle: Text(
                                  (mEntry.key + 1) % 2 == 1
                                      ? "Gloria al Padre, al Hijo, y al Espiritu Santo..."
                                      : "... como era en un principio...",
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                                value: _settings
                                        .rosary.playing[Rosary.CURRENT_COUNT] >
                                    11,
                                onChanged: (value) async {
                                  if (_settings.rosary
                                              .playing[Rosary.CURRENT_COUNT] ==
                                          11 &&
                                      value) {
                                    _settings.rosary.nextMistery();
                                    _settings.update();
                                  }
                                  if (_settings.rosary
                                              .playing[Rosary.CURRENT_COUNT] >
                                          11 &&
                                      !value) {
                                    _settings.rosary.previousMistery();
                                    _settings.update();
                                  }
                                },
                              );
                            else
                              return CheckboxListTile(
                                dense: true,
                                title: Text((i - 2).toString() + " - Avemaría"),
                                subtitle: Text(
                                  (mEntry.key + 1) % 2 == 1
                                      ? "Dios te salve Maria..."
                                      : "... Santa María...",
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                                value: _settings
                                        .rosary.playing[Rosary.CURRENT_COUNT] >
                                    i - 2,
                                onChanged: (value) async {
                                  if (_settings.rosary
                                              .playing[Rosary.CURRENT_COUNT] ==
                                          i - 2 &&
                                      value) {
                                    _settings.rosary.nextMistery();
                                    _settings.update();
                                  }
                                  if (_settings.rosary
                                              .playing[Rosary.CURRENT_COUNT] ==
                                          i - 1 &&
                                      !value) {
                                    _settings.rosary.previousMistery();
                                    _settings.update();
                                  }
                                },
                              );
                          }).toList())
                        : ListTile(
                            title: Text((mEntry.key + 1).toString() +
                                "º " +
                                mEntry.value),
                          ))
                    .toList()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Html(
                data: _settings.rosary.skeletonSplitted[1],
              ),
            ),
            Column(
              children: _settings.rosary.letanies
                  .asMap()
                  .entries
                  .map((mEntry) => _settings.rosary.isPlaying()
                      ? CheckboxListTile(
                          dense: true,
                          value: false,
                          title: Text(mEntry.value),
                          onChanged: (_) async {},
                        )
                      : Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: padding + 6),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(mEntry.value),
                          ),
                        ))
                  .toList(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Html(
                data: _settings.rosary.skeletonSplitted[2],
              ),
            ),
          ],
        ),
        floatingActionButton: _settings.rosary.isPlaying()
            ? FloatingActionButton(
                child: Icon(Icons.skip_next),
                onPressed: () async {
                  _settings.rosary.nextMistery();
                  _settings.update();
                },
              )
            : Container());
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
