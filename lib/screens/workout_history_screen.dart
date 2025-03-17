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

/// Widget to display a completed workout card
  Widget _buildWorkoutCard(Map<String, dynamic> workout) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.flame_fill, color: CupertinoColors.activeOrange, size: 32),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout["name"],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  SizedBox(height: 4),
                  Text(
                    "${workout["sets"]} sets × ${workout["reps"]} reps",
                    style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
                  ),
                ],
              ),
            ),
            Text(
              "${workout["weight"]} kg",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
      )
    );
  }

/// Widget for empty history state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.doc_text_search, size: 80, color: CupertinoColors.systemGrey),
          SizedBox(height: 16),
          Text(
            "No completed workouts yet!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: CupertinoColors.systemGrey),
          ),
          SizedBox(height: 8),
          Text(
            "Start a workout and complete it to see history here.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey2),
          ),

        ],

      ),
    );

  }