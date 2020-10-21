import 'package:flutter/material.dart';

import './take_pic_screen.dart';
import './view_images.dart';
import '../widgets/do_nothing.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, Object>> _pages = [
    {
      'page': TakePicScreen(),
      'title': 'Take a Pic',
    },
    {
      'page': Test(),
      'title': 'deletimage',
    },
    {
      'page': ViewImages(),
      'title': 'Your Images',
    },
  ];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
        backgroundColor: Colors.indigo,
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Colors.indigo,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.lightBlue,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.indigo,
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.indigo,
            icon: Icon(Icons.delete),
            title: Text('Delete'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.indigo,
            icon: Icon(Icons.image),
            title: Text('Images'),
          ),
        ],
      ),
    );
  }
}
