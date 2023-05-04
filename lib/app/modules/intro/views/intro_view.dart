import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timo_test/app/modules/homescreen/views/weather_view.dart';
import 'package:timo_test/app/modules/homescreen/views/mainscreen_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'intro1_view.dart';
import 'intro2_view.dart';
import 'intro3_view.dart';
import 'intro4_view.dart';

import '../../homescreen/controllers/homescreen_controller.dart';
import '../../homescreen/views/homescreen_view.dart';

RxInt currentPage = 0.obs;

/*
class IntroView extends GetView {
  const IntroView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: SharedPreferences.getInstance().then(
          (prefs) => prefs.getString('accountLoggedIn') ?? 'default_value'),
      builder: (context, snapshot) {
        print("Snapshot: " + snapshot.toString());
        if (snapshot.hasData) {
          final value = snapshot.data!;
          print("accountLoggedIn: " + value);
          if (value != null && value != 'default_value') {
            // Do something else here if the value of the variable is not null
            Get.put(HomescreenController());
            return HomescreenView();
          } else {
            // Show the PageView if the value of the variable is null
            return Scaffold(
              body: PageView(
                onPageChanged: onPageViewChange,
                children: const [
                  Intro1View(),
                  Intro2View(),
                  Intro3View(),
                  Intro4View(),
                ],
              ),
              bottomNavigationBar: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BottomAppBar(
                    color: Colors.white,
                    clipBehavior: Clip.none,
                    elevation: 0,
                    child: Obx(() => AnimatedSmoothIndicator(
                          activeIndex: currentPage.value,
                          count: 4,
                          effect: const ExpandingDotsEffect(
                            activeDotColor: Color.fromARGB(255, 53, 146, 255),
                          ),
                        )),
                  ),
                ],
              ),
            );
          }
        } else if (snapshot.hasError) {
          // Handle error case
          print("Snapshot error: " + snapshot.hasError.toString());
          return Center(child: Text("Error occurred"));
        } else {
          // Show loading spinner while data is being fetched
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
*/
class IntroView extends GetView {
  const IntroView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          onPageChanged: onPageViewChange,
          children: const [
            Intro1View(),
            Intro2View(),
            Intro3View(),
            Intro4View(),
          ],
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BottomAppBar(
              color: Colors.white,
              clipBehavior: Clip.none,
              elevation: 0,
              child: Obx(() => AnimatedSmoothIndicator(
                    activeIndex: currentPage.value,
                    count: 4,
                    effect: const ExpandingDotsEffect(
                        activeDotColor: Color.fromARGB(255, 53, 146, 255)),
                  )),
            ),
          ],
        ));
  }
}

//when the page is changed, I want that to reflect in my widgets
onPageViewChange(int page) {
  currentPage.value = page;
}
