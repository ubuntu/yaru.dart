import 'package:flutter/widgets.dart';

List<Widget> space({
  required Iterable<Widget> children,
  double? widthGap,
  double? heightGap,
  int skip = 1,
}) =>
    children
        .expand(
          (item) sync* {
            yield SizedBox(
              width: widthGap,
              height: heightGap,
            );
            yield item;
          },
        )
        .skip(skip)
        .toList();
