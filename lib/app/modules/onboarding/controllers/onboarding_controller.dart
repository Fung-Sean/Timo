import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

//a class to keep track of each type of transportation and whether or
//not its been selected
class Transportation {
  String name;
  RxBool isSelected;

  Transportation({required this.name, required this.isSelected});
}

class EventType {
  String name;
  RxBool isSelected;
  EventType({required this.name, required this.isSelected});
}

class OnboardingController extends GetxController {
  final count = 0.obs;
  double progressSliderValue = 0.0;
  List<Transportation> userSelections = [];
  List<EventType> eventSelection = [];
  List<String> TransportationNames = [
    "Walk",
    "Train",
    "Bus",
    "Bike",
    "Car",
    "Uber",
  ];
  List<String> EventNames = [
    "Classes",
    "Meetings",
    "Hangouts",
    "Custom",
  ];
  //add the 6 types of transportation types to a simple list

  int minutesToGetReady = 0;

  //here we create transportation objects, composed of a string of its name and a boolean
  //for if its selected
  OnboardingController() {
    for (var i = 0; i < TransportationNames.length; i++) {
      Transportation transport =
          Transportation(name: TransportationNames[i], isSelected: false.obs);
      userSelections.add(transport);
    }
    for (var i = 0; i < EventNames.length; i++) {
      EventType event = EventType(name: EventNames[i], isSelected: false.obs);
      eventSelection.add(event);
    }
  }

  @override
  Future<void> onInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("Walk", false);
    await prefs.setBool("Train", false);
    await prefs.setBool("Bus", false);
    await prefs.setBool("Bike", false);
    await prefs.setBool("Car", false);
    await prefs.setBool("Uber", false);
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
  void selectTransportation(String name) async {
    bool found = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var i = 0; i < userSelections.length; i++) {
      if (name == userSelections[i].name) {
        found = true;

        if (userSelections[i].isSelected.value == false) {
          userSelections[i].isSelected.value = true;
          print(userSelections[i].name + " is true");
          await prefs.setBool(userSelections[i].name, true);
        } else {
          userSelections[i].isSelected.value = false;
          print(userSelections[i].name + " is false");
          await prefs.setBool(userSelections[i].name, false);
        }
      }
    }
    if (found == false) {
      print("transportation method does not exist.");
    }
  }

  void selectEvent(String name) {
    bool found = false;
    for (var i = 0; i < eventSelection.length; i++) {
      if (name == eventSelection[i].name) {
        found = true;

        if (eventSelection[i].isSelected.value == false) {
          eventSelection[i].isSelected.value = true;
          print(eventSelection[i].name + " is true");
        } else {
          eventSelection[i].isSelected.value = false;
          print(eventSelection[i].name + " is false");
        }
      }
    }
    if (found == false) {
      print("event type does not exist.");
    }
  }

  void seenIntroScreens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("beenSeen", true);
  }

  int getMinutesToGetReady() {
    return minutesToGetReady;
  }

  void setMinutesToGetReady(int mins) {
    minutesToGetReady = mins;
  }

  void onOnboardingExit(int numMinutes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt("time", numMinutes);
  }

  void onEarlyArrivalExit(int numMinutes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("early", numMinutes);
  }

  void increment() => count.value++;
}
