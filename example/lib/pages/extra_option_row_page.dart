import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'package:yaru_widgets_example/widgets/dummy_section.dart';

class ExtraOptionRowPage extends StatefulWidget {
  const ExtraOptionRowPage({Key? key}) : super(key: key);

  @override
  _ExtraOptionRowPageState createState() => _ExtraOptionRowPageState();
}

class _ExtraOptionRowPageState extends State<ExtraOptionRowPage> {
  bool _extraOptionValue = false;

  @override
  Widget build(BuildContext context) {
    return YaruPage(
      children: [
        YaruExtraOptionRow(
          actionLabel: "YaruSimpleDialog",
          iconData: YaruIcons.information,
          onChanged: (c) {
            setState(() {
              _extraOptionValue = c;
            });
          },
          onPressed: () => showDialog(
              context: context,
              builder: (_) => YaruSimpleDialog(
                    titleTextAlign: TextAlign.center,
                    width: 500,
                    title: 'YaruDialogTitle',
                    closeIconData: YaruIcons.window_close,
                    children: [
                      Text(
                        'Hello YaruSimpleDialog22',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: 100,
                        child: YaruSliderRow(
                            // width: 500,
                            actionLabel: 'actionLabel',
                            value: 0,
                            min: 0,
                            max: 10,
                            onChanged: (v) {}),
                      )
                    ],
                  )),
          value: _extraOptionValue,
          actionDescription: "Action Description",
        ),
        YaruExtraOptionRow(
          actionLabel: "YaruAlertDialog",
          iconData: YaruIcons.warning,
          onChanged: (c) {
            setState(() {
              _extraOptionValue = c;
            });
          },
          onPressed: () => showDialog(
            context: context,
            builder: (_) => YaruAlertDialog(
              closeIconData: YaruIcons.window_close,
              title: 'YaruDialogTitle',
              child: YaruPage(
                  padding: EdgeInsets.only(top: 0, right: 20, left: 20),
                  children: [
                    for (var i = 0; i < 5; i++) DummySection(width: null)
                  ]),
              actions: [
                OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel')),
                ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('OK!')));
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'))
              ],
              width: 500,
              height: 300,
            ),
          ),
          value: _extraOptionValue,
          actionDescription: "Action Description",
        )
      ],
    );
  }
}
