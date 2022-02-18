import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets_example/widgets/dummy_section.dart';

const kMinSectionWidth = 400.0;

class SectionPage extends StatefulWidget {
  const SectionPage({Key? key}) : super(key: key);

  @override
  _SectionPageState createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  double sectionWidth = kMinSectionWidth;
  bool _extraOptionValue = false;
  bool _yaruSwitchEnabled = false;
  final List<bool> _selectedValues = [false, false];

  @override
  Widget build(BuildContext context) {
    return YaruPage(
      children: [
        YaruSection(children: [
          YaruSingleInfoRow(infoLabel: 'infoLabel', infoValue: 'infoValue')
        ]),
        DummySection(),
        DummySection(width: 300),
        YaruSection(
          width: sectionWidth,
          children: [
            YaruRow(
              enabled: true,
              trailingWidget: Text("Trailing Widget"),
              actionWidget: Text("Action Widget"),
              description: "Description",
            ),
            YaruSliderRow(
              actionLabel: "YaruSection width",
              value: sectionWidth,
              min: kMinSectionWidth,
              max: 1000,
              onChanged: (v) {
                setState(() {
                  sectionWidth = v;
                });
              },
            ),
            YaruSwitchRow(
              value: _yaruSwitchEnabled,
              onChanged: (v) {
                setState(() {
                  _yaruSwitchEnabled = v;
                });
              },
              trailingWidget: Text("Trailing Widget"),
            ),
            YaruSingleInfoRow(
              infoLabel: "Info Label",
              infoValue: "Info Value",
            ),
            YaruToggleButtonsRow(
              actionLabel: "Action Label",
              labels: ["label1", "label2"],
              onPressed: (v) {
                setState(() {
                  _selectedValues[v] = !_selectedValues[v];
                });
              },
              selectedValues: _selectedValues,
              actionDescription: "Action Description",
            ),
            YaruExtraOptionRow(
              actionLabel: "ActionLabel",
              iconData: YaruIcons.addon,
              onChanged: (c) {
                setState(() {
                  _extraOptionValue = c;
                });
              },
              onPressed: () => showDialog(
                  context: context,
                  builder: (_) => YaruSimpleDialog(
                        width: 200,
                        title: 'Test',
                        closeIconData: YaruIcons.window_close,
                        children: [
                          Text(
                            'Hello YaruSimpleDialog',
                            textAlign: TextAlign.center,
                          ),
                          YaruSliderRow(
                              actionLabel: 'actionLabel',
                              value: 0,
                              min: 0,
                              max: 10,
                              onChanged: (v) {})
                        ],
                      )),
              value: _extraOptionValue,
              actionDescription: "Action Description",
            ),
          ],
          // width: 800,
        )
      ],
    );
  }
}
