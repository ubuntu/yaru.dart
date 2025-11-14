import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../../../utils.dart';
import '../../colors.dart';
import '../../containers.dart';
import '../../controls.dart';
import '../../fonts.dart';
import '../../textfields.dart';

final GlobalKey<ScaffoldState> themePageScaffoldKey = GlobalKey();

class MaterialThemeHomePage extends StatefulWidget {
  const MaterialThemeHomePage({super.key});

  @override
  MaterialThemeHomePageState createState() => MaterialThemeHomePageState();
}

class MaterialThemeHomePageState extends State<MaterialThemeHomePage> {
  MaterialThemeHomePageState();

  int _selectedIndex = 0;

  final _items = <Widget, (Widget, Widget, String)>{
    const FontsView(): (
      const Badge(label: Text('123'), child: Icon(YaruIcons.font)),
      const Badge(label: Text('123'), child: Icon(YaruIcons.font)),
      'Fonts',
    ),
    const ControlsView(): (
      const Icon(YaruIcons.radiobox_checked),
      const Icon(YaruIcons.radiobox_checked_filled),
      'Controls',
    ),
    const TextFieldsView(): (
      const Icon(YaruIcons.text_editor),
      const Icon(YaruIcons.text_editor_filled),
      'TextFields',
    ),
    const ColorsView(): (
      const Icon(YaruIcons.colors),
      const Icon(YaruIcons.colors_filled),
      'Palette',
    ),
    const ContainersView(): (
      const Icon(YaruIcons.window),
      const Icon(YaruIcons.window_filled),
      'Containers',
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: themePageScaffoldKey,
      drawer: _Drawer(
        selectedIndex: _selectedIndex,
        onSelected: (index) {
          setState(() => _selectedIndex = index);
          Navigator.of(context).pop();
        },
        items: _items,
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Center(
          child: YaruIconButton(
            onPressed: () => themePageScaffoldKey.currentState?.openDrawer(),
            icon: const Icon(YaruIcons.menu),
          ),
        ),
        title: const Text(''),
        actions: [
          YaruIconButton(
            onPressed: () => showSnack(context),
            icon: const Icon(YaruIcons.plus),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return Row(
              children: [
                NavigationRail(
                  destinations: [
                    for (final item in _items.entries)
                      NavigationRailDestination(
                        icon: item.value.$1,
                        selectedIcon: item.value.$2,
                        label: Text(item.value.$3),
                      ),
                  ],
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) =>
                      setState(() => _selectedIndex = index),
                ),
                const VerticalDivider(width: 0.0),
                Expanded(
                  child: Center(
                    child: _items.entries.elementAt(_selectedIndex).key,
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: _items.entries.elementAt(_selectedIndex).key,
                  ),
                ),
                const Divider(height: 0.0),
                NavigationBar(
                  destinations: [
                    for (final item in _items.entries)
                      NavigationDestination(
                        icon: item.value.$1,
                        selectedIcon: item.value.$2,
                        label: item.value.$3,
                      ),
                  ],
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) =>
                      setState(() => _selectedIndex = index),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({
    required this.items,
    required this.onSelected,
    required this.selectedIndex,
  });

  final Map<Widget, (Widget, Widget, String)> items;
  final Function(int index) onSelected;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          const DrawerHeader(child: Text('Drawer Header')),
          for (var i = 0; i < items.length; i++)
            ListTile(
              selected: i == selectedIndex,
              leading: i == selectedIndex
                  ? items.entries.elementAt(i).value.$2
                  : items.entries.elementAt(i).value.$1,
              title: Text(items.entries.elementAt(i).value.$3),
              onTap: () => onSelected(i),
            ),
        ],
      ),
    );
  }
}
