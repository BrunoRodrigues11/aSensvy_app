import 'package:apptesteapi/pages/history/history.dart';
import 'package:apptesteapi/pages/home/home.dart';
import 'package:flutter/material.dart';

class NavbarHome extends StatefulWidget {
  const NavbarHome({super.key});

  @override
  State<NavbarHome> createState() => _NavbarHomeState();
}

class _NavbarHomeState extends State<NavbarHome> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Color(0xff0095FF),
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary), 
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: (){
                    _homePage(context, Home());
                  }, 
                ), 
                IconButton(
                  icon: Icon(Icons.list),
                  onPressed: (){
                    _homePage(context, HistoryPage());
                  }, 
                ),
                SizedBox(
                  width: 24,
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: (){
                    // _settingsPage(context, page)
                  }, 
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: (){
                    // _profilePage(context, page);
                  }, 
                ),
              ],
            ),
          ),
        ),
    );
  }

  _homePage(ctx, page) {
    Navigator.pushReplacement(ctx, MaterialPageRoute(builder: ((context) => page)));
  }
  _historyPage(ctx, page) {
    Navigator.pushReplacement(ctx, MaterialPageRoute(builder: ((context) => page)));
  }

  _settingsPage(ctx, page) {
    Navigator.pushReplacement(ctx, MaterialPageRoute(builder: ((context) => page)));
  }  

  _profilePage(ctx, page) {
    Navigator.pushReplacement(ctx, MaterialPageRoute(builder: ((context) => page)));
  }
}