import 'package:casette/constants/constants.dart';
import 'package:casette/screens/Presentation/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'explore_screen.dart';
import 'library_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    ExploreScreen(),
    LibraryScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        backgroundColor: kAppBarColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.explore,
              color: kScaffoldBackgroundColor,
            ),
            label: "Explore",
            backgroundColor: kAppBarColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.library_books,
              color: kScaffoldBackgroundColor,
            ),
            label: "Library",
            backgroundColor: kAppBarColor,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kAppBarColor,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CameraScreen()));
        },
        child: const Icon(
          Icons.add,
          color: kScaffoldBackgroundColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
