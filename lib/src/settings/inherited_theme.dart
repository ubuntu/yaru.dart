import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:platform_linux/platform.dart';
import 'package:yaru/src/settings/yaru_settings.dart';

import '../../theme.dart';

YaruVariant? _defaultFallBackVariant(Platform platform) {
  if (platform.isBudgie) return YaruVariant.ubuntuBudgieBlue;
  if (platform.isCinnamon) return YaruVariant.ubuntuCinnamonBrown;
  if (platform.isGNOME) return YaruVariant.orange;
  if (platform.isKDE) return YaruVariant.kubuntuBlue;
  if (platform.isLXQt) return YaruVariant.lubuntuBlue;
  if (platform.isMATE) return YaruVariant.ubuntuMateGreen;
  if (platform.isUnity) return YaruVariant.ubuntuUnityPurple;
  if (platform.isXfce) return YaruVariant.xubuntuBlue;
  return null;
}

/// Applies Yaru theme to descendant widgets.
///
/// Descendant widgets obtain the current theme's [YaruThemeData] object using
/// [YaruTheme.of]. When a widget uses [YaruTheme.of], it is automatically
/// rebuilt if the theme later changes, so that the changes can be applied.
///
/// There are two ways to use [YaruTheme] - with a child widget or as a builder.
///
/// ### Child widget
///
/// The simplest way to use [YaruTheme] is to wrap a child widget in it.
///
/// ```dart
/// MaterialApp(
///   home: YaruTheme(
///     child: ...
///   ),
/// )
/// ```
///
/// **Note**: [YaruTheme] must be a _descendant_ of [MaterialApp] to avoid that
/// [MaterialApp] overrides [YaruTheme].
///
/// When used like this, [YaruTheme] internally creates an [AnimatedTheme]
/// widget populated with the appropriate Yaru theme data. Moreover, The child
/// widget gets automatically rebuilt whenever the system theme changes.
///
/// ### Builder
///
/// An alternative way to use [YaruTheme] is to use it as a builder.
///
/// ```dart
/// YaruTheme(
///   builder: (context, yaru, child) {
///     return MaterialApp(
///       theme: yaru.theme,
///       darkTheme: yaru.darkTheme,
///       home: ...
///     );
///   },
/// )
/// ```
///
/// When used like this, [YaruTheme] does not create an [AnimatedTheme] widget.
/// Instead, it passes a [YaruThemeData] object to the [builder] function to
/// allow passing the desired values to [MaterialApp]. This has the advantage
/// that any widget created by [MaterialApp], such as the built-in [Navigator],
/// gains Yaru-theme as well.
///
/// ### Theme data overrides
///
/// The [data] property can be used to override parts of the default theme data.
/// For example, the following code overrides the default page transitions and
/// visual density:
///
/// ```dart
/// YaruTheme(
///   data: YaruThemeData(
///    pageTransitionsTheme: PageTransitionsTheme(/*...*/),
///    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
///  ),
///   builder: (context, yaru, child) {
///     return MaterialApp(
///       theme: yaru.theme,
///       darkTheme: yaru.darkTheme,
///       home: ...
///     );
///   },
/// )
/// ```
///
/// See also:
///  * [YaruThemeData]
class YaruTheme extends StatefulWidget {
  /// Applies the given theme [data] to [child].
  ///
  /// The [data] and [child] arguments must not be null.
  const YaruTheme({
    super.key,
    this.builder,
    this.child,
    this.data = const YaruThemeData(),
    @visibleForTesting Platform? platform,
    @visibleForTesting YaruSettings? settings,
  }) : assert(
         builder != null || child != null,
         'Either builder or child must be provided',
       ),
       _platform = platform ?? const LocalPlatform(),
       _settings = settings;

  /// Builds the widget below this widget in the tree.
  final ValueWidgetBuilder<YaruThemeData>? builder;

  /// The widget below this widget in the tree.
  final Widget? child;

  /// Specifies the theme for descendant widgets.
  final YaruThemeData data;

  final Platform _platform;
  final YaruSettings? _settings;

  /// The data from the closest [YaruTheme] instance that encloses the given
  /// context.
  static YaruThemeData of(BuildContext context) => maybeOf(context)!;

  /// An optional data from the closest [YaruTheme] instance that encloses the
  /// given context or `null` if there is no such ancestor.
  static YaruThemeData? maybeOf(BuildContext context) {
    final theme = context
        .dependOnInheritedWidgetOfExactType<_YaruInheritedTheme>();
    return theme?.data;
  }

  @override
  State<YaruTheme> createState() => _YaruThemeState();
}

class _YaruThemeState extends State<YaruTheme> {
  YaruVariant? _variant;
  YaruSettings? _settings;
  StreamSubscription<String?>? _themeNameSubscription;
  StreamSubscription<String?>? _accentColorSubScription;
  StreamSubscription<bool?>? _statusShapesSubscription;

  bool? _statusShapes;

