import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:timo_test/app/modules/homescreen/views/weather_view.dart';
import 'package:timo_test/app/modules/homescreen/views/mainscreen_view.dart';
import '../views/weather_view.dart';
import '../controllers/homescreen_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

RxInt currentPage = 0.obs;

class HomescreenView extends GetView<HomescreenController> {
  const HomescreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //a scaffold key for our drawer widget
    final scaffoldKey = GlobalKey<ScaffoldState>();

    //final _homescre = Get.put(WeatherpageController());

    //Record the current date in the top appBar widget
    final now = DateTime.now();
    String date = DateFormat.yMMMMd('en_US').format(now).obs();
    Scaffold(key: scaffoldKey, drawer: Drawer());
    const Color gray = Color.fromARGB(217, 217, 217, 217);
    Color darkBlue = const Color.fromARGB(255, 53, 146, 255);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add your action here
                    print('Button clicked!');
                    controller.introController.getGoogleEventsData();
                    controller.introController.appendToLocalStorage();
                    //controller.update();
                  },
                  child: Text(
                    'Refresh Now ',
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        color: gray,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                ),
              ],
            ),
            IconButton(
              color: Colors.black,
              icon: const Icon(Icons.menu),
              onPressed: () {
                if (scaffoldKey.currentState!.isDrawerOpen) {
                  scaffoldKey.currentState!.closeEndDrawer();
                  //close drawer, if drawer is open
                } else {
                  scaffoldKey.currentState!.openEndDrawer();
                  //open drawer, if drawer is closed
                }
              },
            ),
          ],
          //actions: const [Icon(Icons.more_vert)],
          centerTitle: false,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        endDrawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    // Get.to(NearbyView());
                    // Get.put(NearbyController());
                  },
                  icon: Icon(Icons.download, size: 24),
                  label: Text(
                    'Coffee',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: 22,
                    )),
                  )),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: PageView(
          onPageChanged: onPageViewChange,
          //
          children: [
            MainScreenView(),
            WeatherView(),
          ],
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BottomAppBar(
              elevation: 0,
              child: Obx(() => AnimatedSmoothIndicator(
                    activeIndex: currentPage.value,
                    count: 2,
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
