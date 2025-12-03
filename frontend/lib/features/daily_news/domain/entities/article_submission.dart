import 'package:equatable/equatable.dart';

class ArticleSubmissionEntity extends Equatable {
  final String title;
  final String content;
  final String author;
  final String? imageUrl; // Optional image URL if an image is uploaded

  const ArticleSubmissionEntity({
    required this.title,
    required this.content,
    required this.author,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [title, content, author, imageUrl];
}
