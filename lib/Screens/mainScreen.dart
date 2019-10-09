import 'package:evangelios/Model/TextsSet.dart';
import 'package:evangelios/Parsers/BuigleProvider.dart';
import 'package:evangelios/Parsers/CiudadRedondaProvider.dart';
import 'package:evangelios/Widgets/LoadingWidget.dart';
import 'package:evangelios/Widgets/ScriptWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  double _scaleFactor = 120;

  final int SETTINGS_ID = 0x01;
  final int DIARY_ID = 0x02;

  Provider _provider = Provider.getInstance("CiudadRedonda");

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
          ScriptWidget(
            textsSet.getFirstMarkDown(),
            zoomFactor: _scaleFactor,
          ),
          Divider(),
          ScriptWidget(textsSet.getPsalmMarkDown(), zoomFactor: _scaleFactor),
          Divider(),
          (textsSet.second != null)
              ? ScriptWidget(textsSet.getSecondMarkDown(),
                  zoomFactor: _scaleFactor)
              : Container(),
          (textsSet.second != null) ? Divider() : Container(),
          ScriptWidget(textsSet.getGodspelMarkDown(), zoomFactor: _scaleFactor),
          Container(
            height: spaceForCopyRight,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            Text(
              _provider.getProviderNameForDisplay(),
              style: copyRightStyle,
            ),
          ])
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //statusBarColor: Theme.of(context).scaffoldBackgroundColor));
        statusBarColor: Colors.transparent));
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: FlatButton(
          onPressed: () {
            _selectDate(context).then(_provider.get).then((texts) {
              setState(() {
                _selectedDate = texts.date;
                _selectedTextsSet = texts;
              });
            });
          },
          child: Text(
            Util.getFullDateSpanish(_selectedDate),
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 24),
          ),
        ),
      ),
      body: _selectedTextsSet != null
          ? _buildMainLayout(context, _selectedTextsSet)
          : LoadingWidget("cargando..."),
      //drawer: _buildDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {},
      ),

      bottomNavigationBar: Container(
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {},
                  ),
                  
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.listAlt,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {},
                  ),
                  
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.searchPlus,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                       _scaleFactor+=10; 
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.searchMinus,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                       _scaleFactor-=10; 
                      });
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
