import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaru/theme.dart';

import '../text/text_theme.dart';
import 'constants.dart';

const kDividerColorDark = Color.fromARGB(255, 65, 65, 65);
const kDividerColorLight = Color(0xffdcdcdc);

bool get isMobile =>
    !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia);

// AppBar

AppBarTheme _createAppBarTheme(ColorScheme colorScheme) {
  return AppBarTheme(
    shape: Border(
      bottom: BorderSide(
        strokeAlign: -1,
        color: colorScheme.isHighContrast
            ? colorScheme.outlineVariant
            : colorScheme.onSurface.withOpacity(
                colorScheme.isLight ? 0.2 : 0.07,
              ),
      ),
    ),
    scrolledUnderElevation: kAppBarElevation,
    surfaceTintColor: colorScheme.surface,
    elevation: kAppBarElevation,
    systemOverlayStyle: colorScheme.isLight
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark,
    backgroundColor: colorScheme.surface,
    foregroundColor: colorScheme.onSurface,
    titleTextStyle: createTextTheme(colorScheme.onSurface).titleLarge!.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.normal,
        ),
    iconTheme: IconThemeData(
      color: colorScheme.onSurface,
      size: kCompactIconSize,
    ),
    actionsIconTheme: IconThemeData(color: colorScheme.onSurface),
    toolbarHeight: kCompactAppBarHeight,
  );
}

InputDecorationTheme _createInputDecorationTheme(ColorScheme colorScheme) {
  final radius = BorderRadius.circular(kButtonRadius);
  const width = 1.0;
  const strokeAlign = 0.0;
  final fill = colorScheme.isLight
      ? const Color(0xFFededed)
      : const Color.fromARGB(255, 40, 40, 40);
  final border = colorScheme.isHighContrast
      ? colorScheme.outlineVariant
      : colorScheme.outline;
  final disabledBorder = colorScheme.isLight
      ? const Color.fromARGB(255, 237, 237, 237)
      : const Color.fromARGB(255, 67, 67, 67);

  const textStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  return InputDecorationTheme(
    filled: true,
    fillColor: fill,
    border: OutlineInputBorder(
      borderSide: BorderSide(
        width: width,
        color: border,
      ),
      borderRadius: radius,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: width, color: colorScheme.primary),
      borderRadius: radius,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
          BorderSide(width: width, color: border, strokeAlign: strokeAlign),
      borderRadius: radius,
    ),
    activeIndicatorBorder:
        const BorderSide(width: width, strokeAlign: strokeAlign),
    outlineBorder: const BorderSide(width: width, strokeAlign: strokeAlign),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: width,
        color: colorScheme.error,
        strokeAlign: strokeAlign,
      ),
      borderRadius: radius,
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: width,
        color: colorScheme.error,
        strokeAlign: strokeAlign,
      ),
      borderRadius: radius,
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: width,
        color: disabledBorder,
        strokeAlign: strokeAlign,
      ),
      borderRadius: radius,
    ),
    isDense: true,
    iconColor: colorScheme.onSurface,
    contentPadding:
        const EdgeInsets.only(left: 12, right: 12, bottom: 9, top: 10),
    helperStyle: textStyle,
    hintStyle: textStyle,
    labelStyle: textStyle,
    suffixStyle: textStyle.copyWith(
      color: colorScheme.onSurface.scale(lightness: -0.2),
    ),
    prefixStyle: textStyle.copyWith(
      color: colorScheme.onSurface.scale(lightness: -0.2),
    ),
  );
}

TextSelectionThemeData _createTextSelectionTheme(ColorScheme colorScheme) {
  return TextSelectionThemeData(
    cursorColor: colorScheme.onSurface,
    selectionColor: colorScheme.primary.withOpacity(0.40),
  );
}

const _tooltipThemeData = TooltipThemeData(
  waitDuration: Duration(milliseconds: 500),
);

// Buttons

WidgetStateColor _createCommonButtonIconColor({
  required ColorScheme colorScheme,
  required Color disabledColor,
}) =>
    WidgetStateColor.resolveWith(
      (states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledColor;
        }
        return states.contains(WidgetState.selected)
            ? colorScheme.primary
            : colorScheme.onSurface;
      },
    );

