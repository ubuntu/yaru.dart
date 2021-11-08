import 'dart:io';

import 'package:flutter/material.dart';

class ImageTile extends StatelessWidget {
  const ImageTile(
      {Key? key,
      required this.path,
      this.onTap,
      required this.currentlySelected})
      : super(key: key);

  final String path;
  final bool currentlySelected;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6.0),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: currentlySelected
                ? Theme.of(context).primaryColor.withOpacity(0.3)
                : Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.file(File(path),
                filterQuality: FilterQuality.low, fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }
}
