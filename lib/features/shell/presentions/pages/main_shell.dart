import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

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
          ? _buildModernCupertinoNavBar(context)
          : _buildModernMaterialNavBar(context),
    );
  }

  Widget _buildModernMaterialNavBar(BuildContext context) {
    final primaryColor = Color(0xff010d88);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMaterialNavItem(
            context: context,
            index: 0,
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Home',
            color: primaryColor,
          ),
          _buildMaterialNavItem(
            context: context,
            index: 1,
            icon: Icons.shopping_bag_outlined,
            activeIcon: Icons.shopping_bag,
            label: 'Products',
            color: primaryColor,
          ),
          _buildMaterialNavItem(
            context: context,
            index: 2,
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings,
            label: 'Settings',
            color: primaryColor,
          ),
          _buildMaterialNavItem(
            context: context,
            index: 3,
            icon: Icons.person_outlined,
            activeIcon: Icons.person,
            label: 'Profile',
            color: primaryColor,
          ),
        ],
      ),
    );
  }

  // بناء عنصر التنقل لـ Material Design
  Widget _buildMaterialNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Color color,
  }) {
    final bool isActive = navigationShell.currentIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 24.sp,
              color: isActive ? color : Colors.grey[600],
            ),
            if (isActive) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // تصميم Cupertino بمربع شفاف على الأيقونة النشطة
  Widget _buildModernCupertinoNavBar(BuildContext context) {
    final primaryColor = CupertinoColors.activeBlue;

    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.extraLightBackgroundGray,
        border: const Border(
          top: BorderSide(
            color: CupertinoColors.lightBackgroundGray,
            width: 0.5,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCupertinoNavItem(
            context: context,
            index: 0,
            icon: CupertinoIcons.home,
            label: 'Home',
            color: primaryColor,
          ),
          _buildCupertinoNavItem(
            context: context,
            index: 1,
            icon: CupertinoIcons.shopping_cart,
            label: 'Products',
            color: primaryColor,
          ),
          _buildCupertinoNavItem(
            context: context,
            index: 2,
            icon: CupertinoIcons.settings,
            label: 'Settings',
            color: primaryColor,
          ),
          _buildCupertinoNavItem(
            context: context,
            index: 3,
            icon: CupertinoIcons.person,
            label: 'Profile',
            color: primaryColor,
          ),
        ],
      ),
    );
  }

  // بناء عنصر التنقل لـ Cupertino
  Widget _buildCupertinoNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final bool isActive = navigationShell.currentIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color: isActive ? color : CupertinoColors.inactiveGray,
            ),
            if (isActive) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'package:go_router/go_router.dart';

// class MainShell extends StatelessWidget {
//   final StatefulNavigationShell navigationShell;
//   const MainShell({super.key, required this.navigationShell});

//   void _onItemTapped(int index) {
//     navigationShell.goBranch(
//       index,
//       initialLocation: index == navigationShell.currentIndex,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

//     return Scaffold(
//       body: navigationShell,
//       bottomNavigationBar: isIOS
//           ? _buildModernCupertinoNavBar(context)
//           : _buildModernMaterialNavBar(context),
//     );
//   }

