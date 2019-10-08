import 'package:evangelios/Model/TextsSet.dart';
import 'package:evangelios/Parsers/CiudadRedondaParser.dart';
import 'package:evangelios/Widgets/GodspellWidget.dart';
import 'package:evangelios/Widgets/LectureWidget.dart';
import 'package:evangelios/Widgets/PsalmWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime _selectedDate = DateTime.now();
  DateFormat _formatter = new DateFormat('EEEE dd MMMM');

  //https://stackoverflow.com/questions/51607440/horizontally-scrollable-cards-with-snap-effect-in-flutter

  Widget _buildMainLayout(BuildContext context, TextsSet textsSet) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            LectureWidget(textsSet.first, textsSet.firstIndex),
            Divider(),
            PsalmWidget(textsSet.psalm, textsSet.psalmIndex, textsSet.psalmResponse),
            Divider(),
            LectureWidget(textsSet.first, textsSet.firstIndex),
            Divider(),
            GodspellWidget(textsSet.godspel, textsSet.godspelIndex)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //elevation: 0,
        title: Text(
          _formatter.format(_selectedDate),
          //style: TextStyle(color: Colors.black),
          ),
      ),
      body: FutureBuilder<TextsSet>(
        future: CiudadRedondaParser().get(_selectedDate),
        builder: (BuildContext context, AsyncSnapshot<TextsSet> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text('Esperando resultado...');
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return _buildMainLayout(context, snapshot.data);
          }
          return null;
        },
      ),
    );
  }
}
