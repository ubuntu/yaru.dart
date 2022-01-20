import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/constants.dart';

/// Wraps a list of children widget in a [Column], [SingleChildScrollView] and [Padding].
/// The padding defaults to [kDefaultPagePadding]
/// but can be set if wanted.
class YaruPage extends StatelessWidget {
  const YaruPage({Key? key, required this.children, this.padding})
      : super(key: key);

  final List<Widget> children;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(kDefaultPagePadding),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
