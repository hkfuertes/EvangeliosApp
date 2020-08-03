import '../Model/Comment.dart';
import '../Model/SettingsHelper.dart';
import '../Model/TextsSet.dart';
import '../Parsers/BuigleProvider.dart';
import '../Parsers/CiudadRedondaProvider.dart';
import '../Screens/listScreen.dart';
import '../Widgets/LoadingWidget.dart';
import '../Widgets/PsalmWidget.dart';
import '../Widgets/ScriptWidget.dart';
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

  double _scaleFactor = 120;

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
        _radioProvider =
            value == null ? Providers.CiudadRedonda : int.parse(value);
        _provider = _createProvider(_radioProvider);
      });
    });

    _retrieveTexts(_provider, _selectedDate).then((texts) {
      setState(() {
        _selectedTextsSet = texts;
      });
    });
  }

  Future<TextsSet> _retrieveTexts(Provider provider, DateTime date) async {
    var savedDate = await _settingsHelper.getValue(Tags.LAST_UPDATED_TAG);
    var savedProvider = await _settingsHelper.getValue(Tags.TEXTS_PROVIDER_TAG);
    if (savedDate != null &&
        Comment.dateFormatter.parse(savedDate).difference(date).inDays == 0 &&
        savedProvider == provider.getProviderNameForDisplay()) {
      return TextsSet(
        Comment.dateFormatter.parse(savedDate),
        await _settingsHelper.getValue(Tags.FIRST_TAG),
        await _settingsHelper.getValue(Tags.FIRST_INDEX_TAG),
        await _settingsHelper.getValue(Tags.SECOND_TAG),
        await _settingsHelper.getValue(Tags.SECOND_INDEX_TAG),
        await _settingsHelper.getValue(Tags.PSALM_INDEX_TAG),
        await _settingsHelper.getValue(Tags.PSALM_RESPONSE_TAG),
        await _settingsHelper.getValue(Tags.PSALM_TAG),
        await _settingsHelper.getValue(Tags.GODSPELL_TAG),
        await _settingsHelper.getValue(Tags.GODSPELL_INDEX_TAG),
      );
    } else {
      var texts = await provider.get(date);

      if (date.difference(DateTime.now()).inDays == 0) {
        await _settingsHelper.setValue(Tags.LAST_UPDATED_TAG,
            Comment.dateFormatter.format(DateTime.now()));
        await _settingsHelper.setValue(Tags.FIRST_TAG, texts.first);
        await _settingsHelper.setValue(Tags.FIRST_INDEX_TAG, texts.firstIndex);
        await _settingsHelper.setValue(Tags.SECOND_TAG, texts.second);
        await _settingsHelper.setValue(
            Tags.SECOND_INDEX_TAG, texts.secondIndex);
        await _settingsHelper.setValue(Tags.PSALM_INDEX_TAG, texts.psalmIndex);
        await _settingsHelper.setValue(
            Tags.PSALM_RESPONSE_TAG, texts.psalmResponse);
        await _settingsHelper.setValue(Tags.PSALM_TAG, texts.psalm);
        await _settingsHelper.setValue(
            Tags.GODSPELL_INDEX_TAG, texts.godspelIndex);
        await _settingsHelper.setValue(Tags.GODSPELL_TAG, texts.godspel);

        await _settingsHelper.setValue(
            Tags.TEXTS_PROVIDER_TAG, provider.getProviderNameForDisplay());
      }

      return texts;
    }
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
        leading: Icon(
          FontAwesomeIcons.bible,
          color: Colors.brown,
        ),
        brightness: Brightness.light,
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: AutoSizeText(
          Util.getFullDateSpanish(_selectedDate),
          maxLines: 1,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.brown),
            onPressed: () {
              _selectDate(context).then(_provider.get).then((texts) {
                setState(() {
                  _selectedDate = texts.date;
                  _selectedTextsSet = texts;
                });
              });
            },
          )
        ],
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
