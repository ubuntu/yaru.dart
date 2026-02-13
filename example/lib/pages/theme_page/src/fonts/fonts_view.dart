import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class FontsView extends StatefulWidget {
  const FontsView({super.key});

  @override
  State<FontsView> createState() => _FontsViewState();
}

class _FontsViewState extends State<FontsView> {
  bool mono = false;
  bool italic = false;
  bool doWeight = false;
  int weight = FontWeight.normal.value;
  bool doWidth = false;
  int width = 100;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            YaruSwitchButton(
              value: italic,
              onChanged: (value) => setState(() {
                italic = value;
              }),
              title: Text(
                'Italic',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(width: kYaruPagePadding),
            YaruSwitchButton(
              value: mono,
              onChanged: (value) => setState(() {
                mono = value;
              }),
              title: Text(
                'Mono',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'UbuntuSansMono',
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                YaruCheckbox(
                  value: doWeight,
                  onChanged: (value) => setState(() {
                    doWeight = value ?? false;
                  }),
                ),
                Text('Weight $weight'),
                Slider(
                  value: weight.toDouble(),
                  onChanged: doWeight
                      ? (value) => setState(() {
                          weight = value.toInt();
                        })
                      : null,
                  min: FontWeight.values.first.value.toDouble(),
                  max: FontWeight.values.last.value.toDouble(),
                  divisions: FontWeight.values.length - 1,
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            YaruCheckbox(
              value: doWidth,
              onChanged: (value) => setState(() {
                doWidth = value ?? false;
              }),
            ),
            Text('Width $width'),
            Slider(
              value: width.toDouble(),
              onChanged: doWidth
                  ? (value) => setState(() {
                      width = value.toInt();
                    })
                  : null,
              min: 75,
              max: 100,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _FontText(
              text: 'displayLarge',
              textStyle: theme.textTheme.displayLarge,
              italic: italic,
              mono: mono,
              weight: doWeight ? weight : null,
              width: doWidth ? width : null,
            ),
            _FontText(
              text: 'displayMedium',
              textStyle: theme.textTheme.displayMedium,
              italic: italic,
              mono: mono,
              weight: doWeight ? weight : null,
              width: doWidth ? width : null,
            ),
            _FontText(
              text: 'displaySmall',
              textStyle: theme.textTheme.displaySmall,
              italic: italic,
              mono: mono,
              weight: doWeight ? weight : null,
              width: doWidth ? width : null,
            ),
            _FontText(
              text: 'headlineLarge',
              textStyle: theme.textTheme.headlineLarge,
              italic: italic,
              mono: mono,
              weight: doWeight ? weight : null,
              width: doWidth ? width : null,
            ),
            _FontText(
              text: 'headlineMedium',
              textStyle: theme.textTheme.headlineMedium,
              italic: italic,
              mono: mono,
              weight: doWeight ? weight : null,
              width: doWidth ? width : null,
            ),
            _FontText(
              text: 'headlineSmall',
              textStyle: theme.textTheme.headlineSmall,
              italic: italic,
              mono: mono,
              weight: doWeight ? weight : null,
              width: doWidth ? width : null,
            ),
            _FontText(
              text: 'titleLarge',
              textStyle: theme.textTheme.titleLarge,
              italic: italic,
              mono: mono,
              weight: doWeight ? weight : null,
              width: doWidth ? width : null,
            ),
            _FontText(
              text: 'titleMedium',
              textStyle: theme.textTheme.titleMedium,
              italic: italic,
              mono: mono,
              weight: doWeight ? weight : null,
              width: doWidth ? width : null,
            ),
            _FontText(
              text: 'titleSmall',
              textStyle: theme.textTheme.titleSmall,
              italic: italic,
              mono: mono,
              weight: doWeight ? weight : null,
              width: doWidth ? width : null,
            ),
            _FontText(
              text: 'bodyLarge',
              textStyle: theme.textTheme.bodyLarge,
              italic: italic,
              mono: mono,
              weight: doWeight ? weight : null,
              width: doWidth ? width : null,
            ),
            _FontText(
              text: 'bodyMedium',
              textStyle: theme.textTheme.bodyMedium,
              italic: italic,
              mono: mono,
              weight: doWeight ? weight : null,
              width: doWidth ? width : null,
            ),
            _FontText(
              text: 'bodySmall',
              textStyle: theme.textTheme.bodySmall,
              italic: italic,
              mono: mono,
              weight: doWeight ? weight : null,
              width: doWidth ? width : null,
            ),
            _FontText(
              text: 'labelLarge',
              textStyle: theme.textTheme.labelLarge,
              italic: italic,
              mono: mono,
              weight: doWeight ? weight : null,
              width: doWidth ? width : null,
            ),
            _FontText(
              text: 'labelMedium',
              textStyle: theme.textTheme.labelMedium,
              italic: italic,
              mono: mono,
              weight: doWeight ? weight : null,
              width: doWidth ? width : null,
            ),
            _FontText(
              text: 'labelSmall',
              textStyle: theme.textTheme.labelSmall,
              italic: italic,
              mono: mono,
              weight: doWeight ? weight : null,
              width: doWidth ? width : null,
            ),
          ],
        ),
      ],
    );
  }
}

class _FontText extends StatelessWidget {
  const _FontText({
    required this.text,
    required this.textStyle,
    required this.italic,
    required this.mono,
    required this.weight,
    required this.width,
  });

  final String text;
  final TextStyle? textStyle;
  final bool italic;
  final bool mono;
  final int? weight;
  final int? width;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle?.copyWith(
        fontStyle: italic ? FontStyle.italic : null,
        fontFamily: mono ? 'UbuntuSansMono' : null,
        fontWeight: weight != null
            ? FontWeight.values.firstWhereOrNull((w) => w.value == weight)
            : null,
        fontVariations: width != null
            ? [FontVariation.width(width!.toDouble())]
            : null,
      ),
    );
  }
}
