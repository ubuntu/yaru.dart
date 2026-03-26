import '../../theme.dart';

const _primaryColor = YaruColors.orange;

final yaruLight = createYaruLightTheme(
  primaryColor: _primaryColor,
  elevatedButtonColor: YaruColors.light.success,
);

final yaruDark = createYaruDarkTheme(
  primaryColor: _primaryColor,
  elevatedButtonColor: YaruColors.dark.success,
);
