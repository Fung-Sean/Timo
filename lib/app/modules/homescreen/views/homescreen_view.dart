import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:timo_test/app/modules/homescreen/views/weather_view.dart';
import 'package:timo_test/app/modules/homescreen/views/mainscreen_view.dart';
import '../../nearby/controllers/nearby_controller.dart';
import '../../nearby/views/nearby_view.dart';
import '../views/weather_view.dart';
import '../controllers/homescreen_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:async/async.dart';

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

    return Scaffold(
        key: scaffoldKey,
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
                  onPressed: () async {
                    // Add your action here
                    print('Button clicked!');
                    await controller.introController.getGoogleEventsData();
                    controller.introController.appendToLocalStorage();
                    controller.resetMemoizers();
                    controller.cancelBeforeGetReadyTimer();
                    controller.initialize();
                    //Get.to(MainScreenView());
                    //Get.put(HomescreenController());
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
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 53, 146, 255),
                ),
                child: Text(
                  'Have some extra time? Here are places you can visit given how much time you have before your next event.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    changeSharedPrefs("Coffee");
                    Get.to(NearbyView());
                    Get.put(NearbyController());
                  },
                  child: Row(
                    children: [
                      Icon(Icons.coffee, size: 24),
                      SizedBox(
                          width:
                              10), // Add some spacing between the icon and button text
                      Text(
                        'Coffee',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 22,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    changeSharedPrefs("Gas");
                    Get.to(NearbyView());
                    Get.put(NearbyController());
                  },
                  child: Row(
                    children: [
                      Icon(Icons.local_gas_station, size: 24),
                      SizedBox(
                          width:
                              10), // Add some spacing between the icon and button text
                      Text(
                        'Gas',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 22,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    changeSharedPrefs("Shop");
                    Get.to(NearbyView());
                    Get.put(NearbyController());
                  },
                  child: Row(
                    children: [
                      Icon(Icons.shopping_cart, size: 24),
                      SizedBox(
                          width:
                              10), // Add some spacing between the icon and button text
                      Text(
                        'Shop',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 22,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    changeSharedPrefs("Food");
                    Get.to(NearbyView());
                    Get.put(NearbyController());
                  },
                  child: Row(
                    children: [
                      Icon(Icons.restaurant_menu, size: 24),
                      SizedBox(
                          width:
                              10), // Add some spacing between the icon and button text
                      Text(
                        'Food',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 22,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: PageView(
          onPageChanged: onPageViewChange,
          //
          children: [
            MainScreenView(),
            WeatherView(), // CHECK!!
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

changeSharedPrefs(String key) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("Keyword", key);
}
