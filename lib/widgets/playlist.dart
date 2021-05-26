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

class Playlist extends StatefulWidget {
  List<int> categories;

  Playlist(Key key, {required this.categories}) : super(key: key);

  @override
  _PostState createState() => _PostState(this.categories);
}

class _PostState extends State<Playlist> with WithPosts {
  ScrollController _controller = ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  late List<bool> selections = [false, false, false, false];

  List<String> categoryKeys = ['alternative', 'electro', 'ambient', 'pop'];
  int timestamp = DateTime.now().millisecondsSinceEpoch;

  ///constructor
  _PostState(categories) {
    this.categories = categories;
    _controller.addListener(() {
      var isEnd = _controller.offset > _controller.position.maxScrollExtent - 10;
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
                                _categorySelect(context),
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
          AppLocalizations.of(context)!.translate('playlists').toUpperCase(),
          style: TextStyle(fontFamily: 'DINCondensed', fontSize: Constants.SIZES["title"], fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  _entry(post) {
    var dateFormat = Provider.of<AppLanguage>(context).appLocal == Locale('fr') ? 'FR_fr' : 'EN_us';
    var categories = Constants.CATEGORIES[this.language]!;
    return FadeAnimation(
      key: Key("post_$post.id_$timestamp"),
      fadeDirection: FadeDirection.none,
      delay: 0,
      duration: 1.0.seconds,
      child: GestureDetector(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 5),
              height: 300,
              width: 300,
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
              width: 300,
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

  _textColor(key) {
    if (selections.where((selected) => selected).isEmpty) {
      return Theme.of(context).accentColor;
    } else
      return selections.isEmpty || selections[this.categoryKeys.indexOf(key)]
          ? Theme.of(context).primaryColor
          : Theme.of(context).accentColor;
  }

  _categorySelect(context) {
    var isFrench = Provider.of<AppLanguage>(context).appLocal == Locale('fr');
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
                  tags = [];
                } else {
                  tags = [];
                  for (var i = 0; i < selections.length; i++) {
                    if (selections.elementAt(i)) {
                      var id = Constants.PLAYLIST_TAGS[categoryKeys.elementAt(i)]![isFrench ? "fr" : "en"];
                      if (id != null) {
                        tags.add(id);
                      }
                    }
                  }
                }
                posts = [];
                page = 0;
                timestamp = DateTime.now().millisecondsSinceEpoch;
                futurePosts = fetchPosts();
              });
            },
          )
        ],
      ),
    );
  }
}
