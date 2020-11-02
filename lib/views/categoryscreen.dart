import 'dart:convert';
import 'dart:async';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_basic_app/models/models.dart';
import 'package:news_basic_app/utils/date_utils.dart';
import 'package:news_basic_app/utils/main_constant.dart';

import 'post_detail_page.dart';


const Category = [
  'Berita',
  'Tutorial',
  'Aplikasi',
  'Paket Internet',
  'Game'
];

class CategoryScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>{
  String selectedCategory;
  bool isFinishedLoadAPI;
  PagewiseLoadController _pageLoadController;

  @override
  initState() {
    super.initState();
    isFinishedLoadAPI = false;
    selectedCategory  = Category[0];
    _pageLoadController = new PagewiseLoadController(
      pageFuture: (pageIndex) {
        print("apa ini "+(pageIndex).toString());
        return !isFinishedLoadAPI ? fetchArticle(pageIndex+1) : null;
      },
      pageSize: 5
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListView(
        controller: new ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          new Container(
              margin: EdgeInsets.fromLTRB(5, 8, 5, 5),
              height: 36,
              child: _categoryWidget()
          ),
          new Container(
              margin: EdgeInsets.fromLTRB(4, 0, 4, 10),
              child: _categoryList()
          ),
        ],
      ),
    );
  }

  Widget _categoryWidget(){
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: Category.length,
        itemBuilder: (context, index) {
          return Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: selectedCategory==Category[index] ? Colors.grey[300] : Colors.white,
              child: InkWell(
                child: Container(
                  padding: selectedCategory==Category[index] ? EdgeInsets.fromLTRB(8,4,8,4) : EdgeInsets.fromLTRB(6,4,6,4),
                  child: Text(
                    Category[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: selectedCategory==Category[index] ? 18 : 16,
                        fontWeight: selectedCategory==Category[index] ? FontWeight.bold : FontWeight.normal
                    ),
                  ),
                ),
                onTap: (){
                  selectedCategory = Category[index];
                  isFinishedLoadAPI = false;
                  setState(() {
                    _pageLoadController.reset();
                  });
                },
              )
          );
        }
    );
  }

  Widget _categoryList(){
    return PagewiseListView(
      shrinkWrap: true,
      controller: new ScrollController(keepScrollOffset: false),
      pageLoadController: _pageLoadController,
      itemBuilder: (context, article, index) {
        print("index ke "+index.toString());
        return new Card(
          elevation: 2.0,
          margin: EdgeInsets.all(8.0),
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(article.title,
                          style: CONST_LIST_HEADER_TEXT_STYLE,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(article.adminName + "・" + localFormat(article.publishDate),
                          style: CONST_SUBHEADER_TEXT_STYLE,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: null,
                  ),
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      child: CachedNetworkImage(
                        imageUrl: article.image,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        height: 80,
                        width: 100,
                        placeholder: (context, url) => new CircularProgressIndicator(),
                        errorWidget: (context, url, error) => new Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => PostDetailPage(article: article)
                  )
              );
            },
          ),
        );
      },
      loadingBuilder: (context) {
        return new CircularProgressIndicator();
      },
      showRetry: true,
      retryBuilder: (context, callback) {
        return RaisedButton(
            child: Text('Retry'),
            onPressed: () => callback()
        );
      }
    );
  }

  Future<List<Article>> fetchArticle(int index) async {
    final response =
    await http.get("${API_ARTICLE_BY_CATEGORY.replaceAll("{id}", "${Category.indexOf(selectedCategory)+1}")}?p=$index&limit=5");
    print("API REQUEST: " + response.request.toString());
    print("API STATUS: " + response.statusCode.toString());
    print("API RESPONSE: " + response.body);
    print("API PAGE: "+index.toString());

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      List<Article> art = (json.decode(response.body)['data']['data'] as List)
          .map((json) => new Article.fromJson(json))
          .toList();
      if(art.length<5 || index>10){
        isFinishedLoadAPI = true;
      }
      return art;
    } else {
      // If that response was not OK, throw an er`ror.
      throw Exception('Failed to load post');
    }
  }

}