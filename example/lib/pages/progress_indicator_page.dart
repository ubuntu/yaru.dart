import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class ProgressIndicatorPage extends StatelessWidget {
  const ProgressIndicatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruScrollViewUndershoot.builder(
      builder: (context, controller) {
        return ListView(
          controller: controller,
          padding: const EdgeInsets.all(kYaruPagePadding),
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: YaruCircularProgressIndicator(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: YaruCircularProgressIndicator(
                value: .75,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: YaruLinearProgressIndicator(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: YaruLinearProgressIndicator(
                value: .75,
              ),
            ),
          ],
        );
      },
    );
  }
}
