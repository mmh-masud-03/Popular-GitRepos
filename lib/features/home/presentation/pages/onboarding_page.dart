import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/onboarding/onboarding_screen.dart';
import 'home_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with SingleTickerProviderStateMixin {
  final PageController _controller = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;
  bool _isLastPage = false;

  final List<Map<String, dynamic>> onboardingData = [
    {
      "title": "Welcome to Popular GitRepos!",
      "subtitle": "Explore the most popular Android repositories on GitHub, all in one place.",
      "image": "assets/images/github.png",
      "color": const Color(0xFF2196F3),
    },
    {
      "title": "Stay Updated Automatically",
      "subtitle": "Your data refreshes every 2 hours, so you always have the latest repositories at your fingertips.",
      "image": "assets/images/onboarding2.jpg",
      "color": const Color(0xFF4CAF50),
    },
    {
      "title": "Choose Your Style",
      "subtitle": "Switch between light and dark modes for a comfortable viewing experience, day or night.",
      "image": "assets/images/onboarding3.png",
      "color": const Color(0xFF9C27B0),
    },
    {
      "title": "Ready to Explore?",
      "subtitle": "Dive into the world of Android repositories and discover amazing projects.",
      "image": "assets/images/onboarding4.jpg",
      "color": const Color(0xFFFF5722),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            color: onboardingData[_currentPage]["color"].withOpacity(0.1),
            child: PageView.builder(
              controller: _controller,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                  _isLastPage = index == onboardingData.length - 1;
                });
                _animationController.reset();
                _animationController.forward();
              },
              itemBuilder: (context, index) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: OnboardingScreen(
                    title: onboardingData[index]["title"]!,
                    subtitle: onboardingData[index]["subtitle"]!,
                    image: onboardingData[index]["image"]!,
                  ),
                );
              },
            ),
          ),
          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: !_isLastPage
                ? TextButton(
              onPressed: _completeOnboarding,
              child: const Text("Skip"),
            )
                : const SizedBox.shrink(),
          ),
          // Bottom navigation
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: _controller,
                      count: onboardingData.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: onboardingData[_currentPage]["color"],
                        dotColor: Colors.grey.withOpacity(0.5),
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 8,
                      ),
                    ),
                    const SizedBox(height: 32),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _isLastPage
                          ? ElevatedButton(
                        onPressed: _completeOnboarding,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: onboardingData[_currentPage]["color"],
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          "Get Started",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )
                          : TextButton(
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: onboardingData[_currentPage]["color"],
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}