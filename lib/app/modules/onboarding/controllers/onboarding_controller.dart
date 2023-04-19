import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

//a class to keep track of each type of transportation and whether or
//not its been selected
class Transportation {
  String name;
  bool isSelected;

  Transportation({required this.name, required this.isSelected});
}

class OnboardingController extends GetxController {
  final count = 0.obs;
  double progressSliderValue = 0.0;
  List<Transportation> userSelections = [];
  List<String> TransportationNames = [
    "Walk",
    "Bike",
    "Bus",
    "Train",
    "Car",
    "Uber",
  ];
  //add the 6 types of transportation types to a simple list

  int minutesToGetReady = 0;

  //here we create transportation objects, composed of a string of its name and a boolean
  //for if its selected
  OnboardingController() {
    for (var i = 0; i < TransportationNames.length; i++) {
      Transportation transport =
          Transportation(name: TransportationNames[i], isSelected: false);
      userSelections.add(transport);
    }
  }

  @override
  Future<void> onInit() async {
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

  //Getter and setter methods for the dynamic values of these screens, like
  //the progress slider at the top of the view
  double getProgressSliderValue() {
    return progressSliderValue;
  }

  void setProgressSliderValue(double input) {
    progressSliderValue = input;
  }

  //when a transportation button is pressed, the selection of that transportation item
  //is reversed from what it currently is, either selected or deselected
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

  int getMinutesToGetReady() {
    return minutesToGetReady;
  }

  void setMinutesToGetReady(int mins) {
    minutesToGetReady = mins;
  }

  void onOnboardingExit(int numMinutes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //first we must save the user's transportation selections
    for (var i = 0; i < userSelections.length; i++) {
      if (userSelections[i].isSelected == true) {
        //just save their first selection
        await prefs.setString("transportation", userSelections[i].name);
        break;
      }
    }
    await prefs.setInt("time", numMinutes);
  }

  void increment() => count.value++;
}
