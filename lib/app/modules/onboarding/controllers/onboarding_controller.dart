import 'package:get/get.dart';

//a class to keep track of each type of transportation and whether or
//not its been selected
class Transportation {
  String name;
  bool isSelected;

  Transportation({required this.name, required this.isSelected});
}

class OnboardingController extends GetxController {
  //TODO: Implement OnboardingController
  final count = 0.obs;
  double progressSliderValue = 0.0;
  List<Transportation> userSelections = [];
  List<String> TransportationNames = ["Walk", "Bike", "Bus", "Train", "Car"];
  //add the 5 types of transportation types to a simple list

  int minutesToGetReady = 0;

  OnboardingController() {
    for (var i = 0; i < TransportationNames.length; i++) {
      Transportation transport =
          Transportation(name: TransportationNames[i], isSelected: false);
      userSelections.add(transport);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  double getProgressSliderValue() {
    return progressSliderValue;
  }

  void setProgressSliderValue(double input) {
    progressSliderValue = input;
  }

  void selectTransportation(String name) {
    bool found = false;
    for (var i = 0; i < userSelections.length; i++) {
      if (name == userSelections[i].name) {
        found = true;

        if (userSelections[i].isSelected == false) {
          userSelections[i].isSelected = true;
          print(userSelections[i].name + " is true");
        } else {
          userSelections[i].isSelected = false;
          print(userSelections[i].name + " is false");
        }
      }
    }
    if (found == false) {
      print("transportation method does not exist.");
    }
  }

  void setMinutesToGetReady(int mins) {
    minutesToGetReady = mins;
  }

  void increment() => count.value++;
}
