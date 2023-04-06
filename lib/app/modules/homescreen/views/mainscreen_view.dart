import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/homescreen_controller.dart';
import 'package:timo_test/app/modules/homescreen/views/homescreen_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MainScreenView extends GetView<HomescreenController> {
  const MainScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color darkBlue = const Color.fromARGB(255, 64, 149, 249);
    Color lightBlue = Color.fromARGB(255, 65, 159, 243);

    Color lightGreen = const Color.fromARGB(255, 0, 201, 153);
    Color lightOrange = const Color.fromARGB(255, 237, 123, 87);

    final HomescreenController controller = Get.put(HomescreenController());

    //lets define some variables to give us the proportion of each segment
    int firstSectionValue = (controller.getReadyTime.value / 60).toInt();
    int secondSectionValue = (controller.transportTime.value / 60).toInt();
    int thirdSectionValue = (controller.eventDuration.value).toInt();

    final totalValue =
        firstSectionValue + secondSectionValue + thirdSectionValue;
    final firstSectionWidth = firstSectionValue.toDouble() / totalValue;
    final secondSectionWidth = secondSectionValue.toDouble() / totalValue;
    final thirdSectionWidth = thirdSectionValue.toDouble() / totalValue;

    const IconData directions_walk =
        IconData(0xe1e1, fontFamily: 'MaterialIcons');

    const IconData calendar_today =
        IconData(0xe122, fontFamily: 'MaterialIcons');

    return Scaffold(
        body: Center(
            child: Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 40),
        //here we have some headers indicating the event name and location
        Row(
          children: [
            //this sized box gives us a little bit of for the event name and
            //location, which were originally pressed up against the left side of the
            //screen.
            const SizedBox(width: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(controller.title.value,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 28,
                      ))),
                ),
                Obx(
                  () => Text("at " + controller.location.value,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 17,
                      ))),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 40),
        SizedBox(
          width: 300,
          height: 300,
          child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: <Widget>[
                CircularProgressIndicator(
                  value: 0,
                  strokeWidth: 17,
                  color: darkBlue,
                  backgroundColor: lightBlue,
                ),
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Ready In',
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
                            //this shows the time inside the circle
                            controller.timeDisplay.value,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 64, 149, 249),
                              fontSize: 45,
                            ))),
                      ),
                      Obx(
                        () => Text('Start at ' + controller.startAtString.value,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontSize: 30,
                            ))),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  height: 40,
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset('assets/toothbrush.png', color: darkBlue),
                ),
                Obx(() => HorizontalBarWidget(
                      firstSectionValue:
                          (controller.getReadyTime.value / 60).toInt(),
                      secondSectionValue:
                          (controller.transportTime.value / 60).toInt(),
                      thirdSectionValue:
                          (controller.eventDuration.value).toInt(),
                    )),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.all(4.0),
                    child:
                        Image.asset('assets/toothbrush.png', color: lightBlue),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                      controller.startAtString.value +
                          "-" +
                          controller.startTravelString.value,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 20,
                      ))),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: firstSectionWidth * 325,
                    height: 20,
                    child: Container(color: lightBlue),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(directions_walk, size: 35, color: lightGreen),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                      controller.startTravelString.value +
                          "-" +
                          controller.startEventString.value,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 20,
                      ))),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: secondSectionWidth * 325,
                    height: 20,
                    child: Container(color: lightGreen),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(calendar_today, size: 35, color: lightOrange),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                      controller.startEventString.value +
                          "-" +
                          controller.endEventString.value,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 20,
                      ))),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: thirdSectionWidth * 325,
                    height: 20,
                    child: Container(color: lightOrange),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    )));
  }
}

class HorizontalBarWidget extends StatelessWidget {
  final int firstSectionValue;
  final int secondSectionValue;
  final int thirdSectionValue;

  HorizontalBarWidget({
    required this.firstSectionValue,
    required this.secondSectionValue,
    required this.thirdSectionValue,
  });

  @override
  Widget build(BuildContext context) {
    final totalValue =
        firstSectionValue + secondSectionValue + thirdSectionValue;
    final firstSectionWidth = firstSectionValue.toDouble() / totalValue;
    final secondSectionWidth = secondSectionValue.toDouble() / totalValue;
    final thirdSectionWidth = thirdSectionValue.toDouble() / totalValue;

    Color darkBlue = const Color.fromARGB(255, 64, 149, 249);
    Color lightBlue = Color.fromARGB(255, 65, 159, 243);

    Color lightGreen = const Color.fromARGB(255, 0, 201, 153);
    Color lightOrange = const Color.fromARGB(255, 237, 123, 87);

    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Column(
            children: [
              SizedBox(
                width: firstSectionWidth * 325,
                height: 20,
                child: Container(color: lightBlue),
              ),
              Text(
                firstSectionValue.toString() + " min",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 15,
                )),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                width: secondSectionWidth * 325,
                height: 20,
                child: Container(color: lightGreen),
              ),
              Text(
                secondSectionValue.toString() + " min",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 15,
                )),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                width: thirdSectionWidth * 325,
                height: 20,
                child: Container(color: lightOrange),
              ),
              Text(
                thirdSectionValue.toString() + " min",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 15,
                )),
                //TODO: fix min alignment so that disproportionate times
                //do not create gaps between rectangles
              ),
            ],
          ),
        ],
      ),
    );
  }
}
