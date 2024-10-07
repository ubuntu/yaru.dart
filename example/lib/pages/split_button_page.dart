import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class SplitButtonPage extends StatelessWidget {
  const SplitButtonPage({super.key});

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
        children: [
          YaruSplitButton(
            onPressed: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Main Action'))),
            items: items,
            child: const Text('Main Action'),
          ),
          const SizedBox(height: 10),
          YaruSplitButton.filled(
            onPressed: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Main Action'))),
            items: items,
            child: const Text('Main Action'),
          ),
          const SizedBox(height: 10),
          YaruSplitButton.outlined(
            onPressed: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Main Action'))),
            items: items,
            child: const Text('Main Action'),
          ),
        ],
      ),
    );
  }
}
