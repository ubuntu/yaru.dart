import 'yaru_master_detail_page.dart';

/// Layout delegate interface which controls [YaruMasterDetailPage] pane width
abstract class YaruMasterDetailLayoutDelegate {
  const YaruMasterDetailLayoutDelegate();

  bool get allowPaneResizing;

  double calculatePaneWidth({
    required double availableWidth,
    required double? candidatePaneWidth,
  });
}

/// Layout delegate which controls [YaruMasterDetailPage] pane with a fixed width
class YaruMasterFixedPaneDelegate implements YaruMasterDetailLayoutDelegate {
  const YaruMasterFixedPaneDelegate({required this.paneWidth});

  final double paneWidth;

  @override
  bool get allowPaneResizing => false;

  @override
  double calculatePaneWidth({
    required double availableWidth,
    required double? candidatePaneWidth,
  }) {
    // Security in case of a very large [paneWidth]
    if (paneWidth > availableWidth / 2) {
      return availableWidth / 2;
    }

    return paneWidth;
  }
}

/// Layout delegate which controls a [YaruMasterDetailPage] pane with a resizable width
class YaruMasterResizablePaneDelegate
    implements YaruMasterDetailLayoutDelegate {
  const YaruMasterResizablePaneDelegate({
    required this.initialPaneWidth,
    required this.minPaneWidth,
    required this.minPageWidth,
  });

  /// Initial width of a [YaruMasterDetailPage] pane
  final double initialPaneWidth;

  /// Min width of a [YaruMasterDetailPage] pane
  /// [minPaneWidth] has priority on this value
  final double minPaneWidth;

  /// Min width of a [YaruMasterDetailPage] page
  /// This value has priority on [minPaneWidth]
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
