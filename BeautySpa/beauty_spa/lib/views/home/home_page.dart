import 'package:beauty_spa/views/beauty_booking.dart';
import 'package:beauty_spa/views/home/AdvertisementCard.dart';
import 'package:beauty_spa/views/home/appointment.dart';
import 'package:beauty_spa/views/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showAllSpecialists = false;
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(), // Replace with your actual HomePage content
    const BeautyBookingApp(), // Appointments Page
    ProfileApp(), // Profile Page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const Icon(Icons.menu, color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'Profile') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileApp()),
                  );
                } else if (value == 'Log Out') {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'Profile',
                  child: Row(
                    children: const [
                      Icon(Icons.person, color: Colors.pink),
                      SizedBox(width: 8),
                      Text('Profile'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Log Out',
                  child: Row(
                    children: const [
                      Icon(Icons.logout, color: Colors.pink),
                      SizedBox(width: 8),
                      Text('Log Out'),
                    ],
                  ),
                ),
              ],
              child: CircleAvatar(
                backgroundColor: Colors.pink.shade100,
                radius: 20,
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile.jpeg'),
                  radius: 18,
                ),
              ),
              offset: const Offset(
                  0, 50), // Makes dropdown open below the profile image.
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Banner Section
            _buildBanner(),

            const SizedBox(height: 20),

            // Categories Section (Row 1)
            _buildCategories(),

            const SizedBox(height: 15),

            // Hair Specialists Section (Row 2)
            _buildHairSpecialists(),

            BookingCard(),
            const SizedBox(height: 25),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // Banner Widget
  Widget _buildBanner() {
    final List<Map<String, String>> banners = [
      {
        'image': 'assets/images/banner1.jpeg',
        'title': 'Look Awesome \n& Save Some',
        'buttonText': 'GET UPTO 50% OFF',
      },
      {
        'image': 'assets/images/banner2.jpeg',
        'title': 'Style Your Hair \nwith Experts',
        'buttonText': 'BOOK NOW',
      },
      {
        'image': 'assets/images/banner3.jpeg',
        'title': 'Special Discounts \nOn All Services',
        'buttonText': 'GRAB THE DEAL',
      },
      {
        'image': 'assets/images/banner4.jpeg',
        'title': 'Your Perfect Stylist \nAwaits You',
        'buttonText': 'DISCOVER MORE',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        height: 180,
        child: PageView.builder(
          itemCount: banners.length,
          itemBuilder: (context, index) {
            final banner = banners[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      banner['image']!,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 30,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            banner['title']!,
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/appointment');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              banner['buttonText']!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Categories Widget (Row 1)
  Widget _buildCategories() {
    final List<Map<String, dynamic>> categories = [
      {'icon': CupertinoIcons.scissors, 'label': 'Haircut'},
      {'icon': CupertinoIcons.paintbrush, 'label': 'Styling'},
      {'icon': CupertinoIcons.wind, 'label': 'Massage'},
      {'icon': CupertinoIcons.drop_fill, 'label': 'Makeup'},
      {'icon': CupertinoIcons.leaf_arrow_circlepath, 'label': 'Hair Spa'},
      {'icon': CupertinoIcons.color_filter, 'label': 'Coloring'},
      {'icon': CupertinoIcons.person, 'label': 'Shaving'},
      {'icon': CupertinoIcons.heart_slash_circle, 'label': 'wax'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double itemWidth = constraints.maxWidth / 4;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: itemWidth / (itemWidth + 20),
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.pink[50],
                      radius: 28,
                      child: Icon(
                        category['icon'],
                        color: Colors.pinkAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      category['label'],
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Hair Specialists Section (Row 2)
  // Hair Specialists Section
  Widget _buildHairSpecialists() {
    final List<Map<String, String>> specialists = [
      {
        'name': 'Johan Deo',
        'phone': '889 756 8954',
        'image': 'assets/images/banner1.jpeg'
      },
      {
        'name': 'Anny Roy',
        'phone': '997 896 5446',
        'image': 'assets/images/banner2.jpeg'
      },
      {
        'name': 'Ruh Nex',
        'phone': '857 896 7646',
        'image': 'assets/images/banner3.jpeg'
      },
      {
        'name': 'Lara Smith',
        'phone': '786 234 5643',
        'image': 'assets/images/banner4.jpeg'
      },
      {
        'name': 'Sam K.',
        'phone': '912 678 2234',
        'image': 'assets/images/banner5.jpeg'
      },
    ];

    // Split the specialists list into two parts
    final List<Map<String, String>> firstRowSpecialists =
        specialists.take(3).toList();
    final List<Map<String, String>> secondRowSpecialists =
        specialists.skip(3).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Toggle Text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Our Specialists',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                child: Text(
                  _showAllSpecialists ? 'View Less' : 'View All',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.pinkAccent,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _showAllSpecialists = !_showAllSpecialists;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          // First Row of Specialists (Always Visible)
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3, // Always show 3 in the first row
              itemBuilder: (context, index) {
                return Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          firstRowSpecialists[index]['image']!,
                          height: 100,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        firstRowSpecialists[index]['name']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                );
              },
            ),
          ),

          // Second Row of Specialists (Visible when 'View All' is toggled)
          if (_showAllSpecialists)
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                    secondRowSpecialists.length, // Show remaining specialists
                itemBuilder: (context, index) {
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            secondRowSpecialists[index]['image']!,
                            height: 100,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          secondRowSpecialists[index]['name']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // Bottom Navigation Bar
// Bottom Navigation Bar
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      selectedItemColor: Colors.pinkAccent,
      unselectedItemColor: Colors.grey,
      currentIndex: 0, // Set the default selected tab index
      onTap: (index) {
        // Handle navigation to different pages
        switch (index) {
          case 0:
            // Stay on the HomePage
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BeautyBookingApp()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileApp()),
            );
            break;
          default:
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Appointments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
