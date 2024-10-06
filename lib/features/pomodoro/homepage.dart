import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:second_brain/features/pomodoro/pages/data.dart';
import 'package:second_brain/features/pomodoro/pages/habit.dart';
import 'package:second_brain/features/pomodoro/pages/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Row(
          children: [
            // Expanded(child: Data()),
            // Expanded(child: Settings()),
            Expanded(child: Habit()),
          ],
        ));
  }
}
