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
