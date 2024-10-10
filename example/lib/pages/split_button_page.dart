import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../common/space.dart';

class SplitButtonPage extends StatefulWidget {
  const SplitButtonPage({super.key});

  @override
  State<SplitButtonPage> createState() => _SplitButtonPageState();
}

class _SplitButtonPageState extends State<SplitButtonPage> {
  double width = 200.0;

  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      10,
      (index) {
        final text =
            '${index.isEven ? 'Super long action name' : 'action'} ${index + 1}';
        return PopupMenuItem(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(text))),
        );
      },
    );

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: space(
          heightGap: 10,
          children: [
            YaruSplitButton(
              onPressed: () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Main Action'))),
              items: items,
              child: const Text('Main Action'),
            ),
            YaruSplitButton.filled(
              onPressed: () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Main Action'))),
              items: items,
              child: const Text('Main Action'),
            ),
            YaruSplitButton.outlined(
              menuWidth: width,
              onPressed: () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Main Action'))),
              items: items,
              child: const Text('Main Action'),
            ),
            SizedBox(
              width: 300,
              child: Slider(
                min: 100,
                max: 500,
                value: width,
                onChanged: (v) => setState(() => width = v),
              ),
            ),
            Center(
              child: Text('Menu width: ${width.toInt()}'),
            ),
            YaruSplitButton(
              menuWidth: width,
              items: items,
              child: const Text('Main Action'),
            ),
            YaruSplitButton(
              menuWidth: width,
              child: const Text('Main Action'),
            ),
            YaruSplitButton(
              menuWidth: width,
              child: const Text('Main Action'),
              onPressed: () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Main Action'))),
            ),
          ],
        ),
      ),
    );
  }
}
