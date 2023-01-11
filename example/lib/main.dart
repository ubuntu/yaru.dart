import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:ubuntu_service/ubuntu_service.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import 'example.dart';
import 'theme.dart';

Future<void> main() async {
  await YaruWindowTitleBar.ensureInitialized();

  registerService<Connectivity>(Connectivity.new);
  runApp(
    InheritedYaruVariant(
      child: const Home(),
    ),
  );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruTheme(
      data: YaruThemeData(
        variant: InheritedYaruVariant.of(context),
      ),
      builder: (context, yaru, child) {
        return MaterialApp(
          title: 'Yaru Widgets Factory',
          debugShowCheckedModeBanner: false,
          theme: yaru.theme,
          darkTheme: yaru.darkTheme,
          home: Scaffold(
            appBar: const YaruWindowTitleBar(),
            body: Example.create(context),
          ),
        );
      },
    );
  }
}
