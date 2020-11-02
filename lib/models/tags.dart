class Tags {
  final String slug;
  final String name;

  Tags({this.name, this.slug});

  factory Tags.fromJson(Map<String, dynamic> json) {
    return Tags(
      name: json['name'],
      slug: json['slug'],
    );
  }
}