import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/random_joke_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Belgrade'));

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission();
  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received message: ${message.notification?.title}');
  });

  var androidInitialize = AndroidInitializationSettings('app_icon');
  var initializationSettings = InitializationSettings(android: androidInitialize);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await sendDailyJokeReminderNotification();

  scheduleDailyNotification();

  runApp(const MyApp());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> sendDailyJokeReminderNotification() async {
  var androidDetails = AndroidNotificationDetails(
    'daily_reminder_id',
    'Daily Joke Reminders',
    importance: Importance.max,
    priority: Priority.high,
  );
  var platformDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Daily Joke Reminder',
    'Check the joke of the day!',
    platformDetails,
  );
}

void scheduleDailyNotification() async {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  final tz.TZDateTime scheduledTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, 9, 0, 0); // 9:00 AM

  if (scheduledTime.isBefore(now)) {
    scheduledTime.add(Duration(days: 1));
  }

  var androidDetails = AndroidNotificationDetails(
    'daily_id',
    'Daily Notifications',
    importance: Importance.max,
    priority: Priority.high,
  );
  var platformDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Daily Joke Reminder',
    'Check the joke of the day!',
    scheduledTime,
    platformDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/random-joke': (context) => const RandomJokeScreen(),
      },
    );
  }
}
