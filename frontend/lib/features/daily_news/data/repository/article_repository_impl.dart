import 'dart:io';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app_clean_architecture/core/constants/constants.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/DAO/article_dao.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/article_firebase_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_submission.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article_submission.dart';
import 'package:news_app_clean_architecture/core/services/debug_service.dart';

import '../data_sources/remote/news_api_service.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;
  final ArticleDao _articleDao;
  final ArticleFirebaseService _articleFirebaseService;

  ArticleRepositoryImpl(this._newsApiService, this._articleDao, this._articleFirebaseService);

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
      return DataFailed(
        DioException(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          type: DioExceptionType.badResponse,
          requestOptions: httpResponse.response.requestOptions
        )
      );
    }
   } on DioException catch(e){
    return DataFailed(e);
   }
  }

  @override
  Future<List<ArticleModel>> getSavedArticles() async {
    return _articleDao.getArticles();
  }

  @override
  Future<void> removeArticle(ArticleEntity article) {
    return _articleDao.deleteArticle(ArticleModel.fromEntity(article));
  }

  @override
  Future<void> saveArticle(ArticleEntity article) {
    return _articleDao.insertArticle(ArticleModel.fromEntity(article));
  }
  
  @override
  Future<DataState<void>> submitArticle(ArticleSubmissionEntity article) async {
    final debug = DebugService();
    debug.log('[ArticleRepositoryImpl] submitArticle called with entity: $article');
    try {
      debug.log('[ArticleRepositoryImpl] Converting ArticleSubmissionEntity to ArticleSubmissionModel...');
      final articleModel = ArticleSubmissionModel.fromEntity(article);
      debug.log('[ArticleRepositoryImpl] Calling _articleFirebaseService.submitArticle...');
      await _articleFirebaseService.submitArticle(articleModel);
      debug.log('[ArticleRepositoryImpl] _articleFirebaseService.submitArticle successful. Returning DataSuccess.');
      return const DataSuccess(null);
    } on FirebaseException catch (e) {
      debug.log('[ArticleRepositoryImpl] FirebaseException caught: ${e.message}');
      return DataFailed(
        DioException(
          error: e.message,
          requestOptions: RequestOptions(path: 'firestore'),
          type: DioExceptionType.unknown,
        ),
      );
    } catch (e) {
      debug.log('[ArticleRepositoryImpl] Generic exception caught: ${e.toString()}');
      return DataFailed(
        DioException(
          error: e.toString(),
          requestOptions: RequestOptions(path: 'firestore'),
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<DataState<void>> checkServerStatus() async {
    try {
      await _articleFirebaseService.checkConnection();
      return const DataSuccess(null);
    } on FirebaseException catch (e) {
      return DataFailed(
        DioException(
          error: e.message,
          requestOptions: RequestOptions(path: 'health-check'),
          type: DioExceptionType.connectionError,
        ),
      );
    }
  }
}