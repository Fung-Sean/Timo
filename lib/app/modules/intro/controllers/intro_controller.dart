import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:timo_test/app/modules/login/controllers/login_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as GoogleAPI;
import 'package:http/io_client.dart' show IOClient, IOStreamedResponse;
import 'package:http/http.dart' show BaseRequest, Response;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:timo_test/app/modules/login/providers/google_auth_provider.dart';
import 'dart:io' show Platform;

class IntroController extends GetxController {
  //google sign-in initialization
  final GoogleSignIn _googleSignIn =
      GoogleSignIn(scopes: <String>[GoogleAPI.CalendarApi.calendarScope]);

  //google user sign-in variable
  late GoogleSignInAccount _currentUser;

  //gCal events data
  late List<GoogleAPI.Event> gcalDataFetch;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  void appendToLocalStorage() async {
    //list that fetches Google API data
    List<GoogleAPI.Event> eventsFetched = gcalDataFetch;

    //class that handles gathering data from each GoogleAPI Event
    GoogleDataSource eventsData = GoogleDataSource(events: eventsFetched);

    //list to store all events that will be encoded to json
    List<Event> events = [];

    //loop through all events that were fetched from Google API
    for (int i = 0; i < eventsData.appointments!.length; i++) {
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

    if (await file.exists()) {
      print("Successful append to local storage");
    }
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
    _googleSignIn.signOut();
    //checks if there is a new user account; if there is show login screen otherwise signIn "silently"
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        _currentUser = account;
        _currentUser.clearAuthCache();

        //if they are logged in, grab calendar data
        if (_currentUser != null) {
          print("Success!");
        }
      } else {
        print("User cancelled sign-in");
      }
    });
    _googleSignIn.signInSilently();
    _currentUser = (await _googleSignIn.signIn())!;
    final GoogleAuthProvider httpClient =
        GoogleAuthProvider(await _currentUser.authHeaders);
    final GoogleAPI.CalendarApi calendarApi = GoogleAPI.CalendarApi(httpClient);
    final now = DateTime.now().toUtc();
    print(now);
    final GoogleAPI.Events calEvents = await calendarApi.events.list(
      "primary",
      timeMin: now,
      timeMax: now.add(Duration(days: 1)),
      singleEvents: true,
      orderBy: 'startTime',
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
    gcalDataFetch = appointments;
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
