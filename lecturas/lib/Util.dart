import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Util {
  static List<String> days = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo'
  ];
  static List<String> months = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];

  static String getDayOfWeekSpanish(DateTime date) {
    return days[date.weekday - 1];
  }

  static String getMonthSpanish(DateTime date) {
    return months[date.month - 1];
  }

  static String getFullDateSpanish(DateTime date) {
    return getDayOfWeekSpanish(date) +
        " " +
        date.day.toString() +
        " de " +
        getMonthSpanish(date);
  }

  static String getDateSpanish(DateTime date) {
    return date.day.toString() + " de " + getMonthSpanish(date);
  }

  static ThemeData getScaledTextTheme(
      BuildContext context, double scaleFactor) {
    return Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.copyWith(
              bodyText1: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: Theme.of(context).textTheme.bodyText1.fontSize *
                      scaleFactor),
              bodyText2: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontSize: Theme.of(context).textTheme.bodyText2.fontSize *
                      scaleFactor),
              headline1: Theme.of(context).textTheme.headline1.copyWith(
                  fontSize: Theme.of(context).textTheme.headline1.fontSize *
                      scaleFactor),
              headline2: Theme.of(context).textTheme.headline2.copyWith(
                  fontSize: Theme.of(context).textTheme.headline2.fontSize *
                      scaleFactor),
              headline3: Theme.of(context).textTheme.headline3.copyWith(
                  fontSize: Theme.of(context).textTheme.headline3.fontSize *
                      scaleFactor),
              headline4: Theme.of(context).textTheme.headline4.copyWith(
                  fontSize: Theme.of(context).textTheme.headline4.fontSize *
                      scaleFactor),
              headline5: Theme.of(context).textTheme.headline5.copyWith(
                  fontSize: Theme.of(context).textTheme.headline5.fontSize *
                      scaleFactor),
              headline6: Theme.of(context).textTheme.headline6.copyWith(
                  fontSize: Theme.of(context).textTheme.headline6.fontSize *
                      scaleFactor),
              caption: Theme.of(context).textTheme.caption.copyWith(
                  fontSize: Theme.of(context).textTheme.caption.fontSize *
                      scaleFactor),
              subtitle1: Theme.of(context).textTheme.subtitle1.copyWith(
                  fontSize: Theme.of(context).textTheme.subtitle1.fontSize *
                      scaleFactor),
              subtitle2: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontSize: Theme.of(context).textTheme.subtitle2.fontSize *
                      scaleFactor),
              button: Theme.of(context).textTheme.button.copyWith(
                  fontSize: Theme.of(context).textTheme.button.fontSize *
                      scaleFactor),
              overline: Theme.of(context).textTheme.overline.copyWith(
                  fontSize: Theme.of(context).textTheme.overline.fontSize *
                      scaleFactor),
            ));
  }
}
