import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../screens/jokes_list_screen.dart';
import '../screens/favorite_jokes_screen.dart';
import '../models/joke.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'random_joke_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Joke> favoriteJokes = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _scheduleDailyNotification();
  }

  void _initializeNotifications() async {
    var androidInitializationSettings = AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _scheduleDailyNotification() async {
    var androidDetails = AndroidNotificationDetails(
      'daily_id',
      'Daily Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'Daily Joke Reminder',
      'Check the joke of the day!',
      RepeatInterval.daily,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Joke Types"),
        actions: [
          IconButton(
            icon: Icon(Icons.casino),
            onPressed: () {
              Navigator.pushNamed(context, '/random-joke');
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteJokesScreen(favoriteJokes: favoriteJokes),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<String>>(
              future: ApiService.fetchJokeTypes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  final types = snapshot.data!;
                  return ListView.builder(
                    itemCount: types.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(types[index]),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JokesListScreen(
                                type: types[index],
                                onFavoriteToggle: (joke) {
                                  setState(() {
                                    if (joke.isFavorite) {
                                      favoriteJokes.add(joke);
                                    } else {
                                      favoriteJokes.remove(joke);
                                    }
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
