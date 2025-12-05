import 'package:equatable/equatable.dart';

class ArticleSubmissionEntity extends Equatable {
  final String title;
  final String content;
  final String author;

  const ArticleSubmissionEntity({
    required this.title,
    required this.content,
    required this.author,
  });

  @override
  List<Object?> get props => [title, content, author];
}
