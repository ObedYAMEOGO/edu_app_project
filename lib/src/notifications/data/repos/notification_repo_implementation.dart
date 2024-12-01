import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/core/errors/failures.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:edu_app_project/src/notifications/data/models/notification_model.dart';
import 'package:edu_app_project/src/notifications/domain/entities/notification.dart';
import 'package:edu_app_project/src/notifications/domain/repos/notification_repo.dart';
import 'package:flutter/foundation.dart';

class NotificationRepoImpl implements NotificationRepo {
  const NotificationRepoImpl(this._remoteDataSrc);

  final NotificationRemoteDataSrc _remoteDataSrc;

  @override
  ResultFuture<void> clear(String notificationId) async {
    try {
      await _remoteDataSrc.clear(notificationId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> clearAll() async {
    try {
      await _remoteDataSrc.clearAll();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> clearAllRead() async {
    try {
      await _remoteDataSrc.clearAllRead();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultStream<List<Notification>> getNotifications() {
    return _remoteDataSrc.getNotifications().transform(
          StreamTransformer<List<NotificationModel>,
              Either<Failure, List<Notification>>>.fromHandlers(
            handleData: (notifications, sink) {
              sink.add(Right(notifications));
            },
            handleError: (error, stackTrace, sink) {
              debugPrint(stackTrace.toString());
              if (error is ServerException) {
                sink.add(
                  Left(
                    ServerFailure(
                      message: error.message,
                      statusCode: error.statusCode,
                    ),
                  ),
                );
              } else {
                // Handle other types of exceptions as needed
                sink.add(
                  Left(
                    ServerFailure(
                      message: error.toString(),
                      statusCode: 500,
                    ),
                  ),
                );
              }
            },
          ),
        );
  }

  @override
  ResultFuture<void> markAsRead(String notificationId) async {
    try {
      await _remoteDataSrc.markAsRead(notificationId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> sendNotification(Notification notification) async {
    try {
      await _remoteDataSrc.sendNotification(notification);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
