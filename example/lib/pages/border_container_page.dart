import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class BorderContainerPage extends StatefulWidget {
  const BorderContainerPage({super.key});

  @override
  State<BorderContainerPage> createState() => _BorderContainerPageState();
}

class _BorderContainerPageState extends State<BorderContainerPage> {
  int _take = 80;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(kYaruPagePadding),
          child: Slider(
            value: _take.toDouble(),
            min: 1,
            max: _lorem.characters.length.toDouble(),
            onChanged: (v) => setState(() => _take = v.toInt()),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(kYaruPagePadding),
            itemCount: YaruInfoType.values.length,
            itemBuilder: (context, index) {
              return YaruBorderContainer(
                padding: const EdgeInsets.all(8),
                child: Text(_lorem.characters.take(_take).toString()),
              );
            },
            separatorBuilder: (context, index) {
              final info = YaruInfoType.values[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: kYaruPagePadding),
                child: YaruTranslucentContainer(
                  padding: const EdgeInsets.all(8),
                  color: info.getColor(context),
                  child: Text(_lorem.characters.take(_take).toString()),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

const _lorem =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
