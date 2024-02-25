import 'package:flutter/material.dart';

import 'buttons.dart';
import 'chips.dart';
import 'fabs.dart';
import 'progres.dart';
import 'toggleables.dart';

class ControlsView extends StatefulWidget {
  const ControlsView({super.key});

  @override
  State<ControlsView> createState() => _ControlsViewState();
}

class _ControlsViewState extends State<ControlsView>
    with TickerProviderStateMixin {
  late TabController tabController;
  final items = const <(Widget, Widget)>[
    (Tab(text: 'Buttons'), Buttons()),
    (Tab(text: 'Fabs'), Fabs()),
    (Tab(text: 'Toggleables'), Toggleables()),
    (Tab(text: 'Chips'), Chips()),
    (Tab(text: 'Progress'), Progress()),
  ];

  @override
  void initState() {
    tabController = TabController(length: items.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          tabs: items.map((e) => e.$1).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: items
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: e.$2,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
