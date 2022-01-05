import 'package:flutter/cupertino.dart';
import 'package:yaru_icons/widgets/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class YaruRowList extends StatelessWidget {
  const YaruRowList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) => const YaruRow(
        trailingWidget: Text("Trailing Widget"),
        actionWidget: Text("Action Widget"),
        leadingWidget: Icon(YaruIcons.audio),
        description: "Description",
        enabled: true,
      ),
      itemCount: 20,
    );
  }
}
