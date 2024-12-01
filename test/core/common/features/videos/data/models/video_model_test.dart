import 'dart:convert';

import 'package:edu_app_project/core/common/features/videos/data/models/video_model.dart';
import 'package:edu_app_project/core/common/features/videos/domain/entities/video.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../fixtures/fixture_reader.dart';

void main() {
  final tVideoModel =
      VideoModel.empty(DateTime.fromMillisecondsSinceEpoch(1687187734940));

  test(
    'should be a subclass of [Video] entity',
    () {
      expect(tVideoModel, isA<Video>());
    },
  );
  final tMap = jsonDecode(fixture('video.json')) as DataMap;
  group('fromMap', () {
    test(
      'should return a [VideoModel] with the correct data',
      () {
        final result = VideoModel.fromMap(tMap);
        expect(result, equals(tVideoModel));
      },
    );
  });

  group('toMap', () {
    test(
      'should return a [Map] with the proper data',
      () async {
        final result = tVideoModel.toMap();
        expect(result, equals(tMap));
      },
    );
  });

  group('copyWith', () {
    test(
      'should return a [VideoModel] with the new data',
      () async {
        final result = tVideoModel.copyWith(
          tutor: 'New Tutor',
        );

        expect(result.tutor, 'New Tutor');
      },
    );
  });
}
