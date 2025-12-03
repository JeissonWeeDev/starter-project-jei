import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/article_submission.dart';
import '../repository/article_repository.dart';

class SubmitArticleUseCase implements UseCase<DataState<void>, ArticleSubmissionEntity> {
  final ArticleRepository _articleRepository;

  SubmitArticleUseCase(this._articleRepository);

  @override
  Future<DataState<void>> call({ArticleSubmissionEntity? params}) {
    if (params == null) {
      throw ArgumentError('ArticleSubmissionEntity cannot be null for SubmitArticleUseCase');
    }
    return _articleRepository.submitArticle(params);
  }
}
