import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lecturas/constants.dart';
import 'package:lecturas/parsers/buigle_provider.dart';
import 'package:lecturas/parsers/ciudad_redonda_provider.dart';
import 'package:lecturas/widgets/psalm_widget.dart';
import 'package:lecturas/widgets/script_widget.dart';

import '../model/text_sets.dart';
import '../parsers/misas_navarra_provider.dart';
import '../parsers/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final ScrollController _listController;
  double _percentage = 0;
  DateTime? _selectedDate;
  final DateFormat _formatter = DateFormat('dd/MM/yyyy');
  int _selectedProvider = 0;

  final List<Provider> _providers = [
    BuigleProvider(),
    CiudadRedondaProvider(),
    MisasNavarraProvider()
  ];

  @override
  void initState() {
    _listController = ScrollController();
    _listController.addListener(
      () {
        setState(() {
          _percentage =
              _listController.offset / _listController.position.maxScrollExtent;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Theme.of(context).scaffoldBackgroundColor,
          systemNavigationBarColor: Theme.of(context).bottomAppBarColor),
      child: Scaffold(
        body: SafeArea(
            child: FutureBuilder<TextsSet>(
                future: _providers[_selectedProvider]
                    .get(_selectedDate ?? DateTime.now()),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return ListView(
                        controller: _listController,
                        children: [..._textsSetToList(snapshot.requireData)]);
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              minHeight: 2,
              color: Colors.white.withOpacity(0.7),
              value: _percentage,
            ),
            ListTile(
              onTap: () {},
              title: Text(Constants
                  .days[(_selectedDate ?? DateTime.now()).weekday - 1]),
              subtitle: Text(
                _formatter.format(_selectedDate ?? DateTime.now()),
                textScaleFactor: 0.75,
                style: const TextStyle(
                    fontWeight: FontWeight.w100, fontStyle: FontStyle.italic),
              ),
              //Add here any
              trailing: PopupMenuButton<int>(
                icon: const Icon(Icons.settings),
                onSelected: (value) {
                  setState(() {
                    _selectedProvider = value;
                  });
                },
                itemBuilder: (BuildContext context) {
                  return _providers
                      .asMap()
                      .map<int, PopupMenuItem<int>>(
                          (key, value) => MapEntry<int, PopupMenuItem<int>>(
                              key,
                              PopupMenuItem<int>(
                                child: Row(
                                  children: [
                                    Radio<int>(
                                        value: key,
                                        groupValue: _selectedProvider,
                                        onChanged: null),
                                    Text(value.getProviderNameForDisplay()),
                                  ],
                                ),
                                value: key,
                              )))
                      .values
                      .toList();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _textsSetToList(TextsSet set) {
    return [
      ScriptWidget(
        text: set.first,
        quote: set.firstIndex,
        title: "Primera Lectura",
      ),
      if (set.second != null)
        ScriptWidget(
          text: set.second!,
          quote: set.secondIndex!,
          title: "Segunda Lectura",
        ),
      PsalmWidget(
        texts: set.psalm.split("\n\n"),
        repeat: set.psalmResponse,
        quote: set.psalmIndex,
        title: "Salmo Responsorial",
      ),
      ScriptWidget(
        text: set.godspel,
        quote: set.godspelIndex,
        title: "Evangelio",
      )
    ];
  }
}
