import 'package:flutter/material.dart';
import 'package:lecturas/model/settings_controller.dart';
import 'package:provider/provider.dart';
import '../parsers/texts_provider.dart';

class SettingsPanel extends StatelessWidget {
  SettingsPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SettingsController settings = context.watch<SettingsController>();
    return Padding(
      padding: const EdgeInsets.all(8).copyWith(bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Proveedores",
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          ..._providerWidgets(context, settings),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Ajustes",
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          SwitchListTile(
            dense: true,
            value: settings.getPreferSunday(),
            onChanged: (value) {
              settings.setPreferSunday(value);
            },
            title: const Text("Vispera de festivo"),
            subtitle: const Text("Mostrar el dia siguiente pasadas las 19h"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.font_download),
                Expanded(
                  child: SliderTheme(
                    data: const SliderThemeData(trackHeight: 0.5),
                    child: Slider(
                        activeColor: Theme.of(context).primaryColorLight,
                        inactiveColor: Colors.white.withOpacity(0.5),
                        value: settings.getTextScale(),
                        min: 0.5,
                        max: 2,
                        divisions: 6,
                        label: "${settings.getTextScale()}",
                        onChanged: (value) => settings.setTextScale(value)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _providerWidgets(
      BuildContext context, SettingsController settings) {
    return SettingsController.getAvailableProviders()
        .values
        .map((value) => RadioListTile<TextsProvider>(
              value: value,
              groupValue: settings.getProvider(),
              onChanged: (selected) {
                if (selected != null) {
                  settings.setProvider(selected);
                  Navigator.of(context).pop();
                }
              },
              dense: true,
              title: Text(value.getProviderNameForDisplay()),
              subtitle: Text(value.getUrlForDisplay()),
            ))
        .toList();
  }
}
