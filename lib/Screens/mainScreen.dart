import 'package:evangelios/Model/SettingsHelper.dart';
import 'package:evangelios/Model/TextsSet.dart';
import 'package:evangelios/Parsers/BuigleProvider.dart';
import 'package:evangelios/Parsers/CiudadRedondaProvider.dart';
import 'package:evangelios/Screens/listScreen.dart';
import 'package:evangelios/Widgets/LoadingWidget.dart';
import 'package:evangelios/Widgets/PsalmWidget.dart';
import 'package:evangelios/Widgets/ScriptWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Parsers/Provider.dart';
import '../Util.dart';
import 'editScreen.dart';

import 'package:auto_size_text/auto_size_text.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime _selectedDate = DateTime.now();
  TextsSet _selectedTextsSet;

  double _scaleFactor=120;

  Provider _provider = CiudadRedondaProvider();

  SettingsHelper _settingsHelper = SettingsHelper();

  int _radioProvider = Providers.CiudadRedonda;

  void initState() {
    super.initState();

    _settingsHelper.getValue(Tags.scaleFactorTag).then((value) {
      setState(() {
        _scaleFactor = value == null ? 120 : double.parse(value);
      });
    });

    _settingsHelper.getValue(Tags.selectedProviderTag).then((value) {
      setState(() {
        _radioProvider = value == null ? Providers.CiudadRedonda : int.parse(value);
        _provider = _createProvider(_radioProvider);
      });
    });

    _provider.get(_selectedDate).then((texts) {
      setState(() {
        _selectedTextsSet = texts;
      });
    });
  }

  Provider _createProvider(int choice) {
    switch (choice) {
      case Providers.CiudadRedonda:
        return CiudadRedondaProvider();
      case Providers.Buigle:
        return BuigleProvider();
      default:
        return CiudadRedondaProvider();
    }
  }

  Future savevalues() async {
    await _settingsHelper.setValue(Tags.scaleFactorTag, _scaleFactor);
    await _settingsHelper.setValue(Tags.selectedProviderTag, _radioProvider);
  }

  //https://stackoverflow.com/questions/51607440/horizontally-scrollable-cards-with-snap-effect-in-flutter

  Widget _buildMainLayout(BuildContext context, TextsSet textsSet) {
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
            zoomFactor: _scaleFactor,
          ),
          Divider(),
          PsalmWidget(
              textsSet.psalm, textsSet.psalmResponse, textsSet.psalmIndex,
              zoomFactor: _scaleFactor),
          Divider(),
          (textsSet.second != null)
              ? ScriptWidget(
                  textsSet.second, textsSet.secondIndex, "Palabra de Dios",
                  zoomFactor: _scaleFactor)
              : Container(),
          (textsSet.second != null) ? Divider() : Container(),
          ScriptWidget(
              textsSet.godspel, textsSet.godspelIndex, "Palabra del Señor",
              zoomFactor: _scaleFactor),
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
        title: Row(children: <Widget>[
          Expanded(
            child: FlatButton(
              onPressed: () {
                _selectDate(context).then(_provider.get).then((texts) {
                  setState(() {
                    _selectedDate = texts.date;
                    _selectedTextsSet = texts;
                  });
                });
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: AutoSizeText(
                      Util.getFullDateSpanish(_selectedDate),
                      maxLines: 1,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).primaryColorDark,
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
      body: _selectedTextsSet != null
          ? _buildMainLayout(context, _selectedTextsSet)
          : LoadingWidget("cargando..."),
      //drawer: _buildDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditScreen(this._selectedTextsSet)),
          );
        },
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
                    onPressed: () {
                      _settingModalBottomSheet(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.listAlt,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ListScreen()),
                      );
                    },
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
                      savevalues().then((_) {});
                      setState(() {
                        _scaleFactor += 10;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.searchMinus,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      savevalues().then((_) {});
                      setState(() {
                        _scaleFactor -= 10;
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

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            //color: Theme.of(context).scaffoldBackgroundColor,
            child: new Wrap(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 8.0, bottom: 0.0),
                  child: Text(
                    "Selecciona proveedor",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(),
                RadioListTile(
                  dense: true,
                  value: Providers.CiudadRedonda,
                  groupValue: _radioProvider,
                  onChanged: (val) {
                    setState(() {
                      _radioProvider = val;
                      _provider = CiudadRedondaProvider();
                      _updateTextsSet();
                      savevalues().then(Navigator.of(context).pop);
                    });
                  },
                  title: new Text('Ciudad Redonda'),
                  subtitle: Text('www.ciudadredonda.org'),
                ),
                RadioListTile(
                  dense: true,
                  value: Providers.Buigle,
                  groupValue: _radioProvider,
                  onChanged: (val) {
                    setState(() {
                      _radioProvider = val;
                      _provider = BuigleProvider();
                      _updateTextsSet();
                      savevalues().then(Navigator.of(context).pop);
                    });
                  },
                  title: Text('Buigle'),
                  subtitle: Text('www.buigle.net'),
                ),
                Container(
                  height: 50,
                )
              ],
            ),
          );
        });
  }

  void _updateTextsSet() {
    _selectedTextsSet = null;
    _provider.get(_selectedDate).then((texts) {
      setState(() {
        this._selectedTextsSet = texts;
      });
    });
  }
}
