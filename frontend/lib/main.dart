/* -----------------------------------------------------------------------------*/
// Copyright (c) Jeisson Leon

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/config/routes/routes.dart';
import 'package:news_app_clean_architecture/core/services/debug_service.dart';
import 'package:news_app_clean_architecture/core/widgets/debug_console.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/home/daily_news.dart';
import 'config/theme/app_themes.dart';
import 'features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'features/daily_news/presentation/bloc/server_status/server_status_bloc.dart';
import 'features/daily_news/presentation/bloc/article_submission/article_submission_bloc.dart';
import 'injection_container.dart';

Future<void> main() async {
  final debug = DebugService();
  // Root try-catch to capture any unhandled exception during startup.
  try {
    debug.log('[MAIN] App starting...');

    debug.log('[MAIN] Initializing WidgetsFlutterBinding...');
    WidgetsFlutterBinding.ensureInitialized();
    debug.log('[MAIN] WidgetsFlutterBinding initialized.');

    debug.log('[MAIN] Initializing Firebase...');
    await Firebase.initializeApp();
    debug.log('[MAIN] Firebase initialized successfully.');

    // --- START OF TEMPORARY HARDCODED EMULATOR CONFIGURATION ---
    // User requested hardcoding IP for immediate debugging, as dynamic environment setup was causing issues.
    final String emulatorHost = '192.168.5.105'; // User's provided IP
    debug.log('[MAIN] Temporarily hardcoding Firestore Emulator host to: $emulatorHost');
    try {
      FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
      debug.log('[MAIN] ✅ Firestore emulator configured successfully using hardcoded IP.');
      // --- START OF Firestore emulator direct connection test ---
      debug.log('[MAIN] Attempting direct Firestore connection test...');
      try {
        await FirebaseFirestore.instance.collection('test_collection').doc('test_document').get();
        debug.log('[MAIN] ✅ Direct Firestore connection test successful.');
      } catch (e) {
        debug.log('[MAIN] ❌ Direct Firestore connection test failed: $e');
        debug.log('[MAIN] This indicates an immediate issue with Firestore emulator accessibility.');
      }
      // --- END OF Firestore emulator direct connection test ---
    } catch (e) {
      debug.log('[MAIN] ❌ Error setting up Firebase emulator with hardcoded IP: $e');
    }
    // --- END OF TEMPORARY HARDCODED EMULATOR CONFIGURATION ---

    debug.log('[MAIN] Initializing dependencies...');
    await initializeDependencies();
    debug.log('[MAIN] ✅ Dependencies initialized successfully.');

    debug.log('[MAIN] Running app...');
    runApp(const MyApp());

  } catch (e, stackTrace) {
    debug.log('[MAIN] ❌❌❌ FATAL STARTUP ERROR: $e');
    debug.log(stackTrace.toString());
  }
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});



  @override

  Widget build(BuildContext context) {

    return MultiBlocProvider(

      providers: [

        BlocProvider<RemoteArticlesBloc>(

          create: (context) => sl()..add(const GetArticles()),

        ),

                BlocProvider<ServerStatusBloc>(

                  create: (context) => sl()..add(const CheckServerStatus()),

                ),

                BlocProvider<ArticleSubmissionBloc>(

                  create: (context) => sl(),

                ),

              ],

      child: MaterialApp(

        debugShowCheckedModeBanner: false,

        theme: theme(),

        onGenerateRoute: AppRoutes.onGenerateRoutes,

        // The home property is now a Stack containing DailyNews and DebugConsole

        home: Builder( // Use Builder to get a context for ScaffoldMessenger

          builder: (context) {

            return BlocListener<ServerStatusBloc, ServerStatusState>(

              listener: (context, state) {

                final debug = DebugService();

                if (state is ServerStatusSuccess) {

                  debug.log(state.message);

                  ScaffoldMessenger.of(context)

                    ..hideCurrentSnackBar()

                    ..showSnackBar(

                      SnackBar(

                        content: Text(state.message),

                        backgroundColor: Colors.green,

                      ),

                    );

                }

                if (state is ServerStatusError) {

                  debug.log(state.message);

                  ScaffoldMessenger.of(context)

                    ..hideCurrentSnackBar()

                    ..showSnackBar(

                      SnackBar(

                        content: Text(state.message),

                        backgroundColor: Colors.red,

                      ),

                    );

                }

              },

              child: Stack(

                children: [

                  const DailyNews(), // Our main content

                  const DebugConsole(), // The floating debug console

                ],

              ),

            );

          }

        ),

      ),

    );

  }

}