ButtonStyle _createCommonButtonStyle() {
  return const ButtonStyle(
    padding: WidgetStatePropertyAll(EdgeInsets.all(16)),
    iconSize: WidgetStatePropertyAll(kCompactButtonIconSize),
  );
}

final _buttonThemeData = ButtonThemeData(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(kButtonRadius),
  ),
);

OutlinedButtonThemeData _createOutlinedButtonTheme({
  required ColorScheme colorScheme,
  required Color disabledColor,
}) {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: BorderSide(
        color: colorScheme.isHighContrast
            ? colorScheme.outlineVariant
            : colorScheme.outline,
      ),
      // backgroundColor: colorScheme.surface, // defaults to transparent
      foregroundColor: colorScheme.onSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kButtonRadius),
      ),
    ).merge(
      _createCommonButtonStyle(),
    ),
  );
}

TextButtonThemeData _createTextButtonTheme({
  required ColorScheme colorScheme,
  required Color disabledColor,
}) {
  return TextButtonThemeData(
    style: TextButton.styleFrom(
      iconColor: colorScheme.primary,
      foregroundColor: colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kButtonRadius),
      ),
    ).merge(
      _createCommonButtonStyle(),
    ),
  );
}

ElevatedButtonThemeData _createElevatedButtonTheme({
  required Color color,
  required ColorScheme colorScheme,
  Color? textColor,
  required Color disabledColor,
}) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: textColor ?? contrastColor(color),
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: colorScheme.isHighContrast
            ? BorderSide(color: colorScheme.outlineVariant)
            : BorderSide.none,
        borderRadius: BorderRadius.circular(kButtonRadius),
      ),
    ).merge(
      _createCommonButtonStyle(),
    ),
  );
}

FilledButtonThemeData _createFilledButtonTheme({
  required ColorScheme colorScheme,
  required Color disabledColor,
}) {
  return FilledButtonThemeData(
    style: FilledButton.styleFrom(
      disabledBackgroundColor: colorScheme.onSurface.withOpacity(0.12),
      backgroundColor: colorScheme.onSurface.withOpacity(0.1),
      surfaceTintColor: colorScheme.onSurface.withOpacity(0.1),
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: colorScheme.isHighContrast
            ? BorderSide(color: colorScheme.outlineVariant)
            : BorderSide.none,
        borderRadius: BorderRadius.circular(kButtonRadius),
      ),
    ).merge(
      _createCommonButtonStyle(),
    ),
  );
}

IconButtonThemeData _createIconButtonTheme({
  required ColorScheme colorScheme,
  required Color disabledColor,
}) {
  return IconButtonThemeData(
    style: IconButton.styleFrom(
      padding: EdgeInsets.zero,
      foregroundColor: colorScheme.onSurface,
      highlightColor: colorScheme.onSurface.withOpacity(0.05),
      surfaceTintColor: colorScheme.surface,
      fixedSize: const Size(kCompactButtonHeight, kCompactButtonHeight),
      minimumSize: const Size(kCompactButtonHeight, kCompactButtonHeight),
      maximumSize: const Size(kCompactButtonHeight, kCompactButtonHeight),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      iconSize: kCompactIconSize,
    ).merge(
      _createCommonButtonStyle().copyWith(
        iconColor: _createCommonButtonIconColor(
          colorScheme: colorScheme,
          disabledColor: disabledColor,
        ),
      ),
    ),
  );
}

MenuButtonThemeData _createMenuItemTheme(
  ColorScheme colorScheme,
  TextTheme textTheme,
) {
  return MenuButtonThemeData(
    style: ButtonStyle(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      alignment: Alignment.center,
      textStyle: WidgetStatePropertyAll(textTheme.bodyMedium),
      maximumSize: const WidgetStatePropertyAll(
        Size(
          999,
          kCompactButtonHeight + 10,
        ),
      ),
      minimumSize: const WidgetStatePropertyAll(
        Size(
          20,
          kCompactButtonHeight + 10,
        ),
      ),
    ),
  );
}

