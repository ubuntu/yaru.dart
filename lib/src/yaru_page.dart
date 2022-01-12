import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/constants.dart';

/// Wraps a child widget in a [ScrollView] and [Padding].
/// The padding defaults to [kDefaultPagePadding]
/// but can be set if wanted.
class YaruPage extends StatelessWidget {
  const YaruPage({Key? key, required this.child, this.padding})
      : super(key: key);

  final Widget child;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(padding ?? kDefaultPagePadding),
        child: child,
      ),
    );
  }
}
