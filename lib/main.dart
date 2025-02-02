import 'package:android_popular_git_repos/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Popular GitRepos',
      theme: AppTheme.lightTheme,
      home: Scaffold(),
    );
  }
}

