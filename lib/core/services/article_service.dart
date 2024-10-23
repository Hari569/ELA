import '/models/article_model.dart';

class ArticleService {
  List<Article> _articles = [];

  Future<List<Article>> getArticles() async {
    // In a real app, this would fetch from a database or API
    return _articles;
  }

  Future<void> addArticle(Article article) async {
    _articles.add(article);
  }

  Future<void> updateArticle(Article article) async {
    final index = _articles.indexWhere((a) => a.id == article.id);
    if (index != -1) {
      _articles[index] = article;
    }
  }

  Future<void> removeArticle(String id) async {
    _articles.removeWhere((a) => a.id == id);
  }
}
