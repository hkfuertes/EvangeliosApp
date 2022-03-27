import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class MainPage extends StatelessWidget {
  DateTime? _selectedDate;
  final double _radius = 16.0;
  final DateFormat _formatter = DateFormat("dd/MM/yyyy");

  MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(_radius),
                bottomRight: Radius.circular(_radius))),
        title: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Constants.days[
                              (_selectedDate ?? DateTime.now()).weekday - 1],
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(_formatter.format(_selectedDate ?? DateTime.now()),
                            textScaleFactor: 0.9,
                            style: Theme.of(context).textTheme.subtitle2)
                      ]),
                ),
              ],
            ),
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
      ),
      body: Container(),
    );
  }

  Widget _buildDateSelectorButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: OutlinedButton.icon(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white)),
          onPressed: () {
            showDatePicker(
                    locale: const Locale("es", "ES"),
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365)))
                .then((value) {});
          },
          icon: const Icon(Icons.calendar_month_outlined),
          label: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Constants.days[
                              (_selectedDate ?? DateTime.now()).weekday - 1],
                          textScaleFactor: 1.25,
                        ),
                        Text(
                          _formatter.format(_selectedDate ?? DateTime.now()),
                          style: const TextStyle(fontWeight: FontWeight.w100),
                        ),
                      ]),
                ),
              ),
            ],
          )),
    );
  }
}
