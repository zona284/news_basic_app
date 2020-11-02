import 'package:equatable/equatable.dart';

import 'tags.dart';

class Article extends Equatable{
  final String id;
  final String publishDate;
  final String adminName;
  final String adminImage;
  final String categoryName;
  final String slug;
  final String content;
  final String title;
  final int total_hit;
  final String image;
  final String metaDescription;
  final List<Tags> listTags;


  Article({this.id, this.publishDate, this.adminName, this.adminImage,
    this.categoryName, this.slug, this.content, this.title, this.total_hit,
    this.image, this.metaDescription, this.listTags});

  factory Article.fromJson(Map<String, dynamic> json) {
//    var _tags = json['tags'] as List;
//    List<Tags> _tagList = _tags.map((i) => Tags.fromJson(i)).toList();

    return Article(
      id: json["id"],
      title: json["title"],
      slug: json["slug"],
      content: json["content"],
      total_hit: json["total_hit"],
      image: json["image"],
      publishDate: json["publish_date"],
      adminName: json["admin_name"],
      adminImage: json["admin_image"],
      categoryName: json["category_name"],
      metaDescription: json["meta_description"],
//      listTags: _tagList,
    );
  }

  @override
  List<Object> get props => [id,
    publishDate,
    adminName,
    adminImage,
    categoryName,
    slug,
    content,
    title,
    total_hit,
    image,
    metaDescription,
    listTags
  ];


}