import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:haumea/helpers/app_language.dart';
import 'package:haumea/helpers/constants.dart';
import 'package:haumea/mixins/with_posts.dart';
import 'package:haumea/models/post.dart';
import 'package:haumea/screens/detail.dart';
import 'package:provider/provider.dart';
import 'package:quiver/iterables.dart';

class Playlists extends StatefulWidget {
  final titleKey;
  final tagID;
  final skipFirst;
  final seeMoreIndex;
  final double seeMoreSize;

  const Playlists(
      {Key? key, this.titleKey, this.tagID, this.skipFirst = false, this.seeMoreIndex = -1, this.seeMoreSize = 250})
      : super(key: key);

  @override
  _PlaylistsState createState() =>
      _PlaylistsState(this.tagID, this.titleKey, this.skipFirst, this.seeMoreIndex, this.seeMoreSize);
}

class _PlaylistsState extends State<Playlists> with WithPosts {
  late String titleKey;

  ///constructor
  _PlaylistsState(tagID, titleKey, skipFirst, seeMoreIndex, seeMoreSize) {
    this.titleKey = titleKey;
    this.tagID = tagID ?? 0;
    this.skipFirst = skipFirst;
    this.seeMoreIndex = 5;
    this.seeMoreSize = 122;
    this.perPage = 6;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var isFrench = Provider.of<AppLanguage>(context).appLocal == Locale('fr');
    if (this.titleKey == 'latest') {
      var allKeys = Constants.CATEGORIES[isFrench ? 'fr' : 'en']!;
      this.categories = allKeys.keys.toList();
    } else {
      this.categories = [Constants.categoryIdFor(this.titleKey, isFrench ? "fr" : "en")];
    }
    this.language = isFrench ? 'fr' : 'en';
    if (this.posts.length == 0) {
      futurePosts = fetchPosts();
    }
    Provider.of<AppLanguage>(context).addListener(() {
      this.posts = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    var isFrench = Provider.of<AppLanguage>(context).appLocal == Locale('fr');
    this.language = isFrench ? 'fr' : 'en';
    print("Latest ${this.posts.length} ${MediaQuery.of(context).size.width}");
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(AppLocalizations.of(context)!.translate(this.widget.titleKey).toUpperCase(),
              style: TextStyle(fontSize: Constants.SIZES["title"], fontFamily: 'DINCondensed')),
        ),
        Container(
          height: 250,
          child: FutureBuilder<List<Object>>(
              future: futurePosts,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                if (snapshot.hasData) {
                  List<Object> loaded = snapshot.data ?? [];

                  if (loaded[0] is PostModel) {
                    var posts = snapshot.data;
                    // Get first post (larger tile)
                    var main = posts![0];
                    // Then all others will be small time
                    var others = posts.getRange(1, posts.length).toList();
                    var leftPadding = (MediaQuery.of(context).size.width - 250) / 2;
                    var rightPadding = (MediaQuery.of(context).size.width * .75 - 250);
                    var children = [
                      Container(
                        padding: EdgeInsets.only(right: rightPadding, left: leftPadding),
                        width: 250 + rightPadding + leftPadding,
                        child: _getImageTile(main),
                      )
                    ];
                    // Group by 2
                    for (var group in partition(others, 2).toList()) {
                      var subChildren = [];
                      for (var post in group as List) {
                        subChildren.add(Container(
                            padding: EdgeInsets.only(
                                bottom: group.indexOf(post) == 0 ? 3 : 0,
                                top: group.indexOf(post) == 1 ? 3 : 0,
                                right: 10),
                            height: 125,
                            child: post is PostModel ? _getImageTile(post) : post));
                      }
                      children.add(Container(
                          width: MediaQuery.of(context).size.width * 1 / 3,
                          child: Column(children: subChildren.cast<Widget>())));
                    }

                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: children,
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ],
    );
  }

  _getImageTile(post) {
    return InkWell(
        child: CachedNetworkImage(
          imageUrl: post.thumbnail,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(post: post),
            ),
          );
        });
  }
}
