import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/check_server_status.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/server_status/server_status_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/DAO/article_dao.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/repository/article_repository_impl.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'features/daily_news/data/data_sources/local/app_database.dart';
import 'features/daily_news/domain/usecases/get_saved_article.dart';
import 'features/daily_news/domain/usecases/remove_article.dart';
import 'features/daily_news/domain/usecases/save_article.dart';
import 'features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';

// New imports for article submission feature
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/article_firebase_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/submit_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article_submission/article_submission_bloc.dart';


final sl = GetIt.instance;

Future<void> initializeDependencies() async {

  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  sl.registerSingleton<AppDatabase>(database);
  sl.registerSingleton<ArticleDao>(sl<AppDatabase>().articleDAO);
  
  // Dio & Firebase
  sl.registerSingleton<Dio>(Dio());
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  // Dependencies
  sl.registerSingleton<NewsApiService>(NewsApiService(sl()));
  sl.registerSingleton<ArticleFirebaseService>(ArticleFirebaseServiceImpl(sl<FirebaseFirestore>()));

  sl.registerSingleton<ArticleRepository>(
    ArticleRepositoryImpl(sl<NewsApiService>(), sl<ArticleDao>(), sl<ArticleFirebaseService>())
  );
  
  //UseCases
  sl.registerSingleton<GetArticleUseCase>(
    GetArticleUseCase(sl())
  );

  sl.registerSingleton<GetSavedArticleUseCase>(
    GetSavedArticleUseCase(sl())
  );

  sl.registerSingleton<SaveArticleUseCase>(
    SaveArticleUseCase(sl())
  );
  
  sl.registerSingleton<RemoveArticleUseCase>(
    RemoveArticleUseCase(sl())
  );

  sl.registerSingleton<SubmitArticleUseCase>( // New UseCase
    SubmitArticleUseCase(sl())
  );

  sl.registerSingleton<CheckServerStatusUseCase>(
    CheckServerStatusUseCase(sl())
  );


  //Blocs
  sl.registerFactory<RemoteArticlesBloc>(
    ()=> RemoteArticlesBloc(sl())
  );

  sl.registerFactory<LocalArticleBloc>(
    ()=> LocalArticleBloc(sl(),sl(),sl())
  );

  sl.registerFactory<ArticleSubmissionBloc>( // New BLoC
    ()=> ArticleSubmissionBloc(sl())
  );

  sl.registerFactory<ServerStatusBloc>(
    ()=> ServerStatusBloc(sl())
  );

}