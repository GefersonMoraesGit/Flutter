import 'package:flutter/material.dart';
import 'package:haumea/helpers/app_language.dart';
import 'package:haumea/helpers/constants.dart';
import 'package:haumea/helpers/ui.dart';
import 'package:haumea/widgets/landing/headlines.dart';
import 'package:haumea/widgets/landing/latest_post.dart';
import 'package:haumea/widgets/landing/playlists.dart';
import 'package:provider/provider.dart';

class PostByTag extends StatelessWidget {
  final tagKey;
  final tagID;

  const PostByTag({Key? key, this.tagKey, this.tagID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isFrench = Provider.of<AppLanguage>(context).appLocal == Locale('fr');
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the HomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Center(child: UI.logo(context)),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Headlines(titleKey: tagKey, tagID: tagID),
          LatestPost(titleKey: "reviews", tagID: tagID, skipFirst: true),
          Playlists(
              titleKey: "playlists", seeMoreIndex: 5, tagID: Constants.PLAYLIST_TAGS[tagKey]![isFrench ? "fr" : "en"]),
          SizedBox(height: 30)
        ])));
  }
}
