import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/vs.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';
import 'example_model.dart';
import 'example_page_items.dart';

class CodeSnippedButton extends StatelessWidget {
  const CodeSnippedButton({super.key, required this.pageItem});

  final PageItem pageItem;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ExampleModel>();
    if (pageItem.snippetUrl == null) {
      return const SizedBox.shrink();
    }
    return FloatingActionButton(
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
      tooltip: 'Example snippet',
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      backgroundColor: PopupMenuTheme.of(context).color,
      shape: PopupMenuTheme.of(context).shape,
      child: const Icon(YaruIcons.code),
    );
  }
}

class _CodeDialog extends StatefulWidget {
  const _CodeDialog({required this.pageItem});

  final PageItem pageItem;

  @override
  State<_CodeDialog> createState() => _CodeDialogState();
}

class _CodeDialogState extends State<_CodeDialog> {
  late Future<String> _snippet;

  @override
  void initState() {
    super.initState();
    _snippet = widget.pageItem.snippetUrl?.isNotEmpty == false
        ? Future.value('')
        : context.read<ExampleModel>().getCodeSnippet(
              widget.pageItem.snippetUrl!,
            );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ExampleModel>();

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: YaruDialogTitleBar(
        title: Text(!model.appIsOnline ? 'Offline' : widget.pageItem.title),
        leading: !model.appIsOnline
            ? null
            : Center(
                child: YaruIconButton(
                  icon: const Icon(YaruIcons.copy),
                  tooltip: 'Copy',
                  onPressed: () async {
                    await _snippet.then(
                      (value) => Clipboard.setData(
                        ClipboardData(text: value),
                      ),
                    );
                  },
                ),
              ),
      ),
      contentPadding: EdgeInsets.zero,
      content: !model.appIsOnline
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const YaruAnimatedVectorIcon(YaruAnimatedIcons.no_network),
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
              future: _snippet,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: YaruCircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: HighlightView(
                    snapshot.data!,
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
              },
            ),
    );
  }
}
