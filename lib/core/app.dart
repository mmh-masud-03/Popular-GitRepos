
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:popular_git_repo/core/theme/app_theme.dart';
import 'package:popular_git_repo/core/theme/theme_provider.dart';
import 'package:popular_git_repo/features/home/presentation/pages/home_page.dart';

import '../features/home/presentation/pages/onboarding_page.dart';

class GitReposApp extends ConsumerStatefulWidget {
  const GitReposApp({super.key});

  @override
  ConsumerState<GitReposApp> createState() => _GitReposAppState();
}

class _GitReposAppState extends ConsumerState<GitReposApp> {
  bool _isLoading = true;




  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    // Show a loading indicator while checking onboarding status
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Popular GitRepos',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const HomePage() ,
    );
  }
}