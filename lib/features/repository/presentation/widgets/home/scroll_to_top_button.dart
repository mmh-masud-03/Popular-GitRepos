// lib/features/home/presentation/widgets/scroll_to_top_button.dart
import 'package:flutter/material.dart';

class ScrollToTopButton extends StatelessWidget {
  final ScrollController scrollController;
  final Duration duration;
  final Curve curve;

  const ScrollToTopButton({
    super.key,
    required this.scrollController,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
  });

  void _scrollToTop() {
    scrollController.animateTo(
      0,
      duration: duration,
      curve: curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 200),
      offset: const Offset(0, 0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: 1.0,
        child: FloatingActionButton(
          onPressed: _scrollToTop,
          tooltip: 'Scroll to top',
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.arrow_upward),
        ),
      ),
    );
  }
}
