import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show File, Platform;
import 'package:rxdart/subjects.dart';

NotificationPlugin notificationPlugin = NotificationPlugin._();

class NotificationPlugin {
  //
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  //this shit is for handling the issue with ios versions that are less than 10 *_*
  final BehaviorSubject<ReceivedNotification>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  var initializationSettings;

  NotificationPlugin._() {
    //initialize the plugin
    print('initialized');
    init();
  }
  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecifics();
  }

  initializePlatformSpecifics() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        print('triggered $id');
        ReceivedNotification receivedNotification = ReceivedNotification(
            id: id, title: title, body: body, payload: payload);
        didReceivedLocalNotificationSubject.add(receivedNotification);
      },
    );
    initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }

  setListenerForLowerVersions(Function onNotificationInLowerVersions) {
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> showNotification() async {
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      "CHANNEL_DESCRIPTION",
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'test',
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Test Title',
      'Test Body', //null
      platformChannelSpecifics,
      payload: 'New Payload',
    );
  }

  Future<void> showDailyAtTime(int id, String body, Time time) async {
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 4',
      'CHANNEL_NAME 4',
      "CHANNEL_DESCRIPTION 4",
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      id,
      'Your daily challenge!',
      body,
      time,
      platformChannelSpecifics,
      payload: 'Test Payload ${time.hour}:${time.minute}, daily',
    );
  }

  Future<void> showWeeklyAtDayTime(
      int id, String body, Day day, Time time) async {
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 5',
      'CHANNEL_NAME 5',
      "CHANNEL_DESCRIPTION 5",
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
      id,
      'Your weekly challenge!',
      body, //null
      day,
      time,
      platformChannelSpecifics,
      payload: 'Test Payload ${time.hour}:${time.minute}, ${day.value}',
    );
  }

  // Future<void> repeatNotification() async {
  //   var androidChannelSpecifics = AndroidNotificationDetails(
  //     'CHANNEL_ID 3',
  //     'CHANNEL_NAME 3',
  //     "CHANNEL_DESCRIPTION 3",
  //     importance: Importance.Max,
  //     priority: Priority.High,
  //     styleInformation: DefaultStyleInformation(true, true),
  //   );
  //   var iosChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics =
  //       NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.periodicallyShow(
  //     0,
  //     'Repeating Test Title',
  //     'Repeating Test Body',
  //     RepeatInterval.EveryMinute,
  //     platformChannelSpecifics,
  //     payload: 'Test Payload',
  //   );
  // }
  //
  // Future<void> scheduleNotification() async {
  //   var scheduleNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
  //   var androidChannelSpecifics = AndroidNotificationDetails(
  //     'CHANNEL_ID 1',
  //     'CHANNEL_NAME 1',
  //     "CHANNEL_DESCRIPTION 1",
  //     // icon: 'secondary_icon',
  //     // sound: RawResourceAndroidNotificationSound('my_sound'),
  //     // largeIcon: DrawableResourceAndroidBitmap('large_notf_icon'),
  //     // enableLights: true,
  //     // color: const Color.fromARGB(255, 255, 0, 0),
  //     // ledColor: const Color.fromARGB(255, 255, 0, 0),
  //     // ledOnMs: 1000,
  //     // ledOffMs: 500,
  //     importance: Importance.Max,
  //     priority: Priority.High,
  //     // playSound: true,
  //     // timeoutAfter: 5000,
  //     // styleInformation: DefaultStyleInformation(true, true),
  //   );
  //   var iosChannelSpecifics = IOSNotificationDetails(
  //     sound: 'my_sound.aiff',
  //   );
  //   var platformChannelSpecifics = NotificationDetails(
  //     androidChannelSpecifics,
  //     iosChannelSpecifics,
  //   );
  //   await flutterLocalNotificationsPlugin.schedule(
  //     0,
  //     'Test Title',
  //     'Test Body',
  //     scheduleNotificationDateTime,
  //     platformChannelSpecifics,
  //     payload: 'Test Payload',
  //   );
  // }

  Future<int> getPendingNotificationCount() async {
    List<PendingNotificationRequest> p =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    for (int i = 0; i < p.length; i++) {
      print('body: ${p[i].body}. id: ${p[i].id}. payload: ${p[i].payload}');
    }
    return p.length;
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}
