import 'dart:convert';

class WordpressPage {
  final String status;
  final String content;
  final String title;

  WordpressPage({
    required this.status,
    required this.content,
    required this.title,
  });

  factory WordpressPage.fromJson(Map<String, dynamic> json) {
    return WordpressPage(
        status: json['status'], content: json['content']['rendered'], title: json['title']['rendered']);
  }

  static List<WordpressPage> parse(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<WordpressPage>((json) => WordpressPage.fromJson(json)).toList();
  }
}
