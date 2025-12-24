import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget{
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.note),
          label: 'Invice',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Customer',
        ),
      ],
    );
  }
}