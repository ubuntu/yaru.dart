import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class RoundToggleButtonPage extends StatefulWidget {
  const RoundToggleButtonPage({super.key});

  @override
  State<RoundToggleButtonPage> createState() => _RoundToggleButtonPageState();
}

class _RoundToggleButtonPageState extends State<RoundToggleButtonPage> {
  bool _selected = false;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      children: [
        YaruRoundToggleButton(
          onPressed: () => setState(
            () => _selected = !_selected,
          ),
          selected: _selected,
          iconData: YaruIcons.view,
          tooltip: 'View',
        )
      ],
    );
  }
}
