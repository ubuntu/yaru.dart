[![Pub Package](https://img.shields.io/pub/v/yaru.svg)](https://pub.dev/packages/yaru)

[yaru.dart](https://github.com/ubuntu/yaru.dart) implements the Ubuntu [Yaru](https://github.com/ubuntu/yaru) design and [Canonical Vanilla Design](https://vanillaframework.io/) as a [Flutter](https://flutter.dev/) theme for [material.dart](https://api.flutter.dev/flutter/material/material-library.html).

[Test the theme in your browser - HERE](https://ubuntu.github.io/yaru.dart)

![Example app using Yaru light style](https://raw.githubusercontent.com/ubuntu/yaru.dart/main/doc/readme/screenshot_light.png)
![Example app using Yaru dark style](https://raw.githubusercontent.com/ubuntu/yaru.dart/main/doc/readme/screenshot_dark.png)

## Using Yaru
To be able to use this package follow this steps:
1. [Installation](https://pub.dev/packages/yaru/install)
2. Import yaru.dart
   
    ```dart
    import 'package:yaru/yaru.dart';
    ```
3. Create `YaruTheme`
   
    ```dart
    YaruTheme(
      builder: (context, yaru, child) {
        return MaterialApp(
          theme: yaru.theme,
          darkTheme: yaru.darkTheme,
          home: Scaffold(
            appBar: AppBar(
              title: Text('Yaru Theme'),
            ),
            body: Container(),
          ),
        );
      }
    );
    ```

## Variants

Yaru comes in several variants. The `YaruTheme` widget detects the appropriate
flavor and accent color from the system on Linux, and defaults to `YaruVariant.orange`
on other platforms. Applications may choose a specific variant by manually
setting the `variant` propert.

   ```dart
   YaruTheme(
     data: YaruThemeData(
       variant: YaruVariant.red,
     ),
     child: ...
   )
   ```

## Contributing to yaru.dart

We welcome contributions! See the [contribution guide](CONTRIBUTING.md) for more details.
