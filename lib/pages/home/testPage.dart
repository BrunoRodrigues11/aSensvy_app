import 'package:aSensvy/config/helper_functions.dart';
import 'package:aSensvy/config/theme.dart';
import 'package:aSensvy/pages/history/history.dart';
import 'package:aSensvy/pages/home/home.dart';
import 'package:aSensvy/pages/ia_verify/ia_verify.dart';
import 'package:aSensvy/pages/settings/settings.dart';
import 'package:aSensvy/pages/users/profile.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int index = 0;
  final screens = const [
    Home(),
    HistoryPage(),
    IaVerify(),
    SettingsPage(),
    ProfilePage(),
  ];

  GoToScreen goToScreen = GoToScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.blue.shade100,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child: NavigationBar(
          height: 60,
          backgroundColor: AppColors.primaryBgCard,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.access_time_outlined),
              selectedIcon: Icon(Icons.access_time_filled),
              label: 'Histórico',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_box_outlined),
              selectedIcon: Icon(Icons.add_box),
              label: 'Analisar',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Ajustes',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outlined),
              selectedIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
      // floatingActionButton: Theme(
      //   data: Theme.of(context).copyWith(
      //     floatingActionButtonTheme: const FloatingActionButtonThemeData(
      //       sizeConstraints: BoxConstraints.tightFor(height: 50, width: 50),
      //     ),
      //   ),
      //   child: FloatingActionButton(
      //     backgroundColor: AppColors.primaryColor,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(15),
      //     ),
      //     child: const Icon(Icons.add),
      //     onPressed: () {
      //       goToScreen.goToIAVerifyPage(context);
      //     },
      //   ),
      // ),
    );
  }
}
