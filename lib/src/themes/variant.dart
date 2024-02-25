import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/themes/ubuntu_butterfly.dart';
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
  ];
}

final _yaruLightThemes = <YaruVariant, ThemeData>{
  YaruVariant.orange: yaruLight,
  YaruVariant.bark: yaruBarkLight,
  YaruVariant.sage: yaruSageLight,
  YaruVariant.olive: yaruOliveLight,
  YaruVariant.viridian: yaruViridianLight,
  YaruVariant.prussianGreen: yaruPrussianGreenLight,
  YaruVariant.blue: yaruBlueLight,
  YaruVariant.purple: yaruPurpleLight,
  YaruVariant.magenta: yaruMagentaLight,
  YaruVariant.red: yaruRedLight,
  YaruVariant.kubuntuBlue: yaruKubuntuLight,
  YaruVariant.lubuntuBlue: yaruLubuntuLight,
  YaruVariant.ubuntuBudgieBlue: yaruUbuntuBudgieLight,
  YaruVariant.ubuntuButterflyPink: yaruUbuntuButterflyLight,
  YaruVariant.ubuntuCinnamonBrown: yaruUbuntuCinnamonLight,
  YaruVariant.ubuntuMateGreen: yaruUbuntuMateLight,
  YaruVariant.ubuntuStudioBlue: yaruUbuntuStudioLight,
  YaruVariant.ubuntuUnityPurple: yaruUbuntuUnityLight,
  YaruVariant.xubuntuBlue: yaruXubuntuLight,
};

final _yaruDarkThemes = <YaruVariant, ThemeData>{
  YaruVariant.orange: yaruDark,
  YaruVariant.bark: yaruBarkDark,
  YaruVariant.sage: yaruSageDark,
  YaruVariant.olive: yaruOliveDark,
  YaruVariant.viridian: yaruViridianDark,
  YaruVariant.prussianGreen: yaruPrussianGreenDark,
  YaruVariant.blue: yaruBlueDark,
  YaruVariant.purple: yaruPurpleDark,
  YaruVariant.magenta: yaruMagentaDark,
  YaruVariant.red: yaruRedDark,
  YaruVariant.kubuntuBlue: yaruKubuntuDark,
  YaruVariant.lubuntuBlue: yaruLubuntuDark,
  YaruVariant.ubuntuBudgieBlue: yaruUbuntuBudgieDark,
  YaruVariant.ubuntuButterflyPink: yaruUbuntuButterflyDark,
  YaruVariant.ubuntuCinnamonBrown: yaruUbuntuCinnamonDark,
  YaruVariant.ubuntuMateGreen: yaruUbuntuMateDark,
  YaruVariant.ubuntuStudioBlue: yaruUbuntuStudioDark,
  YaruVariant.ubuntuUnityPurple: yaruUbuntuUnityDark,
  YaruVariant.xubuntuBlue: yaruXubuntuDark,
};
