import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:haumea/helpers/app_language.dart';
import 'package:haumea/helpers/constants.dart';
import 'package:haumea/mixins/with_posts.dart';
import 'package:haumea/models/post.dart';
import 'package:haumea/screens/detail.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

import '../helpers/ui.dart';
import 'FadeAnimation.dart';

class Post extends StatefulWidget {
  List<int> categories;
  String titleKey;

  Post(Key key, {required this.categories, required this.titleKey}) : super(key: key);

  @override
  _PostState createState() => _PostState(this.categories);
}

class _PostState extends State<Post> with WithPosts {
  ScrollController _controller = ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  ///constructor
  _PostState(categories) {
    this.categories = categories;
    this.perPage = 10;
    _controller.addListener(() {
      var isEnd = _controller.offset > _controller.position.maxScrollExtent - 600;
      if (isEnd && !isLoading && !noMoreEntries)
        setState(() {
          page = page + 1;
          futurePosts = fetchPosts();
        });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var isFrench = Provider.of<AppLanguage>(context).appLocal == Locale('fr');
    this.language = isFrench ? 'fr' : 'en';
    futurePosts = fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    var dateFormat = Provider.of<AppLanguage>(context).appLocal == Locale('fr') ? 'FR_fr' : 'EN_us';
    var categories = Constants.CATEGORIES[this.language]!;
    var allKeys = categories.keys.toList();

    return FutureBuilder<List<Object>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.hasData) {
            List<Object> loaded = snapshot.data ?? [];
            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      page = 0;
                      futurePosts = fetchPosts();
                    });
                  },
                  child: ListView.builder(
                      itemCount: loaded.length,
                      controller: _controller,
                      itemBuilder: (BuildContext context, int index) {
                        if (loaded[index] is PostModel) {
                          final post = loaded[index] as PostModel;
                          post.categories.removeWhere((element) => !allKeys.contains(element));
                          if (index == 0) {
                            return Column(
                              children: [
                                _title(),
                                _entry(post),
                              ],
                            );
                          } else {
                            return _entry(post);
                          }
                        } else {
                          return loaded[index] as Widget;
                        }
                      }),
                ),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  _title() {
    return Container(
      padding: EdgeInsets.only(top: 40, bottom: 18),
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.translate(this.widget.titleKey).toUpperCase(),
          style: TextStyle(fontFamily: 'DINCondensed', fontSize: Constants.SIZES["title"], fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  _entry(post) {
    var dateFormat = Provider.of<AppLanguage>(context).appLocal == Locale('fr') ? 'FR_fr' : 'EN_us';
    var categories = Constants.CATEGORIES[this.language]!;
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
                this.widget.key!.toString().contains('home')
                    ? Text(AppLocalizations.of(context)!.translate(categories[post.categories[0]]!),
                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12))
                    : Text(''),
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
          );
        },
      ),
    );
  }
}
