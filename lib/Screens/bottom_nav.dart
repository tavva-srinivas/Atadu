import 'package:btr_chat/Screens/home_screen.dart';
import 'package:btr_chat/Screens/maps.dart';
import 'package:btr_chat/Screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../api/api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Nav Bar Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: BottomNavDemo(),
    );
  }
}

class BottomNavDemo extends StatefulWidget {
  @override
  _BottomNavDemoState createState() => _BottomNavDemoState();
}

class _BottomNavDemoState extends State<BottomNavDemo> {

  @override
  void initState() {
    API.get_self_info();
    print("me is initialised");
    super.initState();
  }
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Map_search(),
    Home_Screen(),
    Profile_Screen(user: API.me,),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
              gap: 8,
              activeColor: Colors.white,
              iconSize: 22, // Increased icon size
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Increased padding
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                  backgroundColor: Colors.indigo,
                ),
                GButton(
                  icon: Icons.chat,
                  text: 'Chat',
                  backgroundColor: Colors.pink,
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                  backgroundColor: Colors.deepPurple,
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              }),
        ),
      ),
    );
  }
}
//
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Home Screen'),
//     );
//   }
// }
//
// class ChatScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Chat Screen'),
//     );
//   }
// }
//
// class ProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Profile Screen'),
//     );
//   }
// }
