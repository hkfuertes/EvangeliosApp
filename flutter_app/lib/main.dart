import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lecturas/constants.dart';
import 'package:lecturas/model/settings_controller.dart';
import 'package:lecturas/pages/main_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  var settings = await SettingsController.fromPrefs();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => settings),
  ], child: const MyApp()));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var date = context.watch<SettingsController>().getDate();
    return MaterialApp(
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
      supportedLocales: const [
        Locale('es', 'ES'),
      ],
      title: 'Lecturas',
      theme: Constants.getThemeFromCalendar(date: date),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
