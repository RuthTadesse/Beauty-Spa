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
        fontFamily: 'Montserrat',
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
            color: Colors.black,
            fontFamily: 'Montserrat',
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
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 251, 251, 251),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
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
          _buildTabSelector(),
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 237, 122, 160)
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

  void _showEditDialog(
      BuildContext context, QueryDocumentSnapshot appointment) {
    if (!isUpcomingSelected) {
      return;
    }

    final _dateController = TextEditingController(text: appointment['date']);
    String? selectedSlot = appointment['slot'];

    const availableSlots = [
      '9:30-10:30 AM',
      '10:30-11:45 AM',
      '12:00-1:30 PM',
      '2:00-4:30 PM',
      '5:30-6:30 PM',
      '6:30-7:30 PM',
    ];

    showDialog(
      context: context,
      builder: (context) {
        bool isLoading = false; // Variable to track the loading state

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                "Edit Appointment",
                style: TextStyle(
                  color: Color.fromARGB(255, 196, 60, 105),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateFormat('MM/dd/yyyy')
                              .parse(appointment['date']),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          _dateController.text =
                              DateFormat('MM/dd/yyyy').format(pickedDate);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Select Time Slot',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableSlots.map((slot) {
                        final isSelected = slot == selectedSlot;
                        return ChoiceChip(
                          label: Text(
                            slot,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                selectedSlot = slot;
                              });
                            }
                          },
                          selectedColor: Colors.pinkAccent,
                          backgroundColor: Colors.grey[200],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (selectedSlot == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please select a time slot.")),
                            );
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          await FirebaseFirestore.instance
                              .collection('appointments')
                              .doc(appointment.id)
                              .update({
                            'date': _dateController.text,
                            'slot': selectedSlot,
                          });

                          setState(() {
                            isLoading = false;
                          });

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Appointment updated successfully!")),
                          );
                        },
                  child: isLoading
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text("Updating"),
                            SizedBox(width: 8),
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2,
                              ),
                            )
                          ],
                        )
                      : const Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Appointment Card
  Widget _buildAppointmentCard(QueryDocumentSnapshot appointment) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromARGB(255, 209, 207, 207).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Slot: ${appointment['slot']}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (isUpcomingSelected)
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.pinkAccent),
                  onPressed: () {
                    _showEditDialog(context, appointment);
                  },
                ),
            ],
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
