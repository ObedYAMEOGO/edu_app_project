import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/errors/failures.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef DataMap = Map<String, dynamic>;
