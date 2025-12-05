import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class ArticleSubmissionEvent extends Equatable {
  const ArticleSubmissionEvent();

  @override
  List<Object?> get props => [];
}

class SubmitArticle extends ArticleSubmissionEvent {
  final String title;
  final String content;
  final String author;
  final File? imageFile;

  const SubmitArticle({
    required this.title,
    required this.content,
    required this.author,
    this.imageFile,
  });

  @override
  List<Object?> get props => [title, content, author, imageFile];
}

class SelectImage extends ArticleSubmissionEvent {
  final File? imageFile;

  const SelectImage(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}
