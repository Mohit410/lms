import 'package:flutter/material.dart';
import 'package:lms/utils/constants.dart';
import 'package:lms/screens/Home/home_screen.dart';
import 'package:lms/screens/Notification/notification_screen.dart';
import 'package:lms/screens/Profile/profile_screen.dart';
import 'package:lms/utils/user_preferences.dart';

class BottomNavPanel extends StatefulWidget {
  const BottomNavPanel({Key? key}) : super(key: key);

  @override
  State<BottomNavPanel> createState() => _BottomNavPanelState();
}

class _BottomNavPanelState extends State<BottomNavPanel> {
  int currentIndex = 0;
  final _widgteOptions = <Widget>[
    const HomeScreen(),
    const NotificationScreen(),
    const ProfileScreen()
  ];

  final _appBarWidget = <Widget>[
    const Text("Home"),
    const Text("Notification"),
    const Text("Profile")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child:
                  IndexedStack(children: _appBarWidget, index: currentIndex)),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        floatingActionButton: isAdmin()
            ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pushNamed(context, addBookRoute);
                },
                label: const Text('Add a book'),
                icon: const Icon(Icons.add_rounded),
                backgroundColor: Colors.blue,
              )
            : null,
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.blue,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            currentIndex: currentIndex,
            showUnselectedLabels: false,
            onTap: (index) => setState(() => currentIndex = index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notification',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              )
            ]),
        body: IndexedStack(
          index: currentIndex,
          children: _widgteOptions,
        ));
  }
}
