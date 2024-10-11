import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class SplitButtonPage extends StatefulWidget {
  const SplitButtonPage({super.key});

  @override
  State<SplitButtonPage> createState() => _SplitButtonPageState();
}

class _SplitButtonPageState extends State<SplitButtonPage> {
  double _width = 200.0;

  @override
  Widget build(BuildContext context) {
    const contentWidth = 500.0;
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

    final tiles = [
      YaruTile(
        title: const Text('YaruSplitButton()'),
        subtitle: const Text('Regular version'),
        trailing: YaruSplitButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Main Action')),
          ),
          items: items,
          child: const Text('Main Action'),
        ),
      ),
      YaruTile(
        title: const Text('YaruSplitButton'),
        subtitle: const Text('.filled()'),
        trailing: YaruSplitButton.filled(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Main Action')),
          ),
          items: items,
          child: const Text('Main Action'),
        ),
      ),
      YaruTile(
        title: const Text('YaruSplitButton'),
        subtitle: const Text('outlined()'),
        trailing: YaruSplitButton.outlined(
          menuWidth: _width,
          onPressed: () => ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Main Action'))),
          items: items,
          child: const Text('Main Action'),
        ),
      ),
      YaruTile(
        title: const Text('YaruSplitButton'),
        subtitle: const Text(
          'items: null, onOptionPressed: null',
        ),
        trailing: YaruSplitButton(
          menuWidth: _width,
          child: const Text('Main Action'),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Main Action')),
          ),
        ),
      ),
      YaruTile(
        title: const Text('YaruSplitButton'),
        subtitle: const Text('onPressed: null'),
        trailing: YaruSplitButton(
          menuWidth: _width,
          items: items,
          child: const Text('Main Action'),
        ),
      ),
      YaruTile(
        title: const Text('YaruSplitButton'),
        subtitle:
            const Text('items: null, onOptionPressed: null, onPressed: null'),
        trailing: YaruSplitButton(
          menuWidth: _width,
          child: const Text('Main Action'),
        ),
      ),
    ];
    final row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Menu width: ${_width.toInt()}'),
        Expanded(
          child: Slider(
            min: 100,
            max: 500,
            value: _width,
            onChanged: (v) => setState(() => _width = v),
          ),
        ),
      ],
    );

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: contentWidth, child: row),
          Flexible(
            child: YaruBorderContainer(
              width: contentWidth,
              margin: const EdgeInsets.all(kYaruPagePadding),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: tiles.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: tiles.elementAt(index),
                ),
                separatorBuilder: (context, index) => index != tiles.length - 1
                    ? const Divider()
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
