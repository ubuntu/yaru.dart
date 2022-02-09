# Flutter Yaru Widgets

[![Pub Package](https://img.shields.io/pub/v/yaru_widgets.svg)](https://pub.dev/packages/yaru_widgets)

Common flutter widgets useful for building desktop and web applications.

![screenshot_dark](https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/.github/images/screenshot_dark.png)

## What is this?

A set of convenient widgets made with `material.dart` to easily build desktop and web applications.

[LIVE DEMO](https://feichtmeier.github.io/)

For example:

- `YaruMasterDetailPage`, for having a UI skeletton that adapts its navigation to the window width, with one layout for a wide/landscape window and one layout for a narrow/portrait window
- `Yaru*Row` widgets, which make it easy to put widgets in a consistent row-container
- `YaruPage`, for creating a scrollable, always-the-same-size container page
- `YaruSection` for putting `Yaru*Row` widgets into a container with a rounded border and a headline
- `YaruTabbedPage`, for creating a tabbed view of `YaruPage`s with sane constraints and looks

## What it ain't

This is not:

- a new design language
- a hard-copy of GNOME's Adwaita

## Why not build on `foundation.dart` and `widgets.dart`?

You may ask why `yaru_widgets.dart` is not built directly upon `foundation.dart` and `widgets.dart` like for example the [Chicago widget library](https://github.com/tvolkert/chicago).
The answer is that `material.dart` brings functionally everything that one needs to build applications. The sometimes polarizing elevation of the material design language can be easily adjusted with a flutter theme. There is simply no need to build a whole new widget library parallel to `material.dart` or `cupertino.dart` if only the visuals should be changed. Using `material.dart` as a base brings stability to your application and you can be sure that basic widgets, containers and constraints "just work".

So `yaru_widgets.dart` uses the completeness and the level of polish `material.dart` has and adds a set of widgets to it that are useful (but not necessarily the only way) to build desktop and web applications so they all have a consistent look and use the same design patterns.

## Recommended themes

Themes inside [`yaru.dart`](https://github.com/ubuntu/yaru.dart) are recommended but all flutter material themes should work.
