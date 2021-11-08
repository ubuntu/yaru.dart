import 'package:flutter/material.dart';

/// A card widget that presents a toggleable option.
///
/// For example:
/// ```dart
/// Row(
///   children: [
///     OptionCard(
///       imageAsset: 'assets/foo.png',
///       titleText: 'Foo',
///       bodyText: 'Description...',
///       selected: model.option == MyOption.foo,
///       onSelected: () => model.option = Option.foo,
///     ),
///     OptionCard(
///       imageAsset: 'assets/bar.png',
///       titleText: 'Bar',
///       bodyText: 'Description...',
///       selected: model.option == MyOption.bar,
///       onSelected: () => model.option = MyOption.bar,
///     ),
///   ],
/// )
/// ```
class YaruOptionCard extends StatefulWidget {
  /// Creates an option card with the given properties.
  const YaruOptionCard({
    Key? key,
    this.imageAsset,
    this.titleText,
    this.bodyText,
    required this.selected,
    required this.onSelected,
    required this.okIconData,
  }) : super(key: key);

  /// An image asset that illustrates the option.
  final String? imageAsset;

  /// A short title below the image.
  final String? titleText;

  /// A longer descriptive body text below the title.
  final String? bodyText;

  /// Whether the option is currently selected.
  final bool selected;

  /// Called when the option is selected.
  final VoidCallback onSelected;

  final IconData okIconData;

  @override
  YaruOptionCardState createState() => YaruOptionCardState();
}

@visibleForTesting
// ignore: public_member_api_docs
class YaruOptionCardState extends State<YaruOptionCard> {
  bool _hovered = false;

  bool get hovered => _hovered; // ignore: public_member_api_docs

  void _setHovered(bool hovered) {
    if (_hovered == hovered) return;
    setState(() => _hovered = hovered);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onSurface.withAlpha(
            widget.selected ? 10 : 0,
          ),
      elevation: 0,
      child: InkWell(
        hoverColor: Theme.of(context).colorScheme.onSurface.withAlpha(7),
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              right: 10,
              child: Icon(
                widget.okIconData,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withAlpha(widget.selected ? 255 : 0),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    flex: 2,
                    child: widget.imageAsset != null
                        ? Image.asset(widget.imageAsset!)
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.titleText ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Text(widget.bodyText ?? ''),
                  ),
                ],
              ),
            ),
          ],
        ),
        onHover: _setHovered,
        onTap: widget.onSelected,
      ),
    );
  }
}
