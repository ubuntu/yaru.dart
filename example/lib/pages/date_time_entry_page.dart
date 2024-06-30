import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class DateTimePage extends StatefulWidget {
  const DateTimePage({super.key});

  @override
  State<DateTimePage> createState() => _DateTimePageState();
}

class _DateTimePageState extends State<DateTimePage> {
  final _dateController = YaruDateTimeEntryController.now();
  final _dateTimeController = YaruDateTimeEntryController.now();
  final _timeController = YaruTimeEntryController.now();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 275,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              YaruDateTimeEntry(
                controller: _dateController,
                includeTime: false,
                firstDateTime: DateTime(1900),
                lastDateTime: DateTime(2050),
                onChanged: (dateTime) {
                  setState(() {
                    _formKey.currentState?.validate();
                  });
                },
              ),
              Text(_dateController.dateTime.toString()),
              YaruTimeEntry(
                controller: _timeController,
                onChanged: (time) {
                  setState(() {
                    _formKey.currentState?.validate();
                  });
                },
              ),
              Text(_timeController.timeOfDay.toString()),
              YaruDateTimeEntry(
                controller: _dateTimeController,
                includeTime: true,
                firstDateTime: DateTime(1900),
                lastDateTime: DateTime(2050),
                onChanged: (dateTime) {
                  setState(() {
                    _formKey.currentState?.validate();
                  });
                },
              ),
              Text(_dateTimeController.dateTime.toString()),
            ].withSpacing(25),
          ),
        ),
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
