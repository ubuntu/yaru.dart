import 'dart:io';

import 'package:flutter/material.dart';

/// The official Ubuntu Logo
class UbuntuLogo extends StatelessWidget {
  const UbuntuLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(File('../assets/ubuntu.png'));
  }
}
