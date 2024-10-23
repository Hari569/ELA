import 'package:uuid/uuid.dart';

class Post {
  final String id;
  final String username;
  final String content;
  final String? imagePath;
  final String? videoPath; // Added for video support
  int likes;
  List<Comment> comments;
  DateTime createdAt;

  Post({
    String? id,
    required this.username,
    required this.content,
    this.imagePath,
    this.videoPath, // Added to constructor
    this.likes = 0,
    List<Comment>? comments,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        comments = comments ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'content': content,
      'imagePath': imagePath,
      'videoPath': videoPath, // Added to map
      'likes': likes,
      'comments': comments.map((comment) => comment.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      username: map['username'],
      content: map['content'],
      imagePath: map['imagePath'],
      videoPath: map['videoPath'], // Added to fromMap
      likes: map['likes'],
      comments: (map['comments'] as List)
          .map((commentMap) => Comment.fromMap(commentMap))
          .toList(),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class Comment {
  final String id;
  final String username;
  final String content;
  DateTime createdAt;

  Comment({
    String? id,
    required this.username,
    required this.content,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      username: map['username'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
