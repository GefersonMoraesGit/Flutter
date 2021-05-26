import 'package:flutter/material.dart';
import 'package:haumea/helpers/app_language.dart';
import 'package:haumea/helpers/constants.dart';
import 'package:haumea/helpers/theme_preference.dart';
import 'package:haumea/helpers/ui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLinks extends StatelessWidget {
  const SocialLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return ColoredBox(
      color: themeNotifier.getOppositeTheme().scaffoldBackgroundColor,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Constants.PADDING),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(AppLocalizations.of(context)!.translate('sociallinks_title').toUpperCase(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: Constants.SIZES['title'],
                      fontFamily: 'DINCondensed')),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  getIcon(
                      context: context,
                      title: 'instagram',
                      icon: 'assets/icons/instagram.png',
                      url: 'https://www.instagram.com/haumea.magazine/',
                      reverse: true),
                  getIcon(
                      context: context,
                      title: 'facebook',
                      icon: 'assets/icons/facebook.png',
                      url: 'https://www.facebook.com/haumeamagazine/',
                      reverse: true),
                  getIcon(
                      context: context,
                      title: 'soundcloud',
                      icon: 'assets/icons/soundcloud.png',
                      url: 'https://soundcloud.com/haumeamagazine',
                      reverse: false),
                  getIcon(
                      context: context,
                      title: 'spotify',
                      icon: 'assets/icons/spotify.png',
                      url: 'https://open.spotify.com/user/fv97azs9r72ey5be7k4uxx0lg?si=Wz0M2k_iTSykCsm5zFpO1Q&nd=1/',
                      reverse: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getIcon({context, title, icon, url, reverse = false}) {
    return InkWell(
      onTap: () {
        launch(url, forceSafariVC: false);
      },
      child: Column(children: [
        Container(
            width: 40,
            height: 40,
            padding: EdgeInsets.only(right: 10, left: 10),
            child: UI.icon(icon, context, reverse: reverse, scale: 2.0)),
        Text(title, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14, fontFamily: 'DINCondensed')),
      ]),
    );
  }
}
