import 'package:bionic_test/pages/audiopick_page.dart';
import 'package:bionic_test/pages/contactpick_page.dart';
import 'package:bionic_test/pages/documentpick_page.dart';
import 'package:bionic_test/pages/imagepick_page.dart';
import 'package:bionic_test/pages/mappick_page.dart';
import 'package:bionic_test/pages/sendnotif_page.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;
  List pages = [
    ImagePage(),
    DocumentPage(),
    ContactPage(),
    AudioPage(),
    SendNotif(),
    MapPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.black26,
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i) {
          _selectedIndex = i;
          setState(() {});
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.audio_file),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "",
          ),
        ],
      ),
    );
  }
}
