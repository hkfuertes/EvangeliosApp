import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lecturas/parsers/buigle_provider.dart';
import 'package:lecturas/parsers/ciudad_redonda_provider.dart';
import 'package:provider/provider.dart';

import '../parsers/texts_provider.dart';

class SettingsController with ChangeNotifier {
  String? _provider;
  bool? _preferSunday;
  double? _textScale;

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
  setPreferSunday(bool preferSunday) => _preferSunday = preferSunday;

  double getTextScale() => _textScale ?? 1;
  setTextScale(double textScale) => _textScale = textScale;

  static SettingsController of(BuildContext context) =>
      context.read<SettingsController>();
}
