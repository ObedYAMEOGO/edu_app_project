
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/notifications/domain/entities/notification.dart';

abstract class NotificationRepo {
  const NotificationRepo();

  // USE
  ResultFuture<void> markAsRead(String notificationId);

  // USE
  ResultFuture<void> clearAll();

  ResultFuture<void> clear(String notificationId);

  ResultFuture<void> clearAllRead();

  // USE
  ResultStream<List<Notification>> getNotifications();

  // USE
  // Exams included
  ResultFuture<void> sendNotification(Notification notification);
}
