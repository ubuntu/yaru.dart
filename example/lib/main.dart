import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import 'src/app.dart';

Future<void> main() async {
  await YaruWindowTitleBar.ensureInitialized();
  runApp(_MyApp());
}

class _MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return YaruTheme(
      builder: (context, yaru, child) => MaterialApp(
        title: 'Flutter Yaru Icons Demo',
        debugShowCheckedModeBanner: false,
        theme: yaru.theme,
        darkTheme: yaru.darkTheme,
        home: App.create(
          context: context,
        ),
      ),
    );
  }
}