ToggleButtonsThemeData _createToggleButtonsTheme(ColorScheme colorScheme) {
  return ToggleButtonsThemeData(
    constraints: const BoxConstraints(
      minHeight: kCompactButtonHeight,
      minWidth: 50,
      maxWidth: double.infinity,
      maxHeight: kCompactButtonHeight,
    ),
    borderRadius: const BorderRadius.all(Radius.circular(kButtonRadius)),
    borderColor: colorScheme.isHighContrast
        ? colorScheme.outlineVariant
        : colorScheme.outline,
    selectedColor: colorScheme.onSurface,
    selectedBorderColor:
        colorScheme.isHighContrast ? colorScheme.outlineVariant : null,
    fillColor: colorScheme.outline,
    hoverColor: colorScheme.onSurface.withOpacity(.05),
  );
}

// Dialogs

DialogTheme _createDialogTheme(ColorScheme colorScheme) {
  final bgColor = _createMenuBg(colorScheme);
  return DialogTheme(
    backgroundColor: bgColor,
    surfaceTintColor: bgColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kWindowRadius),
      side: colorScheme.isDark
          ? BorderSide(
              color: Colors.white
                  .withOpacity(colorScheme.isHighContrast ? 1 : 0.2),
            )
          : BorderSide.none,
    ),
  );
}

// Switches

SwitchThemeData _createSwitchTheme(ColorScheme colorScheme) {
  return SwitchThemeData(
    trackOutlineColor: WidgetStateColor.resolveWith(
      (states) => Colors.transparent,
    ),
    thumbColor: WidgetStateProperty.resolveWith(
      (states) => _getSwitchThumbColor(states, colorScheme),
    ),
    trackColor: WidgetStateProperty.resolveWith(
      (states) => _getSwitchTrackColor(states, colorScheme),
    ),
  );
}

Color _getSwitchThumbColor(Set<WidgetState> states, ColorScheme colorScheme) {
  if (states.contains(WidgetState.disabled)) {
    if (states.contains(WidgetState.selected)) {
      return colorScheme.onSurface.withOpacity(0.5);
    }
    return colorScheme.onSurface.withOpacity(0.5);
  } else {
    return colorScheme.onPrimary;
  }
}

Color _getSwitchTrackColor(Set<WidgetState> states, ColorScheme colorScheme) {
  final uncheckedColor = colorScheme.onSurface.withOpacity(.25);
  final disabledUncheckedColor = colorScheme.onSurface.withOpacity(.15);
  final disabledCheckedColor = colorScheme.onSurface.withOpacity(.18);

  if (states.contains(WidgetState.disabled)) {
    if (states.contains(WidgetState.selected)) {
      return disabledCheckedColor;
    }
    return disabledUncheckedColor;
  } else {
    if (states.contains(WidgetState.selected)) {
      return colorScheme.primary;
    } else {
      return uncheckedColor;
    }
  }
}

// Checks & Radios

Color _getToggleFillColor({
  required Set<WidgetState> states,
  required ColorScheme colorScheme,
  required bool radio,
}) {
  if (!states.contains(WidgetState.disabled)) {
    if (states.contains(WidgetState.selected)) {
      return colorScheme.primary;
    }
    return colorScheme.onSurface.withOpacity(radio ? 0.5 : 0.14);
  }
  if (states.contains(WidgetState.selected)) {
    return colorScheme.onSurface.withOpacity(0.2);
  }
  return colorScheme.onSurface.withOpacity(0.2);
}

Color _getCheckColor(Set<WidgetState> states, ColorScheme colorScheme) {
  if (!states.contains(WidgetState.disabled)) {
    return ThemeData.estimateBrightnessForColor(colorScheme.primary) ==
            Brightness.light
        ? Colors.black
        : Colors.white;
  }
  return YaruColors.warmGrey;
}

CheckboxThemeData _createCheckBoxTheme(ColorScheme colorScheme) {
  return CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kCheckRadius),
    ),
    side: BorderSide(
      color: colorScheme.outline
          .scale(lightness: colorScheme.isLight ? -0.6 : 0.5),
    ),
    fillColor: WidgetStateProperty.resolveWith(
      (states) => _getToggleFillColor(
        states: states,
        colorScheme: colorScheme,
        radio: false,
      ),
    ),
    checkColor: WidgetStateProperty.resolveWith(
      (states) => _getCheckColor(states, colorScheme),
    ),
  );
}

