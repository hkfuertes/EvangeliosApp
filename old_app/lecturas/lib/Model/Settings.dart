import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lecturas/Model/Rosary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/SettingsHelper.dart';
import '../Model/TextsSet.dart';
import '../Parsers/BuigleProvider.dart';
import '../Parsers/CiudadRedondaProvider.dart';
import '../Parsers/TextsProvider.dart';
import 'dart:async';

class Tags {
  static const scaleFactorTag = "SCALE_FACTOR";
  static const selectedProviderTag = "SELECTED_PROVIDER";
  static const darkThemeTag = "DARK_THEME";

  static const LAST_UPDATED_TAG = "LAST_UPDATED_TAG";
  static const TEXTS_PROVIDER_TAG = "TEXTS_PROVIDER_TAG";

  static const TEXTS_TAG = "text_tag";
}

class Settings extends ChangeNotifier {
  double scaleFactor = 1.2;
  int selectedProvider = TextsProviders.CiudadRedonda;
  bool darkTheme = false;
  TextsSet currentTexts;
  DateTime currentTime = DateTime.now();

  SettingsHelper _settingsHelper = SettingsHelper();

  Rosary rosary;

  Future retrieveConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var scaleFactorTest = prefs.getDouble(Tags.scaleFactorTag);
    if (scaleFactorTest != null) scaleFactor = scaleFactorTest;

    var selectedProviderTest = prefs.getInt(Tags.selectedProviderTag);
    if (selectedProviderTest != null) selectedProvider = selectedProvider;

    var darkThemeTest = prefs.getBool(Tags.darkThemeTag);
    if (darkThemeTest != null) darkTheme = darkThemeTest;
  }

  Future saveConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(Tags.scaleFactorTag, scaleFactor);
    prefs.setInt(Tags.selectedProviderTag, selectedProvider);
    prefs.setBool(Tags.darkThemeTag, darkTheme);
  }

  Future<TextsSet> retrieveText() async {
    if (currentTexts == null ||
        currentTexts.date != currentTime ||
        currentTexts.provider != getProvider().getProviderNameForDisplay())
      currentTexts = await _retrieveTexts(getProvider(), currentTime);
    return currentTexts;
  }

  bool useDarkTheme() {
    if (rosary != null && rosary.isPlaying()) {
      return true;
    } else {
      return darkTheme;
    }
  }

  void update() {
    saveConfig().then((_) {
      /*
      Fluttertoast.showToast(
          msg: "Configuración guardada con éxito",
          toastLength: Toast.LENGTH_SHORT);
          */
    });
    notifyListeners();
  }

  TextsProvider getProvider() {
    switch (selectedProvider) {
      case TextsProviders.CiudadRedonda:
        return CiudadRedondaProvider();
      case TextsProviders.Buigle:
        return BuigleProvider();
      default:
        return CiudadRedondaProvider();
    }
  }

  Future<TextsSet> _retrieveTexts(TextsProvider provider, DateTime date) async {
    var savedProvider = await _settingsHelper.getValue(Tags.TEXTS_PROVIDER_TAG);
    TextsSet texts;
    var savedTexts = await _settingsHelper.getValue(Tags.TEXTS_TAG);

    if (savedTexts != null) {
      texts = TextsSet.fromJson(savedTexts);
    }

    if (savedTexts == null ||
        !(texts.date.difference(date).inDays == 0 &&
            texts.date.day == date.day) ||
        savedProvider != provider.getProviderNameForDisplay()) {
      texts = await provider.get(date);
      if (date.difference(DateTime.now()).inDays == 0) {
        await _settingsHelper.setValue(Tags.TEXTS_TAG, texts.toJson());
        await _settingsHelper.setValue(
            Tags.TEXTS_PROVIDER_TAG, provider.getProviderNameForDisplay());
      }
    }
    return texts;
  }
}
