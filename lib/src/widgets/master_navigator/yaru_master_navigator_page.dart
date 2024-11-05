import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class YaruMasterNavigatorObserver extends ChangeNotifier
    implements NavigatorObserver {
  YaruMasterNavigatorObserver({
    required this.getSelectedPageId,
    required this.setSelectedPagerId,
  });

  final String? Function() getSelectedPageId;
  final void Function(String? pageId) setSelectedPagerId;

  @override
  void didPop(Route route, Route? previousRoute) {
    // TODO: implement didPop
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    // TODO: implement didPush
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    // TODO: implement didRemove
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    // TODO: implement didReplace
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    // TODO: implement didStartUserGesture
  }

  @override
  void didStopUserGesture() {
    // TODO: implement didStopUserGesture
  }

  @override
  // TODO: implement navigator
  NavigatorState? get navigator => throw UnimplementedError();
}

class YaruMasterNavigatorObserverProvider extends InheritedWidget {
  const YaruMasterNavigatorObserverProvider({required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    throw UnimplementedError();
  }
}

class YaruMasterNavigatorPage extends StatelessWidget {
  const YaruMasterNavigatorPage({
    super.key,
    required this.paneLayoutDelegate,
  });

  final YaruPanedViewLayoutDelegate paneLayoutDelegate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const YaruMasterNavigatorList(),
      endDrawer: const YaruMasterNavigatorList(),
      resizeToAvoidBottomInset: isMobile,
      body: YaruPanedView(
        pane: const YaruMasterNavigatorList(),
        page: Navigator(
          initialRoute: libraryModel.selectedPageId ?? kSearchPageId,
          onDidRemovePage: (page) {},
          key: libraryModel.masterNavigatorKey,
          observers: [libraryModel],
          onGenerateRoute: (settings) {
            final page = (masterItems.firstWhereOrNull(
                      (e) => e.pageId == settings.name,
                    ) ??
                    masterItems.elementAt(0))
                .pageBuilder(context);

            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_, __, ___) => BackGesture(child: page),
              transitionsBuilder: (_, a, __, c) =>
                  FadeTransition(opacity: a, child: c),
            );
          },
        ),
        layoutDelegate: paneLayoutDelegate,
      ),
    );
  }
}

class YaruMasterNavigatorList extends StatelessWidget {
  const YaruMasterNavigatorList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
