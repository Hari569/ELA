import 'package:flutter/material.dart';
import 'package:ELA/models/post_model.dart';
import 'package:ELA/data/repositories/post_repository.dart';

class ElaAdminScreen extends StatefulWidget {
  const ElaAdminScreen({Key? key}) : super(key: key);

  @override
  _ElaAdminScreenState createState() => _ElaAdminScreenState();
}

class _ElaAdminScreenState extends State<ElaAdminScreen> {
  List<Post> posts = [];
  late PostRepository _postRepository;

  @override
  void initState() {
    super.initState();
    _initRepository();
  }

  Future<void> _initRepository() async {
    _postRepository = await PostRepository.getInstance();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final loadedPosts = await _postRepository.loadPosts();
    setState(() {
      posts = loadedPosts;
    });
  }

  Future<void> _deletePost(int index) async {
    setState(() {
      posts.removeAt(index);
    });
    await _postRepository.savePosts(posts);
  }

  Future<void> _deleteComment(int postIndex, int commentIndex) async {
    setState(() {
      posts[postIndex].comments.removeAt(commentIndex);
    });
    await _postRepository.savePosts(posts);
  }

  Widget _buildMediaInfo(Post post) {
    List<Widget> mediaWidgets = [];

    if (post.imagePath != null) {
      mediaWidgets.add(
        ListTile(
          leading: const Icon(Icons.image),
          title: const Text('Image URL:'),
          subtitle: SelectableText(post.imagePath!),
        ),
      );
    }

    if (post.videoPath != null) {
      mediaWidgets.add(
        ListTile(
          leading: const Icon(Icons.video_library),
          title: const Text('Video URL:'),
          subtitle: SelectableText(post.videoPath!),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: mediaWidgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ELA Community Admin'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ExpansionTile(
              title: Text(post.username),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.content),
                  _buildMediaInfo(post),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () =>
                    _showDeleteConfirmation(context, () => _deletePost(index)),
              ),
              children: [
                ...post.comments.asMap().entries.map((entry) {
                  final commentIndex = entry.key;
                  final comment = entry.value;
                  return ListTile(
                    title: Text(comment.username),
                    subtitle: Text(comment.content),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _showDeleteConfirmation(
                        context,
                        () => _deleteComment(index, commentIndex),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.green),
          ),
        ],
      ),
    );
  }
}
