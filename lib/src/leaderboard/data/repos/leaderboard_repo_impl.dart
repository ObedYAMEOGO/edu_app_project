import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/core/errors/failures.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/leaderboard/data/datasources/leaderboard_remote_data_src.dart';
import 'package:edu_app_project/src/leaderboard/data/models/leaderboard_user_model.dart';
import 'package:edu_app_project/src/leaderboard/domain/entities/leaderboard_user.dart';
import 'package:edu_app_project/src/leaderboard/domain/repos/leaderboard_repo.dart';
import 'package:flutter/widgets.dart';

class LeaderboardRepoImpl implements LeaderboardRepo {
  const LeaderboardRepoImpl(this._remoteDataSrc);

  final LeaderboardRemoteDataSrc _remoteDataSrc;

  @override
  ResultStream<List<LeaderboardUser>> getLeaderboard() {
    try {
      return _remoteDataSrc.getLeaderboard().transform(
            StreamTransformer<List<LeaderboardUserModel>,
                Either<Failure, List<LeaderboardUser>>>.fromHandlers(
              handleData: (leaderboardUsers, sink) {
                sink.add(Right(leaderboardUsers));
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
                  sink.add(
                    Left(
                      ServerFailure(message: error.toString(), statusCode: 500),
                    ),
                  );
                }
              },
            ),
          );
    } on ServerException catch (e) {
      return Stream.value(
        Left(ServerFailure(message: e.message, statusCode: e.statusCode)),
      );
    }
  }
}
