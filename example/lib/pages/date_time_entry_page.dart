import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class DateTimePage extends StatefulWidget {
  const DateTimePage({super.key});

  @override
  State<DateTimePage> createState() => _DateTimePageState();
}

class _DateTimePageState extends State<DateTimePage> {
  DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            YaruDateTimeEntry(
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2050),
              onChanged: (dateTime) {
                setState(() {
                  _dateTime = dateTime;
                });
              },
            ),
            const SizedBox(height: 25),
            Text(_dateTime.toString()),
          ],
        ),
      ),
    );
  }
}
