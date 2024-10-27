import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnack(
  BuildContext context,
) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Yay! ❤️ for Yaru'),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {},
      ),
    ),
  );
}

List<Widget> space({
  double widthGap = 5,
  double heightGap = 5,
  required Iterable<Widget> children,
}) =>
    children
        .expand(
          (item) sync* {
            yield SizedBox(width: widthGap);
            yield item;
          },
        )
        .skip(1)
        .toList();
