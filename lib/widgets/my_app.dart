import 'package:flutter/material.dart';
import 'package:timer_app/widgets/alarm_witget.dart';
import 'package:timer_app/widgets/stopwatch_widgets.dart';
import 'package:timer_app/widgets/timer_widget.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedTab = 0;

  void onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: _selectedTab,
          children: const [
            StopWatch(),
            AlarmWidgets(),
            TimerWidgets(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onSelectTab,
          selectedIconTheme: const IconThemeData(size: 60),
          iconSize: 30,
          currentIndex: _selectedTab,
          elevation: 0,
          backgroundColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.hourglass_bottom_rounded,
                color: Colors.white,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.alarm,
                color: Colors.white,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.timer,
                color: Colors.white,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
