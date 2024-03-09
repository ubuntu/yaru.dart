import '../../theme.dart';

const _primaryColor = YaruColors.ubuntuMateGreen;

// TODO: remove this for 5.0 release.
@Deprecated('Use yaruUbuntuMateLight instead')
final yaruMateLight = yaruUbuntuMateLight;

final yaruUbuntuMateLight = createYaruLightTheme(
  primaryColor: _primaryColor,
);

// TODO: remove this for 5.0 release.
@Deprecated('Use yaruUbuntuMateDark instead')
final yaruMateDark = yaruUbuntuMateDark;

final yaruUbuntuMateDark = createYaruDarkTheme(
  primaryColor: _primaryColor,
);
