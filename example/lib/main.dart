import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';

import 'example.dart';
import 'theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LightTheme(yaruLight)),
        ChangeNotifierProvider(create: (_) => DarkTheme(yaruDark)),
      ],
      child: const Home(),
    ),
  );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yaru Widgets Factory',
      debugShowCheckedModeBanner: false,
      theme: context.watch<LightTheme>().value,
      darkTheme: context.watch<DarkTheme>().value,
      home: Example.create(context),
    );
  }
}
