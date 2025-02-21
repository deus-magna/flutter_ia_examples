import 'package:flutter/material.dart';
import 'package:flutter_ia_translator/chat_screen.dart';
import 'package:flutter_ia_translator/home_screen.dart';
import 'package:flutter_ia_translator/story_telling_screen.dart';
import 'package:flutter_ia_translator/temperature_controller.dart';
import 'package:flutter_ia_translator/translator_screen.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => HomeScreen()),
      GoRoute(path: '/chat', builder: (context, state) => ChatScreen()),
      GoRoute(
        path: '/translator',
        builder: (context, state) => TranslatorScreen(),
      ),
      GoRoute(
        path: '/temp',
        builder: (context, state) => TemperatureController(),
      ),
      GoRoute(
        path: '/story',
        builder: (context, state) => StoryTellingScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter IA examples',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData.dark(),
    );
  }
}
