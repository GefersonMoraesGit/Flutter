import 'package:flutter/material.dart';
import 'package:haumea/helpers/theme_preference.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_language.dart';

class UI {
  static const ColorFilter invert = ColorFilter.matrix(<double>[
    -1,
    0,
    0,
    0,
    255,
    0,
    -1,
    0,
    0,
    255,
    0,
    0,
    -1,
    0,
    255,
    0,
    0,
    0,
    1,
    0,
  ]);

  static const ColorFilter identity = ColorFilter.matrix(<double>[
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);

  static PreferredSizeWidget appBar(context, withLanguageSelector, {invertColor = false, titleKey = null}) {
    return AppBar(
      // Here we take the value from the HomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Center(
          child: titleKey != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    AppLocalizations.of(context)!.translate(titleKey),
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'DINCondensed'),
                  ),
                )
              : logo(context)),
      actions: <Widget>[
        Row(
          children: [
            Visibility(
              visible: withLanguageSelector,
              replacement: SizedBox(
                width: 60,
              ),
              child: GestureDetector(
                  onTap: () {
                    launch('https://www.instagram.com/haumea.magazine/', forceSafariVC: false);
                  },
                  child: Container(
                      width: 40,
                      height: 20,
                      padding: EdgeInsets.only(right: 10, left: 10),
                      child: UI.icon('assets/icons/instagram.png', context))),
            ),
          ],
        ),
      ],
    );
  }

  static logo(context, {reverse = false}) {
    return Container(
      height: 50,
      child: icon('assets/logo-retina-noir.png', context, reverse: reverse),
    );
  }

  static icon(asset, context, {reverse = false, scale = 1.0}) {
    var isLight = Theme.of(context).accentColor == Colors.black;

    return ColorFiltered(
        colorFilter: isLight ? (reverse ? invert : identity) : (reverse ? identity : invert),
        child: Image.asset(
          asset,
          scale: scale,
        ));
  }

  static Widget loader() {
    return Container(
        child: Padding(padding: EdgeInsets.symmetric(vertical: 50), child: Center(child: CircularProgressIndicator())));
  }

  static hexColor(Color color) {
    return '0x${color.value.toRadixString(16).padLeft(8, '0')}';
  }

  static wordpressBody(context, content) {
    var scale = MediaQuery.of(context).textScaleFactor;
    var isLight = Theme.of(context).accentColor == Colors.black;
    final themeChange = Provider.of<ThemeNotifier>(context);
    // Change text size if force by app settings
    // var textSize = themeChange.getTextSize();
    // print("$textSize $scale");
    // switch (textSize) {
    //   case 1:
    //     scale = 0.8;
    //     break;
    //   case 2:
    //     scale = 1;
    //     break;
    //   case 3:
    //     scale = 1.2;
    //     break;
    // }
    var fontSize = {
      "p": 14 * scale * 1.2,
      "h1": 25 * scale * 1.2,
      "h2": 25 * scale * 1.2,
      "h3": 25 * scale * 1.2,
      "li": 14 * scale * 1.2,
    };
    return """
        <html class="avada-html-layout-wide avada-html-header-position-top avada-has-site-width-percent avada-is-100-percent-template avada-has-site-width-100-percent" lang="fr-FR" prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb#">
        <head>
        	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
        	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        	<meta name="viewport" content="width=device-width, initial-scale=1" />
        	<meta name='robots' content='max-image-preview:large' />

        	<!-- This site is optimized with the Yoast SEO plugin v15.1.1 - https://yoast.com/wordpress/plugins/seo/ -->
        	<title>hauméa selects #3 : plongée dans la nouvelle face de la soul music avec Sebastea, Naomi Cheyanne, Deborah Williams, Santi Forget, Mighloe et RUTHEE. - Hauméa Magazine</title>
        	<meta name="robots" content="index, follow, max-snippet:-1, max-image-preview:large, max-video-preview:-1" />
        	<link rel="canonical" href="https://www.haumeamagazine.com/haumea-selects-3-plongee-dans-la-nouvelle-face-de-la-soul-music-avec-sebastea-naomi-cheyanne-deborah-williams-santi-forget-mighloe-et-ruthee/" />
        	<meta property="og:locale" content="fr_FR" />
        	<meta property="og:locale:alternate" content="en_US" />
        	<meta property="og:type" content="article" />
        	<meta property="og:title" content="hauméa selects #3 : plongée dans la nouvelle face de la soul music avec Sebastea, Naomi Cheyanne, Deborah Williams, Santi Forget, Mighloe et RUTHEE. - Hauméa Magazine" />
        	<meta property="og:description" content="On a tous une idée plus ou moins définie de [&hellip;]" />
        	<meta property="og:url" content="https://www.haumeamagazine.com/haumea-selects-3-plongee-dans-la-nouvelle-face-de-la-soul-music-avec-sebastea-naomi-cheyanne-deborah-williams-santi-forget-mighloe-et-ruthee/" />
        	<meta property="og:site_name" content="Hauméa Magazine" />
        	<meta property="article:published_time" content="2021-04-13T13:00:25+00:00" />
        	<meta property="article:modified_time" content="2021-04-14T08:48:23+00:00" />
        	<meta property="og:image" content="https://www.haumeamagazine.com/wp-content/uploads/2021/04/haumeaselects3.jpg" />
        	<meta property="og:image:width" content="1100" />
        	<meta property="og:image:height" content="600" />
        	<meta name="twitter:card" content="summary_large_image" />
        	<script type="application/ld+json" class="yoast-schema-graph">{"@context":"https://schema.org","@graph":[{"@type":"WebSite","@id":"https://www.haumeamagazine.com/#website","url":"https://www.haumeamagazine.com/","name":"Haum\u00e9a Magazine","description":"haum\u00e9a magazine : toute l&#039;actualit\u00e9 musicale ind\u00e9pendante - news, chroniques, reportages, interviews, playlists et plus encore !","potentialAction":[{"@type":"SearchAction","target":"https://www.haumeamagazine.com/?s={search_term_string}","query-input":"required name=search_term_string"}],"inLanguage":"fr-FR"},{"@type":"ImageObject","@id":"https://www.haumeamagazine.com/haumea-selects-3-plongee-dans-la-nouvelle-face-de-la-soul-music-avec-sebastea-naomi-cheyanne-deborah-williams-santi-forget-mighloe-et-ruthee/#primaryimage","inLanguage":"fr-FR","url":"https://www.haumeamagazine.com/wp-content/uploads/2021/04/haumeaselects3.jpg","width":1100,"height":600},{"@type":"WebPage","@id":"https://www.haumeamagazine.com/haumea-selects-3-plongee-dans-la-nouvelle-face-de-la-soul-music-avec-sebastea-naomi-cheyanne-deborah-williams-santi-forget-mighloe-et-ruthee/#webpage","url":"https://www.haumeamagazine.com/haumea-selects-3-plongee-dans-la-nouvelle-face-de-la-soul-music-avec-sebastea-naomi-cheyanne-deborah-williams-santi-forget-mighloe-et-ruthee/","name":"haum\u00e9a selects #3 : plong\u00e9e dans la nouvelle face de la soul music avec Sebastea, Naomi Cheyanne, Deborah Williams, Santi Forget, Mighloe et RUTHEE. - Haum\u00e9a Magazine","isPartOf":{"@id":"https://www.haumeamagazine.com/#website"},"primaryImageOfPage":{"@id":"https://www.haumeamagazine.com/haumea-selects-3-plongee-dans-la-nouvelle-face-de-la-soul-music-avec-sebastea-naomi-cheyanne-deborah-williams-santi-forget-mighloe-et-ruthee/#primaryimage"},"datePublished":"2021-04-13T13:00:25+00:00","dateModified":"2021-04-14T08:48:23+00:00","author":{"@id":"https://www.haumeamagazine.com/#/schema/person/0b2f94def1a6ed3bbd8ebf28ecc81671"},"inLanguage":"fr-FR","potentialAction":[{"@type":"ReadAction","target":["https://www.haumeamagazine.com/haumea-selects-3-plongee-dans-la-nouvelle-face-de-la-soul-music-avec-sebastea-naomi-cheyanne-deborah-williams-santi-forget-mighloe-et-ruthee/"]}]},{"@type":"Person","@id":"https://www.haumeamagazine.com/#/schema/person/0b2f94def1a6ed3bbd8ebf28ecc81671","name":"Clo\u00e9 Gruhier","image":{"@type":"ImageObject","@id":"https://www.haumeamagazine.com/#personlogo","inLanguage":"fr-FR","url":"https://secure.gravatar.com/avatar/f076b18737384c9b1bec7554dee14cca?s=96&d=mm&r=g","caption":"Clo\u00e9 Gruhier"},"description":"R\u00e9dactrice web depuis plusieurs ann\u00e9es, j'ai une passion prononc\u00e9e pour les musiques \u00e9lectroniques et alternatives. Des envol\u00e9es synth\u00e9tiques de Max Cooper aux m\u00e9lodies et textes introspectifs de Banks, mon radar d\u00e9tecte les nouveaut\u00e9s des sc\u00e8nes ind\u00e9pendantes fran\u00e7aises et internationales, et ce entre deux strat\u00e9gies de communication pour des labels et artistes ind\u00e9pendants !","sameAs":["https://cloesansh.com/","https://www.instagram.com/haumea.magazine/","https://soundcloud.com/haumeamagazine/"]}]}</script>
        	<!-- / Yoast SEO plugin. -->


        <link rel='dns-prefetch' href='//s.w.org' />
        <link rel="alternate" type="application/rss+xml" title="Hauméa Magazine &raquo; Flux" href="https://www.haumeamagazine.com/feed/" />
        <link rel="alternate" type="application/rss+xml" title="Hauméa Magazine &raquo; Flux des commentaires" href="https://www.haumeamagazine.com/comments/feed/" />
        					<link rel="shortcut icon" href="https://www.haumeamagazine.com/wp-content/uploads/2020/11/IMG_4751BAB07474-1-150x150.jpeg" type="image/x-icon" />




        				<link rel="alternate" type="application/rss+xml" title="Hauméa Magazine &raquo; hauméa selects #3 : plongée dans la nouvelle face de la soul music avec Sebastea, Naomi Cheyanne, Deborah Williams, Santi Forget, Mighloe et RUTHEE. Flux des commentaires" href="https://www.haumeamagazine.com/haumea-selects-3-plongee-dans-la-nouvelle-face-de-la-soul-music-avec-sebastea-naomi-cheyanne-deborah-williams-santi-forget-mighloe-et-ruthee/feed/" />

        		<meta property="og:title" content="hauméa selects #3 : plongée dans la nouvelle face de la soul music avec Sebastea, Naomi Cheyanne, Deborah Williams, Santi Forget, Mighloe et RUTHEE."/>
        		<meta property="og:type" content="article"/>
        		<meta property="og:url" content="https://www.haumeamagazine.com/haumea-selects-3-plongee-dans-la-nouvelle-face-de-la-soul-music-avec-sebastea-naomi-cheyanne-deborah-williams-santi-forget-mighloe-et-ruthee/"/>
        		<meta property="og:site_name" content="Hauméa Magazine"/>
        		<meta property="og:description" content="On a tous une idée plus ou moins définie de la musique soul. Sauf que, comme pour beaucoup de genres musicaux, elle se détaille, se dédouble, se diversifie à chaque fois qu&#039;un artiste décide de l&#039;interpréter à sa manière. Si certains s&#039;en rappellent comme un genre musical langoureux, d&#039;autres s&#039;en rappelleront comme un genre engagé ;"/>

        									<meta property="og:image" content="https://www.haumeamagazine.com/wp-content/uploads/2021/04/haumeaselects3.jpg"/>
        									<script type="text/javascript">
        			window._wpemojiSettings = {"baseUrl":"https:\/\/s.w.org\/images\/core\/emoji\/13.0.1\/72x72\/","ext":".png","svgUrl":"https:\/\/s.w.org\/images\/core\/emoji\/13.0.1\/svg\/","svgExt":".svg","source":{"concatemoji":"https:\/\/www.haumeamagazine.com\/wp-includes\/js\/wp-emoji-release.min.js?ver=5.7.1"}};
        			!function(e,a,t){var n,r,o,i=a.createElement("canvas"),p=i.getContext&&i.getContext("2d");function s(e,t){var a=String.fromCharCode;p.clearRect(0,0,i.width,i.height),p.fillText(a.apply(this,e),0,0);e=i.toDataURL();return p.clearRect(0,0,i.width,i.height),p.fillText(a.apply(this,t),0,0),e===i.toDataURL()}function c(e){var t=a.createElement("script");t.src=e,t.defer=t.type="text/javascript",a.getElementsByTagName("head")[0].appendChild(t)}for(o=Array("flag","emoji"),t.supports={everything:!0,everythingExceptFlag:!0},r=0;r<o.length;r++)t.supports[o[r]]=function(e){if(!p||!p.fillText)return!1;switch(p.textBaseline="top",p.font="600 32px Arial",e){case"flag":return s([127987,65039,8205,9895,65039],[127987,65039,8203,9895,65039])?!1:!s([55356,56826,55356,56819],[55356,56826,8203,55356,56819])&&!s([55356,57332,56128,56423,56128,56418,56128,56421,56128,56430,56128,56423,56128,56447],[55356,57332,8203,56128,56423,8203,56128,56418,8203,56128,56421,8203,56128,56430,8203,56128,56423,8203,56128,56447]);case"emoji":return!s([55357,56424,8205,55356,57212],[55357,56424,8203,55356,57212])}return!1}(o[r]),t.supports.everything=t.supports.everything&&t.supports[o[r]],"flag"!==o[r]&&(t.supports.everythingExceptFlag=t.supports.everythingExceptFlag&&t.supports[o[r]]);t.supports.everythingExceptFlag=t.supports.everythingExceptFlag&&!t.supports.flag,t.DOMReady=!1,t.readyCallback=function(){t.DOMReady=!0},t.supports.everything||(n=function(){t.readyCallback()},a.addEventListener?(a.addEventListener("DOMContentLoaded",n,!1),e.addEventListener("load",n,!1)):(e.attachEvent("onload",n),a.attachEvent("onreadystatechange",function(){"complete"===a.readyState&&t.readyCallback()})),(n=t.source||{}).concatemoji?c(n.concatemoji):n.wpemoji&&n.twemoji&&(c(n.twemoji),c(n.wpemoji)))}(window,document,window._wpemojiSettings);
        		</script>
        		<style type="text/css">
            body {
              margin: 0 15px !important;
            }
            p, p span {
              line-height: 18px !important;
              font-size:14px !important;
            }
            h1.fusion-responsive-typography-calculated {
              font-size: 25px !important;
            }
            h3 {
              font-family: 'DIN Condensed Bold';
              font-size: 22px;
              line-height: 20px;
            }
            blockquote p {
                  font-family: georgia !important;
                  font-weight: normal  !important;

            }
            #mainPic img {
              object-fit: cover;
            }
        img.wp-smiley,
        img.emoji {
        	display: inline !important;
        	border: none !important;
        	box-shadow: none !important;
        	height: 1em !important;
        	width: 1em !important;
        	margin: 0 .07em !important;
        	vertical-align: -0.1em !important;
        	background: none !important;
        	padding: 0 !important;
        }
        </style>
        	<link rel='stylesheet' id='wp-block-library-css'  href='https://www.haumeamagazine.com/wp-includes/css/dist/block-library/style.min.css?ver=5.7.1' type='text/css' media='all' />
        <link rel='stylesheet' id='wp-block-library-theme-css'  href='https://www.haumeamagazine.com/wp-includes/css/dist/block-library/theme.min.css?ver=5.7.1' type='text/css' media='all' />
        <link rel='stylesheet' id='socialsnap-styles-css'  href='https://www.haumeamagazine.com/wp-content/plugins/socialsnap/assets/css/socialsnap.css?ver=1.1.15' type='text/css' media='all' />
        <link rel='stylesheet' id='wtr-css-css'  href='https://www.haumeamagazine.com/wp-content/plugins/worth-the-read/css/wtr.css?ver=5.7.1' type='text/css' media='all' />
        <link rel='stylesheet' id='avada-stylesheet-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/style.min.css?ver=6.2.3' type='text/css' media='all' />
        <!--[if IE]>
        <link rel='stylesheet' id='avada-IE-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/ie.min.css?ver=6.2.3' type='text/css' media='all' />
        <style id='avada-IE-inline-css' type='text/css'>
        .avada-select-parent .select-arrow{background-color:#ffffff}
        .select-arrow{background-color:#ffffff}
        </style>
        <![endif]-->
        <link rel='stylesheet' id='fusion-dynamic-css-css'  href='https://www.haumeamagazine.com/wp-content/uploads/fusion-styles/a1bbba4975e5c99b728b2d87fbcc19f4.min.css?ver=2.2.3' type='text/css' media='all' />
        <link rel='stylesheet' id='avada-max-1c-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/max-1c.min.css?ver=6.2.3' type='text/css' media='only screen and (max-width: 640px)' />
        <link rel='stylesheet' id='avada-max-2c-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/max-2c.min.css?ver=6.2.3' type='text/css' media='only screen and (max-width: 752px)' />
        <link rel='stylesheet' id='avada-min-2c-max-3c-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/min-2c-max-3c.min.css?ver=6.2.3' type='text/css' media='only screen and (min-width: 752px) and (max-width: 864px)' />
        <link rel='stylesheet' id='avada-min-3c-max-4c-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/min-3c-max-4c.min.css?ver=6.2.3' type='text/css' media='only screen and (min-width: 864px) and (max-width: 976px)' />
        <link rel='stylesheet' id='avada-min-4c-max-5c-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/min-4c-max-5c.min.css?ver=6.2.3' type='text/css' media='only screen and (min-width: 976px) and (max-width: 1088px)' />
        <link rel='stylesheet' id='avada-min-5c-max-6c-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/min-5c-max-6c.min.css?ver=6.2.3' type='text/css' media='only screen and (min-width: 1088px) and (max-width: 1200px)' />
        <link rel='stylesheet' id='avada-min-shbp-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/min-shbp.min.css?ver=6.2.3' type='text/css' media='only screen and (min-width: 1201px)' />
        <link rel='stylesheet' id='avada-max-shbp-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/max-shbp.min.css?ver=6.2.3' type='text/css' media='only screen and (max-width: 1200px)' />
        <link rel='stylesheet' id='avada-max-sh-shbp-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/max-sh-shbp.min.css?ver=6.2.3' type='text/css' media='only screen and (max-width: 1200px)' />
        <link rel='stylesheet' id='avada-min-768-max-1024-p-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/min-768-max-1024-p.min.css?ver=6.2.3' type='text/css' media='only screen and (min-device-width: 768px) and (max-device-width: 1024px) and (orientation: portrait)' />
        <link rel='stylesheet' id='avada-min-768-max-1024-l-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/min-768-max-1024-l.min.css?ver=6.2.3' type='text/css' media='only screen and (min-device-width: 768px) and (max-device-width: 1024px) and (orientation: landscape)' />
        <link rel='stylesheet' id='avada-max-sh-cbp-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/max-sh-cbp.min.css?ver=6.2.3' type='text/css' media='only screen and (max-width: 800px)' />
        <link rel='stylesheet' id='avada-max-sh-sbp-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/max-sh-sbp.min.css?ver=6.2.3' type='text/css' media='only screen and (max-width: 800px)' />
        <link rel='stylesheet' id='avada-max-sh-640-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/max-sh-640.min.css?ver=6.2.3' type='text/css' media='only screen and (max-width: 640px)' />
        <link rel='stylesheet' id='avada-max-shbp-18-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/max-shbp-18.min.css?ver=6.2.3' type='text/css' media='only screen and (max-width: 1182px)' />
        <link rel='stylesheet' id='avada-max-shbp-32-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/max-shbp-32.min.css?ver=6.2.3' type='text/css' media='only screen and (max-width: 1168px)' />
        <link rel='stylesheet' id='avada-min-sh-cbp-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/min-sh-cbp.min.css?ver=6.2.3' type='text/css' media='only screen and (min-width: 800px)' />
        <link rel='stylesheet' id='avada-max-640-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/max-640.min.css?ver=6.2.3' type='text/css' media='only screen and (max-device-width: 640px)' />
        <link rel='stylesheet' id='avada-max-main-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/max-main.min.css?ver=6.2.3' type='text/css' media='only screen and (max-width: 1200px)' />
        <link rel='stylesheet' id='avada-max-cbp-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/max-cbp.min.css?ver=6.2.3' type='text/css' media='only screen and (max-width: 800px)' />
        <link rel='stylesheet' id='avada-max-sh-cbp-eslider-css'  href='https://www.haumeamagazine.com/wp-content/themes/Avada/assets/css/media/max-sh-cbp-eslider.min.css?ver=6.2.3' type='text/css' media='only screen and (max-width: 800px)' />
        <link rel='stylesheet' id='fb-max-sh-cbp-css'  href='https://www.haumeamagazine.com/wp-content/plugins/fusion-builder/assets/css/media/max-sh-cbp.min.css?ver=2.2.3' type='text/css' media='only screen and (max-width: 800px)' />
        <link rel='stylesheet' id='fb-min-768-max-1024-p-css'  href='https://www.haumeamagazine.com/wp-content/plugins/fusion-builder/assets/css/media/min-768-max-1024-p.min.css?ver=2.2.3' type='text/css' media='only screen and (min-device-width: 768px) and (max-device-width: 1024px) and (orientation: portrait)' />
        <link rel='stylesheet' id='fb-max-640-css'  href='https://www.haumeamagazine.com/wp-content/plugins/fusion-builder/assets/css/media/max-640.min.css?ver=2.2.3' type='text/css' media='only screen and (max-device-width: 640px)' />
        <link rel='stylesheet' id='fb-max-1c-css'  href='https://www.haumeamagazine.com/wp-content/plugins/fusion-builder/assets/css/media/max-1c.css?ver=2.2.3' type='text/css' media='only screen and (max-width: 640px)' />
        <link rel='stylesheet' id='fb-max-2c-css'  href='https://www.haumeamagazine.com/wp-content/plugins/fusion-builder/assets/css/media/max-2c.css?ver=2.2.3' type='text/css' media='only screen and (max-width: 752px)' />
        <link rel='stylesheet' id='fb-min-2c-max-3c-css'  href='https://www.haumeamagazine.com/wp-content/plugins/fusion-builder/assets/css/media/min-2c-max-3c.css?ver=2.2.3' type='text/css' media='only screen and (min-width: 752px) and (max-width: 864px)' />
        <link rel='stylesheet' id='fb-min-3c-max-4c-css'  href='https://www.haumeamagazine.com/wp-content/plugins/fusion-builder/assets/css/media/min-3c-max-4c.css?ver=2.2.3' type='text/css' media='only screen and (min-width: 864px) and (max-width: 976px)' />
        <link rel='stylesheet' id='fb-min-4c-max-5c-css'  href='https://www.haumeamagazine.com/wp-content/plugins/fusion-builder/assets/css/media/min-4c-max-5c.css?ver=2.2.3' type='text/css' media='only screen and (min-width: 976px) and (max-width: 1088px)' />
        <link rel='stylesheet' id='fb-min-5c-max-6c-css'  href='https://www.haumeamagazine.com/wp-content/plugins/fusion-builder/assets/css/media/min-5c-max-6c.css?ver=2.2.3' type='text/css' media='only screen and (min-width: 1088px) and (max-width: 1200px)' />
        <script type='text/javascript' src='https://www.haumeamagazine.com/wp-includes/js/jquery/jquery.min.js?ver=3.5.1' id='jquery-core-js'></script>
        <script type='text/javascript' src='https://www.haumeamagazine.com/wp-includes/js/jquery/jquery-migrate.min.js?ver=3.3.2' id='jquery-migrate-js'></script>
        <link rel="https://api.w.org/" href="https://www.haumeamagazine.com/wp-json/" /><link rel="alternate" type="application/json" href="https://www.haumeamagazine.com/wp-json/wp/v2/posts/1737" /><link rel="EditURI" type="application/rsd+xml" title="RSD" href="https://www.haumeamagazine.com/xmlrpc.php?rsd" />
        <link rel="wlwmanifest" type="application/wlwmanifest+xml" href="https://www.haumeamagazine.com/wp-includes/wlwmanifest.xml" />
        <meta name="generator" content="WordPress 5.7.1" />
        <link rel='shortlink' href='https://www.haumeamagazine.com/?p=1737' />
        <link rel="alternate" type="application/json+oembed" href="https://www.haumeamagazine.com/wp-json/oembed/1.0/embed?url=https%3A%2F%2Fwww.haumeamagazine.com%2Fhaumea-selects-3-plongee-dans-la-nouvelle-face-de-la-soul-music-avec-sebastea-naomi-cheyanne-deborah-williams-santi-forget-mighloe-et-ruthee%2F" />
        <link rel="alternate" type="text/xml+oembed" href="https://www.haumeamagazine.com/wp-json/oembed/1.0/embed?url=https%3A%2F%2Fwww.haumeamagazine.com%2Fhaumea-selects-3-plongee-dans-la-nouvelle-face-de-la-soul-music-avec-sebastea-naomi-cheyanne-deborah-williams-santi-forget-mighloe-et-ruthee%2F&#038;format=xml" />
        <style type="text/css">.wtr-time-wrap{
            /* wraps the entire label */
            margin: 0 10px;

        }
        .wtr-time-number{
            /* applies only to the number */

        }

        </style><link rel="alternate" href="https://www.haumeamagazine.com/haumea-selects-3-plongee-dans-la-nouvelle-face-de-la-soul-music-avec-sebastea-naomi-cheyanne-deborah-williams-santi-forget-mighloe-et-ruthee/" hreflang="fr" />
        <link rel="alternate" href="https://www.haumeamagazine.com/en/haumea-selects-3-discovering-the-new-faces-of-modern-soul-music-with-sebastea-naomi-cheyanne-deborah-williams-santi-forget-mighloe-and-ruthee/" hreflang="en" />
        <style type="text/css" id="css-fb-visibility">@media screen and (max-width: 640px){body:not(.fusion-builder-ui-wireframe) .fusion-no-small-visibility{display:none !important;}}@media screen and (min-width: 641px) and (max-width: 1024px){body:not(.fusion-builder-ui-wireframe) .fusion-no-medium-visibility{display:none !important;}}@media screen and (min-width: 1025px){body:not(.fusion-builder-ui-wireframe) .fusion-no-large-visibility{display:none !important;}}</style><style type="text/css" id="custom-background-css">
        body.custom-background { background-color: #000000; }
        </style>
        	<style type="text/css" title="dynamic-css" class="options-output">.wtr-time-wrap{color:#CCCCCC;font-size:16px;opacity: 1;visibility: visible;-webkit-transition: opacity 0.24s ease-in-out;-moz-transition: opacity 0.24s ease-in-out;transition: opacity 0.24s ease-in-out;}.wf-loading .wtr-time-wrap{opacity: 0;}.ie.wf-loading .wtr-time-wrap{visibility: hidden;}</style>		<script type="text/javascript">
        			var doc = document.documentElement;
        			doc.setAttribute( 'data-useragent', navigator.userAgent );
        		</script>
        	</head>

        <body class="post-template-default single single-post postid-1737 single-format-standard custom-background fusion-image-hovers fusion-pagination-sizing fusion-button_size-large fusion-button_type-flat fusion-button_span-no avada-image-rollover-circle-yes avada-image-rollover-no fusion-has-button-gradient fusion-body ltr fusion-sticky-header no-mobile-slidingbar no-mobile-totop avada-has-rev-slider-styles fusion-disable-outline fusion-sub-menu-fade mobile-logo-pos-center layout-wide-mode avada-has-boxed-modal-shadow- layout-scroll-offset-full avada-has-zero-margin-offset-top fusion-top-header menu-text-align-center mobile-menu-design-flyout fusion-show-pagination-text fusion-header-layout-v1 avada-responsive avada-footer-fx-none avada-menu-highlight-style-bottombar fusion-search-form-clean fusion-main-menu-search-overlay fusion-avatar-circle avada-dropdown-styles avada-blog-layout-large avada-blog-archive-layout-large avada-header-shadow-no avada-menu-icon-position-left avada-has-megamenu-shadow avada-has-header-100-width avada-has-breadcrumb-mobile-hidden avada-has-titlebar-hide avada-header-border-color-full-transparent avada-has-pagination-width_height avada-flyout-menu-direction-fade avada-ec-views-v1" >
        <div id="main">
        $content
        </div>
        <style>
          body p, body p span, body div span {
            font-size: ${fontSize['p']}px !important;
            line-height: ${fontSize['p']! * 1.1}px !important;
            font-family: georgia !important;
          }
          body h1 {
            font-size: ${fontSize['h1']}px !important;
            line-height: ${fontSize['h1']! * 1.1}px !important;
            font-family: 'DIN Condensed Bold' !important;
          }
          body h2 {
            font-size: ${fontSize['h2']}px !important;
            line-height: ${fontSize['h2']! * 1.1}px !important;
            font-family: 'DIN Condensed Bold' !important;
          }
          body h3 {
            font-size: ${fontSize['h3']}px !important;
            line-height: ${fontSize['h3']! * 1.1}px !important;
            font-family: 'DIN Condensed Bold' !important;
          }
          body li {
            font-size: ${fontSize['li']}px !important;
            line-height: ${fontSize['li']! * 1.2}px !important;
          }
          a:hover {
            color: inherit !important;
          }
          span.fusion-button-text {
            font-size: 20px !important;
          }
          .fusion-title.fusion-title-center{
            text-align: center !important;
          }

          blockquote {
            margin: 0 10px !important;
            border-color: #f05858 !important;
          }
          ${isLight ? """
          body, html, blockquote, div#main  {
            background: #fffbf7 !important;
            color: black !important;
          }
          a {
            color: black !important;
          }
          #main {
            padding: 0 !important;
          }

          """ : """
          body, html, blockquote, div#main  {
            background: black !important;
            color: white !important;
          }
          a, h1, h2, h3, h4, h5, h6, p {
            color: white !important;
          }
          .title-heading-center {
            color: white !important;
          }
          blockquote {
            background: rgb(40, 40, 40) !important;
          }
          """}

          </style>
        	</body>
        </html>

        """;
  }

  static textFromHTML(html) {
    final document = parse(html);
    return parse(document.body!.text).documentElement!.text;
  }
}
