import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timo_test/app/modules/homescreen/views/weather_view.dart';
import 'package:timo_test/app/modules/homescreen/views/mainscreen_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'intro1_view.dart';
import 'intro2_view.dart';
import 'intro3_view.dart';
import 'intro4_view.dart';

RxInt currentPage = 0.obs;

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
              child: Obx(() => AnimatedSmoothIndicator(
                    activeIndex: currentPage.value,
                    count: 4,
                    effect: const ExpandingDotsEffect(),
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
