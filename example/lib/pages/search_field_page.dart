import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class SearchFieldPage extends StatelessWidget {
  const SearchFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final light = theme.brightness == Brightness.light;
    return Center(
      child: SimpleDialog(
        shadowColor: light ? Colors.black : null,
        titlePadding: EdgeInsets.zero,
        title: const YaruDialogTitleBar(
          titleSpacing: 0,
          centerTitle: true,
          title: YaruSearchFieldTitle(
            searchActive: true,
            title: Text(
              'YaruSearchFieldTitle',
            ),
          ),
        ),
        children: const [
          SizedBox(
            height: 300,
            width: 450,
          )
        ],
      ),
    );
  }
}
