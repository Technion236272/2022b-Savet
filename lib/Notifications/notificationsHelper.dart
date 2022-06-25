import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as notifs;
import 'package:rxdart/subjects.dart' as rxSub;

class NotificationClass {
  final int id;
  final String? title;
  final String? body;
  final String? payload;
  NotificationClass(
      {required this.id,
      required this.body,
      required this.payload,
      required this.title});
}

final rxSub.BehaviorSubject<NotificationClass>
    didReceiveLocalNotificationSubject =
    rxSub.BehaviorSubject<NotificationClass>();
final rxSub.BehaviorSubject<String> selectNotificationSubject =
    rxSub.BehaviorSubject<String>();

Future<void> initNotifications(
    notifs.FlutterLocalNotificationsPlugin notifsPlugin) async {
  var initializationSettingsAndroid =
      notifs.AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = notifs.IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationSubject.add(NotificationClass(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = notifs.InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await notifsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    selectNotificationSubject.add(payload!);
  });
}

Future<void> scheduleNotification(
    notifs.FlutterLocalNotificationsPlugin notifsPlugin,
    String id,
    String title,
    String body,
    DateTime scheduledTime,
    int not_id,
    String? image) async {
  // var styleInfo;
  // if (image != " ") {
  //   var largeIcon = await await Image(
  //       fit: BoxFit.cover, width: double.infinity, image: NetworkImage(image!));
  //   var bigPicturePath = await Image(
  //       fit: BoxFit.cover, width: double.infinity, image: NetworkImage(image));
  //   styleInfo = BigPictureStyleInformation(
  //     FilePathAndroidBitmap(bigPicturePath.toString()),
  //     largeIcon: FilePathAndroidBitmap(largeIcon.toString()),
  //   );
  // }
  var androidSpecifics = notifs.AndroidNotificationDetails(
      id, // This specifies the ID of the Notification
      'Scheduled notification', // This specifies the name of the notification channel//This specifies the description of the channel
      icon: '@mipmap/ic_launcher',
      priority: Priority.high,
      //styleInformation: styleInfo,
      importance: Importance.max);
  var iOSSpecifics = notifs.IOSNotificationDetails();
  var platformChannelSpecifics =
      notifs.NotificationDetails(android: androidSpecifics, iOS: iOSSpecifics);
  await notifsPlugin.schedule(
    not_id,
    title,
    body,
    scheduledTime,
    platformChannelSpecifics,
  ); // This literally schedules the notification

  ///the id is a global int from main check if there is other solution to identify the notification
}

Future<void> turnOffNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> turnOffNotificationById(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    int id) async {
  await flutterLocalNotificationsPlugin.cancel(id);
}
