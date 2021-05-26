import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haumea/models/bottom_tab_provider.dart';
import 'package:haumea/widgets/playlist.dart';
import 'package:provider/provider.dart';

import '../helpers/animated_indexed_stack.dart';
import '../helpers/app_language.dart';
import '../helpers/ui.dart';
import '../widgets/drawer/drawer.dart';
import '../widgets/post.dart';
import 'landing.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> postWidgets(BuildContext context) {
    var isFrench = Provider.of<AppLanguage>(context).appLocal == Locale('fr');
    return [
      LandingPage(),
      Post(Key(isFrench ? "news" : "news_en"), categories: isFrench ? [665] : [710], titleKey: "news"),
      Post(Key(isFrench ? "chroniques" : "chroniques_en"), categories: isFrench ? [2] : [51], titleKey: "reviews"),
      Post(Key(isFrench ? "interviews" : "interviews_en"), categories: isFrench ? [4] : [55], titleKey: "interviews"),
      Post(Key(isFrench ? "reportages" : "reportages_en"), categories: isFrench ? [3] : [53], titleKey: "reports"),
      Playlist(
        Key(isFrench ? "playlists" : "playlists_en"),
        categories: isFrench ? [5] : [57],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var navigationProvider = Provider.of<BottomNavigationBarProvider>(context);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: UI.appBar(context, true),
      body: Center(
        child: AnimatedIndexedStack(children: postWidgets(context), index: navigationProvider.currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppLocalizations.of(context)!.translate('home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: AppLocalizations.of(context)!.translate('news'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: AppLocalizations.of(context)!.translate('reviews'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: AppLocalizations.of(context)!.translate('interviews'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: AppLocalizations.of(context)!.translate('reports'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.queue_music),
            label: AppLocalizations.of(context)!.translate('playlists'),
          ),
        ],
        currentIndex: navigationProvider.currentIndex,
        onTap: (index) {
          HapticFeedback.mediumImpact();
          navigationProvider.currentIndex = index;
        },
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: Theme.of(context).accentColor,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
