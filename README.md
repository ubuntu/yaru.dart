# The official Flutter Yaru Theme and Widgets Suite

[![Pub Package](https://img.shields.io/pub/v/yaru.svg)](https://pub.dev/packages/yaru)


This repository and package contains:

- flutter widgets useful for building desktop and web applications, following but also expanding the yaru theme for the gnome desktop in Ubuntu 22.04+.
- a theme for widgets from material.dart and from this repository
- a complete icon set for flutter apps following the yaru design language

[LIVE DEMO IN YOUR BROWSER](https://ubuntu.github.io/yaru.dart/)


![screenshot](https://raw.githubusercontent.com/ubuntu/yaru.dart/main/.github/images/screenshot.png)
![screenshot](https://raw.githubusercontent.com/ubuntu/yaru.dart/main/.github/images/icons.png)
![screenshot](https://raw.githubusercontent.com/ubuntu/yaru.dart/main/.github/images/theme.png)


# Contributing

- for everything you need
  - flutter
      ```console
      sudo apt -y install git curl cmake meson make clang libgtk-3-dev pkg-config && mkdir -p ~/development && cd ~/development && git clone https://github.com/flutter/flutter.git -b stable && echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc && source ~/.bashrc
      ```
      or,
    ```console
      sudo snap install flutter --classic && flutter
      ```
  - VsCode

      ```console
      sudo snap install code --classic
      ```
- to work on the icons and then build the font, you need to install the [icon_font_generator](https://github.com/rbcprolabs/icon_font_generator) tool:

    ```console
    dart pub global activate -sgit https://github.com/Jupi007/icon_font_generator.git --git-ref yaru
    ```

- Source SVGs files are located inside `./icons`. The final icon name is determined by **subfolder_name** + **icon_name** (Ex: `icons/mimetype/text-plain.svg` will be named `mimetype_text_plain`).

- After modifying or adding icons, you must run the build script, which will generate the icon font:

    ``` console
    ./build-icons.sh
    ```

    or run

    ```bash
    yaru_icon_font_generator assets/icons assets/yaru_icons.otf --output-class-file=lib/src/yaru_icons.dart -r
    ```

## Contributing new gtk<->Flutter theme mappings

1. Add a new `YaruVariant` in `variant.dart`
2. Add a new mapping into the `resolveVariant` method inside `inherited_theme.dart`

# Copying or Reusing

The theme and widgets are licensed under Mozilla Public License Version 2.0.

The icons have mixed licencing. You are free to copy, redistribute and/or modify aspects of this work under the terms of each licence accordingly (unless otherwise specified).

The icon assets (any and all source .svg files or rendered .ttf font) are licensed under the terms of the Creative Commons Attribution-ShareAlike 4.0 License.

Included scripts are free software licensed under the terms of the GNU General Public License, version 3.
