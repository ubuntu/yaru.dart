import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class DateTimePage extends StatefulWidget {
  const DateTimePage({super.key});

  @override
  State<DateTimePage> createState() => _DateTimePageState();
}

class _DateTimePageState extends State<DateTimePage> {
  final YaruDateTimeEntryController _controller =
      YaruDateTimeEntryController.now();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 250,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              YaruDateTimeEntry(
                controller: _controller,
                firstDate: DateTime(1900),
                lastDate: DateTime(2050),
                onChanged: (dateTime) {
                  setState(() {
                    _formKey.currentState?.validate();
                  });
                },
              ),
              const SizedBox(height: 25),
              Text(_dateTime.toString()),
              Text(_controller.value.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
