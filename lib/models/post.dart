import 'dart:convert';

import 'package:haumea/helpers/constants.dart';
import 'package:http/http.dart' as http;

class PostModel {
  final int id;
  final String status;
  final String content;
  final String excerpt;
  final String date;
  final String thumbnail;
  final String title;
  final String link;
  final List<num> categories;
  final String categoryKey;

  PostModel(
      {required this.id,
      required this.status,
      required this.content,
      required this.excerpt,
      required this.date,
      required this.title,
      required this.link,
      required this.categories,
      required this.categoryKey,
      required this.thumbnail});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    Map<String, List<int>> categories = Constants.categoriesByType();
    String categoryKey = '';
    var postCategories = json['categories'].toSet();

    // Set category key of post
    for (MapEntry entry in categories.entries) {
      var entryCategories = entry.value.toSet();
      if (postCategories.intersection(entryCategories).isNotEmpty) {
        categoryKey = entry.key;
        break;
      }
    }

    return PostModel(
        id: json['id'],
        status: json['status'],
        content: json['content']['rendered'],
        excerpt: json['excerpt']['rendered'],
        date: json['date'],
        link: json['link'],
        title: json['title']['rendered'],
        categories: json['categories'].cast<num>(),
        categoryKey: categoryKey,
        thumbnail: json['_embedded']['wp:featuredmedia'][0]["media_details"]["sizes"]["medium_large"]["source_url"]);
  }

  static List<PostModel> parse(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<PostModel>((json) => PostModel.fromJson(json)).toList();
  }

  static List<PostModel> parsePosts(dynamic body) {
    final parsed = body.cast<Map<String, dynamic>>();

    return parsed.map<PostModel>((json) => PostModel.fromJson(json)).toList();
  }

  static Future<PostModel?> getFromSlug(slug) async {
    final response =
        await http.Client().get(Uri.parse("${Constants.HAUMEA_URL}/wp-json/wp/v2/posts?_embed&slug=${slug}"));

    final body = jsonDecode(response.body);
    if (body is List && body.length > 0) {
      return parse(response.body)[0];
    } else {
      return null;
    }
  }

  static Future<PostModel?> getFromCategoryOrTag({categoryID, tagID}) async {
    var url = "${Constants.HAUMEA_URL}/wp-json/wp/v2/posts?_embed&orderby=date&order=desc&per_page=1";
    if (categoryID != null) {
      url += "&categories=${categoryID}";
    }
    if (tagID != null) {
      url += "&tags=${tagID}";
    }
    print("getFromCategoryOrTag $url");
    final response = await http.Client().get(Uri.parse(url));

    final body = jsonDecode(response.body);
    if (body is List && body.length > 0) {
      return parse(response.body)[0];
    } else {
      return null;
    }
  }
}
