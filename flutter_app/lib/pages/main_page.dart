import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lecturas/constants.dart';
import 'package:lecturas/model/settings_controller.dart';
import 'package:lecturas/panels/date_selector_panel.dart';
import 'package:lecturas/panels/settings_panel.dart';
import 'package:lecturas/widgets/psalm_widget.dart';
import 'package:lecturas/widgets/script_widget.dart';
import 'package:provider/provider.dart';

import '../model/text_sets.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final DateFormat _formatter = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    SettingsController settings = context.watch<SettingsController>();
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder<TextsSet>(
            future: settings.getProvider().get(settings.getDate()),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return SafeArea(
                    child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: _textsSetToList(snapshot.data!,
                            textScale: settings.getTextScale()),
                      ),
                    ),
                    Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: _buildHeader(context, settings)),
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

  Widget _buildHeader(BuildContext context, SettingsController settings) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white, width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: _buildDateSelectorButton(context, settings)),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 4.0),
            child: IconButton(
                onPressed: () {
                  _showCustomModalBottomSheet(context, SettingsPanel());
                },
                icon: const Icon(Icons.settings)),
          )
        ],
      ),
    );
  }

  _showCustomModalBottomSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8))
                .copyWith(bottomLeft: Radius.zero, bottomRight: Radius.zero)),
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              child,
            ],
          );
        });
  }

  Widget _buildDateSelectorButton(
      BuildContext context, SettingsController settings) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton.icon(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white)),
          onPressed: () {
            _showCustomModalBottomSheet(
                context,
                DateSelectorPanel(
                  initialDate: settings.getDate(),
                  onDatePicked: (date) {
                    settings.currentDate = date;
                    settings.notifyListeners();
                  },
                ));
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
                          Constants.days[settings.getDate().weekday - 1],
                          textScaleFactor: 1.25,
                        ),
                        Text(
                          _formatter.format(settings.getDate()),
                          style: const TextStyle(fontWeight: FontWeight.w100),
                        ),
                      ]),
                ),
              ),
            ],
          )),
    );
  }

  List<Widget> _textsSetToList(TextsSet set,
      {asExpandableTile = false, textScale = 1}) {
    return [
      ScriptWidget(
        text: set.first,
        quote: set.firstIndex,
        title: "Primera Lectura",
        asExpandableTile: asExpandableTile,
        textScale: textScale,
      ),
      const Divider(),
      PsalmWidget(
          texts: set.psalm.split("\n\n"),
          repeat: set.psalmResponse,
          quote: set.psalmIndex,
          title: "Salmo Responsorial",
          asExpandableTile: asExpandableTile,
          textScale: textScale),
      const Divider(),
      if (set.second != null)
        ScriptWidget(
            text: set.second!,
            quote: set.secondIndex!,
            title: "Segunda Lectura",
            asExpandableTile: asExpandableTile,
            textScale: textScale),
      if (set.second != null) const Divider(),
      ScriptWidget(
          text: set.godspel,
          quote: set.godspelIndex,
          title: "Evangelio",
          asExpandableTile: asExpandableTile,
          textScale: textScale)
    ];
  }
}
