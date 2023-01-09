import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class DialogPage extends StatefulWidget {
  const DialogPage({super.key});

  @override
  State<DialogPage> createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  final controller = YaruWindowController(
    state: const YaruWindowState(
      closable: true,
      minimizable: false,
      maximizable: false,
    ),
    close: Navigator.maybePop,
  );

  bool get isCloseable => controller.state!.closable == true;
  set isCloseable(bool value) {
    controller.state = controller.state!.copyWith(closable: value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(kYaruPagePadding),
        child: Column(
          children: [
            YaruTile(
              title: const Text('YaruDialogTitle'),
              trailing: OutlinedButton(
                onPressed: () => showDialog(
                  barrierDismissible: isCloseable,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      actions: [
                        if (!isCloseable)
                          OutlinedButton(
                            onPressed: () => Navigator.maybePop(context),
                            child: Text(
                              'Evil Force-Close',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          )
                      ],
                      titlePadding: EdgeInsets.zero,
                      title: YaruDialogTitleBar(
                        leading: const Center(
                          child: SizedBox.square(
                            dimension: 25,
                            child: YaruCircularProgressIndicator(
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                        title: const Text('The Title'),
                        controller: controller,
                      ),
                      content: SizedBox(
                        height: 100,
                        child: YaruBanner.tile(
                          surfaceTintColor: Colors.pink,
                          title: Text(
                            isCloseable
                                ? 'You can close me'
                                : 'You cannot close me',
                          ),
                          subtitle: Text(
                            isCloseable ? 'Please' : 'No way',
                          ),
                          icon: Text(
                            isCloseable ? '🪟' : '💅',
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                child: const Text('Open dialog'),
              ),
            ),
            YaruTile(
              title: const Text('isCloseable'),
              trailing: YaruSwitch(
                value: isCloseable,
                onChanged: (value) => setState(() => isCloseable = value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
