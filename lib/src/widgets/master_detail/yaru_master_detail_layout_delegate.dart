import 'yaru_master_detail_page.dart';

/// Layout delegate interface which controls a [YaruMasterDetailPage] pane width and resizing capacity.
abstract class YaruMasterDetailPaneLayoutDelegate {
  const YaruMasterDetailPaneLayoutDelegate();

  bool get allowPaneResizing;

  double calculatePaneWidth({
    required double availableWidth,
    required double? candidatePaneWidth,
  });
}

/// Controls a [YaruMasterDetailPage] pane with a fixed width.
class YaruMasterFixedPaneDelegate
    implements YaruMasterDetailPaneLayoutDelegate {
  /// Controls a [YaruMasterDetailPage] pane with a fixed width.
  const YaruMasterFixedPaneDelegate({required this.paneWidth});

  /// Fixed width of the pane.
  final double paneWidth;

  @override
  bool get allowPaneResizing => false;

  @override
  double calculatePaneWidth({
    required double availableWidth,
    required double? candidatePaneWidth,
  }) {
    // Security in case of a very large [paneWidth].
    if (paneWidth > availableWidth / 2) {
      return availableWidth / 2;
    }

    return paneWidth;
  }
}

/// Controls a [YaruMasterDetailPage] pane with a resizable width.
class YaruMasterResizablePaneDelegate
    implements YaruMasterDetailPaneLayoutDelegate {
  /// Controls a [YaruMasterDetailPage] pane with a resizable width.
  const YaruMasterResizablePaneDelegate({
    required this.initialPaneWidth,
    required this.minPaneWidth,
    required this.minPageWidth,
  });

  /// Initial width of a [YaruMasterDetailPage] pane.
  final double initialPaneWidth;

  /// Min width of a [YaruMasterDetailPage] pane.
  /// [minPaneWidth] has priority on this value.
  final double minPaneWidth;

  /// Min width of a [YaruMasterDetailPage] page.
  /// This value has priority on [minPaneWidth].
  final double minPageWidth;

  @override
  bool get allowPaneResizing => true;

  @override
  double calculatePaneWidth({
    required double availableWidth,
    required double? candidatePaneWidth,
  }) {
    final maxWidth = availableWidth - minPageWidth;
    candidatePaneWidth = candidatePaneWidth ?? initialPaneWidth;

    if (candidatePaneWidth >= maxWidth) {
      return maxWidth;
    } else if (candidatePaneWidth < minPaneWidth) {
      return minPaneWidth;
    } else {
      return candidatePaneWidth;
    }
  }
}
