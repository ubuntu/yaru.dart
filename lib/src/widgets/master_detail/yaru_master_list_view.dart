import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class YaruMasterListView extends StatelessWidget {
  const YaruMasterListView({
    super.key,
    required this.length,
    required this.selectedIndex,
    required this.builder,
    required this.onTap,
    required this.availableWidth,
    this.startUndershoot = true,
    this.endUndershoot = true,
  });

  final int length;
  final YaruMasterTileBuilder builder;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final double availableWidth;
  final bool startUndershoot;
  final bool endUndershoot;

  @override
  Widget build(BuildContext context) {
    final theme = YaruMasterDetailTheme.of(context);
    return YaruScrollViewUndershoot.builder(
      builder: (context, controller) {
        return SingleChildScrollView(
          controller: controller,
          child: Padding(
            padding: theme.listPadding ?? EdgeInsets.zero,
            child: Column(
              children: List.generate(
                length,
                (index) => YaruMasterTileScope(
                  index: index,
                  selected: index == selectedIndex,
                  onTap: () => onTap(index),
                  child: Builder(
                    builder: (context) => builder(
                      context,
                      index,
                      index == selectedIndex,
                      availableWidth,
                    ),
                  ),
                ),
              ).withSpacing(theme.tileSpacing ?? 0),
            ),
          ),
        );
      },
    );
  }
}

extension on List<Widget> {
  List<Widget> withSpacing(double height) => expand((item) sync* {
        yield SizedBox(height: height);
        yield item;
      }).skip(1).toList();
}
