import 'package:cgpa_calculator/ux/navigation/components/custom_bottom_nav.dart';
import 'package:cgpa_calculator/ux/views/home/home_page.dart';
import 'package:cgpa_calculator/ux/views/semesters/semesters_page.dart';
import 'package:cgpa_calculator/ux/views/settings/settings_page.dart';
import 'package:flutter/material.dart';

class NavigationHostPage extends StatefulWidget {
  const NavigationHostPage({super.key});

  @override
  State<NavigationHostPage> createState() => _NavigationHostPageState();
}

class _NavigationHostPageState extends State<NavigationHostPage> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    SemestersPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: pages[currentIndex]),
        Positioned(
          left: 0,
          right: 0,
          bottom: 20,
          child: CustomBottomNav(
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
      ],
    );
  }
}
