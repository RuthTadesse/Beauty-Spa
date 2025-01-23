import 'package:beauty_spa/views/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';
import '../views/authPages/login_page.dart';
import '../views/home/home_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/onboarding': (context) => const OnboardingScreen(),
    '/login': (context) => const LoginPage(),
    '/home': (context) => const HomePage(),
  };
}
