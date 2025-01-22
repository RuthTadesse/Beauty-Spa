import 'package:beauty_spa/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // For Cupertino icons

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display PNG image only
            Center(
              child: Image.asset(
                'assets/images/check.png', // Path to your PNG image
                width: 100,
                height: 100,
                fit: BoxFit.contain, // Ensures the image fits well
              ),
            ),

            const SizedBox(height: 24),
            // "Payment Successful!" text
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            // Subtext
            const Text(
              'Your booking has been successfully done',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            // Back to Home TextButton
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(), // Navigate to HomePage
                    ),
                    (route) => false, // Remove all previous routes
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFD66986),
                        Color(0xFFED9598),
                      ], // Gradient from #d66986 to #ed9598
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Ensures the row is compact
                    children: const [
                      Icon(
                        CupertinoIcons.back, // Cupertino back icon
                        color: Colors.white, // White to match the text
                        size: 20,
                      ),
                      SizedBox(
                          width: 8), // Spacing between the icon and the text
                      Text(
                        'Back to home',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
