import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _logoFade;
  late Animation<Offset> _logoSlide;

  late AnimationController _taglineController;
  late Animation<double> _taglineFade;
  late Animation<Offset> _taglineSlide;

  @override
  void initState() {
    super.initState();

    // Logo animation controller
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _logoScale = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.2,
          end: 0.95,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.95,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 20,
      ),
    ]).animate(_logoController);

    _logoRotation = Tween<double>(begin: -0.03, end: 0.03).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticInOut),
    );

    _logoFade = CurvedAnimation(parent: _logoController, curve: Curves.easeIn);

    _logoSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    _logoController.forward();

    // Tagline animation
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _taglineFade = CurvedAnimation(
      parent: _taglineController,
      curve: Curves.easeIn,
    );
    _taglineSlide =
        Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
          CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
        );

    // Start tagline after logo finishes
    Future.delayed(const Duration(milliseconds: 2600), () {
      _taglineController.forward();
    });

    // Navigate after 6 seconds
    Timer(const Duration(seconds: 6), () {
      Navigator.pushReplacementNamed(context, "/welcome");
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1DD1A1), Color(0xFFE1FCF9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              SlideTransition(
                position: _logoSlide,
                child: FadeTransition(
                  opacity: _logoFade,
                  child: RotationTransition(
                    turns: _logoRotation,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: Image.asset(
                        "assets/logo.png",
                        height: 100, // slightly smaller for balance
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // App name typing animation
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 34, // slightly larger for clarity
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  fontFamily: 'NotoSerifSinhala',
                  letterSpacing: 1.2,
                ),
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  totalRepeatCount: 1,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      "වී සවිය",
                      speed: const Duration(milliseconds: 200),
                      cursor: '',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tagline
              FadeTransition(
                opacity: _taglineFade,
                child: SlideTransition(
                  position: _taglineSlide,
                  child: const Text(
                    "From Field to Market\nYour Agri-Mart Solution!",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                      height: 1.5, // better line spacing
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
