import 'package:flutter/material.dart';

class YaruOptionButton extends StatelessWidget {
  const YaruOptionButton({
    Key? key,
    required this.onPressed,
    required this.iconData,
  }) : super(key: key);

  final VoidCallback onPressed;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(0)),
        onPressed: onPressed,
        child: Icon(iconData),
      ),
    );
  }
}
