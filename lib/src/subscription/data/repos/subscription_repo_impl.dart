import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/enums/subscription_enum.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/core/errors/failures.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/subscription/data/datasources/subscription_remote_data_src.dart';
import 'package:edu_app_project/src/subscription/domain/repos/subscription_repo.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class SubscriptionRepoImpl implements SubscriptionRepo {
  const SubscriptionRepoImpl(this._remoteDataSource);

  final SubscriptionRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<String?> createPaymentIntent({
    required BillingDetails billingDetails,
    required Subscription subscription,
  }) async {
    try {
      final result = await _remoteDataSource.createPaymentIntent(
        billingDetails: billingDetails,
        subscription: subscription,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> confirmPaymentIntent({
    required String clientSecret,
    required Subscription subscription,
  }) async {
    try {
      await _remoteDataSource.confirmPaymentIntent(
        clientSecret: clientSecret,
        subscription: subscription,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
