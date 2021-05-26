import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:haumea/helpers/app_language.dart';
import 'package:haumea/helpers/constants.dart';
import 'package:haumea/models/post.dart';
import 'package:haumea/screens/detail.dart';
import 'package:haumea/widgets/FadeAnimation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supercharged/supercharged.dart';

import '../helpers/ui.dart';

class Likes extends StatefulWidget {
  Likes({Key? key}) : super(key: key);

  @override
  _LikesState createState() => _LikesState();
}

class _LikesState extends State<Likes> {
  late Future<List<Object>> futurePosts;
  late List<Object> posts = [];
  late List<Object> allPosts = [];

  late bool isLoading;

  late List<String> postIDs;

  late List<bool> selections;

  late List<String> categoryKeys;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  initState() {
    super.initState();
    selections = [];
    futurePosts = fetchPosts();
  }

  Future<void> _loadLike() async {
    final prefs = await SharedPreferences.getInstance();
    this.postIDs = prefs.getStringList('likes') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: UI.appBar(context, false),
        body: FutureBuilder<List<Object>>(
            future: futurePosts,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              if (snapshot.hasData) {
                List<Object> loaded = snapshot.data ?? [];
                return loaded.length == 0
                    ? Center(
                        child: Text(
                        AppLocalizations.of(context)!.translate('no_likes'),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'DINCondensed'),
                      ))
                    : Stack(
                        children: [
                          ListView.builder(
                              itemCount: loaded.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (loaded[index] is PostModel) {
                                  final post = loaded[index] as PostModel;

                                  if (index == 0) {
                                    return Column(
                                      children: [
                                        _title(),
                                        this.categoryKeys.length > 1
                                            ? _categorySelect(context)
                                            : SizedBox(
                                                height: 0,
                                              ),
                                        _isVisible(post)
                                            ? _entry(post)
                                            : SizedBox(
                                                height: 0,
                                              ),
                                      ],
                                    );
                                  } else {
                                    return _isVisible(post)
                                        ? _entry(post)
                                        : SizedBox(
                                            height: 0,
                                          );
                                  }
                                } else {
                                  return loaded[index] as Widget;
                                }
                              }),
                        ],
                      );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future<List<Object>> fetchPosts() async {
    isLoading = true;
    await _loadLike();
    if (postIDs.length > 0) {
      posts.add(UI.loader());
      var key = postIDs.join('-');
      var urlParams = postIDs.map((id) => "include[]=${id}").toList();
      var url = "${Constants.HAUMEA_URL}/wp-json/wp/v2/posts?_embed&order=desc&${urlParams.join('&')}";

      var body;
      // Check cache
      var fileInfo = await DefaultCacheManager().getFileFromCache(key);

      // Load cache
      if (fileInfo != null) {
        print("Use cache $key for $url");
        var cacheContent = await fileInfo.file.readAsString();
        body = jsonDecode(cacheContent);
        // setState(() {
        //   futurePosts = updatePosts(cacheContent);
        // });
      } else {
        print("Load and cache $url key $key");
        // Load and cache url
        var file;
        try {
          file = await DefaultCacheManager().getSingleFile(url, key: key);
          body = jsonDecode(await file.readAsString());
        } catch (e) {
          body = [];
        }
      }
      posts.removeLast();
      if (body is List && body.length > 0) {
        posts.addAll(PostModel.parsePosts(body));
      }
      isLoading = false;
    }
    this.categoryKeys = posts.map((post) => (post as PostModel).categoryKey).toSet().toList();

    return posts;
  }

  _isVisible(PostModel post) {
    return selections.isEmpty ||
        selections.where((selected) => selected).isEmpty ||
        selections.elementAt(categoryKeys.indexOf(post.categoryKey));
  }

  _title() {
    return Container(
      padding: EdgeInsets.only(top: 40, bottom: 18),
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.translate('likes').toUpperCase(),
          style: TextStyle(fontFamily: 'DINCondensed', fontSize: Constants.SIZES["title"], fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  _textColor(key) {
    if (selections.where((selected) => selected).isEmpty) {
      return Theme.of(context).accentColor;
    } else
      return selections.isEmpty || selections[this.categoryKeys.indexOf(key)]
          ? Theme.of(context).primaryColor
          : Theme.of(context).accentColor;
  }

  _categorySelect(context) {
    var width = MediaQuery.of(context).size.width;

    var buttons = this
        .categoryKeys
        .map((key) => Container(
            padding: EdgeInsets.symmetric(horizontal: width < 400 ? 8 : 10),
            child: Text(AppLocalizations.of(context)!.translate(key),
                style: TextStyle(
                  fontSize: width < 400 ? 12 : 14,
                  color: _textColor(key),
                ))))
        .toList();
    if (selections.isEmpty) {
      selections = List.generate(buttons.length, (index) => false);
    }
    return Container(
      padding: EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ToggleButtons(
            children: buttons,
            isSelected: selections,
            fillColor: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(50.0),
            onPressed: (int index) {
              setState(() {
                selections[index] = !selections[index];
                // If all is unselected; show all
                if (selections.where((selected) => selected).isEmpty) {
                  futurePosts = Future<List<Object>>.value(posts);
                } else {
                  futurePosts = Future<List<Object>>.value(this
                      .posts
                      .where((post) => selections[this.categoryKeys.indexOf((post as PostModel).categoryKey)])
                      .toList());
                }
              });
            },
          )
        ],
      ),
    );
  }

  _entry(post) {
    var dateFormat = Provider.of<AppLanguage>(context).appLocal == Locale('fr') ? 'FR_fr' : 'EN_us';
    return FadeAnimation(
      key: Key("post_$post.id"),
      fadeDirection: FadeDirection.none,
      delay: 0,
      duration: 1.0.seconds,
      child: GestureDetector(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 5),
              height: 250,
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
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: Text(UI.textFromHTML(post.title),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'DINCondensed',
                        fontWeight: FontWeight.bold,
                        fontSize: Constants.SIZES["subtitle"]))),
            Container(
              child: Row(children: [
                Spacer(flex: 1),
                Text(DateFormat.yMMMMd(dateFormat).format(DateTime.parse(post.date)),
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, fontFamily: 'georgia')),
              ]),
              padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(post: post),
            ),
          ).then((value) => setState(() {
                // reset post list (in case it changes)
                this.posts = [];
                futurePosts = fetchPosts();
              }));
        },
      ),
    );
  }
}
