import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class PanedPage extends StatelessWidget {
  const PanedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pane = Container(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(.025),
      child: const Center(
        child: Text('pane'),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(),
        Flexible(
          child: YaruPanedView(
            pane: pane,
            page: YaruPanedView(
              pane: pane,
              page: YaruPanedView(
                pane: pane,
                page: YaruPanedView(
                  pane: pane,
                  page: const Center(
                    child: Text('YaruPanedView Inception'),
                  ),
                  layoutDelegate: const YaruResizablePaneDelegate(
                    initialPaneSize: 200,
                    minPaneSize: 25,
                    minPageSize: 25,
                    paneSide: YaruPaneSide.bottom,
                  ),
                ),
                layoutDelegate: const YaruResizablePaneDelegate(
                  initialPaneSize: 200,
                  minPaneSize: 25,
                  minPageSize: 25,
                  paneSide: YaruPaneSide.end,
                ),
              ),
              layoutDelegate: const YaruResizablePaneDelegate(
                initialPaneSize: 200,
                minPaneSize: 25,
                minPageSize: 50,
                paneSide: YaruPaneSide.top,
              ),
            ),
            layoutDelegate: const YaruResizablePaneDelegate(
              initialPaneSize: 200,
              minPaneSize: 25,
              minPageSize: 50,
              paneSide: YaruPaneSide.start,
            ),
          ),
        ),
      ],
    );
  }
}
