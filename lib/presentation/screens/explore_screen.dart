import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ELA/core/services/shared_preferences_service.dart';
import 'explore_admin_page.dart';

class VideoData {
  final String id;
  final String url;
  int likeCount;
  bool isLiked;
  bool isSaved;
  List<String> comments;

  VideoData({
    required this.id,
    required this.url,
    this.likeCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    List<String>? comments,
  }) : comments = comments ?? [];

  String get _likeKey => 'like_$url';
  String get _likeCountKey => 'like_count_$url';
  String get _saveKey => 'save_$url';
  String get _commentsKey => 'comments_$url';

  Future<void> saveState() async {
    final prefs = await SharedPreferencesService.getInstance();
    await prefs.setBool(_likeKey, isLiked);
    await prefs.setInt(_likeCountKey, likeCount);
    await prefs.setBool(_saveKey, isSaved);
    await prefs.setStringList(_commentsKey, comments);
  }

  Future<void> loadState() async {
    final prefs = await SharedPreferencesService.getInstance();
    isLiked = prefs.getBool(_likeKey) ?? false;
    likeCount = prefs.getInt(_likeCountKey) ?? 0;
    isSaved = prefs.getBool(_saveKey) ?? false;
    comments = prefs.getStringList(_commentsKey) ?? [];
  }
}

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  PageController _pageController = PageController();
  bool _isTrendingSelected = true;
  bool _isAdmin = false;
  List<VideoData> videos = [
    VideoData(
      id: '1',
      url:
          'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-dandelion-1222-large.mp4',
    ),
    VideoData(
      id: '2',
      url:
          'https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-flowers-1173-large.mp4',
    ),
    VideoData(
      id: '3',
      url:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    ),
    VideoData(
      id: '4',
      url:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ),
    VideoData(
      id: '5',
      url:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadVideoStates();
    _checkAdminStatus();
  }

  Future<void> _loadVideoStates() async {
    for (var video in videos) {
      await video.loadState();
    }
    setState(() {});
  }

  Future<void> _checkAdminStatus() async {
    final prefs = await SharedPreferencesService.getInstance();
    setState(() {
      _isAdmin = prefs.getBool('is_admin') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            itemCount: videos.length,
            itemBuilder: (context, index) {
              return VideoWidget(videoUrl: videos[index].url);
            },
          ),
          _buildTopBar(),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildTopBarButton('Trending', isSelected: _isTrendingSelected),
                _buildTopBarButton('Saved', isSelected: !_isTrendingSelected),
              ],
            ),
            if (_isAdmin)
              IconButton(
                icon:
                    const Icon(Icons.admin_panel_settings, color: Colors.white),
                onPressed: () => _navigateToAdminPage(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBarButton(String text, {required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isTrendingSelected = text == 'Trending';
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    int currentIndex =
        _pageController.hasClients ? (_pageController.page?.round() ?? 0) : 0;
    VideoData currentVideo = videos[currentIndex];

    return Positioned(
      bottom: 16.0,
      right: 16.0,
      child: Column(
        children: [
          _buildActionButton(
            currentVideo.isLiked ? Icons.favorite : Icons.favorite_border,
            currentVideo.likeCount.toString(),
            () => _toggleLike(currentVideo),
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            Icons.comment,
            currentVideo.comments.length.toString(),
            () => _showCommentDialog(currentIndex),
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            Icons.share,
            'Share',
            () => _shareVideo(currentIndex),
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            currentVideo.isSaved ? Icons.bookmark : Icons.bookmark_border,
            'Save',
            () => _toggleSave(currentVideo),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  void _toggleLike(VideoData currentVideo) {
    setState(() {
      if (currentVideo.isLiked) {
        currentVideo.likeCount--;
      } else {
        currentVideo.likeCount++;
      }
      currentVideo.isLiked = !currentVideo.isLiked;
      currentVideo.saveState();
    });
  }

  void _toggleSave(VideoData currentVideo) {
    setState(() {
      currentVideo.isSaved = !currentVideo.isSaved;
      currentVideo.saveState();
    });
  }

  void _showCommentDialog(int videoIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newComment = '';
        return AlertDialog(
          title: const Text('Comments'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: videos[videoIndex].comments.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(videos[videoIndex].comments[index]),
                    );
                  },
                ),
              ),
              TextField(
                onChanged: (value) {
                  newComment = value;
                },
                decoration: const InputDecoration(hintText: 'Add a comment'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Post'),
              onPressed: () {
                if (newComment.isNotEmpty) {
                  setState(() {
                    videos[videoIndex].comments.add(newComment);
                    videos[videoIndex].saveState();
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _shareVideo(int videoIndex) {
    Share.share('Check out this video: ${videos[videoIndex].url}');
  }

  void _navigateToAdminPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminPage(
          videos: videos,
          onAddVideo: (VideoData newVideo) {
            setState(() {
              videos.add(newVideo);
            });
          },
          onRemoveComment: (int videoIndex, int commentIndex) {
            setState(() {
              videos[videoIndex].comments.removeAt(commentIndex);
              videos[videoIndex].saveState();
            });
          },
        ),
      ),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String videoUrl;

  const VideoWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true)
      ..play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : const CircularProgressIndicator(),
    );
  }
}
