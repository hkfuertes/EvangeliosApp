import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lecturas/Model/Settings.dart';
import 'package:lecturas/Parsers/TextsProvider.dart';
import 'package:provider/provider.dart';

class LecturasDrawer extends StatelessWidget {
  Settings _settings;

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);
    bool dark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.bible,
                color: (dark)
                    ? Theme.of(context).textTheme.bodyText1.color
                    : Theme.of(context).primaryColor,
              ),
              title: Text(
                "Lecturas",
                style: TextStyle(
                    color: (dark)
                        ? Theme.of(context).textTheme.bodyText1.color
                        : Theme.of(context).primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            height: 3,
            color: Theme.of(context).primaryColor,
          ),
          Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text("Proveedores"),
            ),
          ),
          RadioListTile(
            dense: true,
            value: TextsProviders.CiudadRedonda,
            groupValue: _settings.selectedProvider,
            onChanged: (val) {
              _settings.selectedProvider = val;
              _settings.update();
              Navigator.of(context).pop();
            },
            title: new Text('Ciudad Redonda'),
            subtitle: Text('www.ciudadredonda.org'),
          ),
          RadioListTile(
            dense: true,
            value: TextsProviders.Buigle,
            groupValue: _settings.selectedProvider,
            onChanged: (val) {
              _settings.selectedProvider = val;
              _settings.update();
              Navigator.of(context).pop();
            },
            title: Text('Buigle'),
            subtitle: Text('www.buigle.net'),
          ),
          Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text("Ajustes"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.font_download),
            title: Text("Tamaño"),
            trailing: ToggleButtons(
              onPressed: (number) async {
                switch (number) {
                  case 0:
                    _settings.scaleFactor = 1.2;
                    break;
                  case 1:
                    _settings.scaleFactor = 1.7;
                    break;
                  case 2:
                    _settings.scaleFactor = 2;
                    break;
                  default:
                    _settings.scaleFactor = 1;
                }
                _settings.update();
              },
              children: [
                Text(
                  "A",
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.bodyText1.fontSize * 1.2),
                ),
                Text(
                  "A",
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.bodyText1.fontSize * 1.7),
                ),
                Text(
                  "A",
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.bodyText1.fontSize * 2),
                ),
              ],
              isSelected: [
                _settings.scaleFactor == 1.2,
                _settings.scaleFactor == 1.7,
                _settings.scaleFactor == 2
              ],
            ),
          ),
          SwitchListTile(
            onChanged: (val) async {
              _settings.darkTheme = val;
              _settings.update();
            },
            secondary: Icon(FontAwesomeIcons.paintBrush),
            value: _settings.darkTheme,
            title: Text("Tema Oscuro"),
            controlAffinity: ListTileControlAffinity.trailing,
          )
        ],
      ),
    );
  }
}
