import 'dart:convert';

import 'package:edu_app_project/core/enums/notification_enum.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/notifications/data/models/notification_model.dart';
import 'package:edu_app_project/src/notifications/domain/entities/notification.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tModel = NotificationModel.empty(
    DateTime.fromMillisecondsSinceEpoch(1687187734940),
  );

  test('should be a subclass of [Notification] entity', () {
    expect(tModel, isA<Notification>());
  });

  final tMap = jsonDecode(fixture('notification.json')) as DataMap;

  group('empty', () {
    test('should return an empty [NotificationModel]', () {
      final result = NotificationModel.empty();

      expect(result.title, '_empty.title');
    });
  });

  group('fromMap', () {
    test('should return a [NotificationModel] with the right data', () {
      final result = NotificationModel.fromMap(tMap);

      expect(result, equals(tModel));
    });
  });

  group('toMap', () {
    test('should return a [DataMap] with the right data', () {
      final result = tModel.toMap();

      expect(result, equals(tMap));
    });
  });

  group('copyWith', () {
    test('should return a [NotificationModel] with the right data', () {
      final result = tModel.copyWith(
        category: NotificationCategory.TEST,
      );

      expect(result, isA<NotificationModel>());
      expect(result.category, equals(NotificationCategory.TEST));
    });
  });
}
