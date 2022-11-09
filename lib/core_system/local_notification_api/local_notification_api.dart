import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jack_components/util/download_file.dart';
import 'package:rxdart/subjects.dart';

class JackLocalNotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final _onNotifications = BehaviorSubject<NotificationResponse>();
  static final _onKilledNotifications =
      BehaviorSubject<NotificationAppLaunchDetails>();

  static Future<void> init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings("@mipmap/ic_launcher");
    const iOS = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);

    /// when app is killed and opened by clicking notification
    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      /// listening clicked LocalNotification when app is killed
      _onKilledNotifications.add(details);
    }

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) async {
        _onNotifications.add(details);
      },
    );
  }

  static Future<NotificationDetails> _notificationDetails({
    String? iconPath,
    DownloadFileType? iconType,
    String? imagePath,
    DownloadFileType? imageType,
    String? sound,
  }) async {
    /// local notification with Icon and Image
    final largeIconPath = iconPath != null && iconPath.startsWith("http")
        ? await JackDownload.downloadFile(
            url: iconPath,
            type: iconType!,
          )
        : null;
    final bigImagePath = imagePath != null && imagePath.startsWith("http")
        ? await JackDownload.downloadFile(
            url: imagePath,
            type: imageType!,
          )
        : null;
    final styleInformation = iconPath != null && imagePath != null
        ? BigPictureStyleInformation(
            FilePathAndroidBitmap(bigImagePath!),
            largeIcon: FilePathAndroidBitmap(largeIconPath!),
          )
        : null;

    return NotificationDetails(
      android: AndroidNotificationDetails(
        'max_importance_channel', // id
        'Max Importance Notifications', // title
        channelDescription:
            'This channel is used for important channel notifications.',
        // description
        importance: Importance.max,
        styleInformation: styleInformation,
        sound: sound != null
            ? RawResourceAndroidNotificationSound(sound.split(".").first)
            : null,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        sound: sound,
      ),
    );
  }

  static Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    String? largeIconPath,
    DownloadFileType? largeIconType,
    String? bigImagePath,
    DownloadFileType? bigImageType,
    String? soundPath,
  }) async {
    _notifications.show(
      id,
      title,
      body,
      await _notificationDetails(
        iconPath: largeIconPath,
        imagePath: bigImagePath,
        iconType: largeIconType,
        imageType: bigImageType,
        sound: soundPath,
      ),
      payload: payload,
    );
  }

  /// listening clicked LocalNotification
  static Future<void> listenNotifications(
          Function(NotificationResponse value) callbackFunc) async =>
      _onNotifications.stream.listen(
        (event) {
          callbackFunc(event);
        },
      );

  /// listening clicked LocalNotification when app is killed
  static Future<void> listenKilledNotifications(
          Function(NotificationAppLaunchDetails value) callbackFunc) async =>
      _onKilledNotifications.stream.listen(
        (event) {
          callbackFunc(event);
        },
      );
}
