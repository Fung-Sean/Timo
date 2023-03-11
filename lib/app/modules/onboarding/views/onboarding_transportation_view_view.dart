import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:timo_test/app/modules/onboarding/views/preptime_view.dart';

import '../controllers/onboarding_controller.dart';

import 'package:flutter/material.dart';

import '../../login/views/login_view.dart';
//import '../../login/bindings/login_binding.dart';
import '../../../routes/app_pages.dart';
//import '../../../routes/app_routes.dart';
//import '../modules/login/views/login_view.dart';

class TransportationView extends GetView<OnboardingController> {
  const TransportationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    OnboardingController control = OnboardingController();
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
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      backgroundColor:
          const Color.fromARGB(255, 112, 180, 252), // Background color
      fixedSize: const Size(
        300,
        70,
      ),
    );

    var walkIsPressed = false.obs;
    var bikeIsPressed = false.obs;
    var busIsPressed = false.obs;
    var trainIsPressed = false.obs;
    var carIsPressed = false.obs;
    return Scaffold(
      // appBar: AppBar(
      //   //title: const Text('TIMO'),
      //   centerTitle: true,
      //   backgroundColor: Color.fromARGB(150, 110, 177, 255),
      // ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 40),
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
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                      width: 150.00,
                      height: 150.00,
                      child: Obx(
                        () => ElevatedButton.icon(
                          onPressed: () {
                            walkIsPressed.value = !(walkIsPressed.value);
                            print("Walking Selected");
                            control.selectTransportation("Walk");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: walkIsPressed.value
                                ? const Color.fromARGB(255, 52, 120, 202)
                                : const Color.fromARGB(255, 112, 180, 252),
                          ),
                          icon: const Icon(directions_walk,
                              size: 70, color: Colors.black),
                          label: Text(''),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                      width: 150.00,
                      height: 150.00,
                      child: Obx(
                        () => ElevatedButton.icon(
                          onPressed: () {
                            bikeIsPressed.value = !(bikeIsPressed.value);
                            print("Biking Selected");
                            control.selectTransportation("Bike");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bikeIsPressed.value
                                ? const Color.fromARGB(255, 52, 120, 202)
                                : const Color.fromARGB(255, 112, 180, 252),
                          ),
                          icon: const Icon(directions_bike,
                              size: 70, color: Colors.black),
                          label: Text(''),
                        ),
                      )),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                      width: 150.00,
                      height: 150.00,
                      child: Obx(
                        () => ElevatedButton.icon(
                          onPressed: () {
                            busIsPressed.value = !(busIsPressed.value);
                            print("Bus Selected");
                            control.selectTransportation("Bus");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: busIsPressed.value
                                ? const Color.fromARGB(255, 52, 120, 202)
                                : const Color.fromARGB(255, 112, 180, 252),
                          ),
                          icon: const Icon(directions_bus_sharp,
                              size: 70, color: Colors.black),
                          label: Text(''),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                      width: 150.00,
                      height: 150.00,
                      child: Obx(
                        () => ElevatedButton.icon(
                          onPressed: () {
                            trainIsPressed.value = !(trainIsPressed.value);
                            print("Train Selected");
                            control.selectTransportation("Train");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: trainIsPressed.value
                                ? const Color.fromARGB(255, 52, 120, 202)
                                : const Color.fromARGB(255, 112, 180, 252),
                          ),
                          icon:
                              const Icon(train, size: 70, color: Colors.black),
                          label: Text(''),
                        ),
                      )),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                      width: 150.00,
                      height: 150.00,
                      child: Obx(
                        () => ElevatedButton.icon(
                          onPressed: () {
                            carIsPressed.value = !(carIsPressed.value);
                            print("Car Selected");
                            control.selectTransportation("Car");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: carIsPressed.value
                                ? const Color.fromARGB(255, 52, 120, 202)
                                : const Color.fromARGB(255, 112, 180, 252),
                          ),
                          icon: const Icon(directions_car,
                              size: 70, color: Colors.black),
                          label: Text(''),
                        ),
                      )),
                ),
              ],
            ),
            const Expanded(child: SizedBox(height: 10)),
            ElevatedButton(
                style: style,
                onPressed: () {
                  Get.to(const PreptimeView());
                  Get.put(OnboardingController());
                },
                child: const Text('Continue')),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
