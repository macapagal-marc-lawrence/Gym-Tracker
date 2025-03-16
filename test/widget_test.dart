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
      MaterialApp( // Wrapped in MaterialApp for better Navigator support
        home: CupertinoApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Check if main title is displayed
    expect(find.text("Gym Workout Tracker"), findsOneWidget);

    // Check if subtitle text is displayed
    expect(find.text("Track Your Progress 💪"), findsOneWidget);
    expect(find.text("Stay fit by logging your workouts!"), findsOneWidget);

    // Ensure buttons are displayed before tapping
    final startWorkoutFinder = find.text("Start Workout");
    final historyFinder = find.text("Workout History");

    expect(startWorkoutFinder, findsOneWidget);
    expect(historyFinder, findsOneWidget);

    // Tap the "Start Workout" button
    await tester.tap(startWorkoutFinder);
    await tester.pumpAndSettle(); // Wait for navigation

    // Verify navigation to WorkoutScreen
    expect(find.byType(WorkoutScreen), findsOneWidget);

    // Navigate back to HomeScreen
    await tester.tap(find.byType(CupertinoNavigationBarBackButton));
    await tester.pumpAndSettle();

    // Tap the "Workout History" button
    await tester.tap(historyFinder);
    await tester.pumpAndSettle(); // Wait for navigation

    // Verify navigation to WorkoutHistoryScreen
    expect(find.byType(WorkoutHistoryScreen), findsOneWidget);
  });
}
