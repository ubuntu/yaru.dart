import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'package:yaru_icons/yaru_icons.dart';

class SelectableContainerPage extends StatefulWidget {
  const SelectableContainerPage({Key? key}) : super(key: key);

  @override
  State<SelectableContainerPage> createState() =>
      _SelectableContainerPageState();
}

class _SelectableContainerPageState extends State<SelectableContainerPage> {
  bool _isImageSelected = false;
  bool _isOvalSelected = false;
  bool _isTextSelected = false;

  @override
  Widget build(BuildContext context) {
    return YaruPage(
      children: [
        YaruSelectableContainer(
          selected: _isImageSelected,
          onTap: () => setState(() => _isImageSelected = !_isImageSelected),
          child: kIsWeb
              ? Image.asset('assets/ubuntuhero.jpg',
                  filterQuality: FilterQuality.low, fit: BoxFit.fill)
              : Image.file(File('assets/ubuntuhero.jpg'),
                  filterQuality: FilterQuality.low, fit: BoxFit.fill),
        ),
        SizedBox(
          height: 20,
        ),
        YaruSelectableContainer(
          selected: _isTextSelected,
          onTap: () => setState(() => _isTextSelected = !_isTextSelected),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text('This is just text but can be selected!'),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        YaruSelectableContainer(
          borderRadius: BorderRadius.circular(100.0),
          selected: _isOvalSelected,
          onTap: () => setState(() => _isOvalSelected = !_isOvalSelected),
          child: ClipOval(
            child: Material(
              color: Colors.amber, // Button color
              child:
                  SizedBox(width: 56, height: 56, child: Icon(YaruIcons.heart)),
            ),
          ),
        )
      ],
    );
  }
}