RadioThemeData _createRadioTheme(ColorScheme colorScheme) {
  return RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith(
      (states) => _getToggleFillColor(
        states: states,
        colorScheme: colorScheme,
        radio: true,
      ),
    ),
  );
}

TabBarTheme _createTabBarTheme(ColorScheme colorScheme, Color dividerColor) {
  return TabBarTheme(
    labelColor: colorScheme.isLight
        ? colorScheme.onSurface
        : Colors.white.withOpacity(0.8),
    indicatorColor: colorScheme.primary,
    dividerColor: dividerColor,
    overlayColor: WidgetStateColor.resolveWith(
      (states) => colorScheme.onSurface.withOpacity(0.05),
    ),
  );
}

ProgressIndicatorThemeData _createProgressIndicatorTheme(
  ColorScheme colorScheme,
) {
  return ProgressIndicatorThemeData(
    circularTrackColor: colorScheme.primary.withOpacity(0.3),
    linearTrackColor: colorScheme.primary.withOpacity(0.3),
    color: colorScheme.primary,
  );
}

FloatingActionButtonThemeData _createFloatingActionButtonTheme(
  ColorScheme colorScheme, [
  Color? buttonColor,
]) {
  const elevation = 3.0;
  final bg = buttonColor ?? colorScheme.primary;

  return FloatingActionButtonThemeData(
    backgroundColor: bg,
    foregroundColor: contrastColor(bg),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
      side: colorScheme.isHighContrast
          ? BorderSide(color: colorScheme.outlineVariant)
          : BorderSide.none,
    ),
    elevation: elevation,
    focusElevation: elevation,
    hoverElevation: elevation,
    disabledElevation: elevation,
    highlightElevation: elevation,
  );
}

SliderThemeData _createSliderTheme(ColorScheme colorScheme) {
  return SliderThemeData(
    thumbColor: Colors.white,
    overlayShape: const RoundSliderOverlayShape(
      overlayRadius: 13,
    ),
    overlayColor:
        colorScheme.primary.withOpacity(colorScheme.isLight ? 0.4 : 0.7),
    thumbShape: const RoundSliderThumbShape(elevation: 3.0),
    inactiveTrackColor: colorScheme.onSurface.withOpacity(0.3),
  );
}

Color contrastColor(Color color) => ThemeData.estimateBrightnessForColor(
          color,
        ) ==
        Brightness.light
    ? Colors.black
    : Colors.white;

Color _createMenuBg(ColorScheme colorScheme) =>
    colorScheme.surface.scale(lightness: colorScheme.isLight ? 0 : -0.2);

PopupMenuThemeData _createPopupMenuTheme(ColorScheme colorScheme) {
  final bgColor = _createMenuBg(colorScheme);
  return PopupMenuThemeData(
    color: bgColor,
    surfaceTintColor: bgColor,
    shape: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: colorScheme.isHighContrast
            ? colorScheme.outlineVariant
            : colorScheme.onSurface.withOpacity(
                colorScheme.isLight ? 0.3 : 0.2,
              ),
        width: 1,
      ),
    ),
  );
}

