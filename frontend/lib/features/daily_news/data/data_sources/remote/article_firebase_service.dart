import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article_submission.dart';
import 'package:news_app_clean_architecture/core/services/debug_service.dart';

abstract class ArticleFirebaseService {
  Future<void> submitArticle(ArticleSubmissionModel article);
  Future<void> checkConnection();
}

class ArticleFirebaseServiceImpl implements ArticleFirebaseService {
  final FirebaseFirestore _firestore;

  ArticleFirebaseServiceImpl(this._firestore);

  @override
  Future<void> submitArticle(ArticleSubmissionModel article) async {
    final debug = DebugService();
    debug.log('[ArticleFirebaseServiceImpl] submitArticle called with model: $article');
    try {
      debug.log('[ArticleFirebaseServiceImpl] Attempting to add article to Firestore...');
      await _firestore.collection('articles').add(article.toFirestore());
      debug.log('[ArticleFirebaseServiceImpl] Article added to Firestore successfully.');
    } catch (e) {
      debug.log('[ArticleFirebaseServiceImpl] Error adding article to Firestore: $e');
      // In a real app, you would handle this error more gracefully
      // For this test, rethrowing is sufficient to indicate failure.
      rethrow;
    }
  }

  @override
  Future<void> checkConnection() {
    // Attempt to get a document that doesn't exist.
    // If this throws a FirebaseException (e.g. permission-denied, unavailable),
    // it will be caught by the repository. If it completes, the connection is OK.
    return _firestore.collection('health-check').doc('ping').get();
  }
}