//   // تصميم مودرن مع خلفية متدرجة وأيقونات مميزة
//   Widget _buildModernMaterialNavBar(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//         child: BottomNavigationBar(
//           items: [
//             BottomNavigationBarItem(
//               icon: Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: navigationShell.currentIndex == 0
//                       ? Colors.blue.withOpacity(0.2)
//                       : Colors.transparent,
//                 ),
//                 child: const Icon(Icons.home_outlined, size: 24),
//               ),
//               activeIcon: Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.blue,
//                 ),
//                 child: const Icon(Icons.home, size: 24, color: Colors.white),
//               ),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: navigationShell.currentIndex == 1
//                       ? Colors.purple.withOpacity(0.2)
//                       : Colors.transparent,
//                 ),
//                 child: const Icon(Icons.shopping_bag_outlined, size: 24),
//               ),
//               activeIcon: Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.purple,
//                 ),
//                 child: const Icon(
//                   Icons.shopping_bag,
//                   size: 24,
//                   color: Colors.white,
//                 ),
//               ),
//               label: 'Products',
//             ),
//             BottomNavigationBarItem(
//               icon: Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: navigationShell.currentIndex == 2
//                       ? Colors.orange.withOpacity(0.2)
//                       : Colors.transparent,
//                 ),
//                 child: const Icon(Icons.settings_outlined, size: 24),
//               ),
//               activeIcon: Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.orange,
//                 ),
//                 child: const Icon(
//                   Icons.settings,
//                   size: 24,
//                   color: Colors.white,
//                 ),
//               ),
//               label: 'Settings',
//             ),
//             BottomNavigationBarItem(
//               icon: Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: navigationShell.currentIndex == 3
//                       ? Colors.green.withOpacity(0.2)
//                       : Colors.transparent,
//                 ),
//                 child: const Icon(Icons.person_outlined, size: 24),
//               ),
//               activeIcon: Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.green,
//                 ),
//                 child: const Icon(Icons.person, size: 24, color: Colors.white),
//               ),
//               label: 'Profile',
//             ),
//           ],
//           currentIndex: navigationShell.currentIndex,
//           onTap: _onItemTapped,
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: Colors.white,
//           elevation: 0,
//           selectedItemColor: Colors.black,
//           unselectedItemColor: Colors.grey[600],
//           selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
//           showSelectedLabels: true,
//           showUnselectedLabels: true,
//         ),
//       ),
//     );
//   }

//   // تصميم مودرن لـ iOS مع تأثيرات أكثر أناقة
//   Widget _buildModernCupertinoNavBar(BuildContext context) {
//     return CupertinoTabBar(
//       items: [
//         BottomNavigationBarItem(
//           icon: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: navigationShell.currentIndex == 0
//                       ? CupertinoColors.activeBlue.withOpacity(0.2)
//                       : Colors.transparent,
//                 ),
//                 child: const Icon(CupertinoIcons.home, size: 24),
//               ),
//               const SizedBox(height: 4),
//             ],
//           ),
//           activeIcon: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: CupertinoColors.activeBlue.withOpacity(0.2),
//                 ),
//                 child: Icon(
//                   CupertinoIcons.home,
//                   size: 24,
//                   color: CupertinoColors.activeBlue,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Container(
//                 width: 6,
//                 height: 6,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: CupertinoColors.activeBlue,
//                 ),
//               ),
//             ],
//           ),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: navigationShell.currentIndex == 1
//                       ? CupertinoColors.activeBlue.withOpacity(0.2)
//                       : Colors.transparent,
//                 ),
//                 child: const Icon(CupertinoIcons.shopping_cart, size: 24),
//               ),
//               const SizedBox(height: 4),
//             ],
//           ),
//           activeIcon: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: CupertinoColors.activeBlue.withOpacity(0.2),
//                 ),
//                 child: Icon(
//                   CupertinoIcons.shopping_cart,
//                   size: 24,
//                   color: CupertinoColors.activeBlue,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Container(
//                 width: 6,
//                 height: 6,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: CupertinoColors.activeBlue,
//                 ),
//               ),
//             ],
//           ),
//           label: 'Products',
//         ),
//         BottomNavigationBarItem(
//           icon: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: navigationShell.currentIndex == 2
//                       ? CupertinoColors.activeBlue.withOpacity(0.2)
//                       : Colors.transparent,
//                 ),
//                 child: const Icon(CupertinoIcons.settings, size: 24),
//               ),
//               const SizedBox(height: 4),
//             ],
//           ),
//           activeIcon: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: CupertinoColors.activeBlue.withOpacity(0.2),
//                 ),
//                 child: Icon(
//                   CupertinoIcons.settings,
//                   size: 24,
//                   color: CupertinoColors.activeBlue,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Container(
//                 width: 6,
//                 height: 6,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: CupertinoColors.activeBlue,
//                 ),
//               ),
//             ],
//           ),
//           label: 'Settings',
//         ),
//         BottomNavigationBarItem(
//           icon: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: navigationShell.currentIndex == 3
//                       ? CupertinoColors.activeBlue.withOpacity(0.2)
//                       : Colors.transparent,
//                 ),
//                 child: const Icon(CupertinoIcons.person, size: 24),
//               ),
//               const SizedBox(height: 4),
//             ],
//           ),
//           activeIcon: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: CupertinoColors.activeBlue.withOpacity(0.2),
//                 ),
//                 child: Icon(
//                   CupertinoIcons.person,
//                   size: 24,
//                   color: CupertinoColors.activeBlue,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Container(
//                 width: 6,
//                 height: 6,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: CupertinoColors.activeBlue,
//                 ),
//               ),
//             ],
//           ),
//           label: 'Profile',
//         ),
//       ],
//       currentIndex: navigationShell.currentIndex,
//       onTap: _onItemTapped,
//       activeColor: CupertinoColors.activeBlue,
//       inactiveColor: CupertinoColors.inactiveGray,
//       backgroundColor: Colors.white.withOpacity(0.9),
//       border: const Border(
//         top: BorderSide(color: CupertinoColors.lightBackgroundGray, width: 0.5),
//       ),
//     );
//   }
// }

// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_application_2/features/home/presentions/pages/home_page.dart';
// // import 'package:flutter_application_2/features/products/presentions/pages/products_screen.dart';
// // import 'package:flutter_application_2/features/settings/presentions/pages/settings_screen.dart';
// // import 'package:go_router/go_router.dart';

// // class MainShell extends StatelessWidget {
// //   final StatefulNavigationShell navigationShell;
// //   MainShell({super.key, required this.navigationShell});

// //   // int _currentIndex = 0;
// //   // final List<Widget> _pages = [
// //   //   const HomeScreen(),
// //   //   const ProductsScreen(),
// //   //   const SettingsScreen(),
// //   // ];
// //   // void _onItemTapped(int index) {
// //   //   setState(() {
// //   //     _currentIndex = index;
// //   //   });
// //   // }
// //   void _onItemTapped(int index) {
// //     navigationShell.goBranch(
// //       index,
// //       initialLocation: index == navigationShell.currentIndex,
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

// //     return Scaffold(
// //       body: navigationShell,
// //       bottomNavigationBar: isIOS
// //           ? __buildCupertinoNavBar(context)
// //           : _buildMaterialNavBar(context),
// //     );
// //   }

// //   Widget _buildMaterialNavBar(BuildContext context) {
// //     return BottomNavigationBar(
// //       items: const <BottomNavigationBarItem>[
// //         BottomNavigationBarItem(
// //           icon: Icon(Icons.home_outlined),
// //           activeIcon: Icon(Icons.home),
// //           label: 'Home',
// //         ),
// //         BottomNavigationBarItem(
// //           icon: Icon(Icons.shopping_bag_outlined),
// //           activeIcon: Icon(Icons.shopping_bag),
// //           label: 'Products',
// //         ),
// //         BottomNavigationBarItem(
// //           icon: Icon(Icons.settings_outlined),
// //           activeIcon: Icon(Icons.settings),
// //           label: 'Settings',
// //         ),
// //         BottomNavigationBarItem(
// //           icon: Icon(Icons.person_outline),
// //           activeIcon: Icon(Icons.person),
// //           label: 'Profile',
// //         ),
// //       ],
// //       currentIndex: navigationShell.currentIndex,
// //       onTap: _onItemTapped,
// //       type: BottomNavigationBarType.fixed,
// //       backgroundColor: Colors.white,
// //       elevation: 0.5,
// //       selectedItemColor: Colors.cyan[200],
// //       unselectedItemColor: Colors.grey[400],
// //       // selectedFontSize: 12,
// //       // unselectedFontSize: 10,
// //       // showSelectedLabels: true,
// //     );
// //   }

// //   Widget __buildCupertinoNavBar(BuildContext context) {
// //     return CupertinoTabBar(
// //       items: const <BottomNavigationBarItem>[
// //         BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Home'),
// //         BottomNavigationBarItem(
// //           icon: Icon(CupertinoIcons.shopping_cart),
// //           label: 'Products',
// //         ),
// //         BottomNavigationBarItem(
// //           icon: Icon(CupertinoIcons.settings),
// //           label: 'Settings',
// //         ),
// //         BottomNavigationBarItem(
// //           icon: Icon(Icons.person_outline),
// //           activeIcon: Icon(Icons.person),
// //           label: 'Profile',
// //         ),
// //       ],
// //       currentIndex: navigationShell.currentIndex,
// //       onTap: (index) => _onItemTapped(index),
// //       activeColor: CupertinoColors.activeBlue,
// //       inactiveColor: CupertinoColors.inactiveGray,
// //     );
// //   }
// // }
