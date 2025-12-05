import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/article_submission.dart';
import '../repository/article_repository.dart';
import 'package:news_app_clean_architecture/core/services/debug_service.dart';

class SubmitArticleUseCase implements UseCase<DataState<void>, ArticleSubmissionEntity> {
  final ArticleRepository _articleRepository;

  SubmitArticleUseCase(this._articleRepository);

  @override
  Future<DataState<void>> call({ArticleSubmissionEntity? params}) async {
    final debug = DebugService();
    debug.log('[SubmitArticleUseCase] call method executed.');

    if (params == null) {
      debug.log('[SubmitArticleUseCase] Error: ArticleSubmissionEntity is null.');
      throw ArgumentError('ArticleSubmissionEntity cannot be null for SubmitArticleUseCase');
    }
    debug.log('[SubmitArticleUseCase] Received params: $params');
    debug.log('[SubmitArticleUseCase] Calling _articleRepository.submitArticle...');
    final result = await _articleRepository.submitArticle(params);
    debug.log('[SubmitArticleUseCase] _articleRepository.submitArticle returned DataState: ${result.runtimeType}');
    return result;
  }
}
