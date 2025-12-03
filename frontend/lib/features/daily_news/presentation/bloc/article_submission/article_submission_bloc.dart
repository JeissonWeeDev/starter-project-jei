import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_submission.dart'; // This file will be created later as per the plan
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/submit_article.dart'; // This file will be updated later as per the plan
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article_submission/article_submission_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article_submission/article_submission_state.dart';


class ArticleSubmissionBloc extends Bloc<ArticleSubmissionEvent, ArticleSubmissionState> {
  final SubmitArticleUseCase _submitArticleUseCase;

  ArticleSubmissionBloc(this._submitArticleUseCase) : super(const ArticleSubmissionInitial()) {
    on<SubmitArticle>(onSubmittedArticle);
    on<SelectImage>(onImageSelected);
  }

  File? _selectedImage; // Internal state for selected image

  void onImageSelected(SelectImage event, Emitter<ArticleSubmissionState> emit) {
    _selectedImage = event.imageFile;
    if (_selectedImage != null) {
      emit(ArticleImageSelected(_selectedImage!));
    } else {
      emit(const ArticleSubmissionInitial()); // Or a state indicating no image selected
    }
  }

  void onSubmittedArticle(SubmitArticle event, Emitter<ArticleSubmissionState> emit) async {
    print('onSubmittedArticle called with title: ${event.title}');
    emit(ArticleSubmissionLoading(selectedImage: _selectedImage));

    // We need to pass the current _selectedImage as part of the entity or separately if not part of entity
    final entity = ArticleSubmissionEntity(
      title: event.title,
      content: event.content,
      author: event.author,
      // For now, imageUrl will be null as the entity doesn't directly handle the local File
      // We will handle the image file upload logic in the data layer
      imageUrl: _selectedImage?.path, // Use the path of the selected image file
    );

    final dataState = await _submitArticleUseCase(params: entity);
    print('Use case returned: $dataState');

    if (dataState is DataSuccess) {
      print('Emitting ArticleSubmissionSuccess');
      emit(const ArticleSubmissionSuccess(message: 'Article submitted successfully!'));
      _selectedImage = null; // Clear selected image after successful submission
    }
    if (dataState is DataFailed) {
      print('Emitting ArticleSubmissionError');
      emit(ArticleSubmissionError(dataState.error.toString(), selectedImage: _selectedImage));
    }
  }
}
