import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Rosary {
  final List<Mistery> misteries;
  final List<String> letanies;
  final String skeleton;
  List<String> skeletonSplitted;

  // 5 for each mistery and the 6th are the letanies.
  static const CURRENT_MISTERY = 0;
  static const CURRENT_COUNT = 1;
  List<int> playing = [-1, -1];

  bool isPlaying() {
    return playing[CURRENT_MISTERY] != -1 || playing[CURRENT_COUNT] != -1;
  }

  bool onLetanies() {
    return playing[CURRENT_MISTERY] == 5;
  }

  bool endOfMistery() {
    return playing[CURRENT_COUNT] == 12 && !onLetanies();
  }

  restartPlayer() {
    playing[CURRENT_MISTERY] = -1;
    playing[CURRENT_COUNT] = -1;
  }

  nextMistery() {
    //1 our father, 10 hail mary, 1 glory = 12;
    playing[CURRENT_COUNT]++;
    if (playing[CURRENT_COUNT] == 13 && !onLetanies()) {
      playing[CURRENT_COUNT] = 0;
      playing[CURRENT_MISTERY]++;
    }
    if (playing[CURRENT_COUNT] == letanies.length && onLetanies()) {
      restartPlayer();
    }
  }

  previousMistery() {
    playing[CURRENT_COUNT]--;
    if (playing[CURRENT_COUNT] == -1) {
      playing[CURRENT_COUNT] = 11;
      playing[CURRENT_MISTERY]--;
    }

    if (playing[CURRENT_MISTERY] == -1) {
      restartPlayer();
    }
  }

  static const MISTERIES_SPLIT_TOKEN = "<!-- MISTERIOS -->";
  static const LETANIES_SPLIT_TOKEN = "<!-- LETANIAS -->";
  static const MISTERIES_NAME_TOKEN = "{# misterios #}";

  Rosary(this.misteries, this.letanies, this.skeleton) {
    var firstSplit = this.skeleton.split(MISTERIES_SPLIT_TOKEN);
    var secondSplit = firstSplit[1].split(LETANIES_SPLIT_TOKEN);
    var thirdSplit = this.skeleton.split(LETANIES_SPLIT_TOKEN);
    skeletonSplitted = [firstSplit[0], secondSplit[0], thirdSplit[1]];
  }

  static Future<Rosary> getFromAsset(
      String dataPath, String skeletonPath) async {
    var skeleton = await rootBundle.loadString(skeletonPath);
    var data = await rootBundle.loadString(dataPath);
    var parsedJson = jsonDecode(data);
    return Rosary(
        (parsedJson["misteries"] as List)
            .map((e) => Mistery.fromJson(e))
            .toList(),
        (parsedJson["letanies"] as List).map((e) => e.toString()).toList(),
        skeleton);
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/my_text.txt');
  }

  Mistery getTodayMisteries() {
    var dayOfWeek = DateTime.now().weekday;
    for (Mistery m in misteries) {
      if (m.dayOfWeek.contains(dayOfWeek)) return m;
    }
    return misteries[0];
  }

  String getTodayTitle() {
    return getTodayMisteries().name;
  }
}

class Mistery {
  final String name;
  final List<int> dayOfWeek;
  final List<String> misteries;

  Mistery(this.name, this.dayOfWeek, this.misteries);

  static Mistery fromJson(Map<String, dynamic> parsedJson) {
    return Mistery(
        parsedJson["name"],
        (parsedJson["dayOfWeek"] as List)
            .map((e) => int.parse(e.toString()))
            .toList(),
        (parsedJson["misteries"] as List).map((e) => e.toString()).toList());
  }
}
