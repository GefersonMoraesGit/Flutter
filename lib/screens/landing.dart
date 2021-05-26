import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:haumea/helpers/app_language.dart';
import 'package:haumea/helpers/constants.dart';
import 'package:haumea/widgets/landing/headlines.dart';
import 'package:haumea/widgets/landing/latest_post.dart';
import 'package:haumea/widgets/landing/newsletter.dart';
import 'package:haumea/widgets/landing/playlists.dart';
import 'package:haumea/widgets/landing/social_links.dart';
import 'package:haumea/widgets/landing/type_selector.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    var isFrench = Provider.of<AppLanguage>(context).appLocal == Locale('fr');
    var categoryID = Constants.HEADLINES_CATEGORY[isFrench ? 'fr' : 'en']!;
    var widgets = [
      Headlines(
        titleKey: 'headlines',
        categoryID: categoryID,
      ),
      LatestPost(titleKey: "latest"),
      Newsletter(),
      SizedBox(
        height: 10,
      ),
      LatestPost(titleKey: "news", seeMoreIndex: 1),
      LatestPost(titleKey: "reviews", seeMoreIndex: 2),
      TypeSelector(),
      SizedBox(
        height: 30,
      ),
      Playlists(titleKey: "playlists", seeMoreIndex: 5),
      // LatestPost(titleKey: "playlists", playlist: true, seeMoreIndex: 5, seeMoreSize: 120.0),
      SizedBox(
        height: 20,
      ),
      LatestPost(titleKey: "interviews", seeMoreIndex: 3),
      LatestPost(titleKey: "reports", seeMoreIndex: 4),
      SocialLinks(),
    ];
    return Stack(children: [
      RefreshIndicator(
          onRefresh: () async {
            await DefaultCacheManager().emptyCache();
            setState(() {
              print('Cache cleared');
            });
          },
          child: ListView.builder(
              itemCount: widgets.length,
              itemBuilder: (BuildContext context, int index) {
                return widgets[index];
              }))
    ]);
  }
}
