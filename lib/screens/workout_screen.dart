import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WorkoutScreen extends StatefulWidget {
 @override
 _WorkoutScreenState createState()=> _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>{
  List<Map<String, dynamic>> workouts = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController setsController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  int _selectedSegment = 0; // 0 = Active Workouts, 1 = Completed Workouts

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }
Future<void> _loadWorkouts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedWorkouts = prefs.getString('workouts');
    if (storedWorkouts != null) {
      try {
        setState(() {
          workouts = List<Map<String, dynamic>>.from(json.decode(storedWorkouts));
        });
      } catch (e) {
        print("Error loading workouts: $e");
        workouts = [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}