  @override
  void initState() {
    super.initState();
    if (widget.data.variant == null && canDetectVariant()) {
      _settings = widget._settings ?? YaruSettings();

      _settings?.init();
      _variant =
          resolveAccentColorVariant(_settings?.getAccentColor()) ??
          resolveGtkThemeVariant(_settings?.getThemeName());
      _accentColorSubScription ??= _settings!.accentColorChanged.listen(
        updateVariant,
      );
      _themeNameSubscription ??= _settings!.themeNameChanged.listen(
        updateVariant,
      );
      _statusShapesSubscription ??= _settings!.statusShapesChanged.listen(
        (v) => setState(() {
          _statusShapes = v;
        }),
      );
      _settings?.getStatusShapes();
    }
  }

  @override
  void dispose() {
    _themeNameSubscription?.cancel();
    _accentColorSubScription?.cancel();
    _statusShapesSubscription?.cancel();
    _settings?.dispose();
    super.dispose();
  }

  bool canDetectVariant() {
    return !kIsWeb &&
        widget._platform.isLinux &&
        !widget._platform.environment.containsKey('FLUTTER_TEST');
  }

  // This very simple but manual solution is the safest approach for now
  // New theme mappings can be added here easily, after adding them in variant.dart
  YaruVariant? resolveGtkThemeVariant(String? name) =>
      switch (name?.replaceAll('-dark', '')) {
        'Adwaita' => YaruVariant.adwaitaBlue,
        'Adwaita-green' || 'Yaru-green' => YaruVariant.adwaitaGreen,
        'Adwaita-orange' => YaruVariant.adwaitaOrange,
        'Adwaita-pink' || 'Yaru-pink' => YaruVariant.adwaitaPink,
        'Adwaita-purple' => YaruVariant.adwaitaPurple,
        'Adwaita-red' => YaruVariant.adwaitaRed,
        'Adwaita-slate' || 'Yaru-slate' => YaruVariant.adwaitaSlate,
        'Adwaita-teal' || 'Yaru-teal' => YaruVariant.adwaitaTeal,
        'Adwaita-yellow' || 'Yaru-yellow' => YaruVariant.adwaitaYellow,
        'Yaru' => YaruVariant.orange,
        'Yaru-prussiangreen' => YaruVariant.prussianGreen,
        'Yaru-bark' => YaruVariant.bark,
        'Yaru-blue' => YaruVariant.blue,
        'Yaru-wartybrown' => YaruVariant.wartyBrown,
        'Yaru-magenta' => YaruVariant.magenta,
        'Yaru-olive' => YaruVariant.olive,
        'Yaru-purple' => YaruVariant.purple,
        'Yaru-sage' => YaruVariant.sage,
        'Yaru-red' => YaruVariant.red,
        'Yaru-viridian' => YaruVariant.viridian,
        _ => _defaultFallBackVariant(widget._platform),
      };

  // This is the gnome accent-color feature for Ubuntu 24.10+
  // it is null on older systems.
  // Previous similar Yaru versions replace their gnome counterpart.
  // At some point we probably want to check which distribution of gnome is run and use the
  // upstream colors instead.
  YaruVariant? resolveAccentColorVariant(String? name) => switch (name) {
    'blue' => YaruVariant.blue,
    'teal' || 'Yaru-teal' => YaruVariant.adwaitaTeal,
    'green' || 'Yaru-green' => YaruVariant.adwaitaGreen,
    'yellow' || 'Yaru-yellow' => YaruVariant.adwaitaYellow,
    'orange' => YaruVariant.orange,
    'red' => YaruVariant.red,
    'pink' || 'Yaru-pink' => YaruVariant.magenta,
    'purple' => YaruVariant.purple,
    'slate' || 'Yaru-slate' => YaruVariant.adwaitaSlate,
    'brown' => YaruVariant.wartyBrown,
    _ => null,
  };

  void updateVariant([String? value]) {
    assert(canDetectVariant());
    final gtkThemeName = value ?? _settings?.getThemeName();
    final accentColor = value ?? _settings?.getAccentColor();
    setState(
      () => _variant =
          resolveAccentColorVariant(accentColor) ??
          resolveGtkThemeVariant(gtkThemeName),
    );
  }

  ThemeMode resolveMode() {
    final mode = widget.data.themeMode ?? ThemeMode.system;
    if (mode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light;
    }
    return mode;
  }

  YaruThemeData resolveData() {
    return widget.data.copyWith(
      variant: widget.data.variant ?? _variant,
      highContrast:
          widget.data.highContrast ?? MediaQuery.highContrastOf(context),
      themeMode: resolveMode(),
      statusShapes: _statusShapes,
    );
  }

  ThemeData resolveTheme(YaruThemeData data) {
    final dark = data.themeMode == ThemeMode.dark;

    if (data.highContrast!) {
      return dark ? yaruHighContrastDark : yaruHighContrastLight;
    }

    final variant = data.variant ?? YaruVariant.orange;
    return (dark ? variant.darkTheme : variant.theme).overrideWith(data);
  }

