import 'package:flutter/material.dart';

class YaruRow extends StatelessWidget {
  const YaruRow({
    Key? key,
    this.leadingWidget,
    required this.trailingWidget,
    this.description,
    required this.actionWidget,
    this.width,
  }) : super(key: key);

  final Widget? leadingWidget;
  final Widget trailingWidget;
  final String? description;
  final Widget actionWidget;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 500,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (leadingWidget != null) ...[
              leadingWidget!,
              const SizedBox(width: 8)
            ],
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  trailingWidget,
                  if (description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        description!,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                ],
              ),
            ),
            actionWidget,
          ],
        ),
      ),
    );
  }
}
