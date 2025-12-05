import 'package:bloc/bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/services/debug_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_submission.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/submit_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article_submission/article_submission_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article_submission/article_submission_state.dart';


class ArticleSubmissionBloc extends Bloc<ArticleSubmissionEvent, ArticleSubmissionState> {
  final SubmitArticleUseCase _submitArticleUseCase;

  ArticleSubmissionBloc(this._submitArticleUseCase) : super(const ArticleSubmissionInitial()) {
    on<SubmitArticle>(onSubmittedArticle);
  }

  void onSubmittedArticle(SubmitArticle event, Emitter<ArticleSubmissionState> emit) async {
    final debug = DebugService();
    debug.log('[ArticleSubmissionBloc] onSubmittedArticle called with event: ${event.runtimeType}');
    debug.log('[ArticleSubmissionBloc] Emitting ArticleSubmissionLoading state.');
    emit(const ArticleSubmissionLoading());
    try {
      final entity = ArticleSubmissionEntity(
        title: event.title,
        content: event.content,
        author: event.author,
      );
      debug.log('[ArticleSubmissionBloc] Created ArticleSubmissionEntity: $entity');

      debug.log('[ArticleSubmissionBloc] Calling SubmitArticleUseCase...');
      final dataState = await _submitArticleUseCase(params: entity);
      debug.log('[ArticleSubmissionBloc] SubmitArticleUseCase returned DataState: ${dataState.runtimeType}');


      if (dataState is DataSuccess) {
        debug.log('[ArticleSubmissionBloc] Emitting ArticleSubmissionSuccess state.');
        emit(const ArticleSubmissionSuccess(message: 'Article submitted successfully!'));
      }
      if (dataState is DataFailed) {
        debug.log('[ArticleSubmissionBloc] SubmitArticleUseCase failed. Emitting ArticleSubmissionError state.');
        // Make the error message more descriptive
        final errorMessage = dataState.error?.message ?? 'An unknown error occurred';
        emit(ArticleSubmissionError('Submission Failed: $errorMessage'));
      }
    } catch (e, stackTrace) {
      // This will catch any unexpected error during the process and display it in the UI.
      final errorMessage = 'Unexpected Error in ArticleSubmissionBloc: ${e.toString()}';
      debug.log('❌ $errorMessage');
      debug.log(stackTrace.toString());
      emit(ArticleSubmissionError(errorMessage));
    }
  }
}
