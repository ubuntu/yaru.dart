import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class ClipPage extends StatelessWidget {
  const ClipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruScrollViewUndershoot.builder(
      builder: (context, controller) {
        return ListView(
          controller: controller,
          padding: const EdgeInsets.all(kYaruPagePadding),
          children: [
            for (final position in YaruDiagonalClip.values)
              YaruTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  color: Colors.red,
                  child: YaruClip.diagonal(
                    position: position,
                    child: Container(color: Colors.green),
                  ),
                ),
                title: Text(position.toString()),
              ),
          ],
        );
      },
    );
  }
}
