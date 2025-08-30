import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/auth/home_page.dart';
import 'package:flutter_application_2/features/products/presentions/pages/products_screen.dart';
import 'package:flutter_application_2/features/settings/presentions/pages/settings_screen.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  MainShell({super.key, required this.navigationShell});

  // int _currentIndex = 0;
  // final List<Widget> _pages = [
  //   const HomeScreen(),
  //   const ProductsScreen(),
  //   const SettingsScreen(),
  // ];
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });
  // }
  void _onItemTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: isIOS
          ? __buildCupertinoNavBar(context)
          : _buildMaterialNavBar(context),
    );
  }

  Widget _buildMaterialNavBar(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          activeIcon: Icon(Icons.shopping_bag),
          label: 'Products',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: navigationShell.currentIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 0.5,
      selectedItemColor: Colors.cyan[200],
      unselectedItemColor: Colors.grey[400],
      // selectedFontSize: 12,
      // unselectedFontSize: 10,
      // showSelectedLabels: true,
    );
  }

  Widget __buildCupertinoNavBar(BuildContext context) {
    return CupertinoTabBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.shopping_cart),
          label: 'Products',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.settings),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: navigationShell.currentIndex,
      onTap: (index) => _onItemTapped(index),
      activeColor: CupertinoColors.activeBlue,
      inactiveColor: CupertinoColors.inactiveGray,
    );
  }
}
