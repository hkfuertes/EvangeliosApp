import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:json_theme/json_theme.dart';
import 'package:lecturas/model/catholic_calendar.dart';
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
    return MaterialApp(
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
      supportedLocales: const [
        Locale('es', 'ES'),
      ],
      title: 'Lecturas',
      theme: _getThemeFromCalendar(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }

  ThemeData _getThemeFromCalendar() {
    var color = Festivity.GREEN;
    var byDateTime =
        CatholicCalendar.getFestivitiesAsDateTimeMap(DateTime.now().year);
    var byName = CatholicCalendar.getFestivitiesAsNameMap(DateTime.now().year);
    //Check if date is specific if not check periods
    if (byDateTime.containsKey(DateTime.now())) {
      color = byDateTime[DateTime.now()]!.color ?? Festivity.GREEN;
    } else {
      var ashWednesday = byName["ashWednesday"]!;
      var easter = byName["easter"]!;
      var advent1 = byName["advent1"]!;
      var christmas = byName["christmas"]!;
      if (Festivity.isDateBetweenFestivities(
          ashWednesday, easter, DateTime.now())) {
        color = ashWednesday.color ?? Festivity.PURPLE;
      } else if (Festivity.isDateBetweenFestivities(
          advent1, christmas, DateTime.now())) {
        color = advent1.color ?? Festivity.PURPLE;
      }
    }

    var swatch = createMaterialColor(Color(color));
    return ThemeData(
        brightness: Brightness.dark,
        primarySwatch: swatch,
        iconTheme: IconThemeData(color: swatch.shade50.lighten()),
        switchTheme: SwitchThemeData(
            thumbColor: MaterialStateProperty.all(swatch.shade100),
            trackColor: MaterialStateProperty.resolveWith((states) =>
                (states.contains(MaterialState.selected)
                    ? swatch.shade50.withOpacity(0.7)
                    : swatch.shade50.withOpacity(0.3)))),
        radioTheme: RadioThemeData(
            fillColor: MaterialStateProperty.all(swatch.shade100)));
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