MenuStyle _createMenuStyle(ColorScheme colorScheme) {
  final bgColor = _createMenuBg(colorScheme);
  return MenuStyle(
    surfaceTintColor: WidgetStateColor.resolveWith((states) => bgColor),
    shape: WidgetStateProperty.resolveWith(
      (states) => RoundedRectangleBorder(
        side: BorderSide(
          color: colorScheme.isHighContrast
              ? colorScheme.outlineVariant
              : colorScheme.onSurface.withOpacity(
                  colorScheme.isLight ? 0.3 : 0.2,
                ),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    side: WidgetStateBorderSide.resolveWith(
      (states) => BorderSide(
        color: colorScheme.isHighContrast
            ? colorScheme.outlineVariant
            : colorScheme.onSurface.withOpacity(
                colorScheme.isLight ? 0.3 : 0.2,
              ),
        width: 1,
      ),
    ),
    elevation: WidgetStateProperty.resolveWith((states) => 1),
    backgroundColor: WidgetStateProperty.resolveWith((states) => bgColor),
  );
}

MenuThemeData _createMenuTheme(ColorScheme colorScheme) {
  return MenuThemeData(
    style: _createMenuStyle(colorScheme),
  );
}

DropdownMenuThemeData _createDropdownMenuTheme(ColorScheme colorScheme) {
  return DropdownMenuThemeData(
    inputDecorationTheme: _createInputDecorationTheme(colorScheme).copyWith(
      constraints: const BoxConstraints(
        maxHeight: kCompactButtonHeight,
        minHeight: kCompactButtonHeight,
      ),
    ),
    menuStyle: _createMenuStyle(colorScheme),
  );
}

NavigationBarThemeData _createNavigationBarTheme(ColorScheme colorScheme) {
  return NavigationBarThemeData(
    height: kCompactNavigationBarHeight,
    backgroundColor: colorScheme.surface,
    surfaceTintColor: colorScheme.surface,
    indicatorColor: colorScheme.onSurface.withOpacity(0.1),
    iconTheme: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected)
          ? IconThemeData(color: colorScheme.onSurface)
          : IconThemeData(color: colorScheme.onSurface.withOpacity(0.8)),
    ),
  );
}

NavigationRailThemeData _createNavigationRailTheme(ColorScheme colorScheme) {
  return NavigationRailThemeData(
    backgroundColor: colorScheme.surface,
    indicatorColor: colorScheme.onSurface.withOpacity(0.1),
    selectedIconTheme: IconThemeData(
      color: colorScheme.onSurface,
      size: kCompactIconSize,
    ),
    unselectedIconTheme: IconThemeData(
      color: colorScheme.onSurface.withOpacity(0.8),
      size: kCompactIconSize,
    ),
  );
}

DrawerThemeData _createDrawerTheme(ColorScheme colorScheme) {
  return DrawerThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadiusDirectional.only(
        topEnd: Radius.circular(kWindowRadius),
        bottomEnd: Radius.circular(kWindowRadius),
      ),
      side: BorderSide(
        color: colorScheme.isLight ? Colors.transparent : kDividerColorDark,
      ),
    ),
    backgroundColor: colorScheme.surface,
  );
}

SnackBarThemeData _createSnackBarTheme(ColorScheme colorScheme) {
  const fg = Colors.white;
  return SnackBarThemeData(
    backgroundColor: const Color.fromARGB(250, 20, 20, 20),
    closeIconColor: fg,
    actionTextColor: colorScheme.primary,
    contentTextStyle: const TextStyle(color: fg),
    disabledActionTextColor: fg.withOpacity(0.7),
    behavior: SnackBarBehavior.floating,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        kCompactButtonHeight,
      ),
    ),
  );
}

ChipThemeData _createChipTheme({
  required Color selectedColor,
  required ColorScheme colorScheme,
}) {
  return ChipThemeData(
    selectedColor: selectedColor.withOpacity(.4),
  );
}

