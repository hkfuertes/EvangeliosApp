import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lecturas/constants.dart';
import 'package:lecturas/parsers/buigle_provider.dart';
import 'package:lecturas/parsers/ciudad_redonda_provider.dart';
import 'package:lecturas/widgets/psalm_widget.dart';
import 'package:lecturas/widgets/script_widget.dart';

import '../model/text_sets.dart';
import '../parsers/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime? _selectedDate;
  final DateFormat _formatter = DateFormat('dd/MM/yyyy');

  final List<Provider> _providers = [BuigleProvider(), CiudadRedondaProvider()];
  Provider _currentProvider = BuigleProvider();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor),
      child: Scaffold(
        body: FutureBuilder<TextsSet>(
            future: _currentProvider.get(_selectedDate ?? DateTime.now()),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return SafeArea(
                    child: ListView(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 6.0),
                        child: Icon(Icons.book),
                      ),
                      Expanded(child: _buildDateSelectorButton()),
                    ],
                  ),
                  ..._textsSetToList(snapshot.data!),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Proveedores",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  ..._providerWidgets(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Ajustes",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  const SwitchListTile(
                    value: false,
                    onChanged: null,
                    title: Text("Visperas"),
                    subtitle: Text("Mostrar el dia siguiente después 19.00"),
                  )
                ]));
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  List<Widget> _providerWidgets() {
    return _providers
        .map((value) => RadioListTile<Provider>(
              value: value,
              groupValue: _currentProvider,
              onChanged: (selected) {
                if (selected != null) {
                  setState(() {
                    _currentProvider = selected;
                  });
                }
              },
              title: Text(value.getProviderNameForDisplay()),
            ))
        .toList();
  }

  Widget _buildDateSelectorButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                          Constants.days[
                              (_selectedDate ?? DateTime.now()).weekday - 1],
                          textScaleFactor: 1.25,
                        ),
                        Text(
                          _formatter.format(_selectedDate ?? DateTime.now()),
                          style: const TextStyle(fontWeight: FontWeight.w100),
                        ),
                      ]),
                ),
              ),
            ],
          )),
    );
  }

  List<Widget> _textsSetToList(TextsSet set, {asExpandableTile = true}) {
    return [
      ScriptWidget(
        text: set.first,
        quote: set.firstIndex,
        title: "Primera Lectura",
        asExpandableTile: asExpandableTile,
      ),
      PsalmWidget(
        texts: set.psalm.split("\n\n"),
        repeat: set.psalmResponse,
        quote: set.psalmIndex,
        title: "Salmo Responsorial",
        asExpandableTile: asExpandableTile,
      ),
      if (set.second != null)
        ScriptWidget(
          text: set.second!,
          quote: set.secondIndex!,
          title: "Segunda Lectura",
          asExpandableTile: asExpandableTile,
        ),
      ScriptWidget(
        text: set.godspel,
        quote: set.godspelIndex,
        title: "Evangelio",
        asExpandableTile: asExpandableTile,
      )
    ];
  }
}
