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
    if (nameController.text.isNotEmpty &&
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
      _clearFields();
    }
  }

  void _markAsCompleted(int index) {
    setState(() {
      workouts[index]["completed"] = true;
    });
    _saveWorkouts();
  }

  void _deleteWorkout(int index) {
    setState(() {
      workouts.removeAt(index);
    });
    _saveWorkouts();
  }

  void _clearFields() {
    nameController.clear();
    setsController.clear();
    repsController.clear();
    weightController.clear();
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
                  _buildTextField(
                      nameController, "Workout Name", CupertinoIcons.flame),
                  SizedBox(height: 10),
                  _buildTextField(
                      setsController, "Sets", CupertinoIcons.repeat),
                  SizedBox(height: 10),
                  _buildTextField(
                      repsController, "Reps", CupertinoIcons.hand_thumbsup),
                  SizedBox(height: 10),
                  _buildTextField(weightController, "Weight (kg)",
                      CupertinoIcons.chart_bar_alt_fill),
                  SizedBox(height: 15),
                  CupertinoButton.filled(
                    child: Text("Add Workout"),
                    onPressed: _addWorkout,
                  ),
                ],
              ),
            ),
// Segmented Control (Active / Completed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoSegmentedControl<int>(
                selectedColor: CupertinoColors.activeBlue,
                borderColor: CupertinoColors.activeBlue,
                unselectedColor: CupertinoColors.white,
                children: {
                  0: Padding(padding: EdgeInsets.all(8), child: Text("Active")),
                  1: Padding(
                      padding: EdgeInsets.all(8), child: Text("Completed")),
                },
                onValueChanged: (int value) {
                  setState(() {
                    _selectedSegment = value;
                  });
                },
                groupValue: _selectedSegment,
              ),
            ),

            SizedBox(height: 10),

            // Workout List
            Expanded(
              child: displayedWorkouts.isEmpty
                  ? Center(
                child: Text(
                  "No workouts yet!",
                  style: TextStyle(color: CupertinoColors.systemGrey),
                ),
              )
                  : ListView.builder(
                itemCount: displayedWorkouts.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(displayedWorkouts[index]["name"]),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      color: CupertinoColors.systemRed,
                      child: Icon(
                          CupertinoIcons.delete, color: CupertinoColors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => _deleteWorkout(index),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: _buildWorkoutCard(displayedWorkouts[index], index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildTextField(TextEditingController controller, String placeholder,
      IconData icon) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(10),
      ),
      style: TextStyle(color: CupertinoColors.black),
      // Ensures black text color
      prefix: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Icon(icon, color: CupertinoColors.systemGrey),
      ),
      keyboardType: placeholder.contains("Weight") ||
          placeholder.contains("Sets") || placeholder.contains("Reps")
          ? TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
    );
  }


  Widget _buildWorkoutCard(Map<String, dynamic> workout, int index) {
    bool isCompleted = workout["completed"];

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Spacing around cards
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCompleted
              ? [CupertinoColors.systemGreen.withOpacity(0.3), CupertinoColors.systemGreen.withOpacity(0.1)]
              : [CupertinoColors.systemBlue.withOpacity(0.3), CupertinoColors.systemBlue.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.08), // Softer shadow
            blurRadius: 8,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Section: Workout Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.flame,
                      color: isCompleted ? CupertinoColors.systemGreen : CupertinoColors.systemBlue,
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        workout["name"],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                        ),
                        overflow: TextOverflow.ellipsis, // Prevents text overflow
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "🔥 ${workout["sets"]} sets × ${workout["reps"]} reps",
                  style: TextStyle(color: CupertinoColors.black.withOpacity(0.7), fontSize: 16),
                ),
                Text(
                  "🏋️ ${workout["weight"]} kg",
                  style: TextStyle(color: CupertinoColors.black.withOpacity(0.7), fontSize: 16),
                ),
              ],
            ),
          ),

          // Right Section: Complete Button
          if (!isCompleted)
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200), // Smooth animation
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: CupertinoColors.activeGreen,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemGreen.withOpacity(0.4),
                      blurRadius: 6,
                      offset: Offset(2, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.check_mark_circled, color: CupertinoColors.white, size: 20),
                    SizedBox(width: 6),
                    Text(
                      "Done",
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: () => _markAsCompleted(index),
            ),
        ],
      ),
    );
  }
}