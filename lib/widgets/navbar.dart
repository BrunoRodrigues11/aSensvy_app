import 'package:aSensvy/pages/history/history.dart';
import 'package:aSensvy/pages/home/home.dart';
import 'package:aSensvy/pages/ia_verify/ia_verify.dart';
import 'package:aSensvy/pages/users/profile.dart';
import 'package:flutter/material.dart';

class NavbarHome extends StatefulWidget {
  const NavbarHome({super.key});

  @override
  State<NavbarHome> createState() => _NavbarHomeState();
}

class _NavbarHomeState extends State<NavbarHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: const Color(0xff034694),
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    _homePage(context, const Home());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.list),
                  onPressed: () {
                    _historyPage(context, const HistoryPage());
                  },
                ),
                const SizedBox(
                  width: 24,
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // _settingsPage(context, page)
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    _profilePage(context, const ProfilePage());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _homePage(ctx, page) {
    Navigator.pushReplacement(
        ctx, MaterialPageRoute(builder: ((context) => page)));
  }

  _historyPage(ctx, page) {
    Navigator.pushReplacement(
        ctx, MaterialPageRoute(builder: ((context) => page)));
  }

  _settingsPage(ctx, page) {
    Navigator.pushReplacement(
        ctx, MaterialPageRoute(builder: ((context) => page)));
  }

  _profilePage(ctx, page) {
    Navigator.pushReplacement(
        ctx, MaterialPageRoute(builder: ((context) => page)));
  }
}

class BtnIaVerify extends StatefulWidget {
  const BtnIaVerify({super.key});

  @override
  State<BtnIaVerify> createState() => _BtnIaVerifyState();
}

class _BtnIaVerifyState extends State<BtnIaVerify> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xff034694),
      onPressed: () {
        _iaVerifyPage(context, const IaVerify());
      },
      child: const Icon(Icons.add),
    );
  }

  _iaVerifyPage(ctx, page) {
    Navigator.pushReplacement(
        ctx, MaterialPageRoute(builder: ((context) => page)));
  }
}
