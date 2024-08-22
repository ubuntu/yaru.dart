import 'package:flutter/material.dart';

import '../../theme.dart';

/// Describes a Yaru variant and its primary color.
enum YaruVariant {
  orange(YaruColors.orange),
  bark(YaruColors.bark),
  sage(YaruColors.sage),
  olive(YaruColors.olive),
  viridian(YaruColors.viridian),
  prussianGreen(YaruColors.prussianGreen),
  blue(YaruColors.blue),
  purple(YaruColors.purple),
  magenta(YaruColors.magenta),
  red(YaruColors.red),
  wartyBrown(YaruColors.wartyBrown),
  adwaitaBlue(YaruColors.adwaitaBlue),
  adwaitaTeal(YaruColors.adwaitaTeal),
  adwaitaGreen(YaruColors.adwaitaGreen),
  adwaitaYellow(YaruColors.adwaitaYellow),
  adwaitaOrange(YaruColors.adwaitaOrange),
  adwaitaRed(YaruColors.adwaitaRed),
  adwaitaPink(YaruColors.adwaitaPink),
  adwaitaPurple(YaruColors.adwaitaPurple),
  adwaitaSlate(YaruColors.adwaitaSlate),

  /// Kubuntu
  kubuntuBlue(YaruColors.kubuntuBlue),

  /// Lubuntu
  lubuntuBlue(YaruColors.lubuntuBlue),

  /// Ubuntu Budgie
  ubuntuBudgieBlue(YaruColors.ubuntuBudgieBlue),

  /// Ubuntu Butterfly
  ubuntuButterflyPink(YaruColors.ubuntuButterflyPink),

  /// Ubuntu Cinnamon Remix
  ubuntuCinnamonBrown(YaruColors.ubuntuCinnamonBrown),

  /// Ubuntu MATE
  ubuntuMateGreen(YaruColors.ubuntuMateGreen),

  /// Ubuntu Studio
  ubuntuStudioBlue(YaruColors.ubuntuStudioBlue),

  /// Ubuntu Unity
  ubuntuUnityPurple(YaruColors.ubuntuUnityPurple),

  /// Xubuntu
  xubuntuBlue(YaruColors.xubuntuBlue);

  const YaruVariant(this.color);

  /// The primary color of the variant.
  final Color color;

  /// A light theme for the variant.
  ThemeData get theme => _yaruLightThemes[this]!;

  /// A dark theme for the variant.
  ThemeData get darkTheme => _yaruDarkThemes[this]!;

  /// The available accent color variants excluding Ubuntu flavors.
  static const List<YaruVariant> accents = [
    orange,
    bark,
    sage,
    olive,
    viridian,
    prussianGreen,
    blue,
    purple,
    magenta,
    red,
    wartyBrown,
    adwaitaBlue,
    adwaitaTeal,
    adwaitaGreen,
    adwaitaYellow,
    adwaitaOrange,
    adwaitaRed,
    adwaitaPink,
    adwaitaPurple,
    adwaitaSlate,
  ];
}

final _yaruLightThemes = Map<YaruVariant, ThemeData>.fromEntries(
  YaruVariant.values.map(
    (e) => MapEntry<YaruVariant, ThemeData>(
      e,
      e == YaruVariant.orange
          ? yaruLight
          : createYaruLightTheme(
              primaryColor: e.color,
            ),
    ),
  ),
);

final _yaruDarkThemes = Map<YaruVariant, ThemeData>.fromEntries(
  YaruVariant.values.map(
    (e) => MapEntry<YaruVariant, ThemeData>(
      e,
      e == YaruVariant.orange
          ? yaruDark
          : createYaruDarkTheme(
              primaryColor: e.color,
            ),
    ),
  ),
);
