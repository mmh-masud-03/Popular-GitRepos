import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:popular_git_repo/features/home/presentation/pages/home_page.dart';

import '../widgets/onboarding/onboarding_screen.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Welcome to Popular GitRepos!",
      "subtitle": "Explore the most popular Android repositories on GitHub, all in one place.",
      "image": "assets/images/github.png",
    },
    {
      "title": "Stay Updated Automatically",
      "subtitle": "Your data refreshes every 2 hours, so you always have the latest repositories at your fingertips.",
      "image": "assets/images/onboarding2.jpg",
    },
    {
      "title": "Choose Your Style",
      "subtitle": "Switch between light and dark modes for a comfortable viewing experience, day or night.",
      "image": "assets/images/onboarding3.png",
    },
    {
      "title": "Ready to Explore?",
      "subtitle": "Dive into the world of Android repositories and discover amazing projects.",
      "image": "assets/images/onboarding4.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingScreen(
                title: onboardingData[index]["title"]!,
                subtitle: onboardingData[index]["subtitle"]!,
                image: onboardingData[index]["image"]!,
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: onboardingData.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.blue,
                    dotColor: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                _currentPage == onboardingData.length - 1
                    ? ElevatedButton(
                  onPressed: () async {
                    // Set onboarding status to true
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('hasSeenOnboarding', true);

                    // Navigate to HomePage
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    }
                  },
                  child: const Text("Get Started"),
                )
                    : TextButton(
                  onPressed: () {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text("Next"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

