import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/yaru_page_container.dart';

class YaruSection extends StatelessWidget {
  const YaruSection({
    Key? key,
    required this.headline,
    required this.children,
    this.width,
    this.headerWidget,
  }) : super(key: key);

  final String headline;
  final List<Widget> children;
  final double? width;
  final Widget? headerWidget;

  @override
  Widget build(BuildContext context) {
    return YaruPageContainer(
        width: width ?? 500,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
            ),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        headline,
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.left,
                      ),
                      headerWidget ?? const SizedBox()
                    ],
                  ),
                ),
              ),
              Column(children: children)
            ],
          ),
        ));
  }
}
