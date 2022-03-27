import 'package:flutter/material.dart';
import 'package:lecturas/model/settings_controller.dart';

import '../parsers/buigle_provider.dart';
import '../parsers/ciudad_redonda_provider.dart';
import '../parsers/texts_provider.dart';

class SettingsPanel extends StatelessWidget {
  SettingsPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          ..._providerWidgets(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Ajustes",
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          const SwitchListTile(
            value: false,
            onChanged: null,
            title: Text("Visperas"),
            subtitle: Text("Mostrar el dia siguiente después 19.00"),
          )
        ],
      ),
    );
  }

  List<Widget> _providerWidgets() {
    return SettingsController.getAvailableProviders()
        .values
        .map((value) => RadioListTile<TextsProvider>(
              value: value,
              groupValue: null,
              onChanged: (selected) {
                if (selected != null) {}
              },
              title: Text(value.getProviderNameForDisplay()),
            ))
        .toList();
  }
}
