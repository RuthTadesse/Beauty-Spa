import 'package:beauty_spa/views/home/appointment.dart';
import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEF), // Light Pink Background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFC0CB)), // Subtle Border
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Booking Title
          Text(
            'Book Your Appointment',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE91E63), // Deep Pink Text
                ),
          ),
          const SizedBox(height: 8),
          // Booking Description
          Text(
            'Schedule your appointment quickly and easily. Select a date and time that suits you best.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 16),
          // Book Now Button
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                // Navigate to the BookingPage when clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookAppointmentPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE91E63), // Deep Pink Button
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
