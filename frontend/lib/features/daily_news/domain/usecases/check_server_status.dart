import '../../../../../core/resources/data_state.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repository/article_repository.dart';

class CheckServerStatusUseCase implements UseCase<DataState<void>, void> {
  final ArticleRepository _articleRepository;

  CheckServerStatusUseCase(this._articleRepository);

  @override
  Future<DataState<void>> call({void params}) {
    return _articleRepository.checkServerStatus();
  }
}
