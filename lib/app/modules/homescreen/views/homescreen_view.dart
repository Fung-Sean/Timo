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
              ElevatedButton.icon(
                  onPressed: () {
                    changeSharedPrefs("Coffee");
                    Get.to(NearbyView());
                    Get.put(NearbyController());
                  },
                  icon: Icon(Icons.coffee, size: 24),
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
              ElevatedButton.icon(
                  onPressed: () {
                    changeSharedPrefs("Gas");
                    Get.to(NearbyView());
                    Get.put(NearbyController());
                  },
                  icon: Icon(Icons.local_gas_station, size: 24),
                  label: Text(
                    'Gas',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: 22,
                    )),
                  )),
              ElevatedButton.icon(
                  onPressed: () {
                    changeSharedPrefs("Shop");
                    Get.to(NearbyView());
                    Get.put(NearbyController());
                  },
                  icon: Icon(Icons.shopping_cart, size: 24),
                  label: Text(
                    'Shop',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: 22,
                    )),
                  )),
              ElevatedButton.icon(
                  onPressed: () {
                    changeSharedPrefs("Food");
                    Get.to(NearbyView());
                    Get.put(NearbyController());
                  },
                  icon: Icon(Icons.restaurant_menu, size: 24),
                  label: Text(
                    'Food',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: 22,
                    )),
                  )),
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

changeSharedPrefs(String key) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("Keyword", key);
}
