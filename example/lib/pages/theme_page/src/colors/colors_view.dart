import 'package:flutter/material.dart';
import 'package:yaru/theme.dart';

const _gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 300,
  mainAxisExtent: 40,
  mainAxisSpacing: 20,
  crossAxisSpacing: 20,
);

class ColorsView extends StatelessWidget {
  const ColorsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColors = _getAccentColors(theme);
    final baseColors = _getBaseColors(theme);
    final specialColors = _getSpecialColors(theme);
    final extensionColors = _getExtensionColors(theme);

    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        ..._themeSection(
          theme: theme,
          colors: accentColors,
          headline: 'Theme Accent Colors',
        ),
        ..._themeSection(
          theme: theme,
          colors: baseColors,
          headline: 'Theme Base Colors',
        ),
        ..._themeSection(
          theme: theme,
          colors: specialColors,
          headline: 'Theme Special Colors',
        ),
        ..._themeSection(
          theme: theme,
          colors: _getYaruPrimaryColors(theme),
          headline: 'Primary Color Yaru Variations',
        ),
        ..._themeSection(
          theme: theme,
          colors: _getUbuntuFlavourColors(theme),
          headline: 'Ubuntu Flavor Colors',
        ),
        ..._themeSection(
          theme: theme,
          colors: extensionColors,
          headline: 'Extension Colors',
        ),
      ],
    );
  }

  List<Widget> _themeSection({
    required ThemeData theme,
    required Map<String, (Color, Color?)> colors,
    required String headline,
  }) {
    final headlineStyle = theme.textTheme.headlineMedium;

    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 5),
        child: Text(
          headline,
          style: headlineStyle,
        ),
      ),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: _gridDelegate,
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final e = colors.entries.elementAt(index);
          return _colorContainer(
            e.key,
            e.value.$1,
            e.value.$2,
          );
        },
      ),
      const _SpacedDivider(),
    ];
  }

  Widget _colorContainer(
    String colorName,
    Color backgroundColor, [
    Color? foregroundColor,
  ]) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 1),
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              colorName,
              style: TextStyle(
                color: foregroundColor ?? contrastColor(backgroundColor),
                fontSize: 11,
              ),
            ),
            Text(
              backgroundColor
                  .toString()
                  .replaceAll('Color(0x', '#')
                  .replaceAll(')', ''),
              style: TextStyle(
                color: foregroundColor ?? contrastColor(backgroundColor),
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpacedDivider extends StatelessWidget {
  const _SpacedDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 30, bottom: 20),
      child: Divider(
        height: 0,
      ),
    );
  }
}

Map<String, (Color, Color?)> _getSpecialColors(ThemeData theme) {
  final s = theme.colorScheme;

  final colors = <String, (Color, Color?)>{
    'error': (s.error, s.onError),
    'onError': (s.onError, null),
    'shadow': (s.shadow, null),
    'scrim': (s.scrim, null),
  };
  return colors;
}

Map<String, (Color, Color?)> _getAccentColors(ThemeData theme) {
  final s = theme.colorScheme;

  final colors = <String, (Color, Color?)>{
    'primary': (s.primary, s.onPrimary),
    'onPrimary': (s.onPrimary, null),
    'inversePrimary': (s.inversePrimary, null),
    'primaryContainer': (s.primaryContainer, s.onPrimaryContainer),
    'onPrimaryContainer': (s.onPrimaryContainer, null),
    'secondary': (s.secondary, s.onSecondary),
    'onSecondary': (s.onSecondary, null),
    'secondaryContainer': (s.secondaryContainer, s.onSecondaryContainer),
    'onSecondaryContainer': (s.onSecondaryContainer, null),
    'tertiary': (s.tertiary, s.onTertiary),
    'onTertiary': (s.onTertiary, null),
    'tertiaryContainer': (s.tertiaryContainer, s.onTertiaryContainer),
    'onTertiaryContainer': (s.onTertiaryContainer, null),
  };
  return colors;
}

Map<String, (Color, Color?)> _getBaseColors(ThemeData theme) {
  final s = theme.colorScheme;

  final colors = <String, (Color, Color?)>{
    'background': (s.surface, s.onSurface),
    'onBackground': (s.onSurface, null),
    'surface': (s.surface, s.onSurface),
    'onSurface': (s.onSurface, null),
    'surfaceTint': (s.surfaceTint, null),
    'surfaceVariant': (s.surfaceContainerHighest, s.onSurfaceVariant),
    'onSurfaceVariant': (s.onSurfaceVariant, null),
    'inverseSurface': (s.inverseSurface, s.onInverseSurface),
    'onInverseSurface': (s.onInverseSurface, null),
  };
  return colors;
}

// TODO: update example with new adwaita colors
Map<String, (Color, Color?)> _getYaruPrimaryColors(ThemeData theme) {
  return {
    'orange': (YaruColors.orange, theme.colorScheme.onPrimary),
    'olive': (YaruColors.olive, theme.colorScheme.onPrimary),
    'viridian': (YaruColors.viridian, theme.colorScheme.onPrimary),
    'purple': (YaruColors.purple, theme.colorScheme.onPrimary),
    'red': (YaruColors.red, theme.colorScheme.onPrimary),
    'blue': (YaruColors.blue, theme.colorScheme.onPrimary),
    'magenta': (YaruColors.magenta, theme.colorScheme.onPrimary),
    'sage': (YaruColors.sage, theme.colorScheme.onPrimary),
    'prussianGreen': (YaruColors.prussianGreen, theme.colorScheme.onPrimary),
    'bark': (YaruColors.bark, theme.colorScheme.onPrimary),
  };
}

Map<String, (Color, Color?)> _getUbuntuFlavourColors(ThemeData theme) {
  return {
    'kubuntuBlue': (YaruColors.kubuntuBlue, theme.colorScheme.onPrimary),
    'lubuntuBlue': (YaruColors.lubuntuBlue, theme.colorScheme.onPrimary),
    'ubuntuBudgieBlue': (
      YaruColors.ubuntuBudgieBlue,
      theme.colorScheme.onPrimary
    ),
    'ubuntuButterflyPink': (
      YaruColors.ubuntuButterflyPink,
      theme.colorScheme.onPrimary
    ),
    'ubuntuCinnamonBrown': (
      YaruColors.ubuntuCinnamonBrown,
      theme.colorScheme.onPrimary
    ),
    'ubuntuMateGreen': (
      YaruColors.ubuntuMateGreen,
      theme.colorScheme.onPrimary
    ),
    'ubuntuStudioBlue': (
      YaruColors.ubuntuStudioBlue,
      theme.colorScheme.onPrimary
    ),
    'ubuntuUnityPurple': (
      YaruColors.ubuntuUnityPurple,
      theme.colorScheme.onPrimary
    ),
    'xubuntuBlue': (YaruColors.xubuntuBlue, theme.colorScheme.onPrimary),
  };
}

Map<String, (Color, Color)> _getExtensionColors(ThemeData theme) {
  return {
    'success': (
      theme.colorScheme.success,
      contrastColor(theme.colorScheme.success)
    ),
    'warning': (
      theme.colorScheme.warning,
      contrastColor(theme.colorScheme.warning)
    ),
    'link': (theme.colorScheme.link, contrastColor(theme.colorScheme.link)),
  };
}
