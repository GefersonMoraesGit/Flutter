import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:haumea/helpers/app_language.dart';
import 'package:haumea/helpers/constants.dart';
import 'package:haumea/helpers/ui.dart';
import 'package:haumea/mixins/with_posts.dart';
import 'package:haumea/models/post.dart';
import 'package:haumea/screens/detail.dart';
import 'package:provider/provider.dart';

class LatestPost extends StatefulWidget {
  final titleKey;
  final tagID;
  final skipFirst;
  final seeMoreIndex;
  final double seeMoreSize;

  const LatestPost(
      {Key? key, this.titleKey, this.tagID, this.skipFirst = false, this.seeMoreIndex = -1, this.seeMoreSize = 250})
      : super(key: key);

  @override
  _LatestPostState createState() =>
      _LatestPostState(this.tagID, this.titleKey, this.skipFirst, this.seeMoreIndex, this.seeMoreSize);
}

class _LatestPostState extends State<LatestPost> with WithPosts {
  late String titleKey;

  ///constructor
  _LatestPostState(tagID, titleKey, skipFirst, seeMoreIndex, seeMoreSize) {
    this.titleKey = titleKey;
    this.tagID = tagID ?? 0;
    this.skipFirst = skipFirst;
    this.seeMoreIndex = seeMoreIndex;
    this.seeMoreSize = seeMoreSize;
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
    PageController pageController = PageController(viewportFraction: 0.75);

    var scale = MediaQuery.of(context).textScaleFactor;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 20),
          child: Text(AppLocalizations.of(context)!.translate(this.widget.titleKey).toUpperCase(),
              style: TextStyle(fontSize: Constants.SIZES["title"], fontFamily: 'DINCondensed')),
        ),
        Container(
          height: 250 + 100 * scale,
          child: FutureBuilder<List<Object>>(
              future: futurePosts,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                if (snapshot.hasData) {
                  List<Object> loaded = snapshot.data ?? [];
                  return PageView.builder(
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: loaded.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (loaded[index] is PostModel) {
                          final post = loaded[index] as PostModel;
                          post.categories.removeWhere((element) => !this.categories.contains(element));
                          var title = UI.textFromHTML(post.title);

                          // if (this.widget.playlist != null) {
                          //   RegExp exp = RegExp(r"(.*)(#\d+)(.*)");
                          //   final match = exp.firstMatch(title);
                          //   if (match != null && match.groupCount == 3) {
                          //     final group1 = match.group(1);
                          //     final group2 = match.group(2);
                          //     title = "$group1 $group2".replaceAll('|', '');
                          //   }
                          // }
                          return GestureDetector(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    height: 250,
                                    width: 250,
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
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                                      alignment: Alignment.center,
                                      child: Text(
                                        title,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'DINCondensed', fontWeight: FontWeight.bold, fontSize: 18),
                                      )),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(post: post),
                                ),
                              );
                            },
                          );
                        } else {
                          return loaded[index] as Widget;
                        }
                      });
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ],
    );
  }
}
