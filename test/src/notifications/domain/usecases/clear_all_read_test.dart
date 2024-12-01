import 'package:dartz/dartz.dart';
import 'package:edu_app_project/src/notifications/domain/repos/notification_repo.dart';
import 'package:edu_app_project/src/notifications/domain/usecases/clear_all_read.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'notification_repo.mock.dart';

void main() {
  late NotificationRepo repo;
  late ClearAllRead usecase;

  setUp(() {
    repo = MockNotificationRepo();
    usecase = ClearAllRead(repo);
  });

  test(
    'should call the [NotificationRepo.clearAllRead]',
    () async {
      when(() => repo.clearAllRead())
          .thenAnswer((_) async => const Right(null));

      final result = await usecase();

      expect(result, const Right<dynamic, void>(null));

      verify(() => repo.clearAllRead()).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
