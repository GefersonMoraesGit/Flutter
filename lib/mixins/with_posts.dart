import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:haumea/helpers/constants.dart';
import 'package:haumea/helpers/ui.dart';
import 'package:haumea/models/post.dart';
import 'package:haumea/widgets/landing/see_more.dart';
import 'package:http/http.dart' as http;

abstract class WithPosts {
  late List<Object> posts = [];
  bool isLoading = false;
  bool skipFirst = false;
  int page = 0, perPage = 5;
  bool noMoreEntries = false;
  late List<int?> categories;
  late Future<List<Object>> futurePosts;
  int tagID = 0;
  List<int> tags = [];
  int seeMoreIndex = -1;
  double seeMoreSize = 250.0;
  late String language;

  void setState(VoidCallback fn);
  Future<List<Object>> fetchPosts() async {
    isLoading = true;
    posts.add(UI.loader());
    var category = this.categories.join(',');
    if (this.skipFirst) {
      perPage = perPage + 1;
    }
    var key = "$language-$category-$page-$perPage";
    var url =
        "${Constants.HAUMEA_URL}/wp-json/wp/v2/posts?_embed&orderby=date&order=desc&categories=$category&per_page=$perPage&page=${page + 1}";
    if (tagID != 0) {
      url += "&tags=${tagID}";
      key = "$tagID-$key";
    }
    if (tags != null && tags.length > 0) {
      url += "&tags=${tags.join(',')}";
      key = "${tags.join('-')}-$key";
    }

    var body;
    // Check cache
    var fileInfo = await DefaultCacheManager().getFileFromCache(key);

    // Load cache
    if (fileInfo != null) {
      print("Use cache $key for $url");
      var cacheContent = await fileInfo.file.readAsString();
      body = jsonDecode(cacheContent);
      setState(() {
        futurePosts = updatePosts(cacheContent);
      });
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
      if (this.skipFirst) {
        posts.removeAt(0);
      }
    } else {
      noMoreEntries = true;
    }
    isLoading = false;
    if (seeMoreIndex != -1) {
      posts.add(SeeMore(tabIndex: seeMoreIndex, size: seeMoreSize));
    }

    return posts;
  }

  Future<List<Object>> updatePosts(cacheContent) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult != ConnectivityResult.none) {
      var category = this.categories.join(',');
      var url =
          "${Constants.HAUMEA_URL}/wp-json/wp/v2/posts?_embed&orderby=date&order=desc&categories=${category}&per_page=${perPage}&page=${page + 1}";
      var key = "$language-$category-$page-$perPage";
      if (tagID != 0) {
        url += "&tags=${tagID}";
        key = "$tagID-$key";
      }
      if (tags != null && tags.length > 0) {
        url += "&tags=${tags.join(',')}";
        key = "${tags.join('-')}-$key";
      }
      final response = await http.Client().get(Uri.parse(url));
      // Update cache
      if (cacheContent != response.body) {
        print('update cache for $category-$page');
        var newPosts = PostModel.parsePosts(jsonDecode(response.body));
        posts.replaceRange(page, min(page + perPage, posts.length), newPosts);
        var file = await DefaultCacheManager().putFile(url, Uint8List.fromList(response.body.codeUnits), key: key);
        print(file);
      } else {
        print('cache for $key is up to date');
      }
    }
    return posts;
  }
}
