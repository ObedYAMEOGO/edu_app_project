

import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/core/errors/failures.dart';
import 'package:edu_app_project/src/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:edu_app_project/src/notifications/data/models/notification_model.dart';
import 'package:edu_app_project/src/notifications/data/repos/notification_repo_implementation.dart';
import 'package:edu_app_project/src/notifications/domain/entities/notification.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRemoteDataSource extends Mock
    implements NotificationRemoteDataSrc {}

void main() {
  late NotificationRemoteDataSrc remoteDataSrc;
  late NotificationRepoImpl repo;

  setUp(() {
    remoteDataSrc = MockNotificationRemoteDataSource();
    repo = NotificationRepoImpl(remoteDataSrc);
  });

  final tNotification = NotificationModel.empty();
  const tException =
      ServerException(message: 'message', statusCode: 'statusCode');
  group('getNotifications', () {
    test(
        'should emit a list of notifications when call to remote source '
        'is successful', () async {
      final notifications = [NotificationModel.empty()];
      // arrange
      when(() => remoteDataSrc.getNotifications()).thenAnswer(
        (_) => Stream.value(notifications),
      );
      // act
      final result = repo.getNotifications();
      // assert
      expect(
        result,
        emits(Right<dynamic, List<Notification>>(notifications)),
      );

      verify(() => remoteDataSrc.getNotifications());
      verifyNoMoreInteractions(remoteDataSrc);
    });
    test(
      'should emit a ServerFailure when call to remote source is unsuccessful',
      () async {
        when(() => remoteDataSrc.getNotifications()).thenAnswer(
          (_) => Stream.error(
            const ServerException(
              message: 'Something went wrong',
              statusCode: '500',
            ),
          ),
        );

        final result = repo.getNotifications();

        expect(
          result,
          emits(
            const Left<ServerFailure, dynamic>(
              ServerFailure(message: 'Something went wrong', statusCode: '500'),
            ),
          ),
        );

        verify(() => remoteDataSrc.getNotifications()).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });
  group('clear', () {
    test(
      'should complete successfully when call to remote source is successful',
      () async {
        when(() => remoteDataSrc.clear(any())).thenAnswer(
          (_) async => const Right<dynamic, void>(null),
        );
        final result = await repo.clear('id');
        expect(result, equals(const Right<dynamic, void>(null)));
        verify(() => remoteDataSrc.clear('id')).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(() => remoteDataSrc.clear(any())).thenThrow(tException);
        final result = await repo.clear('id');

        expect(
          result,
          equals(
            Left<Failure, dynamic>(ServerFailure.fromException(tException)),
          ),
        );
        verify(() => remoteDataSrc.clear('id')).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });

  group('clearAll', () {
    test(
      'should complete successfully when call to remote source is '
      'successful',
      () async {
        when(() => remoteDataSrc.clearAll()).thenAnswer(
          (_) async => const Right<dynamic, void>(null),
        );
        final result = await repo.clearAll();
        expect(result, equals(const Right<dynamic, void>(null)));
        verify(() => remoteDataSrc.clearAll()).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(() => remoteDataSrc.clearAll()).thenThrow(tException);
        final result = await repo.clearAll();

        expect(
          result,
          equals(
            Left<Failure, dynamic>(ServerFailure.fromException(tException)),
          ),
        );
        verify(() => remoteDataSrc.clearAll()).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });

  group('clearAllRead', () {
    test(
      'should complete successfully when call to remote source is '
      'successful',
      () async {
        when(() => remoteDataSrc.clearAllRead()).thenAnswer(
          (_) async => const Right<dynamic, void>(null),
        );
        final result = await repo.clearAllRead();
        expect(result, equals(const Right<dynamic, void>(null)));
        verify(() => remoteDataSrc.clearAllRead()).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(() => remoteDataSrc.clearAllRead()).thenThrow(tException);
        final result = await repo.clearAllRead();

        expect(
          result,
          equals(
            Left<Failure, dynamic>(ServerFailure.fromException(tException)),
          ),
        );
        verify(() => remoteDataSrc.clearAllRead()).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });

  group('markAsRead', () {
    test(
      'should complete successfully when call to remote source is successful',
      () async {
        when(() => remoteDataSrc.markAsRead(any()))
            .thenAnswer((_) async => const Right<dynamic, void>(null));

        final result = await repo.markAsRead('id');

        expect(result, equals(const Right<dynamic, void>(null)));

        verify(() => remoteDataSrc.markAsRead('id')).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(() => remoteDataSrc.markAsRead(any())).thenThrow(tException);

        final result = await repo.markAsRead('id');

        expect(
          result,
          equals(
            Left<Failure, dynamic>(ServerFailure.fromException(tException)),
          ),
        );

        verify(() => remoteDataSrc.markAsRead('id')).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });

  group('sendNotification', () {
    setUp(() => registerFallbackValue(tNotification));
    test(
      'should complete successfully when call to remote source is successful',
      () async {
        when(() => remoteDataSrc.sendNotification(any()))
            .thenAnswer((_) async => const Right<dynamic, void>(null));

        final result = await repo.sendNotification(tNotification);

        expect(result, equals(const Right<dynamic, void>(null)));

        verify(() => remoteDataSrc.sendNotification(tNotification)).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(() => remoteDataSrc.sendNotification(any())).thenThrow(tException);

        final result = await repo.sendNotification(tNotification);

        expect(
          result,
          equals(
            Left<Failure, dynamic>(ServerFailure.fromException(tException)),
          ),
        );

        verify(() => remoteDataSrc.sendNotification(tNotification)).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });
}
