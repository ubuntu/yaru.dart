import 'package:flutter/material.dart';

/// The official Ubuntu Logo
class UbuntuLogo extends StatelessWidget {
  const UbuntuLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This must be a ClipOval or else if the image is colored using BlendMode
    // the transparent parts of the png make it look like a square.

    return const ClipOval(
      child: Image(
        image: AssetImage('assets/ubuntu_logo.png'),
      ),
    );
  }
}
