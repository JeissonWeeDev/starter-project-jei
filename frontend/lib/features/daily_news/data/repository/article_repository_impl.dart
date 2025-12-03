import 'dart:io';

import 'package:dio/dio.dart'; // Keep original import, but use DioException
import 'package:news_app_clean_architecture/core/constants/constants.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/app_database.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_submission.dart'; // Import the new entity

import '../data_sources/remote/news_api_service.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;
  final AppDatabase _appDatabase;
  // We will add FirebaseArticleApiService later, when implementing the real data layer.
  // final FirebaseArticleApiService _firebaseArticleApiService;

  ArticleRepositoryImpl(this._newsApiService, this._appDatabase); // Constructor for mock

  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
   try {
    final httpResponse = await _newsApiService.getNewsArticles(
      apiKey:newsAPIKey,
      country:countryQuery,
      category:categoryQuery,
    );

    if (httpResponse.response.statusCode == HttpStatus.ok) {
      return DataSuccess(httpResponse.data);
    } else {
      // Use DioException and DioExceptionType.badResponse for dio 5.x
      return DataFailed(
        DioException( // Changed from DioError
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          type: DioExceptionType.badResponse, // Changed from DioErrorType.response
          requestOptions: httpResponse.response.requestOptions
        )
      );
    }
   } on DioException catch(e){ // Changed from DioError
    return DataFailed(e);
   }
  }

  @override
  Future<List<ArticleModel>> getSavedArticles() async {
    return _appDatabase.articleDAO.getArticles();
  }

  @override
  Future<void> removeArticle(ArticleEntity article) {
    return _appDatabase.articleDAO.deleteArticle(ArticleModel.fromEntity(article));
  }

  @override
  Future<void> saveArticle(ArticleEntity article) {
    return _appDatabase.articleDAO.insertArticle(ArticleModel.fromEntity(article));
  }
  
  // Mock implementation for article submission
  @override
  Future<DataState<void>> submitArticle(ArticleSubmissionEntity article) async {
    // Simulate a successful submission after a delay
    await Future.delayed(const Duration(seconds: 2));
    print('Mock: Article submitted successfully!');
    print('Mock Data: Title: ${article.title}, Content: ${article.content}, Author: ${article.author}, Image: ${article.imageUrl}');
    return const DataSuccess(null);
  }
}