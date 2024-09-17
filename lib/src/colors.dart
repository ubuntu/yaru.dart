import 'package:flutter/material.dart';

/// Available Yaru colors.
class YaruColors {
  const YaruColors._({
    required this.error,
    required this.success,
    required this.warning,
    required this.link,
  });

  /// Colors derived from the given [brightness].
  factory YaruColors.from(Brightness brightness) {
    return switch (brightness) {
      Brightness.light => YaruColors.light,
      Brightness.dark => YaruColors.dark,
    };
  }

  /// Colors for the given [context].
  static YaruColors of(BuildContext context) {
    return YaruColors.from(Theme.of(context).brightness);
  }

  /// Theme-specific colors for light themes.
  static const light = YaruColors._(
    error: Color(0xFFB52A4A), // YaruColors.red[700],
    success: Color(0xFF0e8420),
    warning: Color(0xFFf99b11),
    link: Color(0xFF0073E5), // YaruColors.blue[700],
  );

  /// Theme-specific colors for dark themes.
  static const dark = YaruColors._(
    error: Color(0xFFE86581), // YaruColors.red[300]
    success: Color(0xFF0e8420),
    warning: Color(0xFFf99b11),
    link: Color(0xFF0094FF), // YaruColors.blue[500]
  );

  /// Ubuntu Orange
  static const Color orange = Color(0xFFE95420);

  /// Warm Grey
  ///
  /// For balance. The addition of warm grey softens the combination of orange
  /// and aubergine and provides a bridge between the two.
  ///
  /// Warm grey can be used for; backgrounds, graphics, dot patterns, charts and
  /// diagrams. It can also be used for large size text.
  static const Color warmGrey = Color(0xFFAEA79F);

  /// Cool Grey
  ///
  /// For typography, particularly body copy. Black can be quite harsh in
  /// combination with aubergine, but grey delivers more balance while still
  /// being legible.
  ///
  /// Cool grey can also be used within charts and diagrams.
  static const Color coolGrey = Color(0xFF333333);

  /// Text Grey
  ///
  /// Text grey is used for small size headings, sub-headings and body copy text
  /// only.
  static const Color textGrey = Color(0xFF111111);

  /// Error
  final Color error;

  /// Warning
  final Color warning;

  /// Success
  final Color success;

  /// Porcelain
  static const Color porcelain = Color(0xFFFAFAFA);

  /// Inkstone
  static const Color inkstone = Color(0xFF3B3B3B);

  /// Jet
  static const Color jet = Color(0xFF2B2B2B);

  /// Dark Jet
  static const Color darkJet = Color(0xFF252525);

  /// Light title bar
  static const Color titleBarLight = Color(0xFFEBEBEB);

  /// Dark title bar
  static const Color titleBarDark = Color(0xFF303030);

  /// Link
  final Color link;

  /// Olive
  static const Color olive = Color(0xFF4B8501);

  /// Bark
  static const Color bark = Color(0xFF787859);

  /// Sage
  static const Color sage = Color(0xFF657B69);

  /// Warty Brown
  /// Actually its  Color(0xFFB39169) but for contrast reassons we use this altered version in Flutter
  static const Color wartyBrown = Color(0xFF92714a);

  /// Prussian Green
  static const Color prussianGreen = Color(0xFF308280);

  /// Viridian
  static const Color viridian = Color(0xFF03875B);

  /// Purple
  static const Color purple = Color(0xFF7764D8);

  /// Red
  static const Color red = Color(0xFFDA3450);

  /// Blue
  static const Color blue = Color(0xFF0073E5);

  /// Magenta
  static const Color magenta = Color(0xFFB34CB3);

  /// Kubuntu Blue
  static const Color kubuntuBlue = Color(0xFF0079C1);

  /// Lubuntu Blue
  static const Color lubuntuBlue = Color(0xFF0068C8);

  /// Ubuntu Budgie Blue
  static const Color ubuntuBudgieBlue = Color(0xFF2196F3);

  /// Ubuntu Butterfly Pink
  static const Color ubuntuButterflyPink = Color(0xFFFF135B);

  /// Ubuntu Cinnamon Brown
  static const Color ubuntuCinnamonBrown = Color(0xFFDD682A);

  /// Ubuntu MATE Green
  static const Color ubuntuMateGreen = Color(0xFF73AF59);

  /// Ubuntu Studio Blue
  static const Color ubuntuStudioBlue = Color(0xFF009BF9);

  /// Ubuntu Unity Purple
  static const Color ubuntuUnityPurple = Color(0xFF9005D5);

  /// Xubuntu Blue
  static const Color xubuntuBlue = Color(0xFF0044AA);

  /// Adwaita accents with 24.10+
  /// https://gnome.pages.gitlab.gnome.org/libadwaita/doc/main/enum.AccentColor.html

  /// Adwaita Blue
  static const Color adwaitaBlue = Color(0xFF3584e4);

  /// Adwaita Teal
  static const Color adwaitaTeal = Color(0xFF2190a4);

  /// Adwaita Green
  static const Color adwaitaGreen = Color(0xFF3a944a);

  /// Adwaita Yellow
  static const Color adwaitaYellow = Color(0xFFc88800);

  /// Adwaita Orange
  static const Color adwaitaOrange = Color(0xFFed5b00);

  /// Adwaita Red
  static const Color adwaitaRed = Color(0xFFe62d42);

  /// Adwaita Pink
  static const Color adwaitaPink = Color(0xFFd56199);

  /// Adwaita Purple
  static const Color adwaitaPurple = Color(0xFF9141ac);

