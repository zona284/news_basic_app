import 'dart:convert';
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_basic_app/models/models.dart';
import 'package:news_basic_app/repositories/base_api_client.dart';
import 'package:http/http.dart' as http;


class MockHttpClient extends Mock implements http.Client {}

class MockBaseApiClient extends Mock implements BaseApiClient {
  BaseApiClient _real;

  MockBaseApiClient(http.Client httpClient) {
    _real = BaseApiClient(httpClient: httpClient);
    when(fetchArticle(1, 1)).thenAnswer((_) => _real.fetchArticle(1, 1));
  }
}

void main () {
  MockHttpClient mockHttpClient;
  MockBaseApiClient mockBaseApiClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockBaseApiClient = MockBaseApiClient(mockHttpClient);
  });

  group('Api Client Test', () {
    test('return Articles if http call successfully', () async {
      // given
      final mockResponseString = '''
        {
          "rescode": "00",
          "data": {
            "data": [
              {
                "id": "1",
                "categoryId": "1",
                "publish_date": "2020-09-29T13:23:56.086Z",
                "title": "title 1",
                "slug": "Pakistan",
                "content": "Human",
                "total_hit": 91708,
                "image": "http://lorempixel.com/640/480/city",
                "admin_name": "Lou Hayes",
                "admin_image": "https://s3.amazonaws.com/uifaces/faces/twitter/conspirator/128.jpg",
                "meta_description": "Unbranded",
                "category": {
                  "id": "1",
                  "name": "Small Frozen Bike",
                  "slug": "Ergonomic"
                }
              }
            ]
          },
          "message": "success"
        }
      ''';
      final data = jsonDecode(mockResponseString)['data']['data'];
      final mockData = (data as List)
          .map((data) => new Article.fromJson(data))
          .toList();

      when(mockHttpClient
          .get('http://5f72ba9e6833480016a9bf3e.mockapi.io/api/v1/category/1/articles?p=1&limit=5'))
          .thenAnswer(
              (_) async => Future.value(http.Response(mockResponseString, 200)));

      expect(await mockBaseApiClient.fetchArticle(1, 1), mockData);
    });

    test('return Exception if http call error', () async {
      when(mockHttpClient
          .get('http://5f72ba9e6833480016a9bf3e.mockapi.io/api/v1/category/1/articles?p=1&limit=0'))
          .thenAnswer((_) async =>
          Future.value(http.Response('error getting articles', 202)));

      expect(() async => await mockBaseApiClient.fetchArticle(1, 1),
          throwsA(isException));
    });
  });
}