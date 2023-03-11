import 'package:flutter/material.dart';

class MyMinutes extends StatelessWidget {
  int mins;
  int currentMinute;
  bool selectedMin = false;

  MyMinutes({required this.mins, required this.currentMinute});

  @override
  Widget build(BuildContext context) {
    mins == currentMinute ? selectedMin = true : selectedMin = false;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            mins < 10 ? '0' + mins.toString() : mins.toString(),
            style: TextStyle(
              fontSize: 40,
              color: mins == currentMinute
                  ? const Color.fromARGB(255, 52, 120, 202)
                  : const Color.fromARGB(255, 112, 180, 252),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void changeColor(int minute) {}
}
