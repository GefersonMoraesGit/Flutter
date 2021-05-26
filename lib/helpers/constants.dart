class Constants {
  static const String HAUMEA_URL = "https://www.haumeamagazine.com";
  // static const String HAUMEA_URL = "https://wordpress-159588-1902682.cloudwaysapps.com/";
  static const CATEGORIES = {
    "fr": {
      665: "news",
      2: "reviews",
      3: "reports",
      4: "interviews",
      5: "playlists",
    },
    "en": {
      710: "news",
      51: "reviews",
      53: "reports",
      55: "interviews",
      57: "playlists",
    },
  };

  static Map<String, List<int>> categoriesByType() {
    Map<String, List<int>> values = {};

    var enCategories = CATEGORIES["en"]!.keys.toList();
    var frCategories = CATEGORIES["fr"]!.keys.toList();
    var categories = CATEGORIES["fr"]!.values;

    for (var i = 0; i < enCategories.length; i++) {
      values[categories.elementAt(i)] = [enCategories.elementAt(i), frCategories.elementAt(i)];
    }
    return values;
  }

  static const HEADLINES_CATEGORY = {"fr": 75, "en": 77};

  static const PLAYLIST_TAGS = {
    "alternative": {
      "fr": 1134,
      "en": 1136,
    },
    "electro": {
      "fr": 1132,
      "en": 1194,
    },
    "ambient": {
      "fr": 1156,
      "en": 1192,
    },
    "pop": {
      "fr": 1138,
      "en": 1140,
    },
  };

  static int categoryIdFor(category, lang) {
    int id = 0;
    for (var entry in CATEGORIES[lang]!.entries) {
      if (entry.value == category) {
        id = entry.key;
        break;
      }
    }
    return id;
  }

  static const SIZES = {
    "title": 40.0,
    "subtitle": 18.0,
  };

  static const PADDING = 20.0;
}
