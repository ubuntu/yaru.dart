import 'package:example/src/icon_size_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaru_icons/yaru_icons.dart';

@immutable
class YaruIconTable extends StatelessWidget {
  YaruIconTable({Key? key}) : super(key: key);
  final _iconNames = YaruIcons.all.keys.toList();

  @override
  Widget build(BuildContext context) {
    return Consumer<IconSizeProvider>(
      builder: (context, iconSizeProvider, _) => SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(
              label: const Text('Icon preview'),
            ),
            DataColumn(
              label: const Text('Icon name'),
            ),
            DataColumn(
              label: const Text('Usage'),
            ),
          ],
          dataRowHeight: iconSizeProvider.size + 16,
          rows: [
            for (var i = 0; i < _iconNames.length; i += 2)
              DataRow(
                cells: [
                  DataCell(
                    Icon(
                      YaruIcons.all[_iconNames[i]]!,
                      size: iconSizeProvider.size,
                    ),
                  ),
                  DataCell(
                    SelectableText(
                      _iconNames[i],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  DataCell(
                    SelectableText(
                      'YaruIcons.${_iconNames[i]}',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontFamily: 'Monospace',
                            backgroundColor: Theme.of(context).highlightColor,
                          ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
