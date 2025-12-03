import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article_submission/article_submission_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article_submission/article_submission_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article_submission/article_submission_state.dart';
import 'package:get_it/get_it.dart'; // For accessing BLoC via GetIt
import 'package:image_picker/image_picker.dart'; // For image picking
import 'dart:io'; // For File

class ArticleSubmissionPage extends StatefulWidget {
  const ArticleSubmissionPage({super.key});

  @override
  State<ArticleSubmissionPage> createState() => _ArticleSubmissionPageState();
}

class _ArticleSubmissionPageState extends State<ArticleSubmissionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  File? _imageFile; // To store the selected image file

  ArticleSubmissionBloc get _bloc => GetIt.instance<ArticleSubmissionBloc>();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
      _bloc.add(SelectImage(_imageFile));
    }
  }

  void _submitArticle() {
    if (_formKey.currentState!.validate()) {
      _bloc.add(
        SubmitArticle(
          title: _titleController.text,
          content: _contentController.text,
          author: _authorController.text,
          imageFile: _imageFile,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit New Article'),
      ),
      body: BlocProvider<ArticleSubmissionBloc>(
        create: (context) => _bloc, // Provide the BLoC
        child: BlocListener<ArticleSubmissionBloc, ArticleSubmissionState>(
          listener: (context, state) {
            if (state is ArticleSubmissionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message ?? 'Article submitted!')),
              );
              _titleController.clear();
              _contentController.clear();
              _authorController.clear();
              setState(() {
                _imageFile = null;
              });
              // Optionally navigate back
              // Navigator.pop(context);
            } else if (state is ArticleSubmissionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message ?? 'Submission failed!')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter article title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _contentController,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      labelText: 'Content',
                      hintText: 'Enter article content',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some content';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _authorController,
                    decoration: const InputDecoration(
                      labelText: 'Author',
                      hintText: 'Enter author name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter author name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  BlocBuilder<ArticleSubmissionBloc, ArticleSubmissionState>(
                    builder: (context, state) {
                      File? currentImage = _imageFile ?? state.selectedImage;
                      return Column(
                        children: [
                          if (currentImage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Image.file(
                                currentImage,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ElevatedButton.icon(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.image),
                            label: const Text('Pick Image'),
                          ),
                          if (state is ArticleSubmissionLoading)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          if (state is ArticleSubmissionError &&
                              state.selectedImage ==
                                  null) // Show error without image if image not selected
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                state.message ?? 'Error',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _submitArticle,
                    child: const Text('Submit Article'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
