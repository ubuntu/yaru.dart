import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaru/yaru.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  int _take = 80;
  bool _idea = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(kYaruPagePadding),
          child: Row(
            children: [
              YaruIconButton(
                tooltip: 'Custom icons and colors are possible',
                isSelected: _idea,
                onPressed: () => setState(() => _idea = !_idea),
                icon: const Icon(YaruIcons.light_bulb_off, size: 30),
                selectedIcon: const Icon(YaruIcons.light_bulb_on, size: 30),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Slider(
                  value: _take.toDouble(),
                  min: 1,
                  max: _lorem.characters.length.toDouble(),
                  onChanged: (v) => setState(() => _take = v.toInt()),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(kYaruPagePadding),
            itemCount: YaruInfoType.values.length,
            itemBuilder: (context, index) {
              final info = YaruInfoType.values[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  YaruInfoBox(
                    icon: info == YaruInfoType.information && _idea
                        ? const Icon(YaruIcons.light_bulb_on)
                        : null,
                    color: info == YaruInfoType.information && _idea
                        ? YaruColors.magenta
                        : null,
                    yaruInfoType: info,
                    title: Text(info.name.capitalize()),
                    subtitle: Text(_lorem.characters.take(_take).toString()),
                    trailing: info == YaruInfoType.information && _idea
                        ? const _CopyButton(text: _lorem)
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: kYaruPagePadding,
                    ),
                    child: Row(
                      children: [
                        YaruInfoBadge(
                          yaruInfoType: info,
                          title: Text(info.name.capitalize()),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.square(kYaruTitleBarItemHeight),
        maximumSize: const Size.square(kYaruTitleBarItemHeight),
        fixedSize: const Size.square(kYaruTitleBarItemHeight),
        side: BorderSide(
          width: 1,
          color: YaruColors.magenta.withValues(alpha: 0.5),
        ),
        padding: EdgeInsets.zero,
      ),
      onPressed: () {
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Copied')));
      },
      child: const Icon(YaruIcons.copy, color: YaruColors.magenta),
    );
  }
}

extension _StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

const _lorem =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
