import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:haumea/helpers/app_language.dart';
import 'package:haumea/helpers/constants.dart';
import 'package:haumea/helpers/ui.dart';
import 'package:haumea/models/post.dart';
import 'package:haumea/screens/detail.dart';

class Headlines extends StatefulWidget {
  var titleKey;
  var categoryID;
  var tagID;

  Headlines({Key? key, this.titleKey, this.categoryID, this.tagID}) : super(key: key);

  @override
  _HeadlinesState createState() => _HeadlinesState();
}

class _HeadlinesState extends State<Headlines> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 40, bottom: 10),
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.translate(this.widget.titleKey).toUpperCase(),
              style: TextStyle(
                  fontFamily: 'DINCondensed', fontSize: Constants.SIZES["title"], fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        FutureBuilder<PostModel?>(
            future: PostModel.getFromCategoryOrTag(categoryID: this.widget.categoryID, tagID: this.widget.tagID),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              if (snapshot.hasData) {
                String excerpt = UI.textFromHTML(snapshot.data!.content);
                excerpt = excerpt.split(" ").sublist(0, 25).join(' ') + ' [...]';
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(post: snapshot.data!),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(bottom: 5),
                        height: 250,
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data!.thumbnail,
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
                          child: Text(UI.textFromHTML(snapshot.data!.title),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'DINCondensed',
                                  fontWeight: FontWeight.bold,
                                  fontSize: Constants.SIZES["subtitle"]))),
                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            excerpt,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'georgia'),
                          )),
                    ],
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
        Padding(padding: EdgeInsets.only(top: 10)),
      ],
    );
  }
}
