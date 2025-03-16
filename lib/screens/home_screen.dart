import 'package:flutter/cupertino.dart';
import 'workout_screen.dart';
import 'workout_history_screen.dart';
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            "Gym Workout Tracker",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [CupertinoColors.systemGrey5, CupertinoColors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.square_stack_3d_down_right_fill,
                    color: CupertinoColors.activeBlue,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Track Your Progress 💪",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black,
                    ),
                  ),
                  Text(
                    "Stay fit by logging your workouts!",
                    style: TextStyle(
                      fontSize: 16,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    icon: CupertinoIcons.flame_fill,
                    text: "Start Workout",
                    color: CupertinoColors.systemOrange,
                    screen: WorkoutScreen(),
                  ),
                   SizedBox(height: 10),
              _buildMenuButton(
                context,
                icon: CupertinoIcons.time_solid,
                text: "Workout History",
                color: CupertinoColors.systemBlue,
                screen: WorkoutHistoryScreen(),
              ),
                ],
              )
          ),
        )
    );
  }

  Widget _buildMenuButton(BuildContext context, {
    required IconData icon,
    required String text,
    required Color color,
    required Widget screen,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => screen));
      },
      child: Container(
width: 280,
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
      ),
    );
  }
}







