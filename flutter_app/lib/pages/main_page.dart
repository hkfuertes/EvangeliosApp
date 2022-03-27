import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lecturas/constants.dart';
import 'package:lecturas/model/settings_controller.dart';
import 'package:lecturas/panels/settings_panel.dart';
import 'package:lecturas/parsers/buigle_provider.dart';
import 'package:lecturas/widgets/psalm_widget.dart';
import 'package:lecturas/widgets/script_widget.dart';

import '../model/text_sets.dart';
import '../parsers/texts_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime? _selectedDate;
  final DateFormat _formatter = DateFormat('dd/MM/yyyy');
  TextsProvider _currentProvider = BuigleProvider();

  DateTime _getDate({preferSunday = false}) {
    if (_selectedDate != null) {
      return _selectedDate!;
    } else {
      var now = DateTime.now();
      return (preferSunday && now.hour > 19)
          ? now.add(const Duration(days: 1))
          : now;
    }
  }

  @override
  Widget build(BuildContext context) {
    var settings = SettingsController.of(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor),
      child: Scaffold(
        body: FutureBuilder<TextsSet>(
            future: settings
                .getProvider()
                .get(_getDate(preferSunday: settings.getPreferSunday())),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return SafeArea(
                    child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: _textsSetToList(snapshot.data!),
                      ),
                    ),
                    _buildHeader(settings),
                  ],
                ));
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  Widget _buildHeader(SettingsController settings) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white, width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          /*
          const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 6.0),
            child: Icon(Icons.book),
          ),*/
          Expanded(child: _buildDateSelectorButton(settings)),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 4.0),
            child: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))
                                  .copyWith(
                                      bottomLeft: Radius.zero,
                                      bottomRight: Radius.zero)),
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /*
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 64),
                              child: Container(
                                color: Colors.white.withOpacity(0.5),
                                height: 2,
                              ),
                            ),*/
                            SettingsPanel(),
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.settings)),
          )
        ],
      ),
    );
  }

  Widget _buildDateSelectorButton(SettingsController settings) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton.icon(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white)),
          onPressed: () {
            showDatePicker(
                    locale: const Locale("es", "ES"),
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365)))
                .then((value) {
              setState(() {
                _selectedDate = value;
              });
            });
          },
          icon: const Icon(Icons.calendar_month_outlined),
          label: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Constants.days[(_getDate(
                                      preferSunday: settings.getPreferSunday()))
                                  .weekday -
                              1],
                          textScaleFactor: 1.25,
                        ),
                        Text(
                          _formatter.format(_getDate(
                              preferSunday: settings.getPreferSunday())),
                          style: const TextStyle(fontWeight: FontWeight.w100),
                        ),
                      ]),
                ),
              ),
            ],
          )),
    );
  }

  List<Widget> _textsSetToList(TextsSet set, {asExpandableTile = false}) {
    return [
      ScriptWidget(
        text: set.first,
        quote: set.firstIndex,
        title: "Primera Lectura",
        asExpandableTile: asExpandableTile,
      ),
      const Divider(),
      PsalmWidget(
        texts: set.psalm.split("\n\n"),
        repeat: set.psalmResponse,
        quote: set.psalmIndex,
        title: "Salmo Responsorial",
        asExpandableTile: asExpandableTile,
      ),
      const Divider(),
      if (set.second != null)
        ScriptWidget(
          text: set.second!,
          quote: set.secondIndex!,
          title: "Segunda Lectura",
          asExpandableTile: asExpandableTile,
        ),
      if (set.second != null) const Divider(),
      ScriptWidget(
        text: set.godspel,
        quote: set.godspelIndex,
        title: "Evangelio",
        asExpandableTile: asExpandableTile,
      )
    ];
  }
}
