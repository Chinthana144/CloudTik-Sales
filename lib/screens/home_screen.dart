
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import 'package:flutter/cupertino.dart';
import 'login_screen.dart';
import '../widgets/bottom_navbar.dart';
import '../screens/invoice_screen.dart';
import '../screens/customer_screen.dart';
import '../screens/setting_screen.dart';
import '../screens/dashboard_screen.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    InvoiceScreen(),
    CustomerScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final userId = sessionProvider.userId;
    final campId = sessionProvider.campId;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Image.asset(
                'assets/images/trizent_icon.ico',
                fit: BoxFit.contain,
              ),
              height: 30,
            ),
            Text(
              'CloudTik Sales',
              style: TextStyle(
                color: Color(0xFF88deff),
                fontSize: 22,
              ),
            ),
            IconButton(
              onPressed: (){
                sessionProvider.clearSession();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen())
                );
              },
              icon: Icon(Icons.logout),
              color: Color(0xFF88deff),
            ),
          ],
        ),
        backgroundColor: Color(0xFF262d35),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.red,
        selectedItemColor: const Color(0xFF26B0DE),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        elevation: 10,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}