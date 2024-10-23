import 'dart:convert';
import 'package:ELA/models/post_model.dart';
import 'package:ELA/core/services/shared_preferences_service.dart';

class PostRepository {
  static const String POSTS_KEY = 'posts';
  late SharedPreferencesService _prefsService;

  PostRepository._();

  static Future<PostRepository> getInstance() async {
    final repository = PostRepository._();
    repository._prefsService = await SharedPreferencesService.getInstance();
    return repository;
  }

  Future<void> savePosts(List<Post> posts) async {
    final String encodedPosts =
        json.encode(posts.map((post) => post.toMap()).toList());
    await _prefsService.setString(POSTS_KEY, encodedPosts);
  }

  Future<List<Post>> loadPosts() async {
    final String? encodedPosts = _prefsService.getString(POSTS_KEY);
    if (encodedPosts == null) return [];
    final List<dynamic> decodedPosts = json.decode(encodedPosts);
    return decodedPosts.map((postMap) => Post.fromMap(postMap)).toList();
  }
}
