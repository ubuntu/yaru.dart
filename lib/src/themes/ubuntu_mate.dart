import '../../theme.dart';

const _primaryColor = YaruColors.ubuntuMateGreen;

@Deprecated('Use yaruUbuntuMateLight instead')
final yaruMateLight = yaruUbuntuMateLight;

final yaruUbuntuMateLight = createYaruLightTheme(
  primaryColor: _primaryColor,
);

@Deprecated('Use yaruUbuntuMateDark instead')
final yaruMateDark = yaruUbuntuMateDark;

final yaruUbuntuMateDark = createYaruDarkTheme(
  primaryColor: _primaryColor,
);
