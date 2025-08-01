import 'package:flutter/material.dart';

import '../constants.dart';

class FontPreviewView extends StatefulWidget {
  const FontPreviewView({super.key});

  @override
  State<FontPreviewView> createState() => _FontPreviewViewState();
}

class _FontPreviewViewState extends State<FontPreviewView> {
  double _fontWeightValue = 400;
  double _fontSize = 32;
  bool _isItalic = false;
  final TextEditingController _controller = TextEditingController(
    text: 'The quick brown fox jumps over the lazy dog',
  );

  FontWeight get _currentFontWeight => FontWeight.lerp(
        FontWeight.w100,
        FontWeight.w800,
        (_fontWeightValue - 100) / 700,
      )!;

  FontStyle get _currentFontStyle => _isItalic ? FontStyle.italic : FontStyle.normal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kWrapSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ubuntu Font Family Preview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'The family supports the full Latin, Cyrillic and Greek alphabets, as well as Esperanto, '
            'with combining diacritical marks and a wide range of punctuation.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Weight:'),
              Expanded(
                child: Slider(
                  min: 100,
                  max: 800,
                  divisions: 7,
                  label: _fontWeightValue.round().toString(),
                  value: _fontWeightValue,
                  onChanged: (value) => setState(() => _fontWeightValue = value),
                ),
              ),
              Text(_fontWeightValue.round().toString()),
            ],
          ),
          Row(
            children: [
              const Text('Size:'),
              Expanded(
                child: Slider(
                  min: 8,
                  max: 72,
                  divisions: 64,
                  label: _fontSize.round().toString(),
                  value: _fontSize,
                  onChanged: (value) => setState(() => _fontSize = value),
                ),
              ),
              Text('${_fontSize.round()} px'),
            ],
          ),
          Row(
            children: [
              const Text('Style:'),
              const SizedBox(width: 16),
              Row(
                children: [
                  Radio<bool>(
                    value: false,
                    groupValue: _isItalic,
                    onChanged: (v) => setState(() => _isItalic = v!),
                  ),
                  const Text('Normal'),
                  Radio<bool>(
                    value: true,
                    groupValue: _isItalic,
                    onChanged: (v) => setState(() => _isItalic = v!),
                  ),
                  const Text('Italic'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _controller,
            style: TextStyle(
              fontFamily: 'UbuntuSans',
              fontWeight: _currentFontWeight,
              fontSize: _fontSize,
              fontStyle: _currentFontStyle,
              package: 'yaru',
            ),
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Preview Text',
            ),
          ),
        ],
      ),
    );
  }
}