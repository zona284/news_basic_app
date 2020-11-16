// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_basic_app/bloc/base_bloc.dart';
import 'package:news_basic_app/bloc/base_event.dart';
import 'package:news_basic_app/bloc/base_state.dart';
import 'package:http/http.dart' as http;

import 'package:news_basic_app/models/article.dart';
import 'package:news_basic_app/repositories/base_api_client.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockApiClient extends Mock implements BaseApiClient {}

void main() {
  BaseBloc baseBloc;
  MockApiClient mockApiClient;

  setUp((){
    mockApiClient = MockApiClient();
    baseBloc = BaseBloc(baseClient: mockApiClient);
  });

  tearDown(() {
    baseBloc?.close();
  });

  group('assertion', () {
    test('BaseBloc should assert if null', () {
      expect(
            () => BaseBloc(baseClient: null),
        throwsA(isAssertionError),
      );
    });

    test('BaseApiClient should assert if null', () {
      expect(
            () => BaseApiClient(httpClient: null),
        throwsA(isAssertionError),
      );
    });
  });

  test('initial state is correct', () {
    expect(baseBloc.state, OnEmpty());
  });

  test('close does not emit new states', () {
    expectLater(
      baseBloc,
      emitsInOrder([emitsDone]),
    );
    baseBloc.close();
  });

  group('Event test', () {
    test('returns FetchHeadline correct props', () {
      expect(FetchHeadline().props, []);
    });

    test('returns FetchLatestArticle correct props', () {
      expect(FetchLatestArticle().props, []);
    });
  });

  group('Bloc test', () {
    final mockResponseJson = json.decode('''
    [
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
        "meta_description": "Unbranded"
      },
      {
        "id": "2",
        "categoryId": "2",
        "publish_date": "2020-09-30T01:12:44.819Z",
        "title": "title 2",
        "slug": "contingency",
        "content": "Chief",
        "total_hit": 80238,
        "image": "http://lorempixel.com/640/480/fashion",
        "admin_name": "Rex Rohan",
        "admin_image": "https://s3.amazonaws.com/uifaces/faces/twitter/ahmadajmi/128.jpg",
        "meta_description": "Refined"
      }
    ]
    ''');
    final mockResponse = (mockResponseJson as List)
        .map((mockResponseJson) => new Article.fromJson(mockResponseJson))
        .toList();

    blocTest(
      'emit [OnLoading, OnLoaded] when fetchHeadline is added and fetched success',
      build: () {
        when(mockApiClient.fetchArticle(1, 1)).thenAnswer(
              (_) => Future.value(mockResponse),
        );
        return baseBloc;
      },
      act: (bloc) => bloc.add(FetchHeadline()),
      expect: [OnLoading(), OnLoaded(obj: mockResponse)]
    );

    blocTest(
      'emits [OnLoading, OnError] when fetchHeadline is added and fetched fails',
      build: () {
        when(mockApiClient.fetchArticle(any, any))
            .thenThrow(Exception('error getting data'));
        return baseBloc;
      },
      act: (bloc) => bloc.add(FetchHeadline()),
      expect: [OnLoading(), OnError()],
    );

    blocTest(
        'emit [OnLoading, OnLoaded] when fetchLatestArticle is added and fetched success',
        build: () {
          when(mockApiClient.fetchArticle(2, 1)).thenAnswer(
                (_) => Future.value(mockResponse),
          );
          return baseBloc;
        },
        act: (bloc) => bloc.add(FetchLatestArticle()),
        expect: [OnLoading(), OnLoaded(obj: mockResponse)]
    );

    blocTest(
      'emits [OnLoading, OnError] when fetchLatestArticle is added and fetched fails',
      build: () {
        when(mockApiClient.fetchArticle(any, any))
            .thenThrow(Exception('error getting data'));
        return baseBloc;
      },
      act: (bloc) => bloc.add(FetchLatestArticle()),
      expect: [OnLoading(), OnError()],
    );
  });

}
