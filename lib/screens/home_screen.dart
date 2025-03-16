import 'package:flutter/cupertino.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar:CupertinoNavigationBar(
            middle: Text(
              "Gym Workout Tracker",
                style: TextStyle(fontWeight: FontWeight.bold),
            ),
        ),
        child: Container(

        )
    );
  }
}
