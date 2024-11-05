import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import 'example_home.dart';
import 'example_model.dart';
import 'pages/icons_page/provider/icon_view_model.dart';

Future<void> main() async {
  await YaruWindowTitleBar.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();
  SemanticsBinding.instance.ensureSemantics();

  di
    ..registerLazySingleton<Connectivity>(Connectivity.new)
    ..registerLazySingleton<IconViewModel>(IconViewModel.new)
    ..registerLazySingleton<ExampleModel>(
      () => ExampleModel(di<Connectivity>()),
      dispose: (m) => m.dispose(),
    );

  await di<ExampleModel>().init();

  runApp(const ExampleHome());
}
