import 'package:flutter/material.dart';
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

  static const LAST_UPDATED_TAG = "LAST_UPDATED_TAG";
  static const TEXTS_PROVIDER_TAG = "TEXTS_PROVIDER_TAG";

  static const TEXTS_TAG = "text_tag";
}

class Settings extends ChangeNotifier {
  double scaleFactor = 1;
  int selectedProvider = Providers.CiudadRedonda;
  bool darkTheme = false;
  TextsSet currentTexts;
  DateTime currentTime = DateTime.now();

  SettingsHelper _settingsHelper = SettingsHelper();

  Future retrieveConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    scaleFactor = prefs.getDouble(Tags.scaleFactorTag);
    selectedProvider = prefs.getInt(Tags.scaleFactorTag);

    /*
    var factor = await _settingsHelper.getValue(Tags.scaleFactorTag);
    var provider = await _settingsHelper.getValue(Tags.selectedProviderTag);

    scaleFactor = (factor == null) ? 120 : double.parse(factor);
    selectedProvider =
        (provider == null) ? Providers.CiudadRedonda : int.parse(provider);
    */
  }

  Future saveConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(Tags.scaleFactorTag, scaleFactor);
    prefs.setInt(Tags.scaleFactorTag, selectedProvider);
  }

  Future<TextsSet> retrieveText() async {
    if (currentTexts == null || currentTexts.date != currentTime)
      currentTexts = await _retrieveTexts(getProvider(), currentTime);
    return currentTexts;
  }

  void update() {
    notifyListeners();
  }

  TextsProvider getProvider() {
    switch (selectedProvider) {
      case Providers.CiudadRedonda:
        return CiudadRedondaProvider();
      case Providers.Buigle:
        return BuigleProvider();
      default:
        return CiudadRedondaProvider();
    }
  }

  Future<TextsSet> _retrieveTexts(TextsProvider provider, DateTime date) async {
    var savedProvider = await _settingsHelper.getValue(Tags.TEXTS_PROVIDER_TAG);
    TextsSet texts;
    var savedTexts = await _settingsHelper.getValue(Tags.TEXTS_TAG);

    if (savedTexts != null &&
        savedProvider == provider.getProviderNameForDisplay()) {
      texts = TextsSet.fromJson(savedTexts);
    } else {
      texts = await provider.get(date);
      if (date.difference(DateTime.now()).inDays == 0) {
        await _settingsHelper.setValue(Tags.TEXTS_TAG, texts.toJson());
        await _settingsHelper.setValue(
            Tags.LAST_UPDATED_TAG, DateTime.now().toIso8601String());
      }
    }
    return texts;
  }
}
