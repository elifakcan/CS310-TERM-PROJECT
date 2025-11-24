import 'package:flutter/material.dart';

class SwipeRecommendationPage extends StatefulWidget {
  const SwipeRecommendationPage({super.key});

  @override
  State<SwipeRecommendationPage> createState() =>
      _SwipeRecommendationPageState();
}

class _SwipeRecommendationPageState extends State<SwipeRecommendationPage> {
  static const creamColor = Color(0xFFFDF4E3);
  static const lightBlue = Color(0xFF5EA8D9);
  static const darkBlue = Color(0xFF234B73);

  Offset _cardOffset = Offset.zero;

  void _swipeLeft() {
    setState(() {
      _cardOffset = const Offset(-2, 0);
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() => _cardOffset = Offset.zero);
    });
  }

  void _swipeRight() {
    setState(() {
      _cardOffset = const Offset(2, 0);
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() => _cardOffset = Offset.zero);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),

              const Center(
                child: Text(
                  'FitSwipe',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 230,
                    height: 320,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.rotate(
                          angle: -0.12,
                          child: Container(
                            width: 220,
                            height: 310,
                            decoration: BoxDecoration(
                              color: darkBlue.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                        Transform.rotate(
                          angle: 0.12,
                          child: Container(
                            width: 220,
                            height: 310,
                            decoration: BoxDecoration(
                              color: lightBlue,
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                        AnimatedSlide(
                          offset: _cardOffset,
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOut,
                          child: Container(
                            width: 210,
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 40,
                    onPressed: _swipeLeft,
                    icon:
                        const Icon(Icons.close, color: darkBlue),
                  ),
                  const SizedBox(width: 40),
                  IconButton(
                    iconSize: 40,
                    onPressed: _swipeRight,
                    icon:
                        const Icon(Icons.favorite, color: darkBlue),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
