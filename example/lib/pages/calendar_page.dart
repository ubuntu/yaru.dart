import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          YaruDayPicker(
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            initialDate: DateTime.now(),
            onDaySelected: (day) => setState(() => selectedDateTime = day),
          ),
          Text('Selected day: ${selectedDateTime.toString()}'),
        ].withSpacing(25),
      ),
    );
  }
}

extension _ListSpacing on List<Widget> {
  List<Widget> withSpacing(double spacing) {
    return expand((item) sync* {
      yield SizedBox(height: spacing);
      yield item;
    }).skip(1).toList();
  }
}
