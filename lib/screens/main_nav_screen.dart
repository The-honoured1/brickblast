import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import 'tabs/home_tab.dart';
import 'tabs/levels_tab.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const LevelsTab(),
    const Scaffold(body: Center(child: Text('Stats (WIP)', style: TextStyle(color: Colors.white)))), // Stats placeholder
    const Scaffold(body: Center(child: Text('Shop (WIP)', style: TextStyle(color: Colors.white)))),  // Shop placeholder
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.borderNeon, width: 2),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.bottomNavDark,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor: AppColors.neonPink,
          unselectedItemColor: AppColors.textMuted,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: 'LEVELS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'STATS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_rounded),
              label: 'SHOP',
            ),
          ],
        ),
      ),
    );
  }
}
