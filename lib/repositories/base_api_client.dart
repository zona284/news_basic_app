import 'dart:convert';

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
    final url = "${API_ARTICLE_BY_CATEGORY.replaceAll("{id}", category.toString())}?p$page&limit=5";
    final response = await this.httpClient.get(url);

    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      List<Article> art = (json.decode(response.body) as List)
          .map((json) => new Article.fromJson(json['data']))
          .toList();
//      if(art.length<20 || index>10){
//        isFinishedLoadAPI = true;
//      }
      return art;
    } else {
      // If that response was not OK, throw an er`ror.
      throw Exception('Failed to load post');
    }
  }
}