import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/homescreen_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomescreenView extends GetView<HomescreenController> {
  const HomescreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(HomescreenController(25, 50, 75, DateTime(2023, 3, 27, 17, 30)));
    //display the date and time on this main screen
    final now = DateTime.now();
    String date = DateFormat.yMMMMd('en_US').format(now).obs();

    //define some colors to be used on the widgets
    Color darkBlue = const Color.fromARGB(255, 64, 149, 249);
    Color lightBlue = const Color.fromARGB(255, 227, 237, 246);

    //a scaffold key for our drawer widget
    final scaffoldKey = GlobalKey<ScaffoldState>();
    Scaffold(key: scaffoldKey, drawer: Drawer());

    return Scaffold(
      appBar: AppBar(
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
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            //here we have some headers indicating the event name and location
            Text(
              controller.eventName,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 25,
              )),
            ),
            Text(
              "at " + controller.address,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: 17,
              )),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: 350,
              height: 350,
              child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: <Widget>[
                    Obx(() => CircularProgressIndicator(
                          value: controller.proportionOfTimer.value,
                          strokeWidth: 17,
                          color: darkBlue,
                          backgroundColor: lightBlue,
                        )),
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Ready!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontSize: 30,
                            )),
                          ),
                          Obx(
                            () => Text(
                              '${controller.time.value}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 64, 149, 249),
                                fontSize: 45,
                              )),
                            ),
                          ),
                          Obx(() => Text(
                                'Leave at ' + controller.arriveTime.value,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 30,
                                )),
                              )),
                        ],
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 110,
                    height: 110,
                    child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.expand,
                        children: <Widget>[
                          CircularProgressIndicator(
                            value: controller.readyProportion,
                            strokeWidth: 10,
                            color: darkBlue,
                            backgroundColor: lightBlue,
                          ),
                          Positioned.fill(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${controller.readyTime}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 64, 149, 249),
                                    fontSize: 20,
                                  )),
                                ),
                                Text(
                                  'min',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      textStyle: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                    fontSize: 20,
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 110,
                    height: 110,
                    child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.expand,
                        children: <Widget>[
                          CircularProgressIndicator(
                            value: controller.travlelProportion,
                            strokeWidth: 10,
                            color: darkBlue,
                            backgroundColor: lightBlue,
                          ),
                          Positioned.fill(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${controller.travelTime}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 64, 149, 249),
                                    fontSize: 20,
                                  )),
                                ),
                                Text(
                                  'min',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      textStyle: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                    fontSize: 20,
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 110,
                    height: 110,
                    child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.expand,
                        children: <Widget>[
                          CircularProgressIndicator(
                            value: controller.eventProportion,
                            strokeWidth: 10,
                            color: darkBlue,
                            backgroundColor: lightBlue,
                          ),
                          Positioned.fill(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${controller.eventTime}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 64, 149, 249),
                                    fontSize: 20,
                                  )),
                                ),
                                Text(
                                  'min',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      textStyle: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                    fontSize: 20,
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            ElevatedButton(
                //style: style,
                onPressed: () {
                  controller.updateArrival();
                  controller.startTimer(900);
                },
                child: const Text('Start Timer')),
          ],
        ),
      ),
    );
  }
}
