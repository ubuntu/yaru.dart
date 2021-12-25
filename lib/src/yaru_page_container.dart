import 'package:flutter/material.dart';

class YaruPageContainer extends StatelessWidget {

  /// Creates a [Container] with specified `width` and `child`.
  /// Total `width` of the [Container] will be `16 + width`.
  /// If the given width is null default value will be 500.
  const YaruPageContainer({
    Key? key,
    required this.child,
    this.width,
  }) : super(key: key);

  /// The child widget that is passed to the container.
  final Widget child;

  /// Width of the [Container].
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: SizedBox(
          width: 16 +
              (width ??
                  500), // 500 width + 8 padding on each edges (for SettingsSection)
          child: child),
    );
  }
}
