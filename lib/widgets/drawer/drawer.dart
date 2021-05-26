import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:haumea/screens/contact.dart';
import 'package:haumea/screens/likes.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/app_language.dart';
import '../../helpers/ui.dart';
import '../../screens/about.dart';
import 'language_selector.dart';
import 'mode_selector.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Container(
        width: 200,
        child: Drawer(
            child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(children: [
            Column(children: [
              Container(
                height: 120,
                child: DrawerHeader(
                  child: UI.logo(context),
                ),
              ),
              GestureDetector(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      AppLocalizations.of(context)!.translate('about'),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'DINCondensed'),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => About(appLanguage: appLanguage),
                      ),
                    );
                  }),
              GestureDetector(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      AppLocalizations.of(context)!.translate('contact'),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'DINCondensed'),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Contact(appLanguage: appLanguage),
                      ),
                    );
                  }),
              GestureDetector(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      AppLocalizations.of(context)!.translate('likes'),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'DINCondensed'),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Likes(),
                      ),
                    );
                  }),
            ]),
            Visibility(
                visible: !kReleaseMode,
                child: Positioned(
                  width: 200,
                  bottom: 350,
                  child: InkWell(
                      child: Center(child: Text('clearCache')),
                      onTap: () async {
                        print('Cache cleared');
                        await DefaultCacheManager().emptyCache();
                      }),
                )),
            // Positioned(width: 200, bottom: 250, height: 65, child: TextSelector()),
            Positioned(width: 200, bottom: 240, child: LanguageSelector()),
            Positioned(width: 200, bottom: 150, child: ModeSelector()),
            Positioned(
                bottom: 40,
                child: GestureDetector(
                    child: Column(children: [
                      Container(
                          height: 50,
                          width: 200,
                          child: UI.icon(
                            'assets/icons/instagram.png',
                            context,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(AppLocalizations.of(context)!.translate('follow_us'),
                            style: TextStyle(
                              fontFamily: 'DINCondensed',
                              fontSize: 16,
                            )),
                      ),
                    ]),
                    onTap: () {
                      launch('https://www.instagram.com/haumea.magazine/', forceSafariVC: false);
                    }))
          ]),
        )));
  }
}
