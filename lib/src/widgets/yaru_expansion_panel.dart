import 'package:flutter/widgets.dart';
import 'package:yaru_widgets/constants.dart';
import 'package:yaru_widgets/widgets.dart';

class YaruExpansionPanel extends StatefulWidget {
  const YaruExpansionPanel({
    super.key,
    required this.children,
    this.borderRadius =
        const BorderRadius.all(Radius.circular(kYaruContainerRadius)),
    required this.headers,
  });

  final List<Widget> children;
  final List<Widget> headers;
  final BorderRadius borderRadius;

  @override
  State<YaruExpansionPanel> createState() => _YaruExpansionPanelState();
}

class _YaruExpansionPanelState extends State<YaruExpansionPanel> {
  late List<bool> _expandedStore;

  @override
  void initState() {
    super.initState();
    _expandedStore =
        List<bool>.generate(widget.children.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.children.length == widget.headers.length);

    return YaruBorderContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int index = 0; index < widget.children.length; index++)
            YaruExpandable(
              isExpanded: _expandedStore[index],
              expandIconPadding: const EdgeInsets.only(top: 10, right: 10),
              onChange: (_) {
                setState(() {
                  _expandedStore[index] = !_expandedStore[index];

                  for (var n = 0; n < _expandedStore.length; n++) {
                    if (n != index && _expandedStore[index] == true) {
                      _expandedStore[n] = false;
                    }
                  }
                });
              },
              header: widget.headers[index],
              child: widget.children[index],
            )
        ],
      ),
    );
  }
}
