import 'package:beauty_spa/views/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
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
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade300,
        elevation: 0,
        leading: IconButton(

          icon: const Icon(
            CupertinoIcons.back, 
            color: Colors.white,
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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pink.shade300, Colors.pink.shade100],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/images/profile.jpeg'),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Leslie Lane',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Text(
                      'Teacher',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Profile Options Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  buildOption(
                    icon: Icons.credit_card,
                    title: 'Payment Methods',
                  ),
                  buildOption(
                    icon: Icons.account_circle,
                    title: 'Account Information',
                  ),
                  const Divider(),
                  buildOption(
                    icon: Icons.notifications,
                    title: 'Notifications',
                  ),
                  buildOption(
                    icon: Icons.favorite,
                    title: 'Favorites',
                  ),
                  buildOption(
                    icon: Icons.settings,
                    title: 'Settings',
                  ),
                  const Divider(),
                  buildOption(
                    icon: Icons.message,
                    title: 'Messages',
                  ),
                  buildOption(
                    icon: Icons.star,
                    title: 'Achievements',
                  ),
                  buildOption(
                    icon: Icons.check_circle,
                    title: 'To-Do List',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                '© 2024 Beauty Mia | miabeauty@gmail.com',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOption({
    required IconData icon,
    required String title,
  }) {
    return MouseRegion(
      onEnter: (_) {},
      onExit: (_) {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: Icon(icon, color: Colors.pink.shade400),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.pink.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tileColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          horizontalTitleGap: 8,
          hoverColor: Colors.pink.shade50,
          onTap: () {
          },
        ),
      ),
    );
  }
}
