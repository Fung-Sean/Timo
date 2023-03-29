import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as GoogleAPI;
import 'package:http/io_client.dart' show IOClient, IOStreamedResponse;
import 'package:http/http.dart' show BaseRequest, Response;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:timo_test/app/modules/login/providers/google_auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  //google sign-in initialization
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '763150906246-jhrqn6r1ekpo27e8tq2ec1qe78421e5h.apps.googleusercontent.com',
    serverClientId:
        '763150906246-g0iqj1ce5rro6vh8tutj37brh6nuda75.apps.googleusercontent.com',
    scopes: <String>[GoogleAPI.CalendarApi.calendarScope],
  );

  //google user sign-in variable
  GoogleSignInAccount? _currentUser;
  final filename = "local_user";
  //late SharedPreferences prefs;

/*
  asyncFunc() async {
    // Async func to handle Futures easier; or use Future.then
    prefs = await SharedPreferences.getInstance();
  }
  */

  @override
  void onInit() {
    //final testRef = database.child("/test");
    //dispose();
    super.onInit();
    //when a user logs in
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      _currentUser = account;

      //if they are logged in, grab calendar data
      if (_currentUser != null) {
        appendToLocalStorage();
      }
    });
    _googleSignIn.signInSilently();
  }

  void appendToLocalStorage() async {
    //list that fetches Google API data
    List<GoogleAPI.Event> eventsFetched = await getGoogleEventsData();

    //class that handles gathering data from each GoogleAPI Event
    GoogleDataSource eventsData = GoogleDataSource(events: eventsFetched);

    //list to store all events that will be encoded to json
    List<Event> events = [];

    //loop through all events that were fetched from Google API
    for (int i = 0; i < eventsData.appointments.length; i++) {
      //gather event start time, current time and calculate difference
      var eventTime = eventsData.getStartTime(i);
      DateTime now = DateTime.now();
      var difference = now.compareTo(eventTime);

      //if the event is in the future
      if (difference < 0) {
        //define the Event class and fill in the properties for it
        String date =
            DateFormat('EEEE, MMMM d, y').format(eventsData.getStartTime(i));
        String startTime =
            DateFormat('h:mm a').format(eventsData.getStartTime(i));
        String endTime = DateFormat('h:mm a').format(eventsData.getEndTime(i));
        Event event = Event(
            title: eventsData.getSubject(i),
            description: eventsData.getNotes(i),
            start: startTime,
            end: endTime,
            date: date,
            location: eventsData.getLocation(i));
        events.add(event);
      }
    }

    //encode all the future events to json format
    String json = jsonEncode(events.map((e) => e.toJson()).toList());

    //get the phone's App Docs directory
    var directory = await getApplicationDocumentsDirectory();

    //use directory to create full filepath
    var filePath = '${directory.path}/data.json';

    //create file at specified filePath
    var file = File(filePath);

    //write json data to file
    file.writeAsString(json);

    readDataFromLocalStorage();
  }

  Future<List<Event>> readDataFromLocalStorage() async {
    //get the phone's App Docs directory
    var directory = await getApplicationDocumentsDirectory();

    //use directory to create full filepath
    final file = File('${directory.path}/data.json');

    //store event data extracted from json
    List<Event> events = [];

    //checks if file exists
    if (await file.exists()) {
      //reads json data in file
      final jsonData = await file.readAsString();

      //decodes it using jsonDecode
      final data = jsonDecode(jsonData);

      //loops through each event field
      for (var element in data) {
        //fills in event info from json data
        Event event = Event(
            title: element['title'],
            description: element['description'],
            start: element['start'],
            end: element['end'],
            date: element['date'],
            location: element['location']);

        //adds it to list of evenets
        events.add(event);
      }
/*
      print(events[0].title);
      print(events[0].description);
      print(events[0].start);
      print(events[0].end);
      print(events[0].date);
      print(events[0].location);
*/
      //returns event
      return events;
    } else {
      //if file not able to be opened, throw an exception
      throw Exception("File does not exist");
    }
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    dispose();
  }

  @override
  void dispose() {
    if (_googleSignIn.currentUser != null) {
      _googleSignIn.disconnect();
      _googleSignIn.signOut();
    }
    super.dispose();
  }

  Future<List<GoogleAPI.Event>> getGoogleEventsData() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    final GoogleAuthProvider httpClient =
        GoogleAuthProvider(await googleUser!.authHeaders);

    final GoogleAPI.CalendarApi calendarApi = GoogleAPI.CalendarApi(httpClient);
    final GoogleAPI.Events calEvents = await calendarApi.events.list(
      "primary",
    );
    final List<GoogleAPI.Event> appointments = <GoogleAPI.Event>[];
    if (calEvents.items != null) {
      for (int i = 0; i < calEvents.items!.length; i++) {
        final GoogleAPI.Event event = calEvents.items![i];
        if (event.start == null) {
          continue;
        }
        appointments.add(event);
      }
    }

    return appointments;
  }
}

class GoogleDataSource extends CalendarDataSource {
  GoogleDataSource({required List<GoogleAPI.Event>? events}) {
    appointments = events;
  }

  @override
  DateTime getStartTime(int index) {
    final GoogleAPI.Event event = appointments![index];
    return event.start?.date ?? event.start!.dateTime!.toLocal();
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].start.date != null;
  }

  @override
  DateTime getEndTime(int index) {
    final GoogleAPI.Event event = appointments![index];
    return event.endTimeUnspecified != null && event.endTimeUnspecified!
        ? (event.start?.date ?? event.start!.dateTime!.toLocal())
        : (event.end?.date != null
            ? event.end!.date!.add(const Duration(days: -1))
            : event.end!.dateTime!.toLocal());
  }

  @override
  String getLocation(int index) {
    return appointments![index].location ?? '';
  }

  @override
  String getNotes(int index) {
    return appointments![index].description ?? '';
  }

  @override
  String getSubject(int index) {
    final GoogleAPI.Event event = appointments![index];
    return event.summary == null || event.summary!.isEmpty
        ? 'No Title'
        : event.summary!;
  }
}

class Event {
  final String title;
  final String description;
  final String start;
  final String end;
  final String location;
  final String date;

  Event(
      {this.location = "None",
      required this.title,
      required this.description,
      required this.start,
      required this.end,
      required this.date});

  // Convert the Event object to a Map that can be encoded as JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'start': start,
      'end': end,
      'location': location,
      'date': date
    };
  }
}
