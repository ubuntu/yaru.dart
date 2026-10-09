import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

enum _MyEnum { option1, option2, option3, option4 }

class DropdownPage extends StatefulWidget {
  const DropdownPage({super.key});

  @override
  State<DropdownPage> createState() => _DropdownPageState();
}

class _DropdownPageState extends State<DropdownPage> {
  _MyEnum _basic = _MyEnum.option1;
  _MyEnum _entries = _MyEnum.option1;
  _MyEnum? _noSelection;
  _MyEnum? _nullable;
  _MyEnum _icons = _MyEnum.option1;
  _MyEnum _compact = _MyEnum.option1;
  _MyEnum _over = _MyEnum.option1;

  @override
  Widget build(BuildContext context) {
    return YaruScrollViewUndershoot.builder(
      builder: (context, controller) {
        return ListView(
          controller: controller,
          padding: const EdgeInsets.all(kYaruPagePadding),
          children: [
            YaruDropdown<_MyEnum>(
              decoration: const InputDecoration(labelText: 'YaruDropdown'),
              values: _MyEnum.values,
              selected: _basic,
              onSelected: (value) => setState(() => _basic = value),
              itemBuilder: (context, value, _) => Text(value.name),
            ),
            const SizedBox(height: 10),
            YaruDropdown<_MyEnum>(
              decoration: const InputDecoration(
                labelText: 'With disabled entry and divider',
              ),
              entries: const [
                YaruDropdownEntry(value: _MyEnum.option1),
                YaruDropdownEntry(value: _MyEnum.option2),
                YaruDropdownEntry(value: _MyEnum.option3, enabled: false),
                YaruDropdownEntry.divider(),
                YaruDropdownEntry(value: _MyEnum.option4),
              ],
              selected: _entries,
              onSelected: (value) => setState(() => _entries = value),
              itemBuilder: (context, value, _) => Text(value.name),
            ),
            const SizedBox(height: 10),
            YaruDropdown<_MyEnum>(
              decoration: const InputDecoration(labelText: 'Without selection'),
              values: _MyEnum.values,
              selected: _noSelection,
              onSelected: (value) => setState(() => _noSelection = value),
              itemBuilder: (context, value, _) => Text(value.name),
            ),
            const SizedBox(height: 10),
            YaruDropdown<_MyEnum?>(
              decoration: const InputDecoration(labelText: 'Nullable'),
              entries: const [
                YaruDropdownEntry(value: null, child: Text('None')),
                YaruDropdownEntry(value: _MyEnum.option1),
                YaruDropdownEntry(value: _MyEnum.option2),
                YaruDropdownEntry(value: _MyEnum.option3),
                YaruDropdownEntry(value: _MyEnum.option4),
              ],
              selected: _nullable,
              onSelected: (value) => setState(() => _nullable = value),
              itemBuilder: (context, value, _) => Text(value!.name),
            ),
            const SizedBox(height: 10),
            YaruDropdown<_MyEnum>(
              decoration: const InputDecoration(labelText: 'With icons'),
              values: _MyEnum.values,
              selected: _icons,
              onSelected: (value) => setState(() => _icons = value),
              iconBuilder: (context, value, _) => Icon(switch (value) {
                _MyEnum.option1 => YaruIcons.drive_harddisk,
                _MyEnum.option2 => YaruIcons.drive_optical,
                _MyEnum.option3 => YaruIcons.drive_removable_media,
                _MyEnum.option4 => YaruIcons.sync,
              }),
              itemBuilder: (context, value, _) => Text(value.name),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: YaruDropdown<_MyEnum>(
                decoration: const InputDecoration(labelText: 'Not expanded'),
                expanded: false,
                values: _MyEnum.values,
                selected: _compact,
                onSelected: (value) => setState(() => _compact = value),
                itemBuilder: (context, value, _) => Text(value.name),
              ),
            ),
            const SizedBox(height: 10),
            YaruDropdown<_MyEnum>(
              decoration: const InputDecoration(labelText: 'Menu over button'),
              menuPosition: PopupMenuPosition.over,
              values: _MyEnum.values,
              selected: _over,
              onSelected: (value) => setState(() => _over = value),
              itemBuilder: (context, value, _) => Text(value.name),
            ),
            const SizedBox(height: 10),
            YaruDropdown<_MyEnum>(
              decoration: const InputDecoration(labelText: 'Disabled'),
              values: _MyEnum.values,
              selected: _MyEnum.option1,
              itemBuilder: (context, value, _) => Text(value.name),
            ),
          ],
        );
      },
    );
  }
}
