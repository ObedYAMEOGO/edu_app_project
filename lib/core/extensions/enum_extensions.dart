import 'package:edu_app_project/core/enums/notification_enum.dart';
import 'package:edu_app_project/core/res/media_res.dart';

extension NotificationExt on String {
  NotificationCategory get toNotificationCategory {
    switch (this) {
      case 'test':
        return NotificationCategory.TEST;
      case 'video':
        return NotificationCategory.VIDEO;
      case 'material':
        return NotificationCategory.MATERIAL;
      case 'subscription_1':
        return NotificationCategory.SUBSCRIPTION_MONTH;
      case 'subscription_2':
        return NotificationCategory.SUBSCRIPTION_YEAR;
      case 'course':
        return NotificationCategory.COURSE;
      case 'scholarship':
        return NotificationCategory.SCHOLARSHIP;

      default:
        return NotificationCategory.NONE;
    }
  }
}

extension CategoryExt on NotificationCategory {
  String get image {
    switch (this) {
      case NotificationCategory.TEST:
        return Res.notificationBell;
      case NotificationCategory.VIDEO:
        return Res.notificationBell;
      case NotificationCategory.MATERIAL:
        return Res.notificationBell;
      case NotificationCategory.SUBSCRIPTION_MONTH:
        return Res.notificationBell;
      case NotificationCategory.SUBSCRIPTION_YEAR:
        return Res.notificationBell;
      case NotificationCategory.COURSE:
        return Res.notificationBell;
      case NotificationCategory.SCHOLARSHIP:
        return Res.notificationBell;
      case NotificationCategory.NONE:
        return Res.notificationBell;
    }
  }
}
