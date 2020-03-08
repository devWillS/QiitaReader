import 'User.dart';

class Article {
  final String title;
  final String url;
  final String createdAt;
  final User user;

  Article({this.title, this.url, this.createdAt, this.user});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      url: json['url'],
      createdAt: json['created_at'],
      user: User.fromJson(json['user']),
    );
  }
}