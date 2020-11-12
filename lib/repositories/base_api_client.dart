import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'package:news_basic_app/models/models.dart';
import 'package:news_basic_app/utils/main_constant.dart';

class BaseApiClient {
  final http.Client httpClient;

  BaseApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<Article>> fetchArticle(int category, int page) async {
    final url = "${API_ARTICLE_BY_CATEGORY.replaceAll("{id}", category.toString())}?p=$page&limit=5";
    final response = await this.httpClient.get(url);

    print("API REQUEST: " + response.request.toString());
    print("API STATUS: " + response.statusCode.toString());
    print("API RESPONSE: " + response.body);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      var data = json.decode(response.body)['data']['data'];
      return (data as List)
          .map((data) => new Article.fromJson(data))
          .toList();
    } else {
      // If that response was not OK, throw an er`ror.
      throw Exception('Failed to load post');
    }
  }
}