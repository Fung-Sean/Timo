import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/timer_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(TimerController());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
    );
  }
}

class TimerView extends GetView<TimerController> {
  const TimerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        height: 100,
        width: 200,
        decoration: ShapeDecoration(
            color: Theme.of(context).primaryColor,
            shape: const StadiumBorder(
                side: BorderSide(width: 2, color: Colors.red))),
        child: Obx(() => Center(
              child: Text(
                controller.time.value,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            )),
      ),
    ));
  }
}
