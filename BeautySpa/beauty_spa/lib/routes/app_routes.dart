import 'package:beauty_spa/views/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';
import '../views/home/login_page.dart';
// import '../views/onboarding/onboarding_page_2.dart';
// import '../views/onboarding/onboarding_page_3.dart';
import '../views/home/home_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/onboarding': (context) => const OnboardingScreen(),
    // '/onboarding2': (context) => const OnboardingPage2(),
    // '/onboarding3': (context) => const OnboardingPage3(),
    '/login': (context) => const LoginPage(),
    '/home': (context) => const HomePage(),
  };
}