/// Helper function to create a new Yaru theme
ThemeData createYaruTheme({
  required ColorScheme colorScheme,
  Color? dividerColor,
  Color? elevatedButtonColor,
  Color? elevatedButtonTextColor,
  bool? useMaterial3 = true,
}) {
  dividerColor ??= colorScheme.isHighContrast
      ? colorScheme.outlineVariant
      : colorScheme.outline;
  final textTheme = createTextTheme(colorScheme.onSurface);

  if (isMobile) {
    return ThemeData(
      textTheme: textTheme,
      dividerColor: dividerColor,
      scaffoldBackgroundColor: colorScheme.surface,
      dividerTheme: DividerThemeData(
        color: dividerColor,
        space: 1.0,
        thickness: 1.0,
      ),
      useMaterial3: true,
      colorScheme: colorScheme,
    );
  }

  final themeData = ThemeData.from(
    useMaterial3: useMaterial3,
    colorScheme: colorScheme,
  );

  return themeData.copyWith(
    iconTheme: IconThemeData(
      color: colorScheme.onSurface,
      size: kCompactIconSize,
    ),
    primaryIconTheme: IconThemeData(color: colorScheme.onSurface),
    progressIndicatorTheme: _createProgressIndicatorTheme(colorScheme),
    pageTransitionsTheme: YaruPageTransitionsTheme.horizontal,
    tabBarTheme: _createTabBarTheme(colorScheme, dividerColor),
    dialogTheme: _createDialogTheme(colorScheme),
    brightness: colorScheme.brightness,
    primaryColor: colorScheme.primary,
    canvasColor: colorScheme.surface,
    scaffoldBackgroundColor: colorScheme.surface,
    cardColor: _cardColor(colorScheme),
    cardTheme: _createCardTheme(colorScheme),
    dividerColor: dividerColor,
    dialogBackgroundColor: colorScheme.surface,
    textTheme: textTheme,
    indicatorColor: colorScheme.primary,
    applyElevationOverlayColor: colorScheme.isDark,
    buttonTheme: _buttonThemeData,
    outlinedButtonTheme: _createOutlinedButtonTheme(
      colorScheme: colorScheme,
      disabledColor: themeData.disabledColor,
    ),
    elevatedButtonTheme: _createElevatedButtonTheme(
      color: elevatedButtonColor ?? colorScheme.primary,
      colorScheme: colorScheme,
      textColor: elevatedButtonTextColor,
      disabledColor: themeData.disabledColor,
    ),
    filledButtonTheme: _createFilledButtonTheme(
      colorScheme: colorScheme,
      disabledColor: themeData.disabledColor,
    ),
    textButtonTheme: _createTextButtonTheme(
      colorScheme: colorScheme,
      disabledColor: themeData.disabledColor,
    ),
    iconButtonTheme: _createIconButtonTheme(
      colorScheme: colorScheme,
      disabledColor: themeData.disabledColor,
    ),
    menuButtonTheme: _createMenuItemTheme(colorScheme, textTheme),
    switchTheme: _createSwitchTheme(colorScheme),
    checkboxTheme: _createCheckBoxTheme(colorScheme),
    radioTheme: _createRadioTheme(colorScheme),
    primaryColorDark: colorScheme.isDark ? colorScheme.primary : null,
    appBarTheme: _createAppBarTheme(colorScheme),
    floatingActionButtonTheme:
        _createFloatingActionButtonTheme(colorScheme, elevatedButtonColor),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurface.withOpacity(0.8),
    ),
    inputDecorationTheme: _createInputDecorationTheme(colorScheme),
    toggleButtonsTheme: _createToggleButtonsTheme(colorScheme),
    textSelectionTheme: _createTextSelectionTheme(colorScheme),
    dropdownMenuTheme: _createDropdownMenuTheme(colorScheme),
    menuTheme: _createMenuTheme(colorScheme),
    popupMenuTheme: _createPopupMenuTheme(colorScheme),
    tooltipTheme: _tooltipThemeData,
    bottomAppBarTheme: BottomAppBarTheme(color: colorScheme.surface),
    navigationBarTheme: _createNavigationBarTheme(colorScheme),
    navigationRailTheme: _createNavigationRailTheme(colorScheme),
    dividerTheme:
        DividerThemeData(color: dividerColor, space: 1.0, thickness: 0.0),
    badgeTheme: BadgeThemeData(
      backgroundColor: elevatedButtonColor ?? colorScheme.primary,
      textColor: contrastColor(elevatedButtonColor ?? colorScheme.primary),
    ),
    scrollbarTheme: const ScrollbarThemeData(
      mainAxisMargin: 3.0,
      crossAxisMargin: 3.0,
    ),
    splashFactory: NoSplash.splashFactory,
    sliderTheme: _createSliderTheme(colorScheme),
    drawerTheme: _createDrawerTheme(colorScheme),
    listTileTheme: ListTileThemeData(
      iconColor: colorScheme.onSurface.withOpacity(0.8),
    ),
    snackBarTheme: _createSnackBarTheme(colorScheme),
    chipTheme: _createChipTheme(
      selectedColor: elevatedButtonColor ?? colorScheme.primary,
      colorScheme: colorScheme,
    ),
  );
}

