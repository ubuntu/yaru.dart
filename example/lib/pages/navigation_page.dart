import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kYaruPagePadding),
      child: Center(
        child: OutlinedButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => _PageTwo())),
          child: const Text('next page'),
        ),
      ),
    );
  }
}

class _PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return YaruDetailPage(
      appBar: const YaruWindowTitleBar(
        leading: YaruBackButton(),
        title: Text('Page 2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kYaruPagePadding),
        child: Center(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => _PageThree())),
            child: const Text('next page'),
          ),
        ),
      ),
    );
  }
}

class _PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const YaruDetailPage(
      appBar: YaruWindowTitleBar(
        leading: YaruBackButton(),
        title: Text('Page 3'),
      ),
      body: Padding(
        padding: EdgeInsets.all(kYaruPagePadding),
        child: Center(child: Text('this is the last page')),
      ),
    );
  }
}
