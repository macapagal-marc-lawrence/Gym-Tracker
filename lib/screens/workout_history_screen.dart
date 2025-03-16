import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WorkoutHistoryScreen extends StatefulWidget {
  @override
  _WorkoutHistoryScreenState createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  List<Map<String, dynamic>> workoutHistory = [];

  @override
  void initState() {
    super.initState();
    _loadWorkoutHistory();
  }

  _loadWorkoutHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedWorkouts = prefs.getString('workouts');
    if (storedWorkouts != null) {
      setState(() {
        List<Map<String, dynamic>> allWorkouts =
        List<Map<String, dynamic>>.from(json.decode(storedWorkouts));
        workoutHistory =
            allWorkouts.where((workout) => workout["completed"]).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "Workout History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: SafeArea(
        child:workoutHistory.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          itemCount: workoutHistory.length,
          itemBuilder: (context, index) {
            return _buildWorkoutCard(workoutHistory[index]);
          },
        ),
      ),
    );
  }
}

