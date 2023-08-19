import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

const _lorem =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

class BannerPage extends StatelessWidget {
  const BannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        mainAxisExtent: 200,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        maxCrossAxisExtent: 550,
      ),
      children: [
        for (int i = 0; i < 20; i++)
          YaruWatermark(
            watermark: const Icon(
              Icons.cloud,
              size: 100,
            ),
            child: _Banner(i: i),
          ),
      ],
    );
  }
}

class _Banner extends StatefulWidget {
  const _Banner({
    Key? key,
    required this.i,
  }) : super(key: key);

  final int i;

  @override
  State<_Banner> createState() => _BannerState();
}

class _BannerState extends State<_Banner> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    final title = Text('YaruBanner ${widget.i}');
    final description = _hovered
        ? const SizedBox(width: 200, height: 100, child: Text(_lorem))
        : const Text(
            'Description',
            overflow: TextOverflow.ellipsis,
          );
    final thirdLine = _hovered ? null : const Text('Third line');
    final icon = _hovered
        ? null
        : Icon(
            YaruIcons.sun,
            size: 80,
            color: Theme.of(context).primaryColor,
          );

    return YaruBanner.tile(
      onHover: (hovered) => setState(() => _hovered = hovered),
      title: title,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          description,
          if (thirdLine != null) thirdLine,
        ],
      ),
      icon: icon,
      onTap: () => showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.all(10),
          title: YaruDialogTitleBar(
            title: title,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: description,
            ),
          ],
        ),
      ),
      surfaceTintColor: widget.i.isEven ? Colors.pink : null,
    );
  }
}
