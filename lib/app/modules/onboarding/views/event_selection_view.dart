import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:timo_test/app/modules/onboarding/views/preptime_view.dart';

import '../controllers/onboarding_controller.dart';

import 'package:flutter/material.dart';

import '../../login/views/login_view.dart';
import '../../../routes/app_pages.dart';

OnboardingController control = OnboardingController();

class EventSelectionView extends GetView<OnboardingController> {
  const EventSelectionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double _value = control.getProgressSliderValue();
    const Color blue = Color.fromARGB(255, 64, 149, 249);
    control.setProgressSliderValue(33);
    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        backgroundColor:
            const Color.fromARGB(255, 112, 180, 252), // Background color
        fixedSize: const Size(
          300,
          70,
        ));
    return Scaffold(
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50),
            Container(
              width: double.maxFinite,
              child: Slider(
                min: 0.0,
                max: 100.0,
                value: _value,
                onChanged: (value) {
                  value = control.getProgressSliderValue();
                },
              ),
            ),
            //const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'What are your preferred modes of transportation?',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 22,
                )),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 350.00,
                height: 60.00,
                child: Obx(() => CheckboxListTile(
                      title: Text("Classes",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: control.eventSelection[0].isSelected.value
                                ? Colors.white
                                : blue,
                            fontSize: 20,
                          ))),
                      value: control.eventSelection[0].isSelected.value,
                      onChanged: (selection) {
                        control.selectEvent("Classes");
                      },
                      activeColor: blue,
                      checkColor: Colors.white,
                      tileColor: Colors.transparent,
                      selectedTileColor: blue,
                      selected: control.eventSelection[0].isSelected.value,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: blue, width: 4),
                      ),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 350.00,
                height: 60.00,
                child: Obx(() => CheckboxListTile(
                      title: Text("Meetings",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: control.eventSelection[1].isSelected.value
                                ? Colors.white
                                : blue,
                            fontSize: 20,
                          ))),
                      value: control.eventSelection[1].isSelected.value,
                      onChanged: (selection) {
                        control.selectEvent("Meetings");
                      },
                      activeColor: blue,
                      checkColor: Colors.white,
                      tileColor: Colors.transparent,
                      selectedTileColor: blue,
                      selected: control.eventSelection[1].isSelected.value,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: blue, width: 4),
                      ),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 350.00,
                height: 60.00,
                child: Obx(() => CheckboxListTile(
                      title: Text("Hangouts",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: control.eventSelection[2].isSelected.value
                                ? Colors.white
                                : blue,
                            fontSize: 20,
                          ))),
                      value: control.eventSelection[2].isSelected.value,
                      onChanged: (selection) {
                        control.selectEvent("Hangouts");
                      },
                      activeColor: blue,
                      checkColor: Colors.white,
                      tileColor: Colors.transparent,
                      selectedTileColor: blue,
                      selected: control.eventSelection[2].isSelected.value,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: blue, width: 4),
                      ),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 350.00,
                height: 60.00,
                child: Obx(() => CheckboxListTile(
                      title: Text("Custom",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: control.eventSelection[3].isSelected.value
                                ? Colors.white
                                : blue,
                            fontSize: 20,
                          ))),
                      value: control.eventSelection[3].isSelected.value,
                      onChanged: (selection) {
                        control.selectEvent("Custom");
                      },
                      activeColor: blue,
                      checkColor: Colors.white,
                      tileColor: Colors.transparent,
                      selectedTileColor: blue,
                      selected: control.eventSelection[3].isSelected.value,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: blue, width: 4),
                      ),
                    )),
              ),
            ),

            const Expanded(child: SizedBox(height: 10)),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                  style: style,
                  onPressed: () {
                    Get.to(PreptimeView());
                    Get.put(OnboardingController());
                  },
                  child: Text(
                    'Continue',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: 22,
                    )),
                  )),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
