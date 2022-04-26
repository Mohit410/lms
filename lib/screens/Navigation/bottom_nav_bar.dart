import 'package:flutter/material.dart';
import 'package:lms/main.dart';
import 'package:lms/screens/Dashboard/dashboard_screen.dart';
import 'package:lms/screens/Home/home_screen.dart';
import 'package:lms/screens/Profile/profile_screen.dart';
import 'package:lms/services/authentication_service.dart';
import 'package:lms/utils/user_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';

class BottomNavPanel extends StatefulWidget {
  const BottomNavPanel({Key? key}) : super(key: key);

  @override
  State<BottomNavPanel> createState() => _BottomNavPanelState();
}

class _BottomNavPanelState extends State<BottomNavPanel> {
  int currentIndex = 0;
  final _widgteOptions = <Widget>[
    const HomeScreen(),
    DashboardScreen(),
    const ProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
    admin = UserPreferences.isAdmin();
    initPlateformState();
  }

  initPlateformState() async {
    await OneSignal.shared.setAppId(appId);
    await OneSignal.shared.disablePush(false);

    var deviceState = await OneSignal.shared.getDeviceState();

    if (deviceState != null && deviceState.userId != null) {
      var tokenId = deviceState.userId;
      await context.read<AuthenticationService>().saveTokenToDatabase(tokenId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Library Management System",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.blue,
              elevation: 0,
              centerTitle: true,
            ),
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
                    icon: Icon(Icons.home_rounded),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard_rounded),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_rounded),
                    label: 'Profile',
                  )
                ]),
            body: IndexedStack(
              index: currentIndex,
              children: _widgteOptions,
            )));
  }
}
