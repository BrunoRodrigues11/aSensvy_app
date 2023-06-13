import 'package:flutter/material.dart';

class NavbarHome extends StatefulWidget {
  const NavbarHome({super.key});

  
  @override
  State<NavbarHome> createState() => _NavbarHomeState();
}

class _NavbarHomeState extends State<NavbarHome> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
				currentIndex: 0,
        items: const [
           BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Minha conta"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket),
              label: "Meus pedidos"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favoritos"
          ),
        ],
      );
  }
}