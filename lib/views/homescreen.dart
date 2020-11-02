import 'dart:convert';
import 'dart:async';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:news_basic_app/models/models.dart';
import 'package:news_basic_app/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_basic_app/utils/date_utils.dart';
import 'package:news_basic_app/utils/main_constant.dart';

import 'post_detail_page.dart';


class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  Future<List<Article>> _futureListHeadline;
  Future<List<Article>> _futureListArticle;

  @override
  initState() {
    super.initState();
    _futureListHeadline = fetchHeadline();
    _futureListArticle = fetchArticle();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: ListView(
          controller: new ScrollController(keepScrollOffset: false),
          shrinkWrap: true,
          padding: const EdgeInsets.all(15.0),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            new Container(
                height: 50,
                margin: EdgeInsets.fromLTRB(0, 5, 0, 20),
                child: Card(
                  borderOnForeground: true,
                  shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[300])),
                  elevation: 0,
                  color: Colors.grey[200],
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Text("Cari Berita",
                              style: CONST_SUBHEADER_TEXT_STYLE,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1),
                          new Icon(Icons.search)
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, ROUTE_SEARCH_PAGE);
                    },
                  ),
                )
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text("Headline News", style: CONST_HEADER_TEXT_STYLE,),
              ],
            ),
            new Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 28),
                height: MediaQuery.of(context).size.height/3 < 215 ? 215 : MediaQuery.of(context).size.height/3,
                child: SizedBox.expand(
                  child: headlineList(),
                )
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text("Berita Terbaru", style: CONST_HEADER_TEXT_STYLE,),
                new GestureDetector(
                  child: Text("lihat semua", style: CONST_LINK_TEXT_STYLE,),
                  onTap: (){
                    MyHomePage.of(context).selectItem(1); //kategori screen
                  },
                )
              ],
            ),
            new Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: newsList()
            ),
          ],
        )
    );
  }

  Widget newsList(){
    return FutureBuilder<List<Article>>
      (
      future: _futureListArticle,
      builder: (context, snapshot) {
        print("snapshot: "+snapshot.toString());
        if(snapshot.hasData) {
          List<Article> articles = new List();
          for(int i=0; i<snapshot.data.length; i++){
            if(i<5){
              articles.add(snapshot.data[i]);
            } else {
              break;
            }
          }

          return new ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: articles.length,
            controller: new ScrollController(keepScrollOffset: false),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: EdgeInsets.fromLTRB(4,4,4,8),
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
                              Text(articles[index].title,
                                style: CONST_LIST_HEADER_TEXT_STYLE,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(articles[index].adminName + "・" + localFormat(articles[index].publishDate),
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
                              imageUrl: articles[index].image,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              height: 75,
                              width: 110,
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
                            builder: (context) => PostDetailPage(article: articles[index])
                        )
                    );
                    print(articles[index].title);
                  },
                ),
              );
            },
          );
        } else if(snapshot.hasError) {
          print(snapshot.error);
          return Center(child: Text("Data tidak ditemukan"),);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget headlineList(){
    double c_width = MediaQuery.of(context).size.width*0.8;
    double c_height = MediaQuery.of(context).size.width*0.6;

    return FutureBuilder<List<Article>>
      (
      future: _futureListHeadline,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return new ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.length,
            controller: new ScrollController(keepScrollOffset: false),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  elevation: 2.0,
                  margin: EdgeInsets.fromLTRB(4,4,8,4),
                  child: InkWell(
                    child: Container(
                      width: c_width,
                      height: c_height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0)
                            ),
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data[index].image,
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.center,
                              height: 120,
                              width: c_width,
                              placeholder: (context, url) => new CircularProgressIndicator(),
                              errorWidget: (context, url, error) => new Icon(Icons.broken_image),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(snapshot.data[index].title,
                                  style: CONST_LIST_HEADER_TEXT_STYLE,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Text(snapshot.data[index].adminName + "・" +
                                    localFormat(snapshot.data[index].publishDate),
                                  style: CONST_SUBHEADER_TEXT_STYLE,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => PostDetailPage(article: snapshot.data[index])
                          )
                      );
                      print(snapshot.data[index].title);
                    },
                  )
              );
            },
          );
        } else if(snapshot.hasError) {
          print(snapshot.error);
          return Center(child: Text("Data tidak ditemukan"),);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<List<Article>> fetchHeadline() async {
    final response =
    await http.get(API_HEADLINE_SLIDER);
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
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<List<Article>> fetchArticle() async {
    final response =
    await http.get("${API_ARTICLE_BY_CATEGORY.replaceAll("{id}", "2")}?p=1&limit=5");
    print("API REQUEST: " + response.request.toString());
    print("API STATUS: " + response.statusCode.toString());
    print("API RESPONSE: " + response.body);

    if (response.statusCode==200 || response.statusCode==201) {
      // If server returns an OK response, parse the JSON
      var data = json.decode(response.body)['data']['data'];
      return (data as List)
          .map((data) => new Article.fromJson(data))
          .toList();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

}