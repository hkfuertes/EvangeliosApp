class CatholicCalendar {
  static List<Festivity> getFestivities(int year) {
    return [
      Festivity(
          name: "advent1",
          color: Festivity.PURPLE,
          date: DateTime.now().getChristmas().lastSunday().subtractWeeks(3)),
      Festivity(
          name: "advent2",
          color: Festivity.PURPLE,
          date: DateTime.now().getChristmas().lastSunday().subtractWeeks(2)),
      Festivity(
          name: "advent3",
          color: Festivity.PINK,
          date: DateTime.now().getChristmas().lastSunday().subtractWeeks(1)),
      Festivity(
          name: "advent4",
          color: Festivity.PURPLE,
          date: DateTime.now().getChristmas().lastSunday()),
      Festivity(name: "christmas", date: DateTime.now().getChristmas()),
      Festivity(
          name: "lent1",
          color: Festivity.PURPLE,
          date: DateTime.now().getEaster().subtractWeeks(6)),
      Festivity(
          name: "lent2",
          color: Festivity.PURPLE,
          date: DateTime.now().getEaster().subtractWeeks(5)),
      Festivity(
          name: "lent3",
          color: Festivity.PURPLE,
          date: DateTime.now().getEaster().subtractWeeks(4)),
      Festivity(
          name: "lent4",
          color: Festivity.PINK,
          date: DateTime.now().getEaster().subtractWeeks(3)),
      Festivity(
          name: "lent5",
          color: Festivity.PURPLE,
          date: DateTime.now().getEaster().subtractWeeks(2)),
      Festivity(
          name: "palmSunday",
          date: DateTime.now().getEaster().subtractWeeks(1)),
      Festivity(
          name: "easter2",
          color: Festivity.WHITE,
          date: DateTime.now().getEaster().addWeeks(1)),
      Festivity(
          name: "easter3",
          color: Festivity.WHITE,
          date: DateTime.now().getEaster().addWeeks(2)),
      Festivity(
          name: "easter4",
          color: Festivity.WHITE,
          date: DateTime.now().getEaster().addWeeks(3)),
      Festivity(
          name: "easter5",
          color: Festivity.WHITE,
          date: DateTime.now().getEaster().addWeeks(4)),
      Festivity(
          name: "easter6",
          color: Festivity.WHITE,
          date: DateTime.now().getEaster().addWeeks(5)),
      Festivity(
          name: "trinity",
          color: Festivity.WHITE,
          date: DateTime.now().getEaster().addWeeks(6)),
      Festivity(
          name: "corpus",
          color: Festivity.WHITE,
          date: DateTime.now().getEaster().addWeeks(7).addDays(4)),
      Festivity(
          name: "ashWednesday",
          color: Festivity.PURPLE,
          date: DateTime.now().getEaster().subtractDays(46)),
      Festivity(name: "motherofgod", date: DateTime(year, 1, 1)),
      Festivity(
          name: "holyThursday",
          color: Festivity.WHITE,
          date: DateTime.now().getEaster().subtractDays(3)),
      Festivity(
          name: "goodFriday",
          color: Festivity.RED,
          date: DateTime.now().getEaster().subtractDays(2)),
      Festivity(
          name: "easterVigil",
          color: Festivity.WHITE,
          date: DateTime.now().getEaster().subtractDays(1)),
      Festivity(
          name: "easter",
          color: Festivity.WHITE,
          date: DateTime.now().getEaster()),
      Festivity(
          name: "ascension",
          color: Festivity.WHITE,
          date: DateTime.now().getEaster().addDays(39)),
      Festivity(
          name: "easter7",
          color: Festivity.WHITE,
          date: DateTime.now().getEaster().addWeeks(6)),
      Festivity(
          name: "pentecost",
          color: Festivity.RED,
          date: DateTime.now().getEaster().addWeeks(7)),
    ];
  }

  static Map<DateTime, Festivity> getFestivitiesAsDateTimeMap(int year) {
    return getFestivities(year).asMap().map((_, e) => MapEntry(e.date, e));
  }

  static Map<String, Festivity> getFestivitiesAsNameMap(int year) {
    return getFestivities(year).asMap().map((_, e) => MapEntry(e.name, e));
  }
}

class Festivity {
  static const WHITE = 0xfff;
  static const RED = 0xDB1E1B;
  static const PURPLE = 0x6D2A82;
  static const GREEN = 0x52BA87;
  static const PINK = 0xF58E8F;

  String name;
  DateTime date;
  int? color; //hex value

  Festivity({required this.name, required this.date, this.color});

  static bool isDateBetweenFestivities(
      Festivity festivity1, Festivity festivity2, DateTime date) {
    return festivity1.date <= date && festivity2.date >= date;
  }
}

extension DateTimeExtensions on DateTime {
  bool operator <=(other) {
    return (other is DateTime) && compareTo(other) <= 0;
  }

  bool operator >=(other) {
    return (other is DateTime) && compareTo(other) >= 0;
  }

  DateTime nextSunday() {
    return add(Duration(days: DateTime.daysPerWeek - weekday));
  }

  DateTime lastSunday() {
    return subtract(Duration(days: DateTime.daysPerWeek - weekday));
  }

  DateTime addDays(int days) {
    return add(Duration(days: days));
  }

  DateTime subtractDays(int days) {
    return subtract(Duration(days: days));
  }

  DateTime addWeeks(int weeks) {
    return add(Duration(days: 7 * weeks));
  }

  DateTime subtractWeeks(int weeks) {
    return subtract(Duration(days: 7 * weeks));
  }

  DateTime getChristmas() {
    return DateTime(year, 12, 25);
  }

  DateTime getEaster() {
    int a = year % 19;
    int b = (year / 100).floor();
    int c = year % 100;
    int d = (b / 4).floor();
    int e = b % 4;
    int f = ((b + 8) / 25).floor();
    int g = ((b - f + 1) / 3).floor();
    int h = (19 * a + b - d - g + 15) % 30;
    int i = (c / 4).floor();
    int k = c % 4;
    int l = (32 + 2 * e + 2 * i - h - k) % 7;
    int m = ((a + 11 * h + 22 * l) / 451).floor();
    int month = ((h + l - 7 * m + 114) / 31).floor();
    int day = ((h + l - 7 * m + 114) % 31) + 1;
    return DateTime(year, month, day);
  }
}
