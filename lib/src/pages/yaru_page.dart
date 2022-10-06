import 'package:flutter/material.dart';
import '../constants.dart';

/// Wraps a list of children widget in a [Column], [SingleChildScrollView] and [Padding].
/// The padding defaults to [kYaruPagePadding]
/// but can be set if wanted.
class YaruPage extends StatelessWidget {
  const YaruPage({
    super.key,
    required this.children,
    this.padding,
    this.controller,
  });

  final List<Widget> children;
  final EdgeInsets? padding;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(kYaruPagePadding),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
