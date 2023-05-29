// Purpose: Notification Widget for local push notification
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationWidget {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notifications.initialize(settings);
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(id, title, body, await notificationDetails());

  static Future showScheduleNotification({
    int id = 1,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledTime,
  }) async =>
      _notifications.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledTime, tz.local),
          await notificationDetails(),
          payload: payload,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);

  static Future<NotificationDetails> notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id 1',
        'channel name',
        importance: Importance.max,
        playSound: false,
      ),
    );
  }

  static void scheduleProductExpiryNotifications({
    required String productName,
    required String productDescription,
    required DateTime expiryDate,
  }) {
    // Schedule a notification for 1 day before the expiry date
    NotificationWidget.showScheduleNotification(
      id: 0, // You can choose the ID according to your need.
      title: "$productName is expiring soon!",
      body: "Your $productName is expiring tomorrow.",
      scheduledTime: expiryDate.subtract(const Duration(days: 1)),
    );

    // Schedule a notification for 1 week before the expiry date
    NotificationWidget.showScheduleNotification(
      id: 1, // You can choose the ID according to your need.
      title: "$productName is expiring soon!",
      body: "Your $productName is expiring in 1 week.",
      scheduledTime: expiryDate.subtract(const Duration(days: 7)),
    );

    // Schedule a notification for 1 month before the expiry date
    NotificationWidget.showScheduleNotification(
      id: 2, // You can choose the ID according to your need.
      title: "$productName is expiring soon!",
      body: "Your $productName is expiring in 1 month.",
      scheduledTime: expiryDate.subtract(const Duration(days: 30)),
    );

    // Show an immediate notification saying that the notifications have been added
    NotificationWidget.showNotification(
      id: 3, // You can choose the ID according to your need.
      title: "Notification Added",
      body: "Your notifications for $productName have been added.",
    );
  }
}
