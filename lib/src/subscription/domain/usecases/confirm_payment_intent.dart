import 'package:edu_app_project/core/enums/subscription_enum.dart';
import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/subscription/domain/repos/subscription_repo.dart';
import 'package:equatable/equatable.dart';

class ConfirmPaymentIntent
    extends FutureUsecaseWithParams<void, ConfirmPaymentIntentParams> {
  const ConfirmPaymentIntent(this._repo);

  final SubscriptionRepo _repo;

  @override
  ResultFuture<void> call(ConfirmPaymentIntentParams params) =>
      _repo.confirmPaymentIntent(
        clientSecret: params.clientSecret,
        subscription: params.subscription,
      );
}

class ConfirmPaymentIntentParams extends Equatable {
  const ConfirmPaymentIntentParams({
    required this.clientSecret,
    required this.subscription,
  });

  final String clientSecret;
  final Subscription subscription;

  @override
  List<dynamic> get props => [
        clientSecret,
        subscription,
      ];
}
