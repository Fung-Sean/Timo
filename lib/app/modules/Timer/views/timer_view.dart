import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/timer_controller.dart';

class TimerView extends GetView<TimerController> {
  const TimerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TimerView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TimerView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
