import 'package:evangelios/Model/TextsSet.dart';
import 'package:evangelios/Parsers/BuigleProvider.dart';
import 'package:evangelios/Parsers/CiudadRedondaParser.dart';
import 'package:evangelios/Widgets/GodspellWidget.dart';
import 'package:evangelios/Widgets/LectureWidget.dart';
import 'package:evangelios/Widgets/LoadingWidget.dart';
import 'package:evangelios/Widgets/PsalmWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Parsers/Provider.dart';
import '../Util.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime _selectedDate = DateTime.now();
  DateFormat _formatter = new DateFormat('EEEE dd de MMMM');
  TextsSet _selectedTextsSet;

  final int SETTINGS_ID = 0x01;
  final int DIARY_ID = 0x02;

  Provider _provider = BuigleProvider();

  void initState() {
    super.initState();
    _provider.get(_selectedDate).then((texts) {
      setState(() {
        _selectedTextsSet = texts;
      });
    });
  }

  //https://stackoverflow.com/questions/51607440/horizontally-scrollable-cards-with-snap-effect-in-flutter

  Widget _buildMainLayout(BuildContext context, TextsSet textsSet) {
    double spaceForCopyRight = 10;
    TextStyle copyRightStyle = TextStyle(fontSize: 10, color: Colors.grey);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          LectureWidget(textsSet.first, textsSet.firstIndex),
          Divider(),
          PsalmWidget(
              textsSet.psalm, textsSet.psalmIndex, textsSet.psalmResponse),
          Divider(),
          (textsSet.second != null)
              ? LectureWidget(textsSet.second, textsSet.secondIndex)
              : Container(),
          (textsSet.second != null) ? Divider() : Container(),
          GodspellWidget(textsSet.godspel, textsSet.godspelIndex),
          Container(
            height: spaceForCopyRight,
          ),
          Text(
            _provider.getProviderNameForDisplay(),
            style: copyRightStyle,
          )
        ]),
      ),
    );
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        locale: Locale('es', 'ES'),
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2018),
        lastDate: DateTime(2100));
    return picked == null ? _selectedDate : picked;
  }

  Widget _buildDrawer() {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
              color: Theme.of(context).primaryColor,
              height: MediaQuery.of(context).padding.top + 5),
          Container(
            color: Theme.of(context).primaryColor,
            child: ListTile(
              dense: true,
              title: Text(
                'Evangelios',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              //subtitle: Text(_provider.getProviderNameForDisplay(), style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),),
              leading: CircleAvatar(
                child: Icon(Icons.book),
              ),
            ),
          ),
          Container(
            height: 2,
            color: Theme.of(context).primaryColorDark,
          ),
          ListTile(
            title: Text('Diario'),
            leading: Icon(Icons.book),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Text('Ajustes'),
            leading: Icon(Icons.settings),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Util.getFullDateSpanish(_selectedDate),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _selectDate(context).then(_provider.get).then((texts) {
                setState(() {
                  _selectedDate = texts.date;
                  _selectedTextsSet = texts;
                });
              });
            },
          ),
          /*
          PopupMenuButton<int>(
              onSelected: (choice) {},
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<int>(
                    value: this.DIARY_ID,
                    child: Text("Diario"),
                  ),
                  PopupMenuItem<int>(
                    value: this.SETTINGS_ID,
                    child: Text("Ajustes"),
                  ),
                ];
              }),
              */
        ],
      ),
      body: _selectedTextsSet != null
          ? _buildMainLayout(context, _selectedTextsSet)
          : LoadingWidget("cargando..."),
      //drawer: _buildDrawer(),
/*
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.calendar_today),
        onPressed: () {},
      ),
      */
    );
  }
}
