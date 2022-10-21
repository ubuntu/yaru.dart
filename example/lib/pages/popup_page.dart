import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class PopupPage extends StatefulWidget {
  const PopupPage({super.key});

  @override
  State<PopupPage> createState() => _PopupPageState();
}

class _PopupPageState extends State<PopupPage> {
  MyEnum myEnum = MyEnum.option1;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kYaruPagePadding),
      child: Row(
        children: [
          YaruPopupMenuButton<MyEnum>(
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
                  )
              ];
            },
          ),
        ],
      ),
    );
  }
}

enum MyEnum {
  option1,
  option2,
  option3,
  option4,
}
