import 'package:flutter/material.dart';
import 'package:ELA/models/post_model.dart';
import 'package:ELA/data/repositories/post_repository.dart';
import 'package:ELA/utils/image_picker_utils.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'community_admin_page.dart';
import 'package:ELA/core/services/shared_preferences_service.dart';

// Conditional imports
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show File;
import 'package:ELA/utils/web_utils.dart'
    if (dart.library.io) 'mock_web_utils.dart';

class ElaCommunityScreen extends StatefulWidget {
  final bool isAdmin;
  const ElaCommunityScreen({Key? key, this.isAdmin = false}) : super(key: key);

  @override
  _ElaCommunityScreenState createState() => _ElaCommunityScreenState();
}

class _ElaCommunityScreenState extends State<ElaCommunityScreen> {
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

  Future<void> _savePosts() async {
    await _postRepository.savePosts(posts);
  }

  void _addNewPost(String content, {String? imageData, String? videoData}) {
    setState(() {
      posts.insert(
        0,
        Post(
          username: 'CurrentUser', // Replace with actual current user's name
          content: content,
          imagePath: imageData,
          videoPath: videoData,
        ),
      );
    });
    _savePosts();
  }

  void _likePost(int index) {
    setState(() {
      posts[index].likes++;
    });
    _savePosts();
  }

  void _addComment(int index, String content) {
    setState(() {
      posts[index].comments.add(
            Comment(
              username:
                  'CurrentUser', // Replace with actual current user's name
              content: content,
            ),
          );
    });
    _savePosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ELA Community'),
        backgroundColor: Colors.green,
        actions: [
          FutureBuilder<bool>(
            future: SharedPreferencesService.getInstance()
                .then((prefs) => prefs.getBool('is_admin') ?? false),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return IconButton(
                  icon: const Icon(Icons.admin_panel_settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ElaAdminScreen()),
                    );
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildCommunityHeader(),
              _buildPostList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewPostDialog(context),
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildCommunityHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.green.shade50,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to the ELA Community!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Share your plant care tips, ask questions, and connect with fellow plant enthusiasts.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildPostList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      post.username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDateTime(post.createdAt),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(post.content),
                if (post.imagePath != null || post.videoPath != null) ...[
                  const SizedBox(height: 8),
                  _buildMediaContent(post),
                ],
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '${post.likes} likes • ${post.comments.length} comments'),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.thumb_up_outlined),
                          onPressed: () => _likePost(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.comment_outlined),
                          onPressed: () => _showCommentDialog(context, index),
                        ),
                      ],
                    ),
                  ],
                ),
                if (post.comments.isNotEmpty) ...[
                  const Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: post.comments.length,
                    itemBuilder: (context, commentIndex) {
                      final comment = post.comments[commentIndex];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  comment.username,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _formatDateTime(comment.createdAt),
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12),
                                ),
                              ],
                            ),
                            Text(comment.content),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMediaContent(Post post) {
    if (post.videoPath != null) {
      return _VideoPlayerWidget(videoPath: post.videoPath!);
    } else if (post.imagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: kIsWeb
            ? Image.network(
                post.imagePath!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            : ImagePickerUtils.buildImage(
                post.imagePath!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
      );
    }
    return const SizedBox.shrink();
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showNewPostDialog(BuildContext context) {
    final textController = TextEditingController();
    String? selectedImageData;
    String? selectedVideoData;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create a New Post'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: textController,
                  decoration:
                      const InputDecoration(hintText: 'What\'s on your mind?'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final imageData = await ImagePickerUtils.pickImage();
                        setState(() {
                          selectedImageData = imageData;
                          selectedVideoData = null;
                        });
                      },
                      icon: const Icon(Icons.image, size: 18),
                      label: const Text('Add Picture'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.video,
                        );
                        if (result != null) {
                          setState(() {
                            if (kIsWeb) {
                              // For web, we'll store the data URL
                              final bytes = result.files.single.bytes!;
                              selectedVideoData = WebUtils.createBlobUrl(bytes);
                            } else {
                              selectedVideoData = result.files.single.path;
                            }
                            selectedImageData = null;
                          });
                        }
                      },
                      icon: const Icon(Icons.video_library, size: 18),
                      label: const Text('Add Video'),
                    ),
                  ],
                ),
                if (selectedImageData != null) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: kIsWeb
                        ? Image.network(
                            selectedImageData!,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : ImagePickerUtils.buildImage(
                            selectedImageData!,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
                if (selectedVideoData != null) ...[
                  const SizedBox(height: 8),
                  const Text('Video selected'),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  _addNewPost(
                    textController.text,
                    imageData: selectedImageData,
                    videoData: selectedVideoData,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentDialog(BuildContext context, int postIndex) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add a Comment'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: 'Write your comment...'),
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                _addComment(postIndex, textController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Comment'),
          ),
        ],
      ),
    );
  }
}

class _VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const _VideoPlayerWidget({required this.videoPath});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    if (kIsWeb) {
      _videoPlayerController = VideoPlayerController.network(widget.videoPath);
    } else {
      _videoPlayerController =
          VideoPlayerController.file(File(widget.videoPath));
    }

    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      placeholder: Center(child: CircularProgressIndicator()),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _chewieController != null &&
            _chewieController!.videoPlayerController.value.isInitialized
        ? Chewie(controller: _chewieController!)
        : Container(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
