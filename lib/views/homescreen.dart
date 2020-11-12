import 'dart:convert';
import 'dart:async';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:news_basic_app/bloc/bloc.dart';
import 'package:news_basic_app/models/models.dart';
import 'package:news_basic_app/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_basic_app/repositories/base_api_client.dart';
import 'package:news_basic_app/utils/date_utils.dart';
import 'package:news_basic_app/utils/main_constant.dart';

import 'post_detail_page.dart';


class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  @override
  initState() {
    super.initState();
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
    return BlocProvider (
      create: (context) => BaseBloc(baseClient: BaseApiClient(httpClient: http.Client())),
      child: BlocBuilder<BaseBloc, BaseState> (
        builder: (context, state) {
          if(state is OnEmpty) {
            BlocProvider.of<BaseBloc>(context).add(FetchLatestArticle());
          } else if(state is OnError) {
            return Center(child: Text("Data tidak ditemukan"),);
          } else if(state is OnLoaded) {
            List<Article> articles = state.obj as List<Article>;
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
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget headlineList(){
    double c_width = MediaQuery.of(context).size.width*0.8;
    double c_height = MediaQuery.of(context).size.width*0.6;
    return BlocProvider(
      create: (context) => BaseBloc(baseClient: BaseApiClient(httpClient: http.Client())),
      child: BlocBuilder<BaseBloc, BaseState>(
        builder: (context, state) {
          if(state is OnEmpty) {
            BlocProvider.of<BaseBloc>(context).add(FetchHeadline());
          }
          else if(state is OnError) {
            return Center(child: Text("Data tidak ditemukan"));
          }
          else if(state is OnLoaded) {
            List<Article> articles = state.obj as List<Article>;
            return new ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: articles.length,
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
                                imageUrl: articles[index].image,
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
                                  Text(articles[index].title,
                                    style: CONST_LIST_HEADER_TEXT_STYLE,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  Text(articles[index].adminName + "・" +
                                      localFormat(articles[index].publishDate),
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
                                builder: (context) => PostDetailPage(article: articles[index])
                            )
                        );
                        print(articles[index].title);
                      },
                    )
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      )
    );
  }

}