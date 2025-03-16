import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../lib/screens/home_screen.dart';
import '../lib/screens/workout_screen.dart';
import '../lib/screens/workout_history_screen.dart';

void main() {
  testWidgets('HomeScreen UI and navigation test', (WidgetTester tester) async {
    // Build HomeScreen widget
    await tester.pumpWidget(
      CupertinoApp(
        home: HomeScreen(),
      ),
    );

    // Check if the main title is displayed
    expect(find.text("Gym Workout Tracker"), findsOneWidget);

    // Check if subtitle text is displayed
    expect(find.text("Track Your Progress 💪"), findsOneWidget);
    expect(find.text("Stay fit by logging your workouts!"), findsOneWidget);

    // Check if buttons are displayed
    expect(find.text("Start Workout"), findsOneWidget);
    expect(find.text("Workout History"), findsOneWidget);

    // Tap the "Start Workout" button
    await tester.tap(find.text("Start Workout"));
    await tester.pumpAndSettle(); // Wait for navigation

    // Verify navigation to WorkoutScreen
    expect(find.byType(WorkoutScreen), findsOneWidget);

    // Navigate back to HomeScreen
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Tap the "Workout History" button
    await tester.tap(find.text("Workout History"));
    await tester.pumpAndSettle(); // Wait for navigation

    // Verify navigation to WorkoutHistoryScreen
    expect(find.byType(WorkoutHistoryScreen), findsOneWidget);
  });
}
