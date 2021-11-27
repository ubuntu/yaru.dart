import 'package:yaru_icons/yaru_icons.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart' as yaru;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Yaru Icons Demo',
      theme: yaru.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const YaruIconsGrid(),
    );
  }
}

class YaruIconsGrid extends StatefulWidget {
  const YaruIconsGrid({Key? key}) : super(key: key);

  @override
  _YaruIconsGridState createState() => _YaruIconsGridState();
}

class _YaruIconsGridState extends State<YaruIconsGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static const _from = 0xf101;
  static const _to = 0xf28b;

  double _iconsSize = 24;
  bool _isMinIconsSize() => _iconsSize <= 16 ? true : false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(YaruIcons.ubuntu_logo, color: yaru.Colors.orange),
        title: Text('Flutter Yaru Icons Demo (${_iconsSize.truncate()}px)'),
        actions: [
          TextButton(
              onPressed: _isMinIconsSize() ? null : _decreaseIconsSize,
              child: Icon(YaruIcons.minus)),
          TextButton(onPressed: _increaseIconsSize, child: Icon(YaruIcons.plus))
        ],
      ),
      body: GridView.extent(
        padding: const EdgeInsets.all(24),
        maxCrossAxisExtent: _iconsSize + 48,
        children: List.generate(_to - _from + 1, (index) {
          final code = index + _from;
          return Column(
            children: [
              Icon(YaruIconsData(code), size: _iconsSize),
              const SizedBox(height: 8),
              Text('ex' + code.toRadixString(16),
                  style: TextStyle(color: Colors.grey[600])),
            ],
          );
        }),
      ),
    );
  }

  void _increaseIconsSize() {
    setState(() {
      _iconsSize += 8;
    });
  }

  void _decreaseIconsSize() {
    setState(() {
      if (!_isMinIconsSize()) {
        _iconsSize -= 8;
      }
    });
  }
}