CardTheme _createCardTheme(ColorScheme colorScheme) {
  return CardTheme(
    color: _cardColor(colorScheme),
  );
}

Color _cardColor(ColorScheme colorScheme) =>
    colorScheme.surface.scale(lightness: colorScheme.isLight ? -0.05 : 0.05);

/// Helper function to create a new Yaru light theme
ThemeData createYaruLightTheme({
  required Color primaryColor,
  Color? elevatedButtonColor,
  Color? elevatedButtonTextColor,
  bool? useMaterial3 = true,
}) {
  final secondary = primaryColor.scale(lightness: 0.2).cap(saturation: .9);
  final secondaryContainer =
      primaryColor.scale(lightness: 0.85).cap(saturation: .5);
  final tertiary = primaryColor.scale(lightness: 0.5).cap(saturation: .8);
  final tertiaryContainer =
      primaryColor.scale(lightness: 0.75).cap(saturation: .75);

  final colorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    error: YaruColors.light.error,
    onError: Colors.white,
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: contrastColor(primaryColor),
    primaryContainer: YaruColors.porcelain,
    onPrimaryContainer: YaruColors.jet,
    inversePrimary: YaruColors.jet,
    secondary: secondary,
    onSecondary: contrastColor(secondary),
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: contrastColor(secondaryContainer),
    surface: Colors.white,
    surfaceTint: Colors.white,
    onSurface: YaruColors.jet,
    inverseSurface: YaruColors.jet,
    onInverseSurface: YaruColors.porcelain,
    tertiary: tertiary,
    onTertiary: contrastColor(tertiary),
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: contrastColor(tertiaryContainer),
    onSurfaceVariant: YaruColors.coolGrey,
    outline: const Color.fromARGB(255, 221, 221, 221),
    outlineVariant: Colors.black,
    scrim: Colors.black,
  );
  return createYaruTheme(
    colorScheme: colorScheme,
    dividerColor: colorScheme.isHighContrast ? null : kDividerColorLight,
    elevatedButtonColor: elevatedButtonColor,
    elevatedButtonTextColor: elevatedButtonTextColor,
    useMaterial3: useMaterial3,
  );
}

/// Helper function to create a new Yaru dark theme
ThemeData createYaruDarkTheme({
  required Color primaryColor,
  Color? elevatedButtonColor,
  Color? elevatedButtonTextColor,
  bool? useMaterial3 = true,
  bool highContrast = false,
}) {
  final secondary = primaryColor.scale(lightness: -0.3, saturation: -0.15);
  final secondaryContainer = primaryColor
      .scale(lightness: -0.6, saturation: -0.75)
      .capDown(lightness: .175);
  final tertiary = primaryColor.scale(lightness: -0.5, saturation: -0.25);
  final tertiaryContainer = primaryColor
      .scale(lightness: -0.5, saturation: -0.65)
      .capDown(lightness: .2);

  final colorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    error: YaruColors.dark.error,
    onError: Colors.white,
    brightness: Brightness.dark,
    primary: primaryColor,
    primaryContainer: YaruColors.coolGrey,
    onPrimary: contrastColor(primaryColor),
    onPrimaryContainer: YaruColors.porcelain,
    inversePrimary: YaruColors.porcelain,
    secondary: secondary,
    onSecondary: contrastColor(primaryColor.scale(lightness: -0.25)),
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: Colors.white,
    surface: YaruColors.jet,
    surfaceTint: YaruColors.jet,
    onSurface: YaruColors.porcelain,
    inverseSurface: YaruColors.porcelain,
    onInverseSurface: YaruColors.inkstone,
    tertiary: tertiary,
    onTertiary: YaruColors.porcelain,
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: YaruColors.porcelain,
    onSurfaceVariant: YaruColors.warmGrey,
    outline: const Color.fromARGB(255, 68, 68, 68),
    outlineVariant: Colors.white,
    scrim: Colors.black,
  );
  return createYaruTheme(
    colorScheme: colorScheme,
    dividerColor: colorScheme.isHighContrast ? null : kDividerColorDark,
    elevatedButtonColor: elevatedButtonColor,
    elevatedButtonTextColor: elevatedButtonTextColor,
    useMaterial3: useMaterial3,
  );
}
