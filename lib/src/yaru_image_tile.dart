import 'dart:io';

import 'package:flutter/material.dart';

class ImageTile extends StatelessWidget {
  /// Creates a Image Tile from the image path given in the path property.
  const ImageTile({Key? key, required this.path, this.onTap, required this.currentlySelected, this.filterQuality})
      : super(key: key);

  // Specifies the path of the asset
  final String path;

  /// Current Value of the imageTile.
  /// Based on the this value selection of the image can be managed.
  /// If this value is `true` [Container] border will have color from [Theme.of(context).primaryColor]
  /// else if the value is `false` the border color will be [Colors.transparent].
  final bool currentlySelected;

  /// Callback triggered when the [ImageTile] is clicked.
  final VoidCallback? onTap;

  /// The rendering quality of the image.
  ///
  /// If the image is of a high quality and its pixels are perfectly aligned
  /// with the physical screen pixels, extra quality enhancement may not be
  /// necessary. If so, then [FilterQuality.none] would be the most efficient.
  ///
  /// If the pixels are not perfectly aligned with the screen pixels, or if the
  /// image itself is of a low quality, [FilterQuality.none] may produce
  /// undesirable artifacts. Consider using other [FilterQuality] values to
  /// improve the rendered image quality in this case. Pixels may be misaligned
  /// with the screen pixels as a result of transforms or scaling.
  ///
  /// See also:
  ///
  ///  * [FilterQuality], the enum containing all possible filter quality
  ///    options.
  ///  * By default [FilterQuality] will be [FilterQuality.low].
  final FilterQuality? filterQuality;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6.0),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: currentlySelected ? Theme.of(context).primaryColor.withOpacity(0.3) : Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.file(File(path), filterQuality: filterQuality ?? FilterQuality.low, fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }
}
