import 'package:flutter/material.dart';

class MyCircularProgressBar extends StatelessWidget {
  final double totalTasks;
  final double completedTasks;

  MyCircularProgressBar(
      {required this.totalTasks, required this.completedTasks});

  @override
  Widget build(BuildContext context) {
    double progress = completedTasks / totalTasks;

    return CircularProgressIndicator(
      value: progress,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    );
  }
}
