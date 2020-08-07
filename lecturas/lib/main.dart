import 'package:lecturas/Model/Settings.dart';
import 'package:provider/provider.dart';

import 'Screens/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Settings settings = Settings();
  await settings.retrieveConfig();
  runApp(ChangeNotifierProvider(create: (context) => settings, child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lecturas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //brightness: Brightness.dark,
        primarySwatch: Colors.brown,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate, // if it's a RTL language
      ],
      supportedLocales: [
        const Locale('es', 'ES'), // include country code too
      ],
      home: MainScreen(),
    );
  }
}
