import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';

import 'src/example.dart';
import 'src/provider/icon_size_provider.dart';
import 'src/provider/search_provider.dart';

void main() {
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
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => IconViewProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => SearchProvider(),
            ),
          ],
          builder: (context, child) => const Example(),
        ),
      ),
    );
  }
}
