import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WorkoutScreen extends StatefulWidget {
 @override
 _WorkoutScreenState createState()=> _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
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
          workouts =
          List<Map<String, dynamic>>.from(json.decode(storedWorkouts));
        });
      } catch (e) {
        print("Error loading workouts: $e");
        workouts = [];
      }
    }
  }

  Future<void> _saveWorkouts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('workouts', json.encode(workouts));
  }

  void _addWorkout() {
    if (nameController.text.isNotEmpty&&
        setsController.text.isNotEmpty &&
        repsController.text.isNotEmpty &&
        weightController.text.isNotEmpty) {
      setState(() {
        workouts.add({
          "name": nameController.text,
          "sets": setsController.text,
          "reps": repsController.text,
          "weight": weightController.text,
          "completed": false
        });
      });
      _saveWorkouts();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayedWorkouts =
    workouts.where((w) => w["completed"] == (_selectedSegment == 1)).toList();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Workout Tracker"),
      ),
      child: SafeArea(
          child: Column(
            children: [
            Padding(padding: EdgeInsets.all(16),
            child: Column(
              children: [
              _buildTextField(nameController, "Workout Name", CupertinoIcons.flame),
                  SizedBox(height: 10),
              ],
            )
            )
            ],
          )
      ),
    );
  }
}

Widget _buildTextField(TextEditingController controller, String placeholder, IconData icon) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(10),
      ),
      prefix: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Icon(icon, color: CupertinoColors.systemGrey),
      ),
      keyboardType: placeholder.contains("Weight") || placeholder.contains("Sets") || placeholder.contains("Reps")
          ? TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
    );
  }