import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '/models/plant_model.dart';

class GrowthTrackerScreen extends StatefulWidget {
  final Plant plant;

  GrowthTrackerScreen({required this.plant});

  @override
  _GrowthTrackerScreenState createState() => _GrowthTrackerScreenState();
}

class _GrowthTrackerScreenState extends State<GrowthTrackerScreen>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  String _growthSuggestion = '';
  late AnimationController _animationController;
  int _currentPhotoIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        setState(() {
          _currentPhotoIndex =
              (_currentPhotoIndex + 1) % widget.plant.growthPhotos.length;
        });
        _animationController.reset();
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        widget.plant.growthPhotos.add(GrowthPhoto(
          imagePath: photo.path,
          dateTaken: DateTime.now(),
        ));
      });
      _analyzeGrowth();
    }
  }

  Future<void> _generateTimeLapseVideo() async {
    if (widget.plant.growthPhotos.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Need at least 2 photos for time-lapse')),
      );
      return;
    }

    _currentPhotoIndex = 0;
    _animationController.forward();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Time-lapse Preview'),
          content: Container(
            width: 300,
            height: 300,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: Tween<double>(begin: 1.0, end: 0.0)
                      .animate(_animationController),
                  child: _buildImageWidget(
                      widget.plant.growthPhotos[_currentPhotoIndex]),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Stop'),
              onPressed: () {
                _animationController.stop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _analyzeGrowth() {
    if (widget.plant.growthPhotos.length < 2) {
      setState(() {
        _growthSuggestion = 'Take more photos to track growth over time.';
      });
      return;
    }

    // Calculate the time difference between the first and last photo
    final firstPhoto = widget.plant.growthPhotos.first;
    final lastPhoto = widget.plant.growthPhotos.last;
    final daysDifference =
        lastPhoto.dateTaken.difference(firstPhoto.dateTaken).inDays;

    setState(() {
      if (daysDifference < 7) {
        _growthSuggestion =
            'Your plant is still young. Keep watering regularly and ensure it gets enough sunlight.';
      } else if (daysDifference < 30) {
        _growthSuggestion =
            'Your plant is growing well. Consider adding fertilizer to boost growth.';
      } else {
        _growthSuggestion =
            'Your plant has been growing for a while. Prune any dead leaves and check if it needs repotting.';
      }
    });
  }

  Widget _buildImageWidget(GrowthPhoto photo) {
    if (kIsWeb) {
      // For web, use Image.network or Image.memory if you have a base64 string
      // Assuming you have a URL for the image, you can use Image.network.
      // Otherwise, you'll need to upload the image somewhere and use the URL.
      return Image.network(photo.imagePath, fit: BoxFit.cover);
    } else {
      // For non-web, use Image.file
      return Image.file(File(photo.imagePath), fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.plant.name} Growth Tracker'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.plant.growthPhotos.isEmpty
                ? const Center(child: Text('No growth photos yet'))
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: widget.plant.growthPhotos.length,
                    itemBuilder: (context, index) {
                      final photo = widget.plant.growthPhotos[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => Scaffold(
                              appBar: AppBar(
                                title: Text('Photo ${index + 1}'),
                                backgroundColor: Colors.black,
                              ),
                              body: Container(
                                color: Colors.black,
                                child: Center(
                                  child: _buildImageWidget(photo),
                                ),
                              ),
                            ),
                          ));
                        },
                        child: _buildImageWidget(photo),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Growth Suggestion:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_growthSuggestion),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _takePhoto,
                        child: const Text('Take New Photo'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.plant.growthPhotos.isNotEmpty
                            ? _generateTimeLapseVideo
                            : null,
                        child: const Text('Generate Time-Lapse'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
