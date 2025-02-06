import 'package:android_popular_git_repos/core/theme/app_theme.dart';
import 'package:android_popular_git_repos/core/theme/theme_provider.dart';
import 'package:android_popular_git_repos/features/home/presentation/widgets/common/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/home/presentation/pages/home_page.dart';
import '../features/home/presentation/pages/onboarding_page.dart';

class GitReposApp extends ConsumerStatefulWidget {
  const GitReposApp({super.key});

  @override
  ConsumerState<GitReposApp> createState() => _GitReposAppState();
}

class _GitReposAppState extends ConsumerState<GitReposApp> {
  bool _isLoading = true;
  bool _hasSeenOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  // Check if the user has seen the onboarding screens
  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    setState(() {
      _hasSeenOnboarding = hasSeenOnboarding;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    // Show a loading indicator while checking onboarding status
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CustomLoader(),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Popular GitRepos',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: _hasSeenOnboarding ? const HomePage() : const OnboardingPage(),
    );
  }
}