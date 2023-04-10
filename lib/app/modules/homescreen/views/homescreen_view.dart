import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:timo_test/app/modules/homescreen/views/weather_view.dart';
import 'package:timo_test/app/modules/homescreen/views/mainscreen_view.dart';

import '../controllers/homescreen_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

RxInt currentPage = 0.obs;

class HomescreenView extends GetView {
  const HomescreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //a scaffold key for our drawer widget
    final scaffoldKey = GlobalKey<ScaffoldState>();

    //Record the current date in the top appBar widget
    final now = DateTime.now();
    String date = DateFormat.yMMMMd('en_US').format(now).obs();
    Scaffold(key: scaffoldKey, drawer: Drawer());

    return Scaffold(

        //appBar widget which should show up on every homescreen view
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            date,
            style: GoogleFonts.inter(
                textStyle: const TextStyle(
              color: Colors.black,
            )),
          ),

          actions: [
            IconButton(
              color: Colors.black,
              icon: const Icon(Icons.menu),
              onPressed: () {
                if (scaffoldKey.currentState!.isDrawerOpen) {
                  scaffoldKey.currentState!.closeDrawer();
                  //close drawer, if drawer is open
                } else {
                  scaffoldKey.currentState!.openDrawer();
                  //open drawer, if drawer is closed
                }
              },
            )
          ],
          //actions: const [Icon(Icons.more_vert)],
          centerTitle: false,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        body: PageView(
          onPageChanged: onPageViewChange,
          //
          children: const [
            MainScreenView(),
            //WeatherView(),
          ],
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BottomAppBar(
              child: Obx(() => AnimatedSmoothIndicator(
                    activeIndex: currentPage.value,
                    count: 3,
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
