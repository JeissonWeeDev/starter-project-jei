import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_submission.dart';

class ArticleSubmissionModel extends ArticleSubmissionEntity {
  const ArticleSubmissionModel({
    required super.title,
    required super.content,
    required super.author,
  });

  factory ArticleSubmissionModel.fromEntity(ArticleSubmissionEntity entity) {
    return ArticleSubmissionModel(
      title: entity.title,
      content: entity.content,
      author: entity.author,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'author': author,
      'publishedAt': FieldValue.serverTimestamp(),
    };
  }
}
