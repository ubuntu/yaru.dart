import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:yaru/yaru.dart';

class FullColorIconsPage extends StatefulWidget {
  const FullColorIconsPage({super.key});

  @override
  State<FullColorIconsPage> createState() => _FullColorIconsPageState();
}

class _FullColorIconsPageState extends State<FullColorIconsPage>
    with SingleTickerProviderStateMixin {
  late Map<String, Future<List<String>>> _iconUrls;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: iconDirsToIconNames.length, vsync: this);
    _iconUrls = iconDirsToIconNames
        .map((key, value) => MapEntry(key, _fetchIconUrls(key)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kYaruPagePadding),
          child: YaruTabBar(
            tabController: _tabController,
            tabs: iconDirsToIconNames.entries
                .map(
                  (e) => Tab(
                    text: e.key,
                  ),
                )
                .toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _iconUrls.entries.map((e) {
              return FutureBuilder(
                future: e.value,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(kYaruPagePadding),
                      itemBuilder: (context, index) {
                        return Image.network(
                          snapshot.data!.elementAt(index),
                          filterQuality: FilterQuality.medium,
                        );
                      },
                      itemCount: snapshot.data!.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 100,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 100,
                      ),
                    );
                  }
                  return const Center(child: YaruCircularProgressIndicator());
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future<List<String>> _fetchIconUrls(String iconSubDir) async {
    return iconDirsToIconNames[iconSubDir]
            ?.map((e) => p.join(_urlPrefix, iconSubDir, e) + _urlSuffix)
            .toList() ??
        [];
  }
}

const iconDirsToIconNames = <String, Set<String>>{
  'actions': {},
  'apps': {
    'accessories-character-map',
    'accessories-dictionary',
    'accessories-text-editor',
    'address-book-app',
    'applications-multimedia',
    'applications-office',
    'backups-app',
    'bluetooth',
    'calculator-app',
    'calendar-app',
    'camera-app',
    'clock-app',
    'configurator-app',
    'disk-usage-app',
    'disk-utility-app',
    'documents-app',
    'docviewer-app',
    'ebook-reader-app',
    'error-app',
    'evince',
    'extensions',
    'file-roller',
    'filemanager-app',
    'gallery-app',
    'games-app',
    'gnome-aisleriot',
    'gnome-mahjongg',
    'gnome-mines',
    'gparted',
    'help-app',
    'image-viewer-app',
    'jockey',
    'libreoffice-base',
    'libreoffice-calc',
    'libreoffice-draw',
    'libreoffice-impress',
    'libreoffice-main',
    'libreoffice-math',
    'libreoffice-writer',
    'livepatch',
    'log-viewer-app',
    'mail-app',
    'maps-app',
    'mediaplayer-app',
    'messaging-app',
    'music-app',
    'notes-app',
    'nvidia-settings',
    'org.gnome.Calls',
    'org.gnome.Software.Create',
    'org.gnome.Software.Socialize',
    'org.gnome.Software',
    'org.gnome.SoundRecorder',
    'org.gnome.TextEditor',
    'packages-app',
    'passwords-app',
    'podcasts-app',
    'power-statistics',
    'quadrapassel',
    'rhythmbox',
    'root-terminal-app',
    'scanner',
    'screenshot-app',
    'session-properties',
    'shotwell',
    'snap-store',
    'software-properties',
    'software-store',
    'software-updater',
    'sudoku-app',
    'synaptic',
    'system-monitor-app',
    'system-settings',
    'terminal-app',
    'to-do-app',
    'transmission',
    'tweaks-app',
    'ubiquity',
    'usage-app',
    'usb-creator-gtk',
    'weather-app',
    'webbrowser-app',
    'wine',
    'winetricks',
    'workspace-switcher-left-bottom',
    'workspace-switcher-left-top',
    'workspace-switcher-right-bottom',
    'workspace-switcher-right-top',
  },
  'categories': {},
  'devices': {},
  'emblems': {},
  'legacy': {},
  'mimetypes': {},
  'places': {},
  'status': {},
};

const _urlPrefix =
    'https://raw.githubusercontent.com/ubuntu/yaru/master/icons/Yaru/256x256/';
const _urlSuffix = '.png';
