import 'package:material_ui/material_ui.dart';

import '../../theme.dart';

final yaruHighContrastLight = createYaruLightTheme(primaryColor: Colors.black);

final yaruHighContrastDark = createYaruDarkTheme(
  primaryColor: Colors.white,
  highContrast: true,
  elevatedButtonTextColor: Colors.black,
);
