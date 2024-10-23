class Article {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String readTime;
  final DateTime publishDate;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.readTime,
    required this.publishDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'readTime': readTime,
      'publishDate': publishDate.toIso8601String(),
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      imageUrl: map['imageUrl'],
      readTime: map['readTime'],
      publishDate: DateTime.parse(map['publishDate']),
    );
  }
}
