import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:haumea/helpers/constants.dart';
import 'package:haumea/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../helpers/ui.dart';
import '../models/page.dart';
import 'detail.dart';

class About extends StatefulWidget {
  var appLanguage;

  About({Key? key, required this.appLanguage}) : super(key: key);

  @override
  _AboutState createState() => _AboutState(appLanguage: this.appLanguage);
}

class _AboutState extends State<About> {
  late Future<WordpressPage> futurePage;
  var appLanguage;

  _AboutState({required this.appLanguage}) {
    futurePage = fetchAbout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: UI.appBar(context, false),
        body: FutureBuilder<WordpressPage>(
            future: futurePage,
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (snapshot.hasData) {
                return InAppWebView(
                    initialData: InAppWebViewInitialData(
                      data: UI.wordpressBody(context, """${snapshot.data!.content}"""),
                    ),
                    initialOptions: InAppWebViewGroupOptions(
                      android: AndroidInAppWebViewOptions(
                        useHybridComposition: true,
                      ),
                      ios: IOSInAppWebViewOptions(
                        allowsInlineMediaPlayback: true,
                      ),
                      crossPlatform: InAppWebViewOptions(
                          useShouldOverrideUrlLoading: true,
                          // set this to true if you are using window.open to open a new window with JavaScript
                          javaScriptCanOpenWindowsAutomatically: true),
                    ),
                    shouldOverrideUrlLoading: (controller, navigation) async {
                      var url = navigation.request.url;
                      if (url.toString().contains('about:blank')) {
                        return NavigationActionPolicy.ALLOW;
                      } else if (url!.host.contains('haumeamagazine')) {
                        var slug = url.pathSegments[url.pathSegments.length - 2];
                        var post = await PostModel.getFromSlug(slug);
                        if (post != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(post: post),
                            ),
                          );
                        } else {
                          launch(url.toString());
                          return NavigationActionPolicy.CANCEL;
                        }
                        return NavigationActionPolicy.CANCEL;
                      } else {
                        launch(url.toString());
                        return NavigationActionPolicy.CANCEL;
                      }
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future<WordpressPage> fetchAbout() async {
    final slug = appLanguage.appLocal == Locale('fr') ? "a-propos-app" : "about-app";
    final response = await http.Client().get(Uri.parse("${Constants.HAUMEA_URL}/wp-json/wp/v2/pages?slug=${slug}"));

    final page = WordpressPage.parse(response.body)[0];
    return page;
  }
}
