import 'package:material_ui/material_ui.dart';
import 'package:yaru/yaru.dart';

class AutocompletePage extends StatelessWidget {
  const AutocompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Default menu', style: Theme.of(context).textTheme.titleSmall),
            YaruAutocomplete<String>(
              optionsBuilder: (value) {
                const options = ['foo', 'bar', 'baz', 'qux', 'quux'];
                return options.where(
                  (option) => option.contains(value.text.toLowerCase()),
                );
              },
              onSelected: (value) => _showMessage(context, value),
            ),
            const SizedBox(height: 24),
            Text('Custom menu', style: Theme.of(context).textTheme.titleSmall),
            const Text(
              'The "See all results" option keeps the query in the field but '
              'announces its own label.',
            ),
            YaruAutocomplete<_CustomOption>(
              optionsBuilder: (value) {
                final query = value.text.trim();
                if (query.isEmpty) return const [];

                final matches = _customOptions.where(
                  (option) =>
                      option.name.toLowerCase().contains(query.toLowerCase()),
                );
                return [...matches, _CustomOption(name: '', query: query)];
              },
              displayStringForOption: (option) => option.query ?? option.name,
              optionAnnouncement: (option) => option.announcement,
              optionsViewBuilder: _buildCustomOptions,
              onSelected: (option) => _showMessage(
                context,
                option.query == null
                    ? 'Selected ${option.name}'
                    : 'See all results for ${option.query}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomOptions(
    BuildContext context,
    AutocompleteOnSelected<_CustomOption> onSelected,
    Iterable<_CustomOption> options,
  ) {
    final theme = Theme.of(context);
    final rows = <Widget>[];
    String? previousSection;

    for (final (index, option) in options.indexed) {
      final section = option.section;
      if (section != null && section != previousSection) {
        rows.add(
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 4),
            child: Text(section, style: theme.textTheme.labelSmall),
          ),
        );
      }
      previousSection = section;

      rows.add(
        Builder(
          builder: (context) => ListTile(
            dense: true,
            selected: AutocompleteHighlightedOption.of(context) == index,
            leading: Icon(option.query == null ? Icons.apps : Icons.search),
            title: Text(option.menuLabel),
            onTap: () => onSelected(option),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.topLeft,
      child: YaruBorderContainer(
        width: 320,
        clipBehavior: Clip.antiAlias,
        color: theme.menuTheme.style?.backgroundColor?.resolve({}),
        constraints: const BoxConstraints(maxHeight: 320),
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: rows,
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _CustomOption {
  const _CustomOption({required this.name, this.section, this.query});

  final String name;
  final String? section;
  final String? query;

  String get announcement =>
      query == null ? '$name, $section' : 'See all results for $query';

  String get menuLabel => query == null ? name : 'See all results for "$query"';
}

const _customOptions = [
  _CustomOption(name: 'Option 1', section: 'Group 1'),
  _CustomOption(name: 'Option 2', section: 'Group 1'),
  _CustomOption(name: 'Option 3', section: 'Group 2'),
  _CustomOption(name: 'Option 4', section: 'Group 2'),
];
