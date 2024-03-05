import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class PopupPage extends StatefulWidget {
  const PopupPage({super.key});

  @override
  State<PopupPage> createState() => _PopupPageState();
}

class _PopupPageState extends State<PopupPage> {
  MyEnum myEnum = MyEnum.option1;
  Set<MyEnum> enumSet = {MyEnum.option1, MyEnum.option3};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kYaruPagePadding),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _buildPopup(),
          YaruPopupMenuButton<MyEnum>(
            onSelected: (value) {
              if (enumSet.contains(value)) {
                enumSet.remove(value);
              } else {
                enumSet.add(value);
              }
            },
            child: const Text('Multi Select'),
            itemBuilder: (context) {
              return [
                for (final value in MyEnum.values)
                  YaruCheckedPopupMenuItem<MyEnum>(
                    value: value,
                    checked: enumSet.contains(value),
                    child: Text(value.name),
                  ),
              ];
            },
          ),
          YaruPopupMenuButton<MyEnum>(
            child: const Text('Multi Select Without close'),
            itemBuilder: (context) {
              return [
                for (final value in MyEnum.values)
                  YaruMultiSelectPopupMenuItem<MyEnum>(
                    value: value,
                    checked: enumSet.contains(value),
                    onChanged: (checked) {
                      // Handle model changes here
                      setState(() {
                        checked ? enumSet.add(value) : enumSet.remove(value);
                      });
                    },
                    child: Text(value.name),
                  ),
              ];
            },
          ),
          Card(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('With custom style'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildPopup(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      backgroundColor: YaruColors.prussianGreen,
                      foregroundColor: Colors.yellow,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  YaruPopupMenuButton<MyEnum> _buildPopup({ButtonStyle? style}) {
    return YaruPopupMenuButton<MyEnum>(
      style: style,
      initialValue: myEnum,
      onSelected: (v) {
        setState(() {
          myEnum = v;
        });
      },
      child: Text(myEnum.name),
      itemBuilder: (context) {
        return [
          for (final value in MyEnum.values)
            PopupMenuItem(
              value: value,
              child: Text(
                value.name,
              ),
            ),
        ];
      },
    );
  }
}

enum MyEnum {
  option1,
  option2,
  option3,
  option4,
}
