import 'package:flutter/foundation.dart';

@immutable
class YaruWindowState {
  const YaruWindowState({
    this.active,
    this.closable,
    this.fullscreen,
    this.maximizable,
    this.maximized,
    this.minimizable,
    this.minimized,
    this.restorable,
    this.title,
  });

  final bool? active;
  final bool? closable;
  final bool? fullscreen;
  final bool? maximizable;
  final bool? maximized;
  final bool? minimizable;
  final bool? minimized;
  final bool? restorable;
  final String? title;

  YaruWindowState copyWith({
    bool? active,
    bool? closable,
    bool? fullscreen,
    bool? maximizable,
    bool? maximized,
    bool? minimizable,
    bool? minimized,
    bool? restorable,
    String? title,
  }) {
    return YaruWindowState(
      active: active ?? this.active,
      closable: closable ?? this.closable,
      fullscreen: fullscreen ?? this.fullscreen,
      maximizable: maximizable ?? this.maximizable,
      maximized: maximized ?? this.maximized,
      minimizable: minimizable ?? this.minimizable,
      minimized: minimized ?? this.minimized,
      restorable: restorable ?? this.restorable,
      title: title ?? this.title,
    );
  }

  YaruWindowState merge(YaruWindowState? other) {
    return copyWith(
      active: other?.active,
      closable: other?.closable,
      fullscreen: other?.fullscreen,
      maximizable: other?.maximizable,
      maximized: other?.maximized,
      minimizable: other?.minimizable,
      minimized: other?.minimized,
      restorable: other?.restorable,
      title: other?.title,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YaruWindowState &&
        other.active == active &&
        other.closable == closable &&
        other.fullscreen == fullscreen &&
        other.maximizable == maximizable &&
        other.maximized == maximized &&
        other.minimizable == minimizable &&
        other.minimized == minimized &&
        other.restorable == restorable &&
        other.title == title;
  }

  @override
  int get hashCode {
    return Object.hash(
      active,
      closable,
      fullscreen,
      maximizable,
      maximized,
      minimizable,
      minimized,
      restorable,
      title,
    );
  }

  @override
  String toString() {
    return 'YaruWindowState(active: $active, closable: $closable, fullscreen: $fullscreen, maximizable: $maximizable, maximized: $maximized, minimizable: $minimizable, minimized: $minimized, restorable: $restorable, title: $title)';
  }
}
