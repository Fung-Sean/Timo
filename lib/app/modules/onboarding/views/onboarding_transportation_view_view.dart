import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 175.00,
                    height: 175.00,
                    child: HollowCircleButton(
                        transportationType: "Walk",
                        icon: directions_walk,
                        color: blue),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 175.00,
                    height: 175.00,
                    child: HollowCircleButton(
                        transportationType: "Car",
                        icon: directions_car,
                        color: red),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 175.00,
                    height: 175.00,
                    child: HollowCircleButton(
                        transportationType: "Train",
                        icon: train,
                        color: purple),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 175.00,
                    height: 175.00,
                    child: HollowCircleButton(
                        transportationType: "Bus",
                        icon: directions_bus_sharp,
                        color: green),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 175.00,
                    height: 175.00,
                    child: HollowCircleButton(
                        transportationType: "Bike",
                        icon: directions_bike,
                        color: yellow),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 175.00,
                    height: 175.00,
                    child: HollowCircleButton(
                        transportationType: "Uber",
                        icon: attach_money,
                        color: pink),
                  ),
                ),
              ],
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

class HollowCircleButton extends StatefulWidget {
  @override
  final String transportationType;
  final IconData icon;
  final Color color;
  HollowCircleButton(
      {required this.transportationType,
      required this.icon,
      required this.color});
  _HollowCircleButtonState createState() => _HollowCircleButtonState();
}

class _HollowCircleButtonState extends State<HollowCircleButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        setState(() {
          _isPressed = !_isPressed;
          //walkIsPressed.value = !(walkIsPressed.value);
          control.selectTransportation(widget.transportationType);
        });
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isPressed ? widget.color : Colors.transparent,
          border: Border.all(
            color: widget.color,
            width: 8,
          ),
        ),
        child: Icon(
          widget.icon,
          size: 80,
          color: _isPressed ? Colors.white : widget.color,
        ),
      ),
    );
  }
}
