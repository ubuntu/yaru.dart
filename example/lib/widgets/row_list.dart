import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class RowList extends StatelessWidget {
  const RowList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) => const YaruRow(
        title: Text("Trailing Widget"),
        trailing: Text("Action Widget"),
        leading: Icon(YaruIcons.audio),
        subtitle: Text("Description"),
      ),
      itemCount: 20,
    );
  }
}
