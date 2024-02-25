import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class SearchFieldPage extends StatefulWidget {
  const SearchFieldPage({super.key});

  @override
  State<SearchFieldPage> createState() => _SearchFieldPageState();
}

class _SearchFieldPageState extends State<SearchFieldPage> {
  var _titleSearchActive = false;
  var _fieldSearchActive = false;

  String _titleText = 'The text you submitted';
  String _fieldText = 'Or the things you changed';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final light = theme.brightness == Brightness.light;

    return Center(
      child: YaruScrollViewUndershoot.builder(
        builder: (context, controller) {
          return ListView(
            controller: controller,
            children: [
              SimpleDialog(
                shadowColor: light ? Colors.black : null,
                titlePadding: EdgeInsets.zero,
                title: YaruDialogTitleBar(
                  titleSpacing: 0,
                  centerTitle: true,
                  title: YaruSearchTitleField(
                    text: _titleText,
                    onClear: () => setState(() => _titleText = ''),
                    onSubmitted: (value) =>
                        setState(() => _titleText = value ?? ''),
                    searchActive: _titleSearchActive,
                    onSearchActive: () => setState(
                      () => _titleSearchActive = !_titleSearchActive,
                    ),
                    title: const Text(
                      'Any Widget Here',
                    ),
                  ),
                ),
                children: [
                  SizedBox(
                    height: 300,
                    width: 450,
                    child: Center(
                      child: Text(
                        _titleText,
                      ),
                    ),
                  ),
                ],
              ),
              SimpleDialog(
                shadowColor: light ? Colors.black : null,
                titlePadding: EdgeInsets.zero,
                title: YaruDialogTitleBar(
                  heroTag: 'bar2',
                  titleSpacing: 0,
                  centerTitle: true,
                  title: _fieldSearchActive
                      ? YaruSearchField(
                          onClear: () {},
                          onChanged: (value) => setState(
                            () => _fieldText = value,
                          ),
                        )
                      : const Text('Title'),
                  leading: YaruSearchButton(
                    searchActive: _fieldSearchActive,
                    onPressed: () => setState(
                      () => _fieldSearchActive = !_fieldSearchActive,
                    ),
                  ),
                ),
                children: [
                  SizedBox(
                    height: 300,
                    width: 450,
                    child: Center(
                      child: Text(_fieldText),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
