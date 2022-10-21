import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

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
          const SizedBox(
            width: 10,
          ),
          StatefulBuilder(
            builder: (context, setState) {
              return YaruPopupMenuButton<MyEnum>(
                initialValue: myEnum,
                child: const Text('Multi Select'),
                onSelected: (value) {
                  setState(() {
                    if (enumSet.contains(value)) {
                      enumSet.remove(value);
                    } else {
                      enumSet.add(value);
                    }
                  });
                },
                itemBuilder: (context) {
                  // return [
                  //   for (final value in MyEnum.values)
                  //     CheckedPopupMenuItem<MyEnum>(
                  //       padding: EdgeInsets.zero,
                  //       value: value,
                  //       checked: enumSet.contains(value),
                  //       child: Text(value.name),
                  //     ),
                  // ];

                  return [
                    for (final value in MyEnum.values)
                      PopupMenuItem(
                        padding: EdgeInsets.zero,
                        child: YaruMultiSelectItem<MyEnum>(
                          onTap: () {
                            if (enumSet.contains(value)) {
                              enumSet.remove(value);
                            } else {
                              enumSet.add(value);
                            }
                          },
                          values: enumSet,
                          value: value,
                          child: Text(value.name),
                        ),
                      )
                  ];
                },
              );
            },
          )
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
