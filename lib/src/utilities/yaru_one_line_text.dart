import 'package:flutter/material.dart';

class YaruOneLineText extends Text {
  YaruOneLineText(
    String data, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaleFactor,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
  }) : super(
          data.replaceAll(' ', '\u00A0'),
          maxLines: 1,
        );
}
