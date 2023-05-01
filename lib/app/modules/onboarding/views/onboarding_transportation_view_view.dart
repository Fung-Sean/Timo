import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timo_test/app/modules/onboarding/views/event_selection_view.dart';
import 'package:timo_test/app/modules/onboarding/views/preptime_view.dart';

import '../controllers/onboarding_controller.dart';

import 'package:flutter/material.dart';

import '../../login/views/login_view.dart';
import '../../../routes/app_pages.dart';

OnboardingController control = OnboardingController();

class TransportationView extends GetView<OnboardingController> {
  const TransportationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double _value = control.getProgressSliderValue();
    const IconData directions_bike =
        IconData(0xe1d2, fontFamily: 'MaterialIcons');
    const IconData directions_walk =
        IconData(0xe1e1, fontFamily: 'MaterialIcons');
    const IconData directions_bus_sharp =
        IconData(0xe8d2, fontFamily: 'MaterialIcons');
    const IconData train = IconData(0xe675, fontFamily: 'MaterialIcons');
    const IconData directions_car =
        IconData(0xe1d7, fontFamily: 'MaterialIcons');
    const IconData attach_money = IconData(0xe0b2, fontFamily: 'MaterialIcons');
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      backgroundColor:
          const Color.fromARGB(255, 112, 180, 252), // Background color
      fixedSize: const Size(
        300,
        70,
      ),
    );

    const Color blue = Color.fromARGB(255, 64, 149, 249);
    const Color red = Color.fromARGB(255, 232, 114, 92);
    const Color purple = Color.fromARGB(255, 104, 88, 247);
    const Color green = Color.fromARGB(255, 48, 202, 154);
    const Color yellow = Color.fromARGB(255, 252, 196, 87);
    const Color pink = Color.fromARGB(255, 250, 121, 164);
    const Color gray = Color.fromARGB(217, 217, 217, 217);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Stack(
              children: [
                Positioned(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircularProgressIndicator(
                          value: _value / 100,
                          backgroundColor: gray,
                          strokeWidth: 5,
                        ),
                        SizedBox(width: 30.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'What are your preferred modes of transportation?',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 17,
                )),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 350.00,
                height: 60.00,
                child: Obx(() => CheckboxListTile(
                      title: Text("Walking",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: control.userSelections[0].isSelected.value
                                ? Colors.white
                                : blue,
                            fontSize: 17,
                          ))),
                      value: control.userSelections[0].isSelected.value,
                      onChanged: (selection) {
                        control.selectTransportation("Walk");
                      },
                      secondary: Icon(directions_walk,
                          size: 40,
                          color: control.userSelections[0].isSelected.value
                              ? Colors.white
                              : blue),
                      activeColor: blue,
                      checkColor: Colors.white,
                      tileColor: Colors.transparent,
                      selectedTileColor: blue,
                      selected: control.userSelections[0].isSelected.value,
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
                      title: Text("Train",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: control.userSelections[1].isSelected.value
                                ? Colors.white
                                : blue,
                            fontSize: 17,
                          ))),
                      value: control.userSelections[1].isSelected.value,
                      onChanged: (selection) {
                        control.selectTransportation("Train");
                      },
                      secondary: Icon(train,
                          size: 40,
                          color: control.userSelections[1].isSelected.value
                              ? Colors.white
                              : blue),
                      activeColor: blue,
                      checkColor: Colors.white,
                      tileColor: Colors.transparent,
                      selectedTileColor: blue,
                      selected: control.userSelections[1].isSelected.value,
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
                      title: Text("Bus",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: control.userSelections[2].isSelected.value
                                ? Colors.white
                                : blue,
                            fontSize: 17,
                          ))),
                      value: control.userSelections[2].isSelected.value,
                      onChanged: (selection) {
                        control.selectTransportation("Bus");
                      },
                      secondary: Icon(directions_bus_sharp,
                          size: 40,
                          color: control.userSelections[2].isSelected.value
                              ? Colors.white
                              : blue),
                      activeColor: blue,
                      checkColor: Colors.white,
                      tileColor: Colors.transparent,
                      selectedTileColor: blue,
                      selected: control.userSelections[2].isSelected.value,
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
                      title: Text("Biking",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: control.userSelections[3].isSelected.value
                                ? Colors.white
                                : blue,
                            fontSize: 17,
                          ))),
                      value: control.userSelections[3].isSelected.value,
                      onChanged: (selection) {
                        control.selectTransportation("Bike");
                      },
                      secondary: Icon(directions_bike,
                          size: 40,
                          color: control.userSelections[3].isSelected.value
                              ? Colors.white
                              : blue),
                      activeColor: blue,
                      checkColor: Colors.white,
                      tileColor: Colors.transparent,
                      selectedTileColor: blue,
                      selected: control.userSelections[3].isSelected.value,
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
                      title: Text("Car",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: control.userSelections[4].isSelected.value
                                ? Colors.white
                                : blue,
                            fontSize: 17,
                          ))),
                      value: control.userSelections[4].isSelected.value,
                      onChanged: (selection) {
                        control.selectTransportation("Car");
                      },
                      secondary: Icon(directions_car,
                          size: 40,
                          color: control.userSelections[4].isSelected.value
                              ? Colors.white
                              : blue),
                      activeColor: blue,
                      checkColor: Colors.white,
                      tileColor: Colors.transparent,
                      selectedTileColor: blue,
                      selected: control.userSelections[4].isSelected.value,
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
                      title: Text("Ride share app",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: control.userSelections[5].isSelected.value
                                ? Colors.white
                                : blue,
                            fontSize: 17,
                          ))),
                      value: control.userSelections[5].isSelected.value,
                      onChanged: (selection) {
                        control.selectTransportation("Uber");
                      },
                      secondary: Icon(attach_money,
                          size: 40,
                          color: control.userSelections[5].isSelected.value
                              ? Colors.white
                              : blue),
                      activeColor: blue,
                      checkColor: Colors.white,
                      tileColor: Colors.transparent,
                      selectedTileColor: blue,
                      selected: control.userSelections[5].isSelected.value,
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
                    Get.to(const EventSelectionView());
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

// class HollowCircleButton extends StatefulWidget {
//   @override
//   final String transportationType;
//   final IconData icon;
//   final Color color;
//   HollowCircleButton(
//       {required this.transportationType,
//       required this.icon,
//       required this.color});
//   _HollowCircleButtonState createState() => _HollowCircleButtonState();
// }

// class _HollowCircleButtonState extends State<HollowCircleButton> {
//   bool _isPressed = false;

//   @override
//   Widget build(BuildContext context) {
//     return InkResponse(
//       onTap: () {
//         setState(() {
//           _isPressed = !_isPressed;
//           //walkIsPressed.value = !(walkIsPressed.value);
//           control.selectTransportation(widget.transportationType);
//         });
//       },
//       child: Container(
//         width: 150,
//         height: 150,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: _isPressed ? widget.color : Colors.transparent,
//           border: Border.all(
//             color: widget.color,
//             width: 8,
//           ),
//         ),
//         child: Icon(
//           widget.icon,
//           size: 80,
//           color: _isPressed ? Colors.white : widget.color,
//         ),
//       ),
//     );
//   }
// }