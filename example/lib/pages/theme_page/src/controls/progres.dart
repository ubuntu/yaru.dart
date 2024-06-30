import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../constants.dart';

class Progress extends StatefulWidget {
  const Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  var _level = 1.0;
  final _width = 300.0;
  @override
  Widget build(BuildContext context) {
    final children = [
      SizedBox(
        width: _width,
        child: LinearProgressIndicator(value: _level),
      ),
      CircularProgressIndicator(value: _level),
      SizedBox(width: _width, child: const LinearProgressIndicator()),
      const CircularProgressIndicator(),
    ];

    return Padding(
      padding: const EdgeInsets.all(kWrapPadding),
      child: Column(
        children: [
          SizedBox(
            width: _width,
            child: Slider(
              value: _level,
              max: 1,
              min: 0,
              onChanged: (value) => setState(() => _level = value),
            ),
          ),
          const Divider(
            height: 2 * kWrapSpacing,
          ),
          const YaruInfoBox(
            yaruInfoType: YaruInfoType.information,
            subtitle: Text(
              'The following material progress indicators are only fallbacks, due to insufficient styling capabilities. Please use YaruLinearProgressIndicator and YaruCircularProgressIndicator instead!',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Wrap(
            spacing: kWrapSpacing,
            runSpacing: kWrapSpacing,
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.vertical,
            verticalDirection: VerticalDirection.down,
            children: children,
          ),
        ],
      ),
    );
  }
}
