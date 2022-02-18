import 'package:flutter/material.dart';

class YaruSection extends StatelessWidget {
  /// Creates a yaru style section widget with multiple
  /// [Widgets] as children.
  const YaruSection({
    Key? key,
    this.headline,
    required this.children,
    this.width,
    this.headerWidget,
  }) : super(key: key);

  /// Text that is placed above the list of `children`.
  final String? headline;

  ///  Creates a vertical list of widgets.
  ///  All children will be of type [Widget],
  final List<Widget> children;

  /// Specifies the [width] of the [Container].
  /// By default the width will be 500.
  final double? width;

  /// Aligns the widget horizontally along with headline.
  ///
  /// Both `headline` and `headerWidget` will be aligned horizontally
  /// with [mainAxisAlignment] as [MainAxisAlignment.spaceBetween].
  final Widget? headerWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: SizedBox(
          width: width,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
              ),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: headline != null && headerWidget != null
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                headline!,
                                style: Theme.of(context).textTheme.headline6,
                                textAlign: TextAlign.left,
                              ),
                              headerWidget ?? const SizedBox()
                            ],
                          ),
                        ),
                      ),
                      Column(children: children)
                    ],
                  )
                : Column(children: children),
          )),
    );
  }
}
