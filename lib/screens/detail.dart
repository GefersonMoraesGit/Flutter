import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:haumea/helpers/ui.dart';
import 'package:haumea/models/post.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final PostModel post;

  DetailPage({required this.post});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int progress = 0;
  bool liked = false;

  late List<String> likes;

  @override
  initState() {
    super.initState();
    _loadLike();
  }

  void _loadLike() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      this.likes = prefs.getStringList("likes") ?? [];
      liked = this.likes.contains(widget.post.id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).accentColor == Colors.black;
    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the HomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Center(child: UI.logo(context)),
          actions: <Widget>[
            GestureDetector(
                onTap: () {
                  share(context, widget.post);
                },
                child: Container(
                    width: 40, height: 20, padding: EdgeInsets.only(right: 10, left: 10), child: Icon(Icons.share))),
          ]),
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialData: InAppWebViewInitialData(data: getHTML(context)),
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
                // Link to haumea post
                if (url!.host.contains('haumeamagazine')) {
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
                  if (url.toString().contains('bandcamp.com/EmbeddedPlayer') ||
                      url.toString().contains('open.spotify.com/embed') ||
                      url.toString().contains('soundcloud.com/player') ||
                      url.toString().contains('youtube.com/embed') ||
                      url.toString().contains('about:blank')) {
                    return NavigationActionPolicy.ALLOW;
                  } else {
                    launch(url.toString());
                    return NavigationActionPolicy.CANCEL;
                  }
                }
              },
              onWebViewCreated: (controller) {},
              onProgressChanged: (InAppWebViewController controller, int progress) {
                this.progress = progress;
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 12),
        child: InkWell(
          child: Image.asset(
            liked ? 'assets/icons/heartSelected.png' : 'assets/icons/heartUnselected.png',
            height: 32,
            width: 32,
            fit: BoxFit.contain,
            color: liked ? Colors.red : (isLight ? Colors.black : Colors.white),
          ),
          onTap: () async {
            HapticFeedback.mediumImpact();
            // Unlike
            if (liked) {
              await this.unlike();
            } else {
              await this.like();
            }
            setState(() {
              liked = !liked;
            });
          },
        ),
      ),
    );
  }

  getHTML(context) {
    return UI.wordpressBody(context, """
      <div id="mainPic" style="margin: 0 -15px;"><img style="min-height:235px" src="${widget.post.thumbnail}"></div>
      <div class="fusion-title fusion-title-center fusion-sep-none"><h1 class="title-heading-center fusion-responsive-typography-calculated" style="margin: 0px; --fontSize:54; line-height: 1.16;" data-fontsize="54" data-lineheight="62.64px">${widget.post.title}</h1></div>
      ${widget.post.content.replaceAll(new RegExp(r'loading=\"lazy\"'), '').replaceAll(new RegExp(r'srcset=\".*\"'), '')}
    """);
  }

  share(BuildContext context, PostModel post) {
    final RenderObject? box = context.findRenderObject();
    var unescape = new HtmlUnescape();

    final String text = "${unescape.convert(post.title)} - via Haumea Magazine ${post.link}";
    Share.share(text);
  }

  like() async {
    final prefs = await SharedPreferences.getInstance();
    this.likes.add(widget.post.id.toString());
    prefs.setStringList("likes", this.likes);
  }

  unlike() async {
    final prefs = await SharedPreferences.getInstance();
    this.likes.remove(widget.post.id.toString());
    prefs.setStringList("likes", this.likes);
  }
}
