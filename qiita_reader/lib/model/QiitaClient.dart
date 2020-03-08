import 'package:qiitareader/entity/Article.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class QiitaClient {
  static bool loading = false;
  static int _page = 1;

  static Future<List<Article>> refresh() {
    loading = true;
    print("refresh");
    _page = 1;
    return _fetchArticle();
  }

  static Future<List<Article>> next() async {
    loading = true;
    print("next");
    _page++;
    return _fetchArticle();
  }

  static Future<List<Article>> _fetchArticle() async {
    print("page:$_page");

    final url = 'https://qiita.com/api/v2/items?page=$_page&per_page=20';
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer 3b9b9a79b0ccac95116724e2767d2c14a61ae12a"},
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonArray = json.decode(response.body);
      loading = false;
      return jsonArray.map((json) => Article.fromJson(json)).toList();
    } else {
      print('Failed to load article');
      throw Exception('Failed to load article');
    }
  }
}