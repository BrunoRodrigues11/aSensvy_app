import 'package:aSensvy/config/theme.dart';
import 'package:aSensvy/pages/history/history.dart';
import 'package:aSensvy/pages/home/home.dart';
import 'package:aSensvy/pages/ia_verify/ia_verify.dart';
import 'package:aSensvy/pages/settings/settings.dart';
import 'package:aSensvy/pages/users/profile.dart';
import 'package:flutter/material.dart';

class InitHomePage extends StatefulWidget {
  int currentTab = 0;
  Widget currentScreen = const Home();
  InitHomePage(this.currentTab, this.currentScreen, {super.key});

  @override
  State<InitHomePage> createState() => _InitHomePageState();
}

class _InitHomePageState extends State<InitHomePage> {
  final List<Widget> screens = const [
    Home(),
    HistoryPage(),
    IaVerify(),
    SettingsPage(),
    ProfilePage(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.currentTab != 0) {
          // Se não estiver na guia inicial (Home), volte para a guia Home.
          setState(() {
            widget.currentScreen = screens[0];
            widget.currentTab = 0;
          });
          return false; // Evite que a tela seja fechada
        } else {
          return true; // Permita que o aplicativo seja fechado
        }
      },
      child: Scaffold(
        body: PageStorage(bucket: bucket, child: widget.currentScreen),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            setState(() {
              widget.currentScreen = const IaVerify();
              widget.currentTab = 4;
            });
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          widget.currentScreen = const Home();
                          widget.currentTab = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.currentTab == 0
                                ? Icons.home
                                : Icons.home_outlined,
                            color: widget.currentTab == 0
                                ? AppColors.primaryColor
                                : Colors.grey,
                          ),
                          Text(
                            'Home',
                            style: TextStyle(
                              color: widget.currentTab == 0
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          widget.currentScreen = const HistoryPage();
                          widget.currentTab = 1;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.currentTab == 1
                                ? Icons.access_time_filled_outlined
                                : Icons.access_time,
                            color: widget.currentTab == 1
                                ? AppColors.primaryColor
                                : Colors.grey,
                          ),
                          Text(
                            'Histórico',
                            style: TextStyle(
                              color: widget.currentTab == 1
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          widget.currentScreen = const SettingsPage();
                          widget.currentTab = 2;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.currentTab == 2
                                ? Icons.settings
                                : Icons.settings_outlined,
                            color: widget.currentTab == 2
                                ? AppColors.primaryColor
                                : Colors.grey,
                          ),
                          Text(
                            'Ajustes',
                            style: TextStyle(
                              color: widget.currentTab == 2
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          widget.currentScreen = const ProfilePage();
                          widget.currentTab = 3;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.currentTab == 3
                                ? Icons.person
                                : Icons.person_outlined,
                            color: widget.currentTab == 3
                                ? AppColors.primaryColor
                                : Colors.grey,
                          ),
                          Text(
                            'Perfil',
                            style: TextStyle(
                              color: widget.currentTab == 3
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
