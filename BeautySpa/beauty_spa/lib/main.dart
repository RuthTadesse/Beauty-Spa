import 'package:beauty_spa/views/beauty_booking.dart';
import 'package:beauty_spa/views/authPages/SignUp.dart';
import 'package:beauty_spa/views/authPages/login_page.dart';
import 'package:beauty_spa/views/successPage.dart';
import 'package:beauty_spa/views/onboarding/onboarding_page.dart';
import 'package:beauty_spa/views/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../views/home/home_page.dart';
import 'views/appointment.dart';
import './views/splash/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  //for asynchronous activity flutter binding shound be initialized
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBi4uWZi0DL5fhyWJNaz-h3uIswvAwtdoI",
        authDomain: "beauty-spa-6dadf.firebaseapp.com",
        projectId: "beauty-spa-6dadf",
        storageBucket: "beauty-spa-6dadf.appspot.com",
        messagingSenderId: "1038778006767",
        appId: "1:1038778006767:web:876769cd4c8d57c35e6f1a",
        measurementId: "G-9HJ1GNV44E",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());

  // Test Firestore connectivity
  try {
    await FirebaseFirestore.instance.collection('test').add({
      'message': 'Firestore connection test',
      'timestamp': FieldValue.serverTimestamp(),
    });
    print('Firestore connection successful!');
  } catch (e) {
    print('Error connecting to Firestore: $e');
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stylist Booking App',
      theme: ThemeData(
        primarySwatch: Colors.grey, 
        scaffoldBackgroundColor: Colors.white, 
        primaryColor: Colors.grey[800],
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
            .copyWith(secondary: Colors.grey),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, 
          elevation: 0, 
          iconTheme: IconThemeData(color: Colors.black), 
        ),
        textTheme: const TextTheme(
            bodyMedium: TextStyle(
        color: Colors.black, 
        fontFamily: 'Montserrat', 
      ),
        ),
      ),
      home: SplashScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen (),
        '/home': (context) => const HomePage(),
        '/profile': (context) =>  ProfilePage(),
        '/login': (context) => const LoginPage(),
        '/appointment': (context) => const BookAppointmentPage(),
        '/booking': (context) => const AppointmentListPage(),
        '/success': (context) =>  SuccessPage(),
         '/signUp': (context) =>  SignUpPage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