  /// Adwaita Slate
  static const Color adwaitaSlate = Color(0xFF6f8396);
}

/// Set of useful methods when working with [Color]
extension YaruColorExtension on Color {
  /// Scale color attributes relatively to current ones.
  /// [alpha], [hue], [saturation] and [lightness] values must be clamped between -1.0 and 1.0
  Color scale({
    double alpha = 0.0,
    double hue = 0.0,
    double saturation = 0.0,
    double lightness = 0.0,
  }) {
    assert(alpha >= -1.0 && alpha <= 1.0);
    assert(hue >= -1.0 && hue <= 1.0);
    assert(saturation >= -1.0 && saturation <= 1.0);
    assert(lightness >= -1.0 && lightness <= 1.0);

    final hslColor = _getPatchedHslColor();

    double scale(double value, double amount, [double upperLimit = 1.0]) {
      var result = value;

      if (amount > 0) {
        result = value + (upperLimit - value) * amount;
      } else if (amount < 0) {
        result = value + value * amount;
      }

      return result.clamp(0.0, upperLimit);
    }

    return hslColor
        .withAlpha(scale(opacity, alpha))
        .withHue(scale(hslColor.hue, hue, 360.0))
        .withSaturation(scale(hslColor.saturation, saturation))
        .withLightness(scale(hslColor.lightness, lightness))
        .toColor();
  }

  /// Adjust color attributes by the given values.
  /// [alpha], [saturation] and [lightness] values must be clamped between -1.0 and 1.0
  /// [hue] value must be clamped between -360.0 and 360.0
  Color adjust({
    double alpha = 0.0,
    double hue = 0.0,
    double saturation = 0.0,
    double lightness = 0.0,
  }) {
    assert(alpha >= -1.0 && alpha <= 1.0);
    assert(hue >= -360.0 && hue <= 360.0);
    assert(saturation >= -1.0 && saturation <= 1.0);
    assert(lightness >= -1.0 && lightness <= 1.0);

    final hslColor = _getPatchedHslColor();

    double adjust(double value, double amount, [double upperLimit = 1.0]) {
      return (value + amount).clamp(0.0, upperLimit);
    }

    return hslColor
        .withAlpha(adjust(hslColor.alpha, alpha))
        .withHue(adjust(hslColor.hue, hue, 360.0))
        .withSaturation(adjust(hslColor.saturation, saturation))
        .withLightness(adjust(hslColor.lightness, lightness))
        .toColor();
  }

  /// Return a copy of this color with attributes replaced by given values.
  /// [alpha], [saturation] and [lightness] values must be clamped between 0.0 and 1.0
  /// [hue] value must be clamped between 0.0 and 360.0
  Color copyWith({
    double? alpha,
    double? hue,
    double? saturation,
    double? lightness,
  }) {
    assert(alpha == null || (alpha >= 0.0 && alpha <= 1.0));
    assert(hue == null || (hue >= 0.0 && hue <= 360.0));
    assert(saturation == null || (saturation >= 0.0 && saturation <= 1.0));
    assert(lightness == null || (lightness >= 0.0 && lightness <= 1.0));

    final hslColor = _getPatchedHslColor();

    return hslColor
        .withAlpha(alpha ?? hslColor.alpha)
        .withHue(hue ?? hslColor.hue)
        .withSaturation(saturation ?? hslColor.saturation)
        .withLightness(lightness ?? hslColor.lightness)
        .toColor();
  }

  Color cap({
    double alpha = 1.0,
    double saturation = 1.0,
    double lightness = 1.0,
  }) {
    assert(alpha >= 0.0 && alpha <= 1.0);
    assert(saturation >= 0.0 && saturation <= 1.0);
    assert(lightness >= 0.0 && lightness <= 1.0);

    final hslColor = _getPatchedHslColor();

    return hslColor
        .withAlpha(hslColor.alpha <= alpha ? hslColor.alpha : alpha)
        .withSaturation(
          hslColor.saturation <= saturation ? hslColor.saturation : saturation,
        )
        .withLightness(
          hslColor.lightness <= lightness ? hslColor.lightness : lightness,
        )
        .toColor();
  }

  Color capDown({
    double alpha = 0.0,
    double saturation = 0.0,
    double lightness = 0.0,
  }) {
    assert(alpha >= 0.0 && alpha <= 1.0);
    assert(saturation >= 0.0 && saturation <= 1.0);
    assert(lightness >= 0.0 && lightness <= 1.0);

    final hslColor = _getPatchedHslColor();

    return hslColor
        .withAlpha(hslColor.alpha >= alpha ? hslColor.alpha : alpha)
        .withSaturation(
          hslColor.saturation >= saturation ? hslColor.saturation : saturation,
        )
        .withLightness(
          hslColor.lightness >= lightness ? hslColor.lightness : lightness,
        )
        .toColor();
  }

  HSLColor _getPatchedHslColor() {
    final hslColor = HSLColor.fromColor(this);

    // A pure dark color have saturation level at 1.0, which results in red when lighten it.
    // We reset this value to 0.0, so the result is desaturated as expected:
    return hslColor
        .withSaturation(hslColor.lightness == 0.0 ? 0.0 : hslColor.saturation);
  }

  /// Returns a hex representation (`#AARRGGBB`) of the color.
  String toHex() {
    return '#${alpha.toHex()}${red.toHex()}${green.toHex()}${blue.toHex()}';
  }
}

extension on int {
  String toHex() => toRadixString(16).padLeft(2, '0');
}
