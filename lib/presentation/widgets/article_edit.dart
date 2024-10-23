import 'package:flutter/material.dart';
import '/models/article_model.dart';
import 'package:uuid/uuid.dart';

class ArticleEditForm extends StatefulWidget {
  final Article? article;

  ArticleEditForm({this.article});

  @override
  _ArticleEditFormState createState() => _ArticleEditFormState();
}

class _ArticleEditFormState extends State<ArticleEditForm> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _imageUrlController;
  late TextEditingController _readTimeController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.article?.title ?? '');
    _contentController =
        TextEditingController(text: widget.article?.content ?? '');
    _imageUrlController =
        TextEditingController(text: widget.article?.imageUrl ?? '');
    _readTimeController =
        TextEditingController(text: widget.article?.readTime ?? '5 min');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    _readTimeController.dispose();
    super.dispose();
  }

  void _saveArticle() {
    final article = Article(
      id: widget.article?.id ?? Uuid().v4(),
      title: _titleController.text,
      content: _contentController.text,
      imageUrl: _imageUrlController.text,
      readTime: _readTimeController.text,
      publishDate: widget.article?.publishDate ?? DateTime.now(),
    );

    Navigator.of(context).pop(article);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.article == null ? 'Add Article' : 'Edit Article'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            TextField(
              controller: _readTimeController,
              decoration: InputDecoration(labelText: 'Read Time'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveArticle,
          child: Text('Save'),
        ),
      ],
    );
  }
}
