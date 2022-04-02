import 'package:flutter/material.dart';

import 'model/catholic_calendar.dart';

class Constants {
  static const days = [
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado",
    "Domingo"
  ];
  static const months = [
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio",
    "Julio",
    "Agosto",
    "Septiembre",
    "Octubre",
    "Noviembre",
    "Diciembre"
  ];

  static ThemeData getThemeFromCalendar() {
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

    if (color == Festivity.WHITE) {
      return ThemeData.dark();
    }

    var swatch = createMaterialColor(Color(color));
    return ThemeData(
        brightness: Brightness.dark,
        primarySwatch: swatch,
        scaffoldBackgroundColor: swatch.shade900.darken(),
        bottomAppBarColor: swatch.shade900.darken(),
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: swatch.shade900.darken()),
        //iconTheme: IconThemeData(color: swatch.shade50.lighten()),
        switchTheme: SwitchThemeData(
            thumbColor: MaterialStateProperty.all(Colors.white),
            trackColor: MaterialStateProperty.resolveWith((states) =>
                (states.contains(MaterialState.selected)
                    ? Colors.white.withOpacity(0.7)
                    : Colors.white.withOpacity(0.3)))),
        radioTheme:
            RadioThemeData(fillColor: MaterialStateProperty.all(Colors.white)));
  }

  static MaterialColor createMaterialColor(Color color) {
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
