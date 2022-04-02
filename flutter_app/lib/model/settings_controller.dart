import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lecturas/parsers/buigle_provider.dart';
import 'package:lecturas/parsers/ciudad_redonda_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../parsers/texts_provider.dart';

class SettingsController with ChangeNotifier {
  String? _provider;
  bool? _preferSunday;
  double? _textScale;

  DateTime? currentDate;

  static final List<TextsProvider> _providers = [
    BuigleProvider(),
    CiudadRedondaProvider()
  ];
  static Map<String, TextsProvider> getAvailableProviders() {
    return _providers.asMap().map((key, value) =>
        MapEntry<String, TextsProvider>(
            value.getProviderNameForDisplay(), value));
  }

  TextsProvider getProvider() =>
      getAvailableProviders()[_provider] ?? _providers[0];

  setProvider(var provider) {
    if (provider is TextsProvider) {
      _provider = provider.getProviderNameForDisplay();
    }
    if (provider is String) _provider = provider;
    notifyListeners();
  }

  bool getPreferSunday() => _preferSunday ?? false;
  setPreferSunday(bool? preferSunday) {
    _preferSunday = preferSunday;
    notifyListeners();
  }

  double getTextScale() => _textScale ?? 1.25;
  setTextScale(double? textScale) {
    _textScale = textScale;
    notifyListeners();
  }

  static SettingsController of(BuildContext context) =>
      context.read<SettingsController>();

  DateTime getDate() {
    if (currentDate != null) {
      return currentDate!;
    } else {
      var now = DateTime.now();
      return (getPreferSunday() && now.hour > 19)
          ? now.add(const Duration(days: 1))
          : now;
    }
  }

  @override
  void notifyListeners() {
    //We save everytime we repaint.
    super.notifyListeners();
    saveSettings();
  }

  Future saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("preferSunday", getPreferSunday());
    await prefs.setDouble("textScale", getTextScale());
    await prefs.setString(
        "provider", _provider ?? _providers[0].getProviderNameForDisplay());
  }

  static Future<SettingsController> fromPrefs() async {
    var settings = SettingsController();
    final prefs = await SharedPreferences.getInstance();
    settings.setPreferSunday(prefs.getBool("preferSunday"));
    settings.setProvider(prefs.getString("provider"));
    settings.setTextScale(prefs.getDouble("textScale"));
    return settings;
  }
}
