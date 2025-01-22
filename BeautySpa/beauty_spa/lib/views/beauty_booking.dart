import 'package:beauty_spa/views/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const BeautyBookingApp());
}

class BeautyBookingApp extends StatelessWidget {
  const BeautyBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat', // Apply Montserrat globally
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 251, 251, 251),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.black, // Black text color
            fontFamily: 'Montserrat', // Use Montserrat font
          ),
        ),
      ),
      home: const AppointmentListPage(),
    );
  }
}

class AppointmentListPage extends StatefulWidget {
  const AppointmentListPage({super.key});

  @override
  State<AppointmentListPage> createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  bool isUpcomingSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Bookings ',
          style: TextStyle(
            color: Colors.black, // Black text color
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 251, 251, 251),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back, // Replaced with Cupertino back icon
            color: Colors.black,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // Redirect to the HomePage if no route is found
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Tab Selector
          _buildTabSelector(),

          // Fetch and Display Appointments
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .orderBy('date', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Appointments Found'));
                }

                final allAppointments = snapshot.data!.docs;
                final now = DateTime.now();
                final displayedAppointments = allAppointments.where((doc) {
                  final date = DateFormat('MM/dd/yyyy').parse(doc['date']);
                  return isUpcomingSelected
                      ? date.isAfter(now)
                      : date.isBefore(now);
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: displayedAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = displayedAppointments[index];
                    return _buildAppointmentCard(appointment);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Tab Selector for Upcoming and History
  Widget _buildTabSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 19),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(238, 247, 247, 249),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align children vertically
          children: [
            Expanded(
              child: _tabButton("Upcoming", isUpcomingSelected),
            ),
            Expanded(
              child: _tabButton("History", !isUpcomingSelected),
            ),
          ],
        ),
      ),
    );
  }

// Tab Button
  Widget _tabButton(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isUpcomingSelected = title == "Upcoming";
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16), // Increased vertical padding for height
        margin:
            const EdgeInsets.only(left: 8), // Start button from leftmost edge
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(
                  255, 237, 122, 160) // Selected tab background color
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Appointment Card
  Widget _buildAppointmentCard(QueryDocumentSnapshot appointment) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white, // White background for a clean, fresh look
        borderRadius: BorderRadius.circular(16), // Rounded corners
        border: Border.all(
          color: const Color.fromARGB(255, 209, 207, 207)
              .withOpacity(0.3), // Light gray border
          width: 1, // Border thickness
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Slot: ${appointment['slot']}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Specialist: ${appointment['specialist']}",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Date: ${appointment['date']}",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Price: \$${appointment['price'].toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
              Text(
                "Tax: \$${appointment['tax'].toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                "Total: \$${appointment['total'].toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
