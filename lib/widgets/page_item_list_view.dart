import 'package:flutter/material.dart';
import 'package:yaru_widgets/widgets/page_item.dart';

const double _kScrollbarThickness = 8.0;
const double _kScrollbarMargin = 2.0;

class PageItemListView extends StatelessWidget {
  const PageItemListView(
      {Key? key,
      required this.pages,
      required this.selectedIndex,
      required this.onTap})
      : super(key: key);

  final List<PageItem> pages;
  final int selectedIndex;
  final Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    final scrollbarThicknessWithTrack =
        _calcScrollbarThicknessWithTrack(context);

    return ListView.separated(
        separatorBuilder: (_, __) => const SizedBox(height: 8.0),
        padding: EdgeInsets.symmetric(
          horizontal: scrollbarThicknessWithTrack,
          vertical: 8.0,
        ),
        controller: ScrollController(),
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              color: index == selectedIndex
                  ? Theme.of(context).colorScheme.onSurface.withOpacity(0.07)
                  : null,
            ),
            child: ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              leading: Icon(
                pages[index].iconData,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
              title: Text(pages[index].title,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).colorScheme.onSurface)),
              selected: index == selectedIndex,
              onTap: () {
                onTap(index);
              },
            ),
          );
        });
  }

  double _calcScrollbarThicknessWithTrack(final BuildContext context) {
    final scrollbarTheme = Theme.of(context).scrollbarTheme;

    var doubleMarginWidth = scrollbarTheme.crossAxisMargin != null
        ? scrollbarTheme.crossAxisMargin! * 2
        : _kScrollbarMargin * 2;

    final scrollBarThumbThikness =
        scrollbarTheme.thickness?.resolve({MaterialState.hovered}) ??
            _kScrollbarThickness;

    return doubleMarginWidth + scrollBarThumbThikness;
  }
}
