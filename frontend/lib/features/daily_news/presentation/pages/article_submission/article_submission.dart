import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/services.dart'; // Import for Clipboard
import '../../bloc/article_submission/article_submission_bloc.dart';
import '../../bloc/article_submission/article_submission_event.dart';
import '../../bloc/article_submission/article_submission_state.dart';
import 'package:news_app_clean_architecture/core/services/debug_service.dart';

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

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  void _submitArticle() {
    final debug = DebugService();
    debug.log('[ArticleSubmissionPage] _submitArticle called.');

    // --- IMMEDIATE FEEDBACK DIALOG ---
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Enviando..."),
              ],
            ),
          ),
        );
      },
    );

    // Short delay to ensure the dialog has time to render before potential heavy processing
    Future.delayed(const Duration(milliseconds: 100), () {
      debug.log('[ArticleSubmissionPage] _submitArticle - delayed logic started.');
      if (_formKey.currentState!.validate()) {
        debug.log('[ArticleSubmissionPage] Form is valid. Attempting to add SubmitArticle event to BLoC.');
        try {
          context.read<ArticleSubmissionBloc>().add(
                SubmitArticle(
                  title: _titleController.text,
                  content: _contentController.text,
                  author: _authorController.text,
                ),
              );
          debug.log('[ArticleSubmissionPage] SubmitArticle event added to BLoC. Closing dialog.');
          // Close the "Sending..." dialog
          Navigator.of(context).pop();

        } catch (e) {
          debug.log('[ArticleSubmissionPage] Error adding SubmitArticle event to BLoC: $e');
          // Close the "Sending..." dialog
          Navigator.of(context).pop();

          final String errorMessage = 'Ocurrió un error al intentar enviar el evento al BLoC: ${e.toString()}';

          // --- ERROR FEEDBACK DIALOG ---
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error Inmediato'),
                content: SelectableText(errorMessage), // Changed to SelectableText
                actions: [
                  TextButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: errorMessage));
                      Navigator.of(context).pop();
                    },
                    child: const Text('Copiar y Cerrar'), // Added Copy button
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cerrar'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        debug.log('[ArticleSubmissionPage] Form validation failed. Closing dialog.');
        // Close the "Sending..." dialog if validation fails
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit New Article'),
      ),
      body: BlocListener<ArticleSubmissionBloc, ArticleSubmissionState>(
          listener: (context, state) {
            if (state is ArticleSubmissionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message ?? 'Article submitted!')),
              );
              _titleController.clear();
              _contentController.clear();
              _authorController.clear();
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
                      if (state is ArticleSubmissionLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return ElevatedButton(
                        onPressed: _submitArticle,
                        child: const Text('Submit Article'),
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    'VERSIÓN DE PRUEBA: ${DateTime.now()}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
