import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:html/dom.dart' as dom;
import 'package:news_basic_app/models/models.dart';
import 'package:news_basic_app/utils/date_utils.dart';
import 'package:news_basic_app/utils/main_constant.dart';
import 'package:share/share.dart';

class PostDetailPage extends StatefulWidget{
  final Article article;
  PostDetailPage({Key key, this.article}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage>{
  double _fontSize = 15.0;

  @override
  Widget build(BuildContext context) {
    String html = widget.article.content;
    print(html);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.article.adminName, style: CONST_APPBAR_TITLE_TEXT_STYLE,),
            Text(localFormat(widget.article.publishDate), style: CONST_APPBAR_SUBTITLE_TEXT_STYLE,)
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        actions: <Widget>[
          IconButton(
              tooltip: 'Ukuran font',
              icon: Icon(Icons.format_size, color: Colors.black87,),
              onPressed: () {
                _fontSize++;
                if(_fontSize>18){
                  _fontSize=14;
                }
                setState(() {});
              }
          ),
//          IconButton(icon: Icon(Icons.favorite), onPressed: null),
          IconButton(
              tooltip: 'Bagikan artikel',
              icon: Icon(Icons.share, color: Colors.black87),
              onPressed: () {
                Share.share(widget.article.title+" baca selengkapnya di "+ BASE_URL + widget.article.slug);
              }
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Image.network(
              widget.article.image,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              height: 200,
              width: MediaQuery.of(context).size.width
          ),
          Container(
            child: Text(widget.article.title,
              style: CONST_DETAILPAGE_HEADER_TITLE_TEXT_STYLE,
              textAlign: TextAlign.left,
            ),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(8,10,8,0),
          ),
          Html(
            data: html,
            style: {
              "*": Style(fontSize: FontSize(_fontSize), letterSpacing: 0.25)
            },
            onLinkTap: (url) {
              print("Opening $url...");
            },
          ),
        ],
      ),
    );
  }

}