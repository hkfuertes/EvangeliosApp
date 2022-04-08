import 'package:flutter/material.dart';
import 'package:lecturas/constants.dart';

class DateSelectorPanel extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime?)? onDatePicked;
  DateTime date;
  DateSelectorPanel({Key? key, required this.initialDate, this.onDatePicked})
      : date = initialDate,
        super(key: key);

  @override
  State<DateSelectorPanel> createState() => _DateSelectorPanelState();
}

class _DateSelectorPanelState extends State<DateSelectorPanel> {
  DateTime? date;

  DateTime getDate() {
    return date ?? widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: 64,
                    child: Text(
                      Constants.days[getDate().weekday - 1],
                      textAlign: TextAlign.end,
                    )),
                textWithButtons(
                    onUpPressed: () {
                      setState(() {
                        date = DateTime(
                            getDate().year, getDate().month, getDate().day + 1);
                      });
                    },
                    onDownPressed: () {
                      setState(() {
                        date = DateTime(
                            getDate().year, getDate().month, getDate().day - 1);
                      });
                    },
                    text: getDate().day.toString()),
                textWithButtons(
                    onUpPressed: () {
                      setState(() {
                        date = DateTime(
                            getDate().year, getDate().month + 1, getDate().day);
                      });
                    },
                    onDownPressed: () {
                      setState(() {
                        date = DateTime(
                            getDate().year, getDate().month - 1, getDate().day);
                      });
                    },
                    size: 76,
                    text: Constants.months[getDate().month - 1]),
                textWithButtons(
                    onUpPressed: () {
                      setState(() {
                        date = DateTime(
                            getDate().year + 1, getDate().month, getDate().day);
                      });
                    },
                    onDownPressed: () {
                      setState(() {
                        date = DateTime(
                            getDate().year + 1, getDate().month, getDate().day);
                      });
                    },
                    text: getDate().year.toString()),
                IconButton(
                    onPressed: () {
                      if (widget.onDatePicked != null) {
                        widget.onDatePicked!(_getDateOrNull(getDate()));
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(Icons.check))
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () {
                        setState(() {
                          //NextSunday
                          date = DateTime.now()
                              .add(Duration(days: 7 - DateTime.now().weekday));
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Domingo"),
                      )),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () {
                        setState(() {
                          //today
                          date = DateTime.now();
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Hoy"),
                      )),
                ),
              ),
            ],
          ),
        ].reversed.toList(),
      ),
    );
  }

  //If selected date is today we return null "no date selected",
  //so preferSunday can apply.
  DateTime? _getDateOrNull(DateTime? datetime) {
    if (datetime == null) {
      return null;
    } else {
      var now = DateTime.now();
      return (datetime.year == now.year &&
              datetime.month == now.month &&
              datetime.day == now.day)
          ? null
          : datetime;
    }
  }

  Column textWithButtons(
      {onUpPressed, onDownPressed, required text, double? size}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(onPressed: onUpPressed, icon: const Icon(Icons.add)),
        SizedBox(
            width: size,
            child: Text(
              text,
              textAlign: TextAlign.center,
            )),
        IconButton(onPressed: onDownPressed, icon: const Icon(Icons.remove)),
      ],
    );
  }
}
