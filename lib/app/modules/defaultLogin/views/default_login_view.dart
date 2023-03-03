import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:timo_test/app/modules/login/controllers/login_controller.dart';
import '../views/palette.dart';

import '../../login/views/login_view.dart';
//import '../../login/bindings/login_binding.dart';
import '../../../routes/app_pages.dart';
//import '../../../routes/app_routes.dart';
//import '../modules/login/views/login_view.dart';

import '../controllers/default_login_controller.dart';

//Views folders is where we edit our front-end page

class DefaultLoginView extends GetView<DefaultLoginController> {
  const DefaultLoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      appBar: AppBar(
        //title: const Text('TIMO'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(246, 0, 0, 0),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 30),
            const Text(
              'Welcome to TIMO!',
              style: TextStyle(fontSize: 50, fontFamily: 'Inter'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Sign in to your account',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 70),
            ElevatedButton(
                style: style,
                onPressed: () {
                  Get.to(LoginView());
                  Get.put(LoginController());
                },
                child: const Text('Leads to Calendar')),

            // const SizedBox(height: 15),
            // ElevatedButton(
            //     style: style,
            //     onPressed: () {
            //       // Navigator.push(
            //       //   context,
            //       //   MaterialPageRoute(builder: (context) => AppPages.LOGIN),
            //       // );
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => AppPages.SECOND_PAGE),
            //       );
            //     },
            //     child: const Text('Sign in using Google'))
          ],
        ),
      ),
    );
  }
}
