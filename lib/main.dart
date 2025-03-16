import 'package:flutter/cupertino.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const GymTrackerApp());
}

class GymTrackerApp extends StatelessWidget {
  const GymTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: "Gym Tracker",
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.black, // Ensures black text
        barBackgroundColor: CupertinoColors.systemGrey6,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            fontFamily: 'SF Pro',
            fontSize: 16,
            color: CupertinoColors.black, // Ensures black text color
          ),
        ),
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
