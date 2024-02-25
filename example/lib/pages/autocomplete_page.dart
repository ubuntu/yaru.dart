import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class AutocompletePage extends StatelessWidget {
  const AutocompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        child: YaruAutocomplete<String>(
          optionsBuilder: (value) {
            const options = ['foo', 'bar', 'baz', 'qux', 'quux'];
            return options.where((o) => o.contains(value.text.toLowerCase()));
          },
          onSelected: (value) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(value)),
          ),
        ),
      ),
    );
  }
}
