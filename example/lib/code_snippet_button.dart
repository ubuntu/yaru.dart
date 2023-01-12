import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/vs.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:provider/provider.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'example_model.dart';
import 'example_page_items.dart';

class CodeSnippedButton extends StatelessWidget {
  const CodeSnippedButton({super.key, required this.pageItem});

  final PageItem pageItem;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ExampleModel>();
    if (pageItem.snippetUrl == null) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Center(
        child: YaruIconButton(
          onPressed: () => showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return ChangeNotifierProvider.value(
                value: model,
                child: _CodeDialog(
                  pageItem: pageItem,
                ),
              );
            },
          ),
          icon: const Icon(YaruIcons.code),
          tooltip: 'Example snippet',
        ),
      ),
    );
  }
}

class _CodeDialog extends StatelessWidget {
  // ignore: unused_element
  const _CodeDialog({super.key, required this.pageItem});

  final PageItem pageItem;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ExampleModel>();

    var snippet = '';

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: YaruDialogTitleBar(
        title: Text(!model.appIsOnline ? 'Offline' : pageItem.title),
        leading: !model.appIsOnline
            ? null
            : Center(
                child: YaruIconButton(
                  icon: const Icon(YaruIcons.copy),
                  tooltip: 'Copy',
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: snippet),
                    );
                  },
                ),
              ),
      ),
      contentPadding: const EdgeInsets.only(top: 10, bottom: 10),
      content: !model.appIsOnline
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  YaruAnimatedNoNetworkIcon(
                    size: 200,
                    color: Theme.of(context).errorColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kYaruPagePadding,
                    ),
                    child: Text(
                      'Sorry, you are offline!\nCould not fetch the source code our GitHub repository.',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : FutureBuilder<String>(
              future: model.getCodeSnippet(
                pageItem.snippetUrl ?? '',
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: YaruCircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  );
                }

                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return const Center(
                      child: YaruCircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    );
                  case ConnectionState.done:
                    snippet = snapshot.data!;
                    return SingleChildScrollView(
                      child: HighlightView(
                        snippet,
                        language: 'dart',
                        theme: Theme.of(context).brightness == Brightness.dark
                            ? vs2015Theme
                            : vsTheme,
                        padding: const EdgeInsets.all(12),
                        textStyle: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    );
                }
              },
            ),
    );
  }
}
