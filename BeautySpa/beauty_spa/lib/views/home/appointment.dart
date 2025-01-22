import 'package:beauty_spa/views/home/paymentPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({super.key});

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  String? selectedSlot;
  String? selectedSpecialist;
  String selectedCategory = 'Makeup';
  double Price = 0.0;
  double taxAmount = 0.0;
  double pricePerSlot = 0.0;

  final List<String> slots = [
    '9:30-10:30 AM',
    '10:30-11:45 AM',
    '12:00-1:30 PM',
    '2:00-4:30 PM',
    '5:30-6:30 PM',
    '6:30-7:30 PM',
  ];

  final Map<String, List<Map<String, String>>> specialists = {
    'Makeup': [
      {
        'name': 'Johan Deo',
        'image': 'assets/images/banner6.jpg',
        'price': '100'
      },
      {
        'name': 'Anny Roy',
        'image': 'assets/images/banner7.jpg',
        'price': '120'
      },
      {
        'name': 'Ruh Nexa',
        'image': 'assets/images/banner8.jpg',
        'price': '110'
      },
    ],
    'Styling': [
      {
        'name': 'Mia Flow',
        'image': 'assets/images/stylist1.jpg',
        'price': '130'
      },
      {
        'name': 'Lena Swift',
        'image': 'assets/images/stylist2.jpg',
        'price': '140'
      },
      {
        'name': 'Ella Grace',
        'image': 'assets/images/stylist3.jpg',
        'price': '150'
      },
    ],
    'Coloring': [
      {
        'name': 'Sophia Ray',
        'image': 'assets/images/coloring.jpg',
        'price': '120'
      },
      {
        'name': 'Olivia Bloom',
        'image': 'assets/images/coloring2.jpg',
        'price': '135'
      },
      {
        'name': 'Emma Luxe',
        'image': 'assets/images/coloring3.jpg',
        'price': '145'
      },
    ],
    'Waxing': [
      {
        'name': 'James King',
        'image': 'assets/images/shaving1.jpg',
        'price': '110'
      },
      {
        'name': 'Logan Pierce',
        'image': 'assets/images/shaving2.jpg',
        'price': '125'
      },
      {
        'name': 'Ethan Blake',
        'image': 'assets/images/shaving3.jpg',
        'price': '135'
      },
    ],
    'Haircut': [
      {
        'name': 'Aiden Cruz',
        'image': 'assets/images/haircut1.jpg',
        'price': '100'
      },
      {
        'name': 'Lucas Gray',
        'image': 'assets/images/haircut2.jpg',
        'price': '115'
      },
      {
        'name': 'Nathan Cole',
        'image': 'assets/images/haircut3.jpg',
        'price': '130'
      },
    ],
    'Massage': [
      {
        'name': 'Liam Stone',
        'image': 'assets/images/massage1.jpg',
        'price': '1231'
      },
      {
        'name': 'Oliver Hale',
        'image': 'assets/images/massage2.jpg',
        'price': '1650'
      },
      {
        'name': 'Henry Wells',
        'image': 'assets/images/massage3.jpg',
        'price': '1000'
      },
    ],
  };

  DateTime currentDate = DateTime.now();
  int selectedDay = DateTime.now().day;

  void _previousMonth() {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month - 1);
      selectedDay = 1;
    });
  }

  void _nextMonth() {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
      selectedDay = 1;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      selectedSpecialist = null;
      Price = 0.0;
      taxAmount = 0.0;
    });
  }

  void _updatePriceAndTax() {
    if (selectedSpecialist != null && selectedSlot != null) {
      double specialistPrice = double.parse(specialists[selectedCategory]!
          .firstWhere((specialist) =>
              specialist['name'] == selectedSpecialist)['price']!);

      Price = specialistPrice + pricePerSlot;
      taxAmount = Price * 0.15;
    }
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateTime(currentDate.year, currentDate.month + 1, 0).day;
    DateTime today = DateTime.now();

    String chooseSpecialistLabel = 'Choose ${selectedCategory} Specialist';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book Appointment',
          style: TextStyle(
            color: Colors.black, // Black text color
            fontFamily: 'Montserrat', // Custom Montserrat font
            fontWeight: FontWeight.w500, // Optional: Use bold weight
          ),
        ),
        backgroundColor:
            const Color.fromARGB(255, 251, 251, 251), 
        elevation: 0, 
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back, 
            color: Colors.black, 
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _previousMonth,
                  ),
                  Text(
                    DateFormat.yMMMM().format(currentDate),
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _nextMonth,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: List.generate(daysInMonth, (index) {
                  int day = index + 1;
                  bool isToday = day == today.day &&
                      currentDate.month == today.month &&
                      currentDate.year == today.year;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDay = day;
                      });
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selectedDay == day
                            ? Colors.pinkAccent
                            : isToday
                                ? Colors.blueAccent
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 12,
                          color: selectedDay == day || isToday
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                children: [
                  'Haircut',
                  'Styling',
                  'Massage',
                  'Makeup',
                  'Coloring',
                  'Waxing',
                ].map((category) {
                  return GestureDetector(
                    onTap: () => _onCategorySelected(category),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selectedCategory == category
                            ? Colors.pinkAccent.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selectedCategory == category
                              ? Colors.pinkAccent
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: selectedCategory == category
                              ? Colors.pinkAccent
                              : Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                chooseSpecialistLabel,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 81, 73, 73),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: (specialists[selectedCategory] ?? [])
                    .map<Widget>((specialist) {
                  bool isSelected = selectedSpecialist == specialist['name'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSpecialist = specialist['name'];
                        _updatePriceAndTax();
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image:
                                  AssetImage(specialist['image'] ?? 'assets'),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.pinkAccent
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          specialist['name'] ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color:
                                isSelected ? Colors.pinkAccent : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '\$${specialist['price']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              color: index < 4
                                  ? Colors.orange
                                  : Colors.grey.shade400,
                              size: 16,
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                'Select Time Slot',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 90, 80, 80),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(slots.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSlot = slots[index];
                        _updatePriceAndTax();
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3 - 16,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selectedSlot == slots[index]
                            ? Colors.pink.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selectedSlot == slots[index]
                              ? const Color.fromARGB(255, 244, 75, 131)
                              : const Color.fromARGB(255, 231, 176, 194)
                                  .withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        slots[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: selectedSlot == slots[index]
                              ? Colors.pinkAccent
                              : const Color.fromARGB(255, 71, 69, 69),
                          fontWeight: selectedSlot == slots[index]
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Total Price and Tax Field
              if (selectedSlot != null && selectedSpecialist != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // White background
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1), // Light shadow
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: const Offset(0, 3), // Slight downward offset
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '\$${(Price + taxAmount).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Color.fromARGB(255, 205, 163, 177),
                          height: 16,
                          thickness: 0.5, // Very thin line for subtlety
                          indent: 4,
                          endIndent: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Price:',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              '\$${Price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Tax:',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              '\$${taxAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              // Proceed to Payment Button
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to the PaymentPage and pass the required data
                    if (selectedSpecialist != null &&
                        selectedSlot != null &&
                        selectedCategory.isNotEmpty &&
                        selectedDay != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                            selectedSpecialist: selectedSpecialist!,
                            selectedSlot: selectedSlot!,
                            selectedCategory: selectedCategory,
                            selectedDate: DateFormat.yMd().format(
                              DateTime(currentDate.year, currentDate.month,
                                  selectedDay),
                            ),
                            price: Price,
                            tax: taxAmount,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please provide all details before proceeding.",
                            style: TextStyle(color: Colors.white), // Text color
                          ),
                          backgroundColor: Colors.red, // Background color
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFD66986),
                          Color(0xFFED9598),
                        ], // Gradient from #d66986 to #ed9598
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Text(
                      "Proceed To Payment", // Replace with your button text
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
