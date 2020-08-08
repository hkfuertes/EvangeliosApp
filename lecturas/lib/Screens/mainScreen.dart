import 'package:flutter_html/flutter_html.dart';

import '../Model/Settings.dart';
import 'package:provider/provider.dart';
import '../Model/TextsSet.dart';

import '../Widgets/LoadingWidget.dart';
import '../Widgets/PsalmWidget.dart';
import '../Widgets/ScriptWidget.dart';
import '../Widgets/LecturasDrawer.dart';
import 'package:flutter/material.dart';

import '../Util.dart';

class MainScreen extends StatelessWidget {
  Settings _settings;

  Widget _buildMainLayout(
      BuildContext context, TextsSet textsSet, Settings _settings) {
    double spaceForCopyRight = 10;
    TextStyle copyRightStyle = TextStyle(fontSize: 10, color: Colors.grey);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 8.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(children: <Widget>[
          ScriptWidget(
            textsSet.first,
            textsSet.firstIndex,
            "Palabra de Dios",
            zoomFactor: _settings.scaleFactor * 100,
          ),
          Divider(),
          PsalmWidget(
              textsSet.psalm, textsSet.psalmResponse, textsSet.psalmIndex,
              zoomFactor: _settings.scaleFactor * 100),
          Divider(),
          (textsSet.second != null)
              ? ScriptWidget(
                  textsSet.second, textsSet.secondIndex, "Palabra de Dios",
                  zoomFactor: _settings.scaleFactor * 100)
              : Container(),
          (textsSet.second != null) ? Divider() : Container(),
          ScriptWidget(
              textsSet.godspel, textsSet.godspelIndex, "Palabra del Señor",
              zoomFactor: _settings.scaleFactor * 100),
          Container(
            height: spaceForCopyRight,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            Text(
              _settings.getProvider().getProviderNameForDisplay(),
              style: copyRightStyle,
            ),
          ])
        ]),
      ),
    );
  }

  Future<DateTime> _selectDate(BuildContext context, Settings _settings) async {
    final DateTime picked = await showDatePicker(
        locale: Locale('es', 'ES'),
        context: context,
        initialDate: _settings.currentTime,
        firstDate: DateTime(2018),
        lastDate: DateTime(2100));
    return picked == null ? _settings.currentTime : picked;
  }

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          Util.getFullDateSpanish(_settings.currentTime),
          maxLines: 1,
          style: TextStyle(
            color: (_settings.darkTheme)
                ? Theme.of(context).textTheme.bodyText1.color
                : Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            //fontSize: 24
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.calendar_today,
            ),
            onPressed: () async {
              _settings.currentTime = await _selectDate(context, _settings);
              _settings.update();
            },
          )
        ],
      ),
      body: FutureBuilder<TextsSet>(
        future: _settings.retrieveText(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData)
            return LoadingWidget("cargando...");
          else
            return _buildMainLayout(context, snapshot.data, _settings);
        },
      ),
      drawer: LecturasDrawer(),
      floatingActionButton: (_settings
              .getProvider()
              .hasExtras(_settings.currentTime))
          ? FutureBuilder<String>(
              future: _settings.getProvider().getExtraUrl(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) return Container();
                return FloatingActionButton(
                  child: Icon(Icons.comment),
                  onPressed: () async {
                    /*
                    if (Platform.isAndroid) {
                      AndroidIntent intent = AndroidIntent(
                        action: 'action_view',
                        data: snapshot.data,
                        //type: "application/pdf"
                      );
                      await intent.launch();
                    }
                    */
                    //await _launchURL(context, snapshot.data);
                    _commentBottomSheet(context, snapshot.data, _settings);
                    print(snapshot.data);
                  },
                );
              })
          : Container(),
    );
  }

  void _commentBottomSheet(context, String text, Settings _settings) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            //color: Theme.of(context).scaffoldBackgroundColor,
            child: new ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 8.0, bottom: 0.0),
                  child: Text(
                    "Comentario",
                    //textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            Theme.of(context).textTheme.bodyText1.fontSize *
                                _settings.scaleFactor),
                  ),
                ),
                Divider(),
                Html(
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 8.0, bottom: 0.0),
                  data: text,
                  defaultTextStyle: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyText1.fontSize *
                          _settings.scaleFactor),
                ),
                Container(
                  height: 50,
                )
              ],
            ),
          );
        });
  }
}
