import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class ArticleSubmissionState extends Equatable {
  final File? selectedImage;
  final String? message;

  const ArticleSubmissionState({this.selectedImage, this.message});

  @override
  List<Object?> get props => [selectedImage, message];
}

class ArticleSubmissionInitial extends ArticleSubmissionState {
  const ArticleSubmissionInitial();
}

class ArticleSubmissionLoading extends ArticleSubmissionState {
  const ArticleSubmissionLoading({super.selectedImage});
}

class ArticleImageSelected extends ArticleSubmissionState {
  const ArticleImageSelected(File imageFile) : super(selectedImage: imageFile);
}

class ArticleSubmissionSuccess extends ArticleSubmissionState {
  const ArticleSubmissionSuccess({super.message});
}

class ArticleSubmissionError extends ArticleSubmissionState {
  const ArticleSubmissionError(String message, {super.selectedImage}) : super(message: message);
}
