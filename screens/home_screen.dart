import 'package:flutter/material.dart';
import 'translate/translate_screen.dart';
import 'lessons/lessons_screen.dart';
import 'camera/camera_screen.dart';
import 'chat/chat_screen.dart';
import 'profile/profile_screen.dart';
import 'words/words_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  final pages = [
    const TranslateScreen(),
    const LessonsScreen(),
    const CameraScreen(),
    const ChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      const TranslateScreen(),
      const LessonsScreen(),
      const CameraScreen(),
      const ChatScreen(),
    ];

    return Scaffold(
      // Ensure index is within range of the current pages list
      body: pages[index.clamp(0, pages.length - 1)],
      
      endDrawer: Drawer(
        backgroundColor: const Color(0xFF050B15),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person_rounded, color: Colors.white),
                title: const Text('Profil'),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.abc_rounded, color: Colors.white),
                title: const Text('So\'zlar'),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const WordsScreen()));
                },
              ),
            ],
          ),
        ),
      ),
      
      bottomNavigationBar: Builder(
        builder: (context) => NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (v) {
            if (v == 4) {
              // Open the drawer if the Menu item is clicked
              Scaffold.of(context).openEndDrawer();
            } else {
              // Switch to the selected page
              setState(() {
                index = v;
              });
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.translate_rounded),
              label: 'Translate',
            ),
            NavigationDestination(
              icon: Icon(Icons.school_rounded),
              label: 'Darslar',
            ),
            NavigationDestination(
              icon: Icon(Icons.camera_rounded),
              label: 'Kamera',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_rounded),
              label: 'Chat',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_rounded),
              label: 'Menu',
            ),
          ],
        ),
      ),
    );
  }
}