  @override
  Widget build(BuildContext context) {
    if (_settings != null && _themeNameSubscription == null) {
      return const SizedBox.shrink(); // #231
    }
    final data = resolveData();
    return _YaruInheritedTheme(
      data: data,
      child:
          widget.builder?.call(context, data, widget.child) ??
          AnimatedTheme(data: resolveTheme(data), child: widget.child!),
    );
  }
}

@immutable
class YaruThemeData with Diagnosticable {
  const YaruThemeData({
    this.variant,
    this.highContrast,
    this.themeMode,
    this.extensions,
    this.pageTransitionsTheme,
    this.useMaterial3,
    this.visualDensity,
    this.statusShapes,
    this.focusBorders = true,
  });

  /// Specifies the theme variant.
  final YaruVariant? variant;

  /// Whether to use high contrast colors.
  final bool? highContrast;

  /// Whether a light or dark theme is used.
  final ThemeMode? themeMode;

  /// Overrides [ThemeData.extensions].
  final Iterable<ThemeExtension<dynamic>>? extensions;

  /// Overrides [ThemeData.pageTransitionsTheme].
  final PageTransitionsTheme? pageTransitionsTheme;

  /// Overrides [ThemeData.useMaterial3].
  final bool? useMaterial3;

  /// Overrides [ThemeData.visualDensity].
  final VisualDensity? visualDensity;

  final bool? statusShapes;

  /// Whether to draw focus borders.
  final bool? focusBorders;

  /// The light theme of [variant] (or [yaruLight] if not available) merged with
  /// the `YaruThemeData` overrides.
  ThemeData? get theme => (variant?.theme ?? yaruLight).overrideWith(this);

  /// The dark theme of [variant] (or [yaruDark] if not available) merged with
  /// the `YaruThemeData` overrides.
  ThemeData? get darkTheme =>
      (variant?.darkTheme ?? yaruDark).overrideWith(this);

  /// Creates a copy of this [YaruThemeData] with the provided values.
  YaruThemeData copyWith({
    YaruVariant? variant,
    bool? highContrast,
    ThemeMode? themeMode,
    Iterable<ThemeExtension<dynamic>>? extensions,
    PageTransitionsTheme? pageTransitionsTheme,
    bool? useMaterial3,
    VisualDensity? visualDensity,
    bool? statusShapes,
  }) {
    return YaruThemeData(
      variant: variant ?? this.variant,
      highContrast: highContrast ?? this.highContrast,
      themeMode: themeMode ?? this.themeMode,
      extensions: extensions ?? this.extensions,
      pageTransitionsTheme: pageTransitionsTheme ?? this.pageTransitionsTheme,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      visualDensity: visualDensity ?? this.visualDensity,
      statusShapes: statusShapes ?? this.statusShapes,
      focusBorders: focusBorders ?? this.focusBorders,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<YaruVariant>('variant', variant));
    properties.add(DiagnosticsProperty<bool>('highContrast', highContrast));
    properties.add(DiagnosticsProperty<ThemeMode>('themeMode', themeMode));
    properties.add(IterableProperty('extensions', extensions));
    properties.add(
      DiagnosticsProperty('pageTransitionsTheme', pageTransitionsTheme),
    );
    properties.add(DiagnosticsProperty('useMaterial3', useMaterial3));
    properties.add(DiagnosticsProperty('visualDensity', visualDensity));
    properties.add(DiagnosticsProperty<bool>('statusShapes', statusShapes));
    properties.add(DiagnosticsProperty<bool>('focusBorders', focusBorders));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final iterableEquals = const IterableEquality().equals;
    return other is YaruThemeData &&
        other.variant == variant &&
        other.highContrast == highContrast &&
        other.themeMode == themeMode &&
        iterableEquals(other.extensions, extensions) &&
        other.pageTransitionsTheme == pageTransitionsTheme &&
        other.useMaterial3 == useMaterial3 &&
        other.visualDensity == visualDensity &&
        other.statusShapes == statusShapes &&
        other.focusBorders == focusBorders;
  }

  @override
  int get hashCode {
    return Object.hash(
      variant,
      highContrast,
      themeMode,
      extensions,
      pageTransitionsTheme,
      useMaterial3,
      visualDensity,
      statusShapes,
      focusBorders,
    );
  }
}

class _YaruInheritedTheme extends InheritedTheme {
  const _YaruInheritedTheme({required this.data, required super.child});

  final YaruThemeData? data;

  @override
  bool updateShouldNotify(covariant _YaruInheritedTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return _YaruInheritedTheme(data: data, child: child);
  }
}

extension _YaruThemeDataX on ThemeData {
  ThemeData overrideWith(YaruThemeData data) {
    return copyWith(
      extensions: data.extensions,
      pageTransitionsTheme: data.pageTransitionsTheme,
      visualDensity: data.visualDensity,
    );
  }
}